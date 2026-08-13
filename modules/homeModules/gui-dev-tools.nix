{ inputs, self, ... }:
{
  flake.homeModules.guiDevTools =
    { pkgs, ... }:
    {
      imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

      home.packages = with pkgs; [
        self.packages.${stdenv.hostPlatform.system}.claude-desktop
        vscode-fhs
        code-cursor-fhs
      ];

      programs.codexDesktopLinux = {
        enable = true;
        package = pkgs.codex;
      };
    };
}
