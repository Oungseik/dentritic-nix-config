{ self, ... }:
{
  flake.homeModules.guiDevTools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        self.packages.${stdenv.hostPlatform.system}.claude-desktop
        self.packages.${stdenv.hostPlatform.system}.codex-desktop
        # vscode-fhs
        # code-cursor-fhs
      ];

      programs.zed-editor = {
        enable = true;
        userSettings.vim_mode = true;
      };
    };
}
