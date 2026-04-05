_: {
  flake.nixosModules.desktopHardware = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd" "nct6775"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/98fa7bd9-7c18-4809-9e2d-d958e2f76c8c";
      fsType = "btrfs";
      options = ["subvol=@root" "compress=zstd" "noatime" "discard=async"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/BEB1-24AA";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/98fa7bd9-7c18-4809-9e2d-d958e2f76c8c";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd" "noatime" "discard=async"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/98fa7bd9-7c18-4809-9e2d-d958e2f76c8c";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime" "discard=async"];
    };

    fileSystems."/var/log" = {
      device = "/dev/disk/by-uuid/98fa7bd9-7c18-4809-9e2d-d958e2f76c8c";
      fsType = "btrfs";
      options = ["subvol=@log" "compress=zstd" "noatime" "discard=async"];
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
