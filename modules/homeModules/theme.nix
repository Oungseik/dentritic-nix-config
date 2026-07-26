{ ... }: {
  flake.homeModules.theme = { config, pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };

      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };

      iconTheme = {
        package = pkgs.kora-icon-theme;
        name = "Kora";
      };

      font = {
        name = "Roboto";
        size = 12;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      qt5ctSettings.Appearance.icon_theme = config.gtk.iconTheme.name;
      qt6ctSettings.Appearance.icon_theme = config.gtk.iconTheme.name;

      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };

    xdg.configFile = {
      "qt5ct/qt5ct.conf".force = true;
      "qt6ct/qt6ct.conf".force = true;
    };
  };
}
