{ self, ... }: {
  flake.homeModules.theme = { config, pkgs, ... }: {
    home.packages = [
      pkgs.roboto
      (pkgs.noto-fonts.override { variants = [ "NotoSansThai" "NotoSansMyanmar" ]; })
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts.sansSerif = [ "Roboto" "Noto Sans Thai" ];
      configFile.terminal-fallback = {
        enable = true;
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <alias binding="strong">
              <family>ZedBrainsMono Nerd Font</family>
              <accept>
                <family>Noto Sans Thai</family>
                <family>Noto Sans Myanmar</family>
              </accept>
            </alias>
          </fontconfig>
        '';
      };
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
      gtk.enable = true;
    };

    xdg.dataFile."icons/default/index.theme".force = true;

    gtk = {
      enable = true;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };

      iconTheme = {
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.gruvbox-plus;
        name = "Gruvbox-Plus-Dark";
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
      qt5ctSettings.Fonts.general = ''"${config.gtk.font.name},${toString config.gtk.font.size}"'';
      qt6ctSettings.Fonts.general = config.qt.qt5ctSettings.Fonts.general;

      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };

    xdg.configFile = {
      "qt5ct/qt5ct.conf".force = true;
      "qt6ct/qt6ct.conf".force = true;
    };
  };
}
