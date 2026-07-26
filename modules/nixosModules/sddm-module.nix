{ ... }:
{
  flake.nixosModules.sddm = { pkgs, ... }: {
    services = {
      xserver.enable = true;
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        extraPackages = [ pkgs.qt6.qtsvg ];
        theme = "catppuccin-mocha-mauve";
      };
    };

    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
      })
    ];
  };
}
