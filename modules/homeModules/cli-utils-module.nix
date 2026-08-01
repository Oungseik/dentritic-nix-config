{ ... }: {
  flake.homeModules.cliUtils = { pkgs, ... }: {
    home.packages = with pkgs; [
      dust
      fd
      gnupg
      just
      lsof
      gnumake
      nix-prefetch-git
      pinentry-curses
      unzip
      zip
    ];

    programs.atuin = {
      enable = true;
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
      enable = true;
      settings.vim_keys = true;
    };

    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = "auto";
    };

    programs.fastfetch = {
      enable = true;
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        scan_timeout = 0;
        line_break.disabled = false;
        cmd_duration.disabled = true;
        directory.truncation_length = 5;
        gcloud.disabled = true;
      };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.yazi =
      let
        plugins-repo = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "bbac5e75b22a2893ef7cdd2bd6814b15f2abb91e";
          hash = "sha256-lio4pvrqK575q7M+GtRr/5EdA4h2J/7gIvXK8c5rq1U=";
        };
        starship = pkgs.fetchFromGitHub {
          owner = "Rolv-Apneseth";
          repo = "starship.yazi";
          rev = "159eaba5b5052bf78ff6cfbfe4e527b946818c82";
          sha256 = "sha256-I21to4cxlszRpsb58cvsmwX7VglQBSJC0rrsFIltzC8=";
        };
      in
      {
        enable = true;
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
