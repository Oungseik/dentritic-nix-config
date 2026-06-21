{ ... }: {
  flake.nixosModules.vpnModule = { ... }: {
    programs = {
      throne = {
        enable = true;
        tunMode.enable = true;
      };
    };
  };
}
