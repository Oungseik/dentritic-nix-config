{ ... }: {
  flake.homeModules = {
    tmux = { pkgs, ... }: {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        keyMode = "vi";
        mouse = true;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          {
            plugin = tmux-nova;
            extraConfig = ''
              set -g @nova-nerdfonts false
              set -g @nova-pane "#{?window_active,,}#I:#W"

              set -g @nova-segment-os " ::"
              set -g @nova-segment-computer " :#h"
              set -g @nova-segment-session " :#S"

              set -g @nova-rows 0
              set -g @nova-segments-0-left "os"
              set -g @nova-segments-0-right "computer session"
            '';
          }
        ];

        extraConfig = ''
          set -ag terminal-overrides ",alacritty:RGB"
          set -ga terminal-overrides ",xterm-256color*:Tc"
          set -sa terminal-features ",xterm-256color:extkeys"

          set -g extended-keys on
          set -g extended-keys-format csi-u

          set -g focus-events on
          set -s set-clipboard on

          bind -T copy-mode-vi v send -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe
        '';
      };
    };
  };
}
