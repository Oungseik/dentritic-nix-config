{ ... }: {
  flake.homeModules.eReader = { pkgs, ... }: {
    home.packages = with pkgs; [
      evince
      zathura
    ];

    programs.zathura = {
      enable = true;
      mappings = {
        "[normal] <C-=>" = "zoom in";
        "[normal] <C-->" = "zoom out";
      };
      options = {
        default-fg = "rgba(220,215,186,1)";
        default-bg = "rgba(31,31,40,1)";

        completion-bg = "rgba(54,54,70,1)";
        completion-fg = "rgba(220,215,186,1)";
        completion-highlight-bg = "rgba(45,79,103,1)";
        completion-highlight-fg = "rgba(220,215,186,1)";
        completion-group-bg = "rgba(54,54,70,1)";
        completion-group-fg = "rgba(126,156,216,1)";

        statusbar-fg = "rgba(200,192,147,1)";
        statusbar-bg = "rgba(54,54,70,1)";

        notification-bg = "rgba(54,54,70,1)";
        notification-fg = "rgba(220,215,186,1)";
        notification-error-bg = "rgba(54,54,70,1)";
        notification-error-fg = "rgba(228,104,118,1)";
        notification-warning-bg = "rgba(54,54,70,1)";
        notification-warning-fg = "rgba(230,195,132,1)";

        inputbar-fg = "rgba(220,215,186,1)";
        inputbar-bg = "rgba(54,54,70,1)";

        recolor = true;
        recolor-lightcolor = "rgba(31,31,40,1)";
        recolor-darkcolor = "rgba(220,215,186,1)";

        index-fg = "rgba(220,215,186,1)";
        index-bg = "rgba(31,31,40,1)";
        index-active-fg = "rgba(220,215,186,1)";
        index-active-bg = "rgba(45,79,103,1)";

        render-loading-bg = "rgba(31,31,40,1)";
        render-loading-fg = "rgba(220,215,186,1)";

        highlight-color = "rgba(34,50,73,1)";
        highlight-fg = "rgba(220,215,186,1)";
        highlight-active-color = "rgba(45,79,103,1)";
      };
      extraConfig = ''
        set selection-clipboard clipboard
      '';
    };

  };
}
