{
  config.flake.discovered_modules = builtins.trace "Imported module nested/some_module.nix" [];
}