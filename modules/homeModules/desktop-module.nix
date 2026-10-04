{ ... }:
{
  flake.homeModules.desktop = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      brightnessctl
      ddcutil
      grim
      slurp
      wl-clipboard
    ];

    services = {
      polkit-gnome.enable = lib.mkDefault true;
      wl-clip-persist.enable = lib.mkDefault true;
    };
  };
}
