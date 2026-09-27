{ ... }:
{
  flake.nixosModules.sharedHost =
    { pkgs, ... }:
    {
      time.timeZone = "Asia/Yangon";

      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 1w";
        };
        settings.auto-optimise-store = true;
        settings.experimental-features = [
          "pipe-operators"
          "nix-command"
          "flakes"
        ];
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.tmp.cleanOnBoot = true;

      environment.systemPackages = with pkgs; [
        curl
        clang
        gcc
        git
        wget
      ];

      programs.nix-ld.enable = true;
      programs.zsh.enable = true;

      services = {
        fstrim.enable = true;
        openssh = {
          enable = true;
          openFirewall = false;
          settings.PasswordAuthentication = true;
          settings.KbdInteractiveAuthentication = false;
          settings.PermitRootLogin = "no";
        };
        fwupd.enable = true;
        power-profiles-daemon.enable = true;
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General.Experimental = true;
      };
    };
}
