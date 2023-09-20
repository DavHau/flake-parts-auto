# Flake Parts Auto



# Why?
flake-parts uses the nixos module system, which allows great modularization of your flake. This library allows you to easily setup your flake to automatically import these modules for you (just remember to add them to your VCS for them to show up).

# How?
See `./examples/mkFlake/flake.nix` and `./examples/importModules/flake.nix`. This library takes a `modulesDir` and imports and exports modules automatically from the following paths:

The modules defined in `<modulesDir>/<moduleKind>/<moduleName>.nix` are exported as `modules.<moduleKind>.<moduleName>`

To be compatible with existing module systems, these `moduleKind` are treated specially:

- `<modulesDir>/flake-parts/<moduleName>.nix` is exported to `flakeModules.<moduleName>` for [flake-parts](https://github.com/hercules-ci/flake-parts) compatibility.
- `<modulesDir>/nixos/<moduleName>.nix` is exported to `nixosModules.<moduleName>` for nixpkg compatibility.
- `<modulesDir>/darwin/<moduleName>.nix` is exported to `darwinModules.<moduleName>` for nixpkg compatibility.



# Pros and Cons:

- `flake-parts-auto.importModules`
    - Pros:
        - easy setup (see examples)
    - Cons:
        - locked to the folder structure
        - There is no way to specify which modules should not be imported/exported, so all modules are both imported and exported. To customize this you have to adapt the logic in `./modules/flake-parts/all-modules.nix`

- `flake-parts-auto.mkFlake` (Since this is a convenience wrapper around `flake-parts-auto.importModules` all of its pros and cons also apply)
    - forces you to not write anything else in the `flake.nix`. This can be viewed as a pro or a con depending on the viewpoint.

- `flake-parts-auto.importCodemap`
    - Pros:
        - allows user specified layout of folder structure.
        - allows specifying which modules should be exported as well.
        - serves as the documentation where things are located.
    - Cons:
        - more complex than `flake-parts-auto.importModules`