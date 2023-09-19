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
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [];
      imports = [
        (import ./modules/flake-parts/all-modules.nix ./modules)
      ];
    };
}
