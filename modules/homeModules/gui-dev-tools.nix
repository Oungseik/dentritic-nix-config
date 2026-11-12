{ inputs, self, ... }:
{
  flake.homeModules.guiDevTools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        self.packages.${stdenv.hostPlatform.system}.claude-desktop
        inputs.codex-desktop-linux.packages.${stdenv.hostPlatform.system}.default
        # vscode-fhs
        # code-cursor-fhs
      ];

      programs.zed-editor = {
        enable = true;
        userSettings.vim_mode = true;
      };
    };
}
