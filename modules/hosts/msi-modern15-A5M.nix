{ inputs, self, ... }:
{

  flake.nixosConfigurations."msi-modern15-A5M" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.msi-modern15-A5M
      self.nixosModules.desktopModule
      self.nixosModules.gamingModule
    ];
  };

  flake.nixosModules."msi-modern15-A5M" =
    {
      config,
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    {
      system.stateVersion = "26.11";
      networking.hostName = "msi-modern15-A5M";

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

      fileSystems."/home/oung/extra-storage" = {
        device = "/dev/disk/by-uuid/eb8fb263-fa19-4de5-8b05-ec034f3a3857";
        fsType = "ext4";
        options = [
          "defaults"
          "nofail"
        ];
      };

      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/8b220869-87c5-4afe-8e4d-817bb0f93c67";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/02F3-D5E2";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/4cb4a67d-7b77-4f39-ad1e-f256e347696d"; } ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
