{ inputs, self, ... }:
{
  flake.homeConfigurations.khinlapyaewon = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    modules = [
      self.homeModules.khinlapyaewon
      self.homeModules.cliUtils
      self.homeModules.zsh
    ];
  };

  flake.homeModules.khinlapyaewon = { pkgs, ... }: {
    home = {
      username = "khinlapyaewon";
      homeDirectory = "/Users/khinlapyaewon";
      stateVersion = "26.11";
    };

    home.packages = [ pkgs.neovim ];
    programs.home-manager.enable = true;
  };
}
