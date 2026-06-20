{ inputs, self, ... }:
{

  flake.homeConfigurations.oung = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    modules = [
      self.homeModules.oung
      self.homeModules.browsers
      self.homeModules.editors
      self.homeModules.terminals
      self.homeModules.tmux
    ];
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

      home.stateVersion = "26.11";
      programs.home-manager.enable = true;
    };
}
