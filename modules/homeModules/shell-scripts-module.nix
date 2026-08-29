{ ... }:
{
  flake.homeModules.shellScripts =
    { pkgs, ... }:
    let
      launchNotes = pkgs.writeShellApplication {
        name = "launch-notes";
        runtimeInputs = with pkgs; [
          jq
          neovide
          niri
        ];
        text = ''
          id=$(niri msg --json windows | jq -r 'first(.[] | select(.app_id == "neovide-notes") | .id) // empty')
          [[ -z $id ]] || exec niri msg action focus-window --id "$id"

          cd "$HOME/Notes"
          exec neovide --wayland_app_id neovide-notes .
        '';
      };

      launchRmpc = pkgs.writeShellApplication {
        name = "launch-rmpc";
        runtimeInputs = with pkgs; [
          jq
          kitty
          niri
          rmpc
        ];
        text = ''
          id=$(niri msg --json windows | jq -r 'first(.[] | select(.app_id == "rmpc") | .id) // empty')
          [[ -z $id ]] || exec niri msg action focus-window --id "$id"

          exec kitty --class rmpc -e rmpc
        '';
      };

      qrRead = pkgs.writeShellApplication {
        name = "qr-read";
        runtimeInputs = with pkgs; [
          grim
          slurp
          wl-clipboard
          zbar
        ];
        text = ''
          region=$(slurp) || exit 0

          content=$(grim -g "$region" - | zbarimg -q --raw -) || exit 1

          printf '%s\n' "$content"
          printf '%s' "$content" | wl-copy
        '';
      };
    in
    {
      home.packages = [
        launchNotes
        launchRmpc
        qrRead
      ];
    };
}
