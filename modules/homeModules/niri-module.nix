{ ... }: {
  flake.homeModules.niri =
    { config, ... }:
    let
      configPath = "${config.home.homeDirectory}/Projects/dendritic-nix-config/config/niri";
    in
    {
      xdg.configFile.niri.source = config.lib.file.mkOutOfStoreSymlink configPath;
    };
}
