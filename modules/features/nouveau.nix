_: {
  flake.nixosModules.nouveau = {lib, ...}: {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = lib.mkForce ["modesetting"];

    # block all proprietary nvidia modules so nouveau can claim the GPU
    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_uvm"
      "nvidia_drm"
      "nvidia_modeset"
    ];
  };
}
