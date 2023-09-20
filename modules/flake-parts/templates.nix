{
  config.flake.templates = {
    importModules = {
      path = ../../examples/importModules;
      description = "Example template for importModules";
    };
    mkFlake = {
      path = ../../examples/mkFlake;
      description = "Example template for mkFlake";
    };
    importCodeMap = {
      path = ../../examples/importCodeMap;
      description = "Example template for importCodeMap";
    };
  };
}