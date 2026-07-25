{ ... }: {
  flake.nixosModules.vpn = { ... }: {
    programs = {
      throne = {
        enable = true;
        tunMode.enable = true;
      };
    };
  };
}
