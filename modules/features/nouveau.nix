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

    # force GLES2 renderer — old GPUs (Fermi, Kepler) may not have
    # working Vulkan via NVK, which causes Hyprland to black screen
    environment.sessionVariables.WLR_RENDERER = "gles2";
  };
}
