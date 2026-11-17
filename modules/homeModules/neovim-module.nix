{ ... }: {
  flake.homeModules.neovim =
    { pkgs, lib, config, ... }:
    {
      home.packages = with pkgs; [
        neovim
        neovide
        ripgrep
        tree-sitter

        hurl
        sleek
        sqruff

        lua-language-server
        markdown-oxide
        kdlfmt
        nixd
        nixfmt
        stylua
        tombi
        vale
        yaml-language-server

        nerd-fonts.jetbrains-mono
        nerd-fonts.zed-mono
      ];

      home.activation.cloneNeovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        nvimConfig=${lib.escapeShellArg "${config.xdg.configHome}/nvim"}
        if [ ! -e "$nvimConfig" ] && [ ! -L "$nvimConfig" ]; then
          run mkdir -p ${lib.escapeShellArg config.xdg.configHome}
          run ${pkgs.git}/bin/git clone https://github.com/oungseik/neovim-config "$nvimConfig"
        elif [ ! -d "$nvimConfig/.git" ] && [ ! -f "$nvimConfig/.git" ]; then
          echo "Warning: $nvimConfig exists without Git metadata; leaving it untouched." >&2
        fi
      '';

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
        EDITOR = "nvim";
      };
    };
}
