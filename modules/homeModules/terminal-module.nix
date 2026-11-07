{ self, ... }: {
  flake.homeModules.terminals = { pkgs, ... }: {
    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.zedbrains-mono ];

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
  };
}
