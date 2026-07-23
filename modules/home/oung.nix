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
      self.homeModules.neovim
      self.homeModules.terminals
      self.homeModules.theme
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

      home.packages = with pkgs; [ neovim ];

      home.sessionVariables = {
        EDITOR = lib.mkDefault "nvim";
      };

      home.stateVersion = "26.11";
      programs.home-manager.enable = true;
    };
}
