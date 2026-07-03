{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.laptopConfiguration = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.laptopHardware
      self.nixosModules.determinate
      self.nixosModules.common
      self.nixosModules.hyprland
      self.nixosModules.greetd
      self.nixosModules.audio
      self.nixosModules.virtualization
      self.nixosModules.anonymity
      self.nixosModules.networking
      self.nixosModules.flatpak
      self.nixosModules.homeManager
      # no openrazer: that fork carries the desktop case's LED controller
    ];

    nixpkgs.config.allowUnfree = true;

    networking.hostName = "laptop";

    # common pins the desktop's original 24.11; this machine was installed at 26.05
    system.stateVersion = lib.mkForce "26.05";

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0;
    boot.initrd.systemd.enable = true;
    boot.extraModprobeConfig = ''
      options kvm-amd nested=1
    '';

    # strix point is happiest on the newest kernel in the pin
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # blackwell mobile gpus are only supported by the open kernel modules;
    # internal panel + usb-c outputs sit on the amd igpu, hdmi is wired to the dgpu
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      # rtd3: let the dgpu power off when nothing renders on it
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        amdgpuBusId = "PCI:195:0:0"; # 0000:c3:00.0 radeon 890m
        nvidiaBusId = "PCI:194:0:0"; # 0000:c2:00.0 rtx 5080 mobile
      };
    };

    # laptop firmware updates via lvfs
    services.fwupd.enable = true;
  };
}
