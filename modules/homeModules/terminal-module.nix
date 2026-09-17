{ self, ... }: {
  flake.homeModules.terminals = { pkgs, lib, ... }: {
    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.zedbrains-mono ];

    programs.ghostty = {
      # enable = true;
      settings = {
        theme = "Kanagawa Wave";
        font-family = [
          "ZedBrainsMono Nerd Font"
          "Noto Sans Thai"
          "Noto Sans Myanmar"
        ];
        font-size = 14;
        background-opacity = 0.9;
        cursor-style-blink = false;
        gtk-titlebar = false;
        window-show-tab-bar = "never";
        keybind = [
          "ctrl+shift+h=unbind"
          "ctrl+shift+l=unbind"
          "ctrl+shift+x=unbind"
          "ctrl+shift+z=unbind"
          "ctrl+shift+g=unbind"
        ];
      };
    };

    programs.alacritty = {
      enable = true;
      theme = "kanagawa_wave";
      settings = {
        font = {
          size = 14;
          normal = {
            family = "ZedBrainsMono Nerd Font";
            style = "Regular";
          };
        };

        keyboard.bindings = [
          {
            action = "CreateNewWindow";
            key = "N";
            mods = "Shift|Control";
          }
        ];

        window = {
          opacity = 0.95;
        };

      };

    };

    programs.kitty = {
      enable = true;
      font.name = "ZedBrainsMono Nerd Font";
      font.size = 14;

      themeFile = "kanagawa";

      keybindings = {
        "ctrl+shift+h" = "no_op";
        "ctrl+shift+l" = "no_op";
        "ctrl+shift+x" = "no_op";
        "ctrl+shift+z" = "no_op";
        "ctrl+shift+g" = "no_op";
      };

      extraConfig = ''
        symbol_map U+0E00-U+0E7F Noto Sans Thai
        symbol_map U+1000-U+109F,U+A9E0-U+A9FF,U+AA60-U+AA7F Noto Sans Myanmar
      '';

      settings = {
        cursor_beam_thickness = 1;
        cursor_blink_interval = 0;

        enable_audio_bell = false;
        background_opacity = "0.9";

        editor = "nvim";
        scrollback_lines = 10000;

        input_delay = 3;
        sync_to_monitor = "yes";
        disable_ligatures = "never";
      };
    };

    programs.wezterm = {
      # enable = true;

      settings = {
        color_scheme = "Kanagawa (Gogh)";
        enable_tab_bar = false;
        font = lib.generators.mkLuaInline ''wezterm.font_with_fallback({ "ZedBrainsMono Nerd Font", "Noto Sans Thai", "Noto Sans Myanmar" })'';
        font_size = 14;
      };
    };
  };
}
