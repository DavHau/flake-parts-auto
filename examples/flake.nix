{
  description = "Example flake for using flake-parts-auto";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts-auto.url = "github:DavHau/flake-parts-auto";
  };

  outputs = inputs@{ flake-parts, self, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      (inputs.flake-parts-auto.importModules ./modules)
    ];
    systems = [
      # systems for which you want to build the `perSystem` attributes
      "x86_64-linux"
      # ...
    ];

    # instead of defining `flake` or `perSystem` here, create module files under
    # ./modules/flake-parts/<name>.nix which will automatically be imported
  };

}
