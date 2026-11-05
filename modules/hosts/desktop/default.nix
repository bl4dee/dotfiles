{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopConfiguration
    ];
  };

  flake.nixosConfigurations.nouveau = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopNouveau
    ];
  };
}
