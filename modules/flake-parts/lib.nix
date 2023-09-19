module-inputs @ {self,...}:{
  config.flake = {
    importModules = import ./all-modules.nix;
    mkFlake = {systems,modulesDir,inputs}: module-inputs.inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      inherit systems;
      imports = [
        (self.importModules modulesDir)
      ];
    };
  };
}
