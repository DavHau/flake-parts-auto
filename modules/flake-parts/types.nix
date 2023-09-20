module-inputs @ {self,inputs,...}:{
  config.flake.lib.types =
    let
      buildPath = list: (builtins.concatStringsSep "/" list) ;
    in
  rec {
      module = {
        flake-parts = {
          # If true, the module will be exported as a flakeModule
          export ? true,
          # If true, the module will be imported into this flake.
          # This allows for easy dogfooding and splitting of modules.
          import ? true
          }:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
          let
            flakePartsModule = builtins.import (buildPath modulePathSegments);
            moduleName = inputs.nixpkgs.lib.lists.last modulePathSegments;
          in
          builtins.trace
            "Importing flake-parts module ${moduleName} from ${buildPath modulePathSegments}"
          {
            imports = if import then [ flakePartsModule ] else [];
            config.flake = if export then {
              modules.flake-parts.${moduleName}=flakePartsModule;
              flakeModules.${moduleName}=flakePartsModule;
            } else {};
          };
        nixOs = {
          export ? true
        }:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
          let
            nixOsModule = import (buildPath modulePathSegments);
            moduleName = inputs.nixpkgs.lib.lists.last modulePathSegments;
          in
          builtins.trace
            "Importing nixos module ${moduleName} from ${buildPath modulePathSegments}"
          {
            config.flake = if export then {
              modules.nixos.${moduleName}=nixOsModule;
              nixosModules.${moduleName}=nixOsModule;
            } else {};
          };
        darwin = {export?true}:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
          let
            darwinModule = import (buildPath modulePathSegments);
            moduleName = inputs.nixpkgs.lib.lists.last modulePathSegments;
          in
          builtins.trace
            "Importing darwin module ${moduleName} from ${buildPath modulePathSegments}"
          {
            config.flake = if export then {
              modules.darwin.${moduleName}=darwinModule;
              darwinModules.${moduleName}=darwinModule;
            } else {};
          };
        # These are exported automatically, because they cannot be imported
        custom = {
          name
        }:
        # The path to the module, this is provided to the function by the library.
        modulePathSegments:
        let
            module = import (buildPath modulePathSegments);
            moduleName = inputs.nixpkgs.lib.lists.last modulePathSegments;
          in
        builtins.trace
            "Importing custom ${name} module ${moduleName} from ${buildPath modulePathSegments}"
        {
          config.flake.modules.${name}.${moduleName}=module;
        };
      };

      directory = moduleType:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
      builtins.trace
            "Importing directory from ${buildPath modulePathSegments}"
      (let
        directoryContents = builtins.attrNames (builtins.readDir (buildPath modulePathSegments));
        importContent = content:
          let
            importPath = modulePathSegments ++ [content];
          in
            self.importCodeMap moduleType importPath;
      in
      {
        imports = builtins.map importContent directoryContents;
      });
      nestedDirectory = moduleType:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
      builtins.trace
            "Importing nested directory from ${buildPath modulePathSegments}"
      {
          # TODO: check that moduleType is not in itself a nestedDirectory or directory
      };


      modules = {
        flake-parts = options: directory (module.flake-parts options);
        nixOs = options: directory (module.nixOs options);
        darwin = options: directory (module.darwin options);
        custom = options: directory (module.custom options);
      };
  };
}
