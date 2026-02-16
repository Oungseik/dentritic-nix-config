{ inputs, self, ... }:
{

  flake.homeConfigurations.oung = inputs.home-manager.lib.homeManagerConfiguration {
    modules = [ self.homeModules.oung ];
  };

  flake.homeModules.oung =
    { pkgs, lib, ... }:
    {
      home = {
        username = "oung";
        homeDirectory = "/home/oung";
      };

      home.sessionVariables = {
        EDITOR = "nvim";
      };

      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };
}
