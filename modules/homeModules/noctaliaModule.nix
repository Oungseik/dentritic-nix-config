{ ... }: {
  flake.homeModules.noctalia =
    { pkgs, config, ... }:
    let
      configPath = "${config.home.homeDirectory}/Projects/dendritic-nix-config/config/noctalia";
    in
    {
      home.packages = with pkgs; [
        noctalia-shell
      ];

      xdg.configFile.noctalia.source = config.lib.file.mkOutOfStoreSymlink configPath;

      programs.btop = {
        settings.color_theme = "noctalia";
      };
    };
}
