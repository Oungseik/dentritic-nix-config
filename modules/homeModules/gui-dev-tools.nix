{ inputs, ... }:
{
  flake.homeModules.guiDevTools =
    { pkgs, ... }:
    {
      imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

      home.packages = with pkgs; [
        vscode-fhs
        code-cursor-fhs
      ];

      programs.codexDesktopLinux = {
        enable = true;
        cliPackage = pkgs.codex;
      };
    };
}
