{ ... }:
{
  flake.homeModules.hyprland = { ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      xwayland.enable = true;

      settings = {
        "$mod" = "SUPER";

        monitor = ", preferred, auto, 1";
        "exec-once" = "noctalia-shell";
        env = "TERMINAL, kitty";

        input = {
          kb_layout = "us, mm";
          kb_options = "grp:win_space_toggle";
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = 0;
        };

        general = {
          gaps_in = 4;
          gaps_out = 4;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "master";
          allow_tearing = false;
        };

        decoration = {
          rounding = 6;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
          shadow = {
            enabled = false;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1acc)";
          };
        };

        animations.enabled = true;
        dwindle.preserve_split = true;

        master = {
          special_scale_factor = 0.9;
          mfact = 0.625;
        };

        misc.force_default_wallpaper = 2;

        bezier = "myBezier, 0.05, 0.8, 0.1, 1.0";
        animation = [
          "windows, 1, 4, myBezier"
          "windowsOut, 1, 4, default, popin 80%"
          "border, 1, 7, default"
          "borderangle, 1, 6, default"
          "fade, 1, 5, default"
          "workspaces, 1, 5, default"
        ];

        gesture = "3, horizontal, workspace";

        bind = [
          "$mod, RETURN, exec, kitty"
          "$mod, T, exec, alacritty"
          "$mod, E, exec, kitty -e yazi"
          "$mod SHIFT, Q, killactive"
          "$mod SHIFT, X, exit"
          "$mod, P, exec, noctalia-shell ipc call launcher toggle"

          "$mod, M, fullscreen, 1"
          "$mod, F, fullscreen, 0"
          "$mod SHIFT, DELETE, exec, hyprlock"

          ", F2, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
          ", F3, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ", F9, exec, brightnessctl set 5%-"
          ", F10, exec, brightnessctl set +5%"

          '', PRINT, exec, mkdir -p "$HOME/Pictures/Screenshots" && IMG="$HOME/Pictures/Screenshots/$(date +'%s_grim.png')" && grim -c -o "$(hyprctl activeworkspace -j | jq -r '.monitor')" "$IMG" && wl-copy < "$IMG"''
          ''$mod, PRINT, exec, mkdir -p "$HOME/Pictures/Screenshots" && IMG="$HOME/Pictures/Screenshots/$(date +'%s_grim.png')" && grim -c -g "$(slurp)" "$IMG" && wl-copy < "$IMG"''

          "$mod, J, layoutmsg, cyclenext"
          "$mod, K, layoutmsg, cycleprev"
          "$mod, TAB, layoutmsg, cyclenext"
          "$mod SHIFT, TAB, layoutmsg, cycleprev"

          "$mod, LEFT, movefocus, l"
          "$mod, RIGHT, movefocus, r"
          "$mod, UP, movefocus, u"
          "$mod, DOWN, movefocus, d"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"

          "$mod SHIFT, J, layoutmsg, swapwithmaster master"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
          "$mod, A, togglespecialworkspace, terminal"
          "$mod SHIFT, A, movetoworkspace, special:terminal"
          "$mod, N, togglespecialworkspace, note"
          "$mod SHIFT, N, movetoworkspace, special:note"

          "$mod CTRL, H, movecurrentworkspacetomonitor, 0"
          "$mod CTRL, L, movecurrentworkspacetomonitor, 1"
          "$mod SHIFT, H, focusmonitor, -1"
          "$mod SHIFT, L, focusmonitor, +1"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        workspace = "special:note, gapsin:0, gapsout:0, on-created-empty:$EDITOR $HOME/Notes";
      };
    };
  };
}
