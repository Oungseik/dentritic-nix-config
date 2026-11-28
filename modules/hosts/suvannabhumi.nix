{ inputs, self, ... }:
{
  flake.nixosConfigurations.suvannabhumi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.suvannabhumi
      self.nixosModules.sharedHost
      self.nixosModules.desktop
      self.nixosModules.sddm
      self.nixosModules.niri
      self.nixosModules.gaming
      self.nixosModules.waydroid
      self.nixosModules.networking
      self.nixosModules.vpn
    ];
  };

  flake.nixosModules.suvannabhumi =
    { config, lib, modulesPath, ... }:
    {
      networking.hostName = "suvannabhumi";
      # Declare the intended user's account here before installing; root SSH login is disabled.
      # Set this to the NixOS release used for the first installation.
      system.stateVersion = "26.11";
      # Open SSH on the new machine's trusted interface only after identifying it.

      # ---- BEGIN hardware-configuration.nix ----
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/9f59595c-fb70-4fb3-b653-f56094feeb74";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/C1A0-D4A5";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/98fb9b75-a66c-4272-94a9-f9a91bd3ffde"; } ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
