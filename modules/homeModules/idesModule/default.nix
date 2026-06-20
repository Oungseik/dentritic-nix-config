{ ... }: {
  flake.homeModules = {
    editors =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          neovim
          neovide

          nerd-fonts.jetbrains-mono
          nerd-fonts.zed-mono
        ];

        programs.neovide.settings = {
          theme = "auto";
          font = {
            normal = [
              "ZedMono Nerd Font"
              "JetBrainsMono NF"
            ];
            size = 13;
          };
        };

        home.sessionVariables = {
          EDITOR = "neovide";
        };
      };
  };
}
