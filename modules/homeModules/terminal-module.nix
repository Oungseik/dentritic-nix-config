{ ... }: {
  flake.homeModules.terminals = { ... }: {
    programs.alacritty = {
      enable = true;
      theme = "kanagawa_wave";
      settings = {
        font = {
          size = 14;
          normal = {
            family = "ZedMono Nerd Font";
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
      font.name = "JetBrainsMono NF";
      font.size = 12;

      themeFile = "kanagawa";

      keybindings = {
        "ctrl+shift+h" = "no_op";
        "ctrl+shift+l" = "no_op";
        "ctrl+shift+x" = "no_op";
        "ctrl+shift+z" = "no_op";
        "ctrl+shift+g" = "no_op";
      };

      settings = {
        "modify_font cell_height" = "110%";

        cursor_beam_thinkness = 1;
        cursor_blink_interval = 0;

        enable_audio_bell = false;
        background_opacity = "0.9";

        editor = "nvim";

        cursor_trail = 1;
        repaint_delay = 20;
        input_delay = 3;
        sync_to_monitor = "yes";
        allow_remote_control = "yes";
        listen_on = "unix:@mykitty";
        disable_ligatures = "never";
      };
    };
  };
}
