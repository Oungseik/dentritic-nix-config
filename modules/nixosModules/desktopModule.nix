{ ... }: {
  flake.nixosModules.desktopModule = { pkgs, ... }: {

    # services = {
    #   xserver.enable = true; # need for mouse support of SDDM during login
    #   xserver.xkb = {
    #     layout = "us";
    #     variant = "";
    #   };
    # };

    services = {
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        theme = "catppuccin-mocha-mauve"; # Theme name corresponds to the overridden package's theme name
        wayland.enable = true;
      };

      blueman.enable = true;
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

      polkit_gnome

      qt5.qtquickcontrols2
      qt5.qtgraphicaleffects
    ];
  };
}
