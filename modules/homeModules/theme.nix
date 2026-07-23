{ self, ... }: {
  flake.homeModules.theme = { pkgs, ... }: {
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

      iconTheme.package = self.packages.${pkgs.stdenv.hostPlatform.system}.gruvbox-plus;
      # iconTheme.package = pkgs.kora-icon-theme;
      iconTheme.name = "Kora";

      font = {
        name = "Roboto";
        size = 12;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";

      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };
  };
}
