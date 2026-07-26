{ ... }: {
  flake.homeModules.neovim =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        neovim
        neovide
        ripgrep
        tree-sitter

        hurl
        sleek

        lua-language-server
        markdown-oxide
        nixd
        nixfmt
        stylua
        tombi
        vale
        yaml-language-server

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
