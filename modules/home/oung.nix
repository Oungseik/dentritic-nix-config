{ inputs, self, ... }:
{

  flake.homeConfigurations.oung = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        (_final: prev: {
          # shortcut: pinned until nixpkgs has a working release, then remove this override
          neovide = prev.neovide.overrideAttrs (
            finalAttrs: _previousAttrs: {
              version = "0.17.2";
              src = prev.fetchFromGitHub {
                owner = "neovide";
                repo = "neovide";
                tag = finalAttrs.version;
                hash = "sha256-y8lq7zlul47sEZMfVJ54OwM5XJmnZmLlRN/ENVbG6Oc=";
              };
              cargoHash = "sha256-QPk6wmU3W/OOEhEFSX1T07jTK9dkkzIDoIfPXCSqlOI=";
            }
          );
        })
      ];
    };
    modules = [
      self.homeModules.oung
      self.homeModules.browsers
      self.homeModules.cliUtils
      self.homeModules.communication
      self.homeModules.desktop
      self.homeModules.shellScripts
      self.homeModules.eReader
      self.homeModules.gaming
      self.homeModules.guiDevTools
      self.homeModules.git
      # self.homeModules.hyprland
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
      self.homeModules.pythonDevelopmentEnvironment
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
      programs.kitty.enable = true;
      programs.home-manager.enable = true;
    };
}
