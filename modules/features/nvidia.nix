_: {
  flake.nixosModules.nvidia = {
    config,
    pkgs,
    ...
  }: {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    # Disable PCIe Active State Power Management (ASPM).
    # On Linux, ASPM causes NVIDIA GPUs to get stuck at PCIe Gen 1 (2.5 GT/s)
    # instead of Gen 3 (8.0 GT/s), tanking bandwidth and producing 10-15 FPS
    # in benchmarks instead of the expected 100+.
    boot.kernelParams = ["pcie_aspm=off" "pcie_port_pm=off"];

    # NVreg_EnableGpuFirmware=0: disables GSP firmware on Turing (RTX 2080).
    #   GSP on Turing triggers rapid P-state thrashing because RTD3 runtime
    #   power management is unsupported on Turing but the GSP path attempts it.
    # NVreg_DynamicPowerManagement=0: disables RTD3 power cycling entirely.
    #   RTD3 is Ampere+ only; on Turing it causes continuous P0<->P8 oscillation,
    #   erratic fan cycling, and severely reduced sustained GPU performance.
    boot.extraModprobeConfig = ''
      options nvidia NVreg_EnableGpuFirmware=0
      options nvidia NVreg_DynamicPowerManagement=0
    '';
  };
}
