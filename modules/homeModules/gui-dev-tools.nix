{ inputs, self, ... }:
{
  flake.homeModules.guiDevTools =
    { pkgs, ... }:
    {
      imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

      home.packages = with pkgs; [
        self.packages.${stdenv.hostPlatform.system}.claude-desktop
        self.packages.${stdenv.hostPlatform.system}.opencode-desktop
        codex
        # vscode-fhs
        # code-cursor-fhs
      ];

      programs.zed-editor = {
        enable = true;
        userSettings.vim_mode = true;
      };

      home.sessionVariables.CODEX_CLI_PATH = "${pkgs.codex}/bin/codex";
      programs.codexDesktopLinux.enable = true;
    };
}
