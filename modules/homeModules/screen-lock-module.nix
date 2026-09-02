{ ... }: {
  flake.homeModules.screenLock = { pkgs, ... }: {
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      playerctl
    ];

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "pidof hyprlock || hyprlock";
          after_sleep_cmd = "niri msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "pidof hyprlock || hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "niri msg output eDP-1 off";
            on-resume = "niri msg output eDP-1 on";
          }
          {
            timeout = 3600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      extraConfig = ''
        background {
            monitor =
            path =
            reload_cmd = noctalia-shell ipc call wallpaper get eDP-1
            blur_passes = 2
            blur_size = 3
            contrast = 0.8916
            brightness = 0.8172
            vibrancy = 0.1696
            vibrancy_darkness = 0.0
        }

        input-field {
            monitor =
            size = 250, 60
            outline_thickness = 2
            dots_size = 0.2
            dots_spacing = 0.2
            dots_center = true
            outer_color = rgba(0, 0, 0, 0)
            inner_color = rgba(0, 0, 0, 0.5)
            font_color = rgb(200, 200, 200)
            fade_on_empty = false
            font_family = JetBrains Mono Nerd Font Mono
            placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
            hide_input = false
            position = 0, -120
            halign = center
            valign = center
        }

        label {
            monitor =
            text = cmd[update:1000] echo "$(date +"%-I:%M%p")"
            color = rgb(cdd6f4)
            font_size = 120
            font_family = JetBrains Mono Nerd Font Mono ExtraBold
            position = 0, -300
            halign = center
            valign = top
        }

        label {
            monitor =
            text = Hi there, $USER
            color = rgb(cdd6f4)
            font_size = 25
            font_family = JetBrains Mono Nerd Font Mono
            position = 0, -40
            halign = center
            valign = center
        }

        label {
            monitor =
            text = cmd[update:1000] sh -c 'echo "$(playerctl metadata title)   $(playerctl metadata artist)"'
            color = rgb(cdd6f4)
            font_size = 18
            font_family = JetBrains Mono Nerd Font Mono
            position = 0, 0
            halign = center
            valign = bottom
        }
      '';
    };
  };
}
