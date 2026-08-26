{ inputs, self, ... }:
{
  flake.homeModules.guiDevTools =
    { pkgs, ... }:
    {
      imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

      home.packages = with pkgs; [
        self.packages.${stdenv.hostPlatform.system}.claude-desktop
        self.packages.${stdenv.hostPlatform.system}.zcode
        inputs.opencode.packages.${stdenv.hostPlatform.system}.opencode
        inputs.opencode.packages.${stdenv.hostPlatform.system}.opencode-desktop
        codex
        vscode-fhs
        code-cursor-fhs
      ];

      home.sessionVariables.CODEX_CLI_PATH = "${pkgs.codex}/bin/codex";
      programs.codexDesktopLinux.enable = true;
    };
}
