_: {
  flake.nixosModules.openrazer = {pkgs, ...}: let
    openrazer-src = builtins.fetchGit {
      url = "https://github.com/bl4dee/openrazer.git";
      ref = "add-lianli-o11-dynamic";
      rev = "808aaebb3b90bf82bc01497a667b21082d7b5b05";
    };
  in {
    hardware.openrazer = {
      enable = true;
      users = ["blink"];
    };

    nixpkgs.overlays = [
      (final: prev: {
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
