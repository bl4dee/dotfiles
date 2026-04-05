_: {
  flake.nixosModules.greetd = {
    pkgs,
    lib,
    ...
  }: {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --issue --sessions /run/current-system/sw/share/wayland-sessions";
        user = "greeter";
      };
    };

    # kde plasma
    services.desktopManager.plasma6.enable = true;

    # prevent late boot messages from printing over tuigreet
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
