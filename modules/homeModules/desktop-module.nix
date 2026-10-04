{ ... }:
{
  flake.homeModules.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      brightnessctl
      ddcutil
      grim
      slurp
      wl-clipboard
    ];

    services = {
      polkit-gnome.enable = true;
      wl-clip-persist.enable = true;
    };
  };
}
