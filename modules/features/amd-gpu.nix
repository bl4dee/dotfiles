_: {
  flake.nixosModules.amdGpu = {
    pkgs,
    ...
  }: {
    # Mesa: OpenGL, Vulkan (RADV), VA-API — with 32-bit for Steam/Wine
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["amdgpu"];

    # Early KMS — correct resolution from first frame, no flicker
    boot.initrd.kernelModules = ["amdgpu"];

    boot.kernelParams = [
      # GCN 1.0 (Southern Islands, 2012): HD 7700-7900, R9 270/280
      "amdgpu.si_support=1"
      "radeon.si_support=0"
      # GCN 1.1 (Sea Islands, 2013): R7 260X, R9 290/290X
      "amdgpu.cik_support=1"
      "radeon.cik_support=0"
      # Unlock OverDrive: manual clocks, voltage, fan curves, power limit
      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    # GPU firmware blobs (every AMD generation needs these)
    hardware.enableRedistributableFirmware = true;

    # GPU diagnostics and control
    environment.systemPackages = with pkgs; [
      vulkan-tools # vulkaninfo
      mesa-demos # glxinfo, eglinfo
      libva-utils # vainfo
      radeontop # real-time GPU utilization
      lact # clocks, fan curves, power limits, temp monitoring
    ];

    # LACT daemon (required for the lact GUI to control the GPU)
    systemd.services.lact = {
      description = "LACT Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
        Restart = "on-failure";
      };
    };
  };
}
