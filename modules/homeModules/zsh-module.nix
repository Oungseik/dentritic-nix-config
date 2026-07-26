{ ... }: {
  flake.homeModules.zsh = { ... }: {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

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
