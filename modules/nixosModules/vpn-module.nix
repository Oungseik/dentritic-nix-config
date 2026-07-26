{ ... }: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      sshuttle
    ];

    programs = {
      throne = {
        enable = true;
        tunMode.enable = true;
      };
    };
  };
}
