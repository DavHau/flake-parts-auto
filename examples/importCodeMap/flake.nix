{
  description = "Example flake for using flake-parts-auto";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts-auto={
      url = "path:../../.";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = inputs@{ flake-parts, self, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];
    imports = [
      (inputs.flake-parts-auto.importCodeMap (with inputs.flake-parts-auto.lib;{
        # imports AND exports flake-parts modules from ./modules/flake-parts/<modulename>.nix
        flake-parts = types.modules.flake-parts {};
        # exports flake-parts modules from ./modules/custom-folder/<modulename>.nix
        custom-folder = types.modules.flake-parts {import=false;};
        # imports flake-parts modules from ./modules/private-flake-parts/<modulename>.nix
        private-flake-parts = types.modules.flake-parts {export=false;};


        


      }) ./modules )
    ];
  };
}
