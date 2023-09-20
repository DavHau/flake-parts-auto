# This function builds a flake-parts module that conditionally imports the
# modules a codemap defines.
{self,inputs,...}:
{
  config.flake.importCodeMap =
  let importCodeMap =
    # The specification of the codemap to be imported
    codeMap:
    # The Path where it all starts.
    codeMapDir:
  let
    # Ensure that codeMapDir is a list:
    codeMapDirList =
      if (builtins.isList codeMapDir) then
        codeMapDir
      else if (builtins.isPath codeMapDir) then
        [ codeMapDir ]
      else
        (builtins.throw "The codeMapDir is of invalid type.");
    codeMapDirPath = builtins.concatStringsSep "/" codeMapDirList;
  in
  if builtins.trace "Importing codemap from ${codeMapDirPath}" (! builtins.pathExists codeMapDirPath) then
    # If the path does not exist, we ignore it.
    builtins.trace "The path ${codeMapDirPath} is not present, skipping import." {}
  else if (builtins.isAttrs codeMap) then
    # An attrset is treated like a directory of codeMaps, where each key represents
    # a different path to modules. These path names are only for discoverability
    # and do not affect the resulting import/export process.
    let
      importCodeMapInSubdir =
      directoryName: innerCodeMap: importCodeMap innerCodeMap (codeMapDirList ++ [directoryName]);
    in
    {
      imports = inputs.nixpkgs.lib.mapAttrsToList importCodeMapInSubdir codeMap;
    }
  else if (builtins.isFunction codeMap) then
    # If it is a function, it gets given the codeMapDir and imported.
    {
      imports = [ (codeMap codeMapDirList) ];
    }
  else
    (builtins.throw "The Codemap is of invalid type.")
  ;
  in importCodeMap;
}


# TODO:
# - (builtins.pathExists )