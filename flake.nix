{
  description = ''
    Define directory to search for modules which to export via the flake.
    Modules from:
      - {modulesDir}/flake-parts/<name> will be imported automatically and exported to:
        -> flake.modules.flake-parts.<name>
      - {modulesDir}/nixos/<name> will be exported to:
        -> flake.nixosModules.<name>
      - {modulesDir}/<class>/<name> will be exported to:
        -> flake.modules.<class>.<name>
  '';

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        (import ./modules/flake-parts/all-modules.nix ./modules)
      ];
    };
}
