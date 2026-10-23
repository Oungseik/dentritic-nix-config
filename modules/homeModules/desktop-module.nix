{ ... }:
{
  flake.homeModules.desktop = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      ddcutil
      wl-clipboard
    ];

    services = {
      polkit-gnome.enable = lib.mkDefault true;
    };
  };
}
