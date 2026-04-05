_: {
  flake.nixosModules.virtualization = {pkgs, ...}: {
    virtualisation.docker.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    virtualisation.spiceUSBRedirection.enable = true;
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;

    # CH341A USB SPI programmer — allow libvirt/user access
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="5512", MODE="0666", TAG+="uaccess"
    '';

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      spice-gtk
      libvirt
      dnsmasq
      phodav
    ];
  };
}
