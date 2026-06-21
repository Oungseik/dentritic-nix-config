{ ... }: {
  flake.homeModules.neovim =
    { config, pkgs, ... }:
    let
      home = config.home.homeDirectory;
      nvimPath = "${home}/nix-config/modules/homeModules/idesModule/nvim";
    in
    {
      home.packages = with pkgs; [
        neovim
        neovide

        nerd-fonts.jetbrains-mono
        nerd-fonts.zed-mono
      ];

      xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink nvimPath;

      programs.neovide.settings = {
        theme = "auto";
        font = {
          normal = [
            "ZedMono Nerd Font"
            "JetBrainsMono NF"
          ];
          size = 13;
        };
      };

      home.sessionVariables = {
        EDITOR = "neovide";
      };
    };
}
