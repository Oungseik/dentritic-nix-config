{ ... }: {
  flake.homeModules.cliUtils = { pkgs, ... }: {
    programs.atuin = {
      enableNushellIntegration = true;
      enableZshIntegration = true;

      settings = {
        auto_sync = true;
        sync_frequency = "15m";
        history_filter = [
          "^z"
          "^ls"
          "^vi"
          "^clear"
          "^claer"
          "^git mv"
        ];
      };
    };

    programs.btop = {
      settings.vim_keys = true;
    };

    programs.eza = {
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      icons = "auto";
    };

    programs.git = {
      settings = {
        init.defaultBranch = "main";
        format.pretty = "[%C(yellow)%h%C(reset)] %C(blue)%ad%C(reset) | %s%d [%an]";
        log.date = "short";
        user.name = "Min Aung Thu Win";
        user.email = "mhemaungthuwin@gmail.com";
      };
    };

    programs.starship = {
      settings = {
        add_newline = true;
        line_break.disabled = false;
        cmd_duration.disabled = true;
        directory.truncation_length = 5;
      };
    };

    programs.yazi =
      let
        plugins-repo = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "bbac5e75b22a2893ef7cdd2bd6814b15f2abb91e";
          hash = "ha256-lio4pvrqK575q7M+GtRr/5EdA4h2J/7gIvXK8c5rq1U=";
        };
        starship = pkgs.fetchFromGitHub {
          owner = "Rolv-Apneseth";
          repo = "starship.yazi";
          rev = "159eaba5b5052bf78ff6cfbfe4e527b946818c82";
          sha256 = "sha256-I21to4cxlszRpsb58cvsmwX7VglQBSJC0rrsFIltzC8=";
        };
      in
      {
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = {
          mgr.show_hidden = false;
        };

        theme.flavor.dark = "kanagawa";
        plugins = {
          inherit starship;
          full-border = "${plugins-repo}/full-border.yazi";
        };

        initLua = ''
          require("starship"):setup()
          require("full-border"):setup {
            -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
            type = ui.Border.ROUNDED,
          }
        '';
      };

  };
}
