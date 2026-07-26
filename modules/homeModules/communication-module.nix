{ ... }: {
  flake.homeModules.communication = { pkgs, ... }: {
    home.packages = with pkgs; [
      discord
      slack
    ];
  };
}
