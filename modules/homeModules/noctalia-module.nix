{ inputs, ... }: {
  flake.homeModules.noctalia =
    {
      pkgs,
      config,
      ...
    }:
    let
      configPath = "${config.home.homeDirectory}/Projects/dendritic-nix-config/config/noctalia";
    in
    {
      home.packages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      services.polkit-gnome.enable = false;

      xdg.configFile.noctalia.source = config.lib.file.mkOutOfStoreSymlink configPath;
      xdg.stateFile."noctalia/settings.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${configPath}/state/settings.toml";

      programs.btop.settings.color_theme = "noctalia";
    };
}
