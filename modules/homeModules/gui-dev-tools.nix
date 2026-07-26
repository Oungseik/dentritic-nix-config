{ ... }: {
  flake.homeModules.guiDevTools = { pkgs, ... }: {
    home.packages = with pkgs; [
      vscode-fhs
      code-cursor-fhs
    ];
  };
}
