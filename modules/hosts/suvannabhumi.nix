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
      # Replace the imports line below with the generated module's attributes
      # (not its outer function and braces), as in hongsawatoi.nix. Keep the
      # hostname, stateVersion, and any hand-added mounts above.
      imports = [ (throw "suvannabhumi: paste generated hardware configuration into modules/hosts/suvannabhumi.nix") ];
    };
}
