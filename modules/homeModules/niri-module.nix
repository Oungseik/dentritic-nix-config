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
          config.niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Access" = "gtk";
            "org.freedesktop.impl.portal.Notification" = "gtk";
            "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
          };
          extraPortals = with pkgs; [
            gnome-keyring
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
        };
      };
    };
}
