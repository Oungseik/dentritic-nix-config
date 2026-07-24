{ ... }: {
  flake.homeModules.zsh = { ... }: {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };
}
