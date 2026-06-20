{ ... }:
{
  flake.homeModules = {
    browsers =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          firefox
          google-chrome
        ];

        programs.firefox = {
          enable = true;
        };
      };
  };
}
