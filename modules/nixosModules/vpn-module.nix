{ self, ... }: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      sshuttle
      self.packages.${stdenv.hostPlatform.system}.hiddify
    ];

    programs = {
      throne = {
        enable = true;
        tunMode.enable = true;
      };
    };
  };
}
