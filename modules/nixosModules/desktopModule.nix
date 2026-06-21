{ ... }: {
  flake.nixosModules.desktopModule = { pkgs, ... }: {

    services = {
      xserver.enable = true;
      xserver.xkb = {
        layout = "us";
        variant = "";
      };

      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        theme = "catppuccin-mocha-mauve"; # Theme name corresponds to the overridden package's theme name
      };

      gvfs.enable = true;
      udisks2.enable = true;
      upower.enable = true;
    };

    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    programs = {
      ssh = {
        enableAskPassword = false;
        askPassword = "systemd-ask-password";
      };
    };

    environment.systemPackages = with pkgs; [
      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
      })

      home-manager
      polkit_gnome

      qt5.qtquickcontrols2
      qt5.qtgraphicaleffects

      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs =
              pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                pkg-config
                ncurses
                # Feel free to add more packages here if needed.
              ]);
            profile = "export FHS=1";
            runScript = "zsh";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
  };
}
