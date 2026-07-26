{ ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {

    nixpkgs.config.allowUnfree = true;

    services = {
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

      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      seahorse.enable = true;
    };

    environment.systemPackages = [ pkgs.home-manager ];
  };
}
