{ ... }: {
  flake.homeModules.cliUtils = { pkgs, ... }: {
    home.packages = with pkgs; [
      dust
      fd
      file
      gnupg
      just
      lsof
      gnumake
      nix-prefetch-git
      pinentry-curses
      sqlite
      unzip
      zip
    ];

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        auto_sync = true;
        enter_accept = true;
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
          rev = "6229767f7fef39a2a78f5cee9122cc4dfb43f327";
          hash = "sha256-/BNGoWziHIZ9i+RoTWGq/q3ZowNCyHGBOWiz8v2/vOE=";
        };
        starship = pkgs.fetchFromGitHub {
          owner = "Rolv-Apneseth";
          repo = "starship.yazi";
          rev = "ea92cf49380466f07231c952b409831e6afd2156";
          sha256 = "sha256-Jvoc/7YaOOppu8K2lJaVgiuBIyanRHHjEA6ZvnrFtiQ=";
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
