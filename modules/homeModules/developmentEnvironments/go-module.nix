{ ... }: {
  flake.homeModules.goDevelopmentEnvironment =
    { config, pkgs, ... }:
    let
      goHome = "${config.home.homeDirectory}/.local/share/go";
    in
    {
      home.packages = with pkgs; [
        delve
        go
        go-tools
        golangci-lint
        gopls
        gotestsum
      ];

      home.sessionVariables = {
        GOPATH = goHome;
        GOBIN = "${goHome}/bin";
      };
      home.sessionPath = [ "${goHome}/bin" ];
    };
}
