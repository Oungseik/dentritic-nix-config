{ ... }: {
  flake.homeModules.zsh = { ... }: {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      history = {
        append = true;
        share = true;
        ignoreSpace = true;
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
      };

      initContent = ''
        bindkey -e
        bindkey '^P' history-beginning-search-backward
        bindkey '^N' history-beginning-search-forward
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" 'ma=7'
        zstyle ':completion:*' menu select

        autoload -U select-word-style
        select-word-style bash

        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^X^E' edit-command-line
      '';

      shellAliases = {
        ls = "eza";
        la = "eza -la";
        v = "nvim";
        nix = "nix --experimental-features 'nix-command flakes pipe-operators'";
        home-manager = "home-manager --experimental-features 'nix-command flakes pipe-operators'";
      };
    };
  };
}
