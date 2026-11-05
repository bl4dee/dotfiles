{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktopBase = {pkgs, ...}: {
    imports = [
      self.nixosModules.desktopHardware
      self.nixosModules.determinate
      self.nixosModules.common
      self.nixosModules.hyprland
      self.nixosModules.greetd
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

    # GameMode — auto-sets performance governor, GPU perf mode,
    # nice -4, ioprio realtime, and scheduler tweaks while gaming
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10; # nice -10 for the game process
          softrealtime = "auto";
          inhibit_screensaver = 0;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          nv_powermizer_mode = 1; # prefer maximum performance
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
      };
    };

    # kernel tuning
    boot.kernel.sysctl = {
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.swappiness" = 10; # prefer keeping game data in RAM
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  # default desktop: proprietary nvidia (Maxwell+ / GTX 900 and newer)
  flake.nixosModules.desktopConfiguration = _: {
    imports = [
      self.nixosModules.desktopBase
      self.nixosModules.nvidia
    ];
  };

  # nouveau desktop: for old GPUs (Kepler, Fermi, etc.)
  flake.nixosModules.desktopNouveau = _: {
    imports = [
      self.nixosModules.desktopBase
      self.nixosModules.nouveau
    ];
  };
}
