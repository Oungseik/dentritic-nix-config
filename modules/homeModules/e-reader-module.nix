{ self, ... }: {
  flake.homeModules.eReader = { pkgs, ... }: {
    home.packages = with pkgs; [
      evince
      zathura
      self.packages.${pkgs.stdenv.hostPlatform.system}.zedbrains-mono
    ];

    programs.zathura = {
      enable = true;
      mappings = {
        "[normal] <C-=>" = "zoom in";
        "[normal] <C-->" = "zoom out";
      };
      # Kanagawa "Lotus" (light) palette; literals taken from the upstream
      # palette in rebelot/kanagawa.nvim (`lua/kanagawa/colors.lua`).
      options = {
        # girara UI font (statusbar, inputbar, completion); page text scales with zoom.
        font = "ZedBrainsMono Nerd Font 14";

        default-fg = "#545464"; # lotusInk1
        default-bg = "#f2ecbc"; # lotusWhite3

        completion-bg = "#c7d7e0"; # lotusBlue1
        completion-fg = "#43436c"; # lotusInk2
        completion-highlight-bg = "#9fb5c9"; # lotusBlue3
        completion-highlight-fg = "#43436c"; # lotusInk2
        completion-group-bg = "#c7d7e0"; # lotusBlue1
        completion-group-fg = "#4d699b"; # lotusBlue4

        statusbar-fg = "#43436c"; # lotusInk2
        statusbar-bg = "#e7dba0"; # lotusWhite4

        notification-bg = "#e7dba0"; # lotusWhite4
        notification-fg = "#545464"; # lotusInk1
        notification-error-bg = "#e7dba0"; # lotusWhite4
        notification-error-fg = "#e82424"; # lotusRed3
        notification-warning-bg = "#e7dba0"; # lotusWhite4
        notification-warning-fg = "#e98a00"; # lotusOrange2

        inputbar-fg = "#545464"; # lotusInk1
        inputbar-bg = "#e7dba0"; # lotusWhite4

        recolor = true;
        recolor-lightcolor = "#f2ecbc"; # lotusWhite3, pages read as warm paper
        recolor-darkcolor = "#545464"; # lotusInk1
        recolor-keephue = true; # keep image hues, remap luminance only

        index-fg = "#545464"; # lotusInk1
        index-bg = "#f2ecbc"; # lotusWhite3
        index-active-fg = "#545464"; # lotusInk1
        index-active-bg = "#b5cbd2"; # lotusBlue2

        render-loading-bg = "#f2ecbc"; # lotusWhite3
        render-loading-fg = "#545464"; # lotusInk1

        highlight-color = "#c9cbd1"; # lotusViolet3
        highlight-fg = "#545464"; # lotusInk1
        highlight-active-color = "#b5cbd2"; # lotusBlue2
      };
      extraConfig = ''
        set selection-clipboard clipboard
      '';
    };

  };
}
