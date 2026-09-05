{ ... }:
{
  flake.homeModules.passwordManagers =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.proton-pass-cli ];

      programs.password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (extensions: [
          extensions.pass-audit
          extensions.pass-genphrase
          extensions.pass-otp
        ]);
      };

      programs.television.channels.pass = {
        metadata = {
          name = "pass";
          description = "Search password-store entries; enter copies the password, ctrl-o the OTP code";
          requirements = [ "pass" ];
        };
        source.command = ''cd "''${PASSWORD_STORE_DIR:-$HOME/.password-store}" && find . -name '*.gpg' -printf '%P\n' | sed 's/\.gpg$//' | sort'';
        # No preview: `pass show` would decrypt and launch pinentry-curses over tv's TTY, breaking the channel.
        keybindings = {
          enter = "actions:copy-password";
          ctrl-o = "actions:copy-otp";
        };
        actions = {
          # sleep is super necessary here, unless the password won't be in clipboard
          copy-password = {
            command = "pass show -c '{}' && sleep 1;";
            mode = "execute";
          };
          copy-otp = {
            command = "pass otp -c '{}' && sleep 1";
            mode = "execute";
          };
        };
      };
    };
}
