{ ... }: {
  flake.homeModules.niri =
    { config, pkgs, ... }:
    let
      configPath = "${config.home.homeDirectory}/Projects/dendritic-nix-config/config/niri";
    in
    {
      xdg = {
        configFile.niri.source = config.lib.file.mkOutOfStoreSymlink configPath;
        portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };
      };
    };
}
