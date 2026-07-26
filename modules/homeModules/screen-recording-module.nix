{ ... }: {
  flake.homeModules.screenRecording = { pkgs, ... }: {
    home.packages = with pkgs; [ kooha ];
  };
}
