_: {
  flake.nixosModules.openrazer = _: {
    hardware.openrazer = {
      enable = true;
      users = ["blink"];
    };

    nixpkgs.overlays = [
      (final: prev: let
        # same commit as before, but fetched as a github tarball: the
        # add-lianli-o11-dynamic branch was force-pushed and no longer
        # contains it, which broke builtins.fetchGit on fresh machines
        openrazer-src = prev.fetchFromGitHub {
          owner = "bl4dee";
          repo = "openrazer";
          rev = "808aaebb3b90bf82bc01497a667b21082d7b5b05";
          hash = "sha256-xxYZKTIzmBbiVwCzQlOWVpVU+Jcc+SYBF+WIpEK4Yt0=";
        };
      in {
        openrazer-daemon = prev.openrazer-daemon.overrideAttrs (old: {
          src = openrazer-src;
        });
        linuxPackages = prev.linuxPackages.extend (lpFinal: lpPrev: {
          openrazer = lpPrev.openrazer.overrideAttrs (old: {
            src = openrazer-src;
          });
        });
      })
    ];
  };
}
