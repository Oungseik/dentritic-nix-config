{ ... }:
{
  flake.homeModules.hyprland =
    { pkgs, lib, ... }:
    let
      lua = lib.generators.mkLuaInline;
      modKey = key: lua ''mod .. " + ${key}"'';
      bind = keys: dispatcher: arg: {
        _args = [
          keys
          (lua "hl.dsp.exec_raw(${builtins.toJSON dispatcher}, ${builtins.toJSON arg})")
        ];
      };
    in
    {
      home.packages = with pkgs; [
        alacritty
        noctalia-shell
        kitty
        jq
        yazi
        grim
        slurp
        wl-clipboard
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        xwayland.enable = true;

        settings = {
          mod._var = "SUPER";
          on._args = [
            "hyprland.start"
            (lua ''function() hl.exec_cmd("noctalia-shell") end'')
          ];

          config = {
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
              "col.active_border" = {
                colors = [
                  "rgba(33ccffee)"
                  "rgba(00ff99ee)"
                ];
                angle = 45;
              };
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
          };

          monitor = {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
          };

          env = {
            _args = [
              "TERMINAL"
              "kitty"
            ];
          };

          curve = {
            _args = [
              "myBezier"
              {
                type = "bezier";
                points = [
                  [
                    0.05
                    0.8
                  ]
                  [
                    0.1
                    1.0
                  ]
                ];
              }
            ];
          };

          animation = [
            {
              leaf = "windows";
              enabled = true;
              speed = 4;
              bezier = "myBezier";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 4;
              bezier = "default";
              style = "popin 80%";
            }
            {
              leaf = "border";
              enabled = true;
              speed = 7;
              bezier = "default";
            }
            {
              leaf = "borderangle";
              enabled = true;
              speed = 6;
              bezier = "default";
            }
            {
              leaf = "fade";
              enabled = true;
              speed = 5;
              bezier = "default";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 5;
              bezier = "default";
            }
          ];

          gesture = {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          };

          bind = [
            (bind (modKey "RETURN") "exec" "kitty")
            (bind (modKey "T") "exec" "alacritty")
            (bind (modKey "E") "exec" "kitty -e yazi")
            (bind (modKey "SHIFT + Q") "killactive" "")
            (bind (modKey "SHIFT + X") "exit" "")
            (bind (modKey "P") "exec" "noctalia-shell ipc call launcher toggle")

            (bind (modKey "M") "fullscreen" "1")
            (bind (modKey "F") "fullscreen" "0")
            (bind (modKey "SHIFT + DELETE") "exec" "hyprlock")

            (bind "F2" "exec" "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-")
            (bind "F3" "exec" "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+")
            (bind "F9" "exec" "brightnessctl set 5%-")
            (bind "F10" "exec" "brightnessctl set +5%")

            (bind "PRINT" "exec"
              ''mkdir -p "$HOME/Pictures/Screenshots" && IMG="$HOME/Pictures/Screenshots/$(date +'%s_grim.png')" && grim -c -o "$(hyprctl activeworkspace -j | jq -r '.monitor')" "$IMG" && wl-copy < "$IMG"''
            )
            (bind (modKey "PRINT") "exec"
              ''mkdir -p "$HOME/Pictures/Screenshots" && IMG="$HOME/Pictures/Screenshots/$(date +'%s_grim.png')" && grim -c -g "$(slurp)" "$IMG" && wl-copy < "$IMG"''
            )

            (bind (modKey "J") "layoutmsg" "cyclenext")
            (bind (modKey "K") "layoutmsg" "cycleprev")
            (bind (modKey "TAB") "layoutmsg" "cyclenext")
            (bind (modKey "SHIFT + TAB") "layoutmsg" "cycleprev")

            (bind (modKey "LEFT") "movefocus" "l")
            (bind (modKey "RIGHT") "movefocus" "r")
            (bind (modKey "UP") "movefocus" "u")
            (bind (modKey "DOWN") "movefocus" "d")

            (bind (modKey "1") "workspace" "1")
            (bind (modKey "2") "workspace" "2")
            (bind (modKey "3") "workspace" "3")
            (bind (modKey "4") "workspace" "4")
            (bind (modKey "5") "workspace" "5")
            (bind (modKey "6") "workspace" "6")
            (bind (modKey "7") "workspace" "7")
            (bind (modKey "8") "workspace" "8")
            (bind (modKey "9") "workspace" "9")

            (bind (modKey "SHIFT + 1") "movetoworkspace" "1")
            (bind (modKey "SHIFT + 2") "movetoworkspace" "2")
            (bind (modKey "SHIFT + 3") "movetoworkspace" "3")
            (bind (modKey "SHIFT + 4") "movetoworkspace" "4")
            (bind (modKey "SHIFT + 5") "movetoworkspace" "5")
            (bind (modKey "SHIFT + 6") "movetoworkspace" "6")
            (bind (modKey "SHIFT + 7") "movetoworkspace" "7")
            (bind (modKey "SHIFT + 8") "movetoworkspace" "8")
            (bind (modKey "SHIFT + 9") "movetoworkspace" "9")

            (bind (modKey "SHIFT + J") "layoutmsg" "swapwithmaster master")

            (bind (modKey "S") "togglespecialworkspace" "magic")
            (bind (modKey "SHIFT + S") "movetoworkspace" "special:magic")
            (bind (modKey "A") "togglespecialworkspace" "terminal")
            (bind (modKey "SHIFT + A") "movetoworkspace" "special:terminal")
            (bind (modKey "N") "togglespecialworkspace" "note")
            (bind (modKey "SHIFT + N") "movetoworkspace" "special:note")

            (bind (modKey "CTRL + H") "movecurrentworkspacetomonitor" "0")
            (bind (modKey "CTRL + L") "movecurrentworkspacetomonitor" "1")
            (bind (modKey "SHIFT + H") "focusmonitor" "-1")
            (bind (modKey "SHIFT + L") "focusmonitor" "+1")

            {
              _args = [
                (modKey "mouse:272")
                (lua ''hl.dsp.exec_raw("movewindow", "")'')
                { mouse = true; }
              ];
            }
            {
              _args = [
                (modKey "mouse:273")
                (lua ''hl.dsp.exec_raw("resizewindow", "")'')
                { mouse = true; }
              ];
            }
          ];

          workspace_rule = {
            workspace = "special:note";
            gaps_in = 0;
            gaps_out = 0;
            on_created_empty = "cd $HOME/Notes && neovide";
          };
        };
      };
    };
}
