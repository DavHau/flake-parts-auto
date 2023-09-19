# Flake Parts Auto



# Why?
flake-parts uses module system, which allows great modularization of your flake.

# How?
See `./examples/mkFlake/flake.nix` and `./examples/importModules/flake.nix`. This library takes a `modulesDir` and imports and exports modules automatically from the following paths:

The modules defined in `<modulesDir>/<moduleKind>/<moduleName>.nix` are exported as `modules.<moduleKind>.<moduleName>`

To be compatible with existing module systems, these `moduleKind` are treated specially:

- `<modulesDir>/flake-parts/<moduleName>.nix` is exported to `flakeModules.<moduleName>` for [flake-parts](https://github.com/hercules-ci/flake-parts) compatibility.
- `<modulesDir>/nixos/<moduleName>.nix` is exported to `nixosModules.<moduleName>` for nixpkg compatibility.
- `<modulesDir>/darwin/<moduleName>.nix` is exported to `darwinModules.<moduleName>` for nixpkg compatibility.



# Disadvantages:
- There is no way to specify which modules should not be imported/exported, so all modules are both imported and exported. To customize this you have to adapt the logic in `./modules/flake-parts/all-modules.nix`
