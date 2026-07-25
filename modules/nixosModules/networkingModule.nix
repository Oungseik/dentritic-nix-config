{ ... }: {
  flake.nixosModules.networkingModule = { ... }: {
    networking = {
      networkmanager.enable = true;
      networkmanager.dns = "none";
      hosts = {
        "127.0.0.1" = [ "sfrclak.com" ];
      };

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
