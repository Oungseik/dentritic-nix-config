{ ... }: {
  flake.homeModules.cliUtils = { pkgs, ... }: {
    home.packages = with pkgs; [
      dust
      fd
      file
      gnupg
      just
      jq
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
          # Simple navigation/listing only; preserve compound commands.
          "^[[:blank:]]*(cd|z|zi|ls|la|ll|eza)([[:blank:]]+[^;&|<>$`()\\r\\n]*)?[[:blank:]]*$"
          # Screen/session noise and observed clear typos.
          "^[[:blank:]]*(clear|claer|clar|cler|cleasr|pwd|exit)[[:blank:]]*$"
          # Bare launches add no reusable arguments; keep parameterized calls.
          "^[[:blank:]]*(vi|vim|nvim|lvim|btop|htop|top|fastfetch|yazi|lazygit|tmux|codex|pi|omp|opencode)[[:blank:]]*$"
          # Keep Git mutations and inspections with explicit arguments.
          "^[[:blank:]]*git[[:blank:]]+(status|diff|log|branch)[[:blank:]]*$"
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
          rev = "896fa5aec1db0163e2f65d07a130d064de53b0b2";
          hash = "sha256-0nD3jSkUt7mcsfPnJ3yBwdJYRY6JVSxVAj4eXEgBWus=";
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
            -- Available values: "plain", "rounded"
            set = "rounded",
          }
        '';
      };

  };
}
