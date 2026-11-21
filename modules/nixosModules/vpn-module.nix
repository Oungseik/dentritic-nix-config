{ self, ... }: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      sshuttle
      self.packages.${stdenv.hostPlatform.system}.outline-manager
    ];

    programs = {
      throne = {
        enable = true;
        tunMode.enable = true;
      };
    };
  };
}
