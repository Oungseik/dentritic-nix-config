{ inputs, ... }: {
  flake.homeModules.noctalia =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      configPath = "${config.home.homeDirectory}/Projects/dendritic-nix-config/config/noctalia";
      isV5 = config.desktop.noctalia.version == "v5";
      # The pinned Quickshell fork leaves an unused, broken Breakpad dependency;
      # its crash handler is disabled by default.
      v4Package = pkgs.noctalia-shell.override {
        noctalia-qs = pkgs.noctalia-qs.overrideAttrs (old: {
          buildInputs = lib.remove pkgs.breakpad old.buildInputs;
        });
      };
    in
    {
      options.desktop.noctalia.version = lib.mkOption {
        type = lib.types.enum [
          "v4"
          "v5"
        ];
        default = "v4";
        description = "Noctalia version to install and integrate with the desktop.";
      };

      config = {
        home.packages = [
          (if isV5 then inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default else v4Package)
        ];

        xdg.configFile.noctalia.source = config.lib.file.mkOutOfStoreSymlink configPath;
        xdg.stateFile."noctalia/settings.toml".source =
          config.lib.file.mkOutOfStoreSymlink "${configPath}/state/settings.toml";

        services = lib.mkIf isV5 {
          polkit-gnome.enable = false;
          wl-clip-persist.enable = false;
        };

        programs.btop.settings.color_theme = "noctalia";
      };
    };
}
