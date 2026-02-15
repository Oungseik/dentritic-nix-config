{ inputs, self, ... }:
{

  flake.nixosConfigurations."msi-modern15-A5M" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModule.msi-modern15-A5M
      self.nixosModules.gamingModule
    ];
  };

  flake.nixosModule."msi-modern15-A5M" =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      system.stateVersion = "26.05";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.tmp.cleanOnBoot = true;

      environment.systemPackages = with pkgs; [
        curl
        git
        wget
      ];

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General.Experimental = true;
        };
      };
    };
}
