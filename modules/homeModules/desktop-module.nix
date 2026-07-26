{ ... }:
{
  flake.homeModules.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      brightnessctl
      grim
      jq
      slurp
      wl-clipboard
      wl-clip-persist
    ];

    services.polkit-gnome.enable = true;
  };
}
