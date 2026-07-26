{ ... }: {
  flake.homeModules.neovim =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        git
        lazygit
        neovim
        neovide
        tree-sitter

        lua-language-server

        nerd-fonts.jetbrains-mono
        nerd-fonts.zed-mono
      ];

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
