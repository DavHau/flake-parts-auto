{
  description = "Example flake for using flake-parts-auto";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts-auto={
      url = "github:DavHau/flake-parts-auto";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = inputs : inputs.flake-parts-auto.mkFlake {
    inherit inputs;
    systems = import inputs.systems;
    modulesDir = ../modules;
  };
}
