{ ... }: {
  flake.nixosModules.networkingModule = { ... }: {
    networking = {
      networkmanager.enable = true;
      networkmanager.dns = "none";
      hosts = {
        "127.0.0.1" = [ "sfrclak.com" ];
      };

      # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      nameservers = [
        "8.8.8.8"
        "8.8.4.4"
      ];

      firewall.allowedTCPPorts = [
        4173
        5173
      ];
    };
  };
}
