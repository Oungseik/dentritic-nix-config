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
    };
}
