{ ... }: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    home.packages = with pkgs; [
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
