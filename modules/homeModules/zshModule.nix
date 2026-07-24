{ ... }: {
  flake.homeModules.zsh = { ... }: {
    programs.zsh = {
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };
}
