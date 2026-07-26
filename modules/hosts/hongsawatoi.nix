{ inputs, self, ... }:
{

  flake.nixosConfigurations.hongsawatoi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hongsawatoi
      self.nixosModules.desktop
      self.nixosModules.hyprland
      self.nixosModules.niri
      self.nixosModules.gaming
      self.nixosModules.networking
      self.nixosModules.vpn
    ];
  };

  flake.nixosModules.hongsawatoi =
    {
      config,
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    {
      system.stateVersion = "26.11";
      networking.hostName = "hongsawatoi";
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

      users.users.oung = {
        isNormalUser = true;
        description = "Oung Seik Nyan";
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
      };

      programs.zsh.enable = true;

      services = {
        fstrim.enable = true;
        fwupd.enable = true;
        power-profiles-daemon.enable = true;
      };

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
