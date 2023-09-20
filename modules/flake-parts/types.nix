module-inputs @ {self,inputs,...}:{
  config.flake.lib.types =
    let
      buildPath = list: (builtins.concatStringsSep "/" list) ;
    in
  rec {
      modules = {
          # If true, the module will be exported as a flakeModule
          export ? true,
          # If true, the module will be imported into this flake.
          # This allows for easy dogfooding and splitting of modules.
          import ? true
          }:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
          let
            directoryContents = builtins.readDir (buildPath modulePathSegments);
            directoryFiles = inputs.nixpkgs.lib.attrsets.filterAttrs (name: value: value == "regular")
              directoryContents;
            fileImporter = fileName: _: builtins.import (buildPath (modulePathSegments++[fileName]));
            importedModules = builtins.mapAttrs (fileImporter) directoryFiles;
          in
          (builtins.trace
            "Importing modules from ${buildPath modulePathSegments}/*"
          {
            imports = if import then (builtins.attrValues importedModules) else [];
            config.flake = if export then {
              modules.flake-parts=importedModules;
              flakeModules=importedModules;
            } else {};
          });
      directories = moduleType:
          # The path to the module, this is provided to the function by the library.
          modulePathSegments:
      # builtins.trace
      #       "Importing directory from ${buildPath modulePathSegments}"
      (let
        directoryContents = builtins.attrNames
          (inputs.nixpkgs.lib.attrsets.filterAttrs (name: value: value == "directory")
          (builtins.readDir
          (buildPath modulePathSegments
          )));
        importContent = content: self.importCodeMap moduleType (modulePathSegments ++ [content]);
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
          # inputs.nixpkgs.lib.filesystem.listFilesRecursive
      };

  };
}
