{ ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {

    nixpkgs.config.allowUnfree = true;

    services = {
      xserver.enable = true; # need for mouse support of SDDM during login
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        extraPackages = [ pkgs.qt6.qtsvg ];
        theme = "catppuccin-mocha-mauve"; # Theme name corresponds to the overridden package's theme name
      };

      blueman.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      upower.enable = true;
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.hyprlock = { };

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

      hyprland.enable = true;
      niri.enable = true;
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      seahorse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
      })

      home-manager
    ];
  };
}
