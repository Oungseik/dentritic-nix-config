{ ... }: {
  flake.homeModules.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = true;

      plugins = with pkgs.tmuxPlugins; [
        sensible
        {
          plugin = vim-tmux-navigator;
          extraConfig = ''
            # Forward Ctrl-hjkl to pane-aware applications.
            set -g @vim_navigator_pattern '(\S+/)?g?\.?(view|l?n?vim?x?|fzf|otlp-tui)(diff)?(-wrapped)?'
          '';
        }
        {
          plugin = tmux-nova;
          extraConfig = ''
            set -g @nova-nerdfonts false
            set -g @nova-pane "#{?window_active,,}#I:#W"

            set -g @nova-pane-active-border-style "colour8"
            set -g @nova-pane-border-style "colour0"
            set -g @nova-status-style-bg "default"
            set -g @nova-status-style-fg "colour3"
            set -g @nova-status-style-active-bg "default"
            set -g @nova-status-style-active-fg "colour6"
            set -g @nova-status-style-double-bg "default"

            set -g @nova-segment-os " ::"
            set -g @nova-segment-os-colors "default colour4"
            set -g @nova-segment-computer " :#h"
            set -g @nova-segment-computer-colors "default colour5"
            set -g @nova-segment-session " :#S"
            set -g @nova-segment-session-colors "default colour4"

            set -g @nova-rows 0
            set -g @nova-segments-0-left "os"
            set -g @nova-segments-0-right "computer session"
          '';
        }
      ];

      extraConfig = ''
        run-shell '${pkgs.tmux}/bin/tmux set-option -g default-shell "$(${pkgs.getent}/bin/getent passwd "$(${pkgs.coreutils}/bin/id -u)" | ${pkgs.coreutils}/bin/cut -d: -f7)"'

        set -ag terminal-overrides ",alacritty:RGB"
        set -ga terminal-overrides ",xterm-256color*:Tc"
        set -sa terminal-features ",xterm-256color:extkeys"

        set -g extended-keys on
        set -g extended-keys-format csi-u

        set -g focus-events on
        set -s set-clipboard on

        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x
      '';
    };
  };
}
