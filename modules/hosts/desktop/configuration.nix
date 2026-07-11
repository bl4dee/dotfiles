{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktopConfiguration = {pkgs, ...}: {
    imports = [
      self.nixosModules.desktopHardware
      self.nixosModules.determinate
      self.nixosModules.common
      self.nixosModules.hyprland
      self.nixosModules.greetd
      self.nixosModules.nvidia
      self.nixosModules.audio
      self.nixosModules.virtualization
      self.nixosModules.cryptoRecovery
      self.nixosModules.anonymity
      self.nixosModules.networking
      self.nixosModules.flatpak
      self.nixosModules.openrazer
      self.nixosModules.homeManager
    ];

    nixpkgs.config.allowUnfree = true;

    networking.hostName = "desktop";

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0;
    boot.initrd.systemd.enable = true;
    boot.kernelModules = ["kvm-amd"];
    boot.extraModprobeConfig = ''
      options kvm-amd nested=1
    '';

    # zram swap (compressed RAM, essentially free)
    zramSwap = {
      enable = true;
      memoryPercent = 50;
      algorithm = "zstd";
    };

    # kernel tuning
    boot.kernel.sysctl = {
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
