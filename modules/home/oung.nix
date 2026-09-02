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
      self.homeModules.cliUtils
      self.homeModules.communication
      self.homeModules.desktop
      self.homeModules.shellScripts
      self.homeModules.eReader
      self.homeModules.guiDevTools
      self.homeModules.git
      # self.homeModules.hyprland
      self.homeModules.screenLock
      # self.homeModules.music
      self.homeModules.neovim
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.passwordManagers
      self.homeModules.screenRecording
      self.homeModules.television
      self.homeModules.terminals
      self.homeModules.theme
      self.homeModules.tmux
      self.homeModules.zsh

      self.homeModules.javascriptDevelopmentEnvironment
      self.homeModules.rustDevelopmentEnvironment
      # self.homeModules.goDevelopmentEnvironment
      # self.homeModules.phpDevelopmentEnvironment
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
      home.sessionPath = [ "$HOME/.local/bin" ];

      home.sessionVariables = {
        EDITOR = lib.mkDefault "nvim";
      };

      home.stateVersion = "26.11";
      programs.home-manager.enable = true;
    };
}
