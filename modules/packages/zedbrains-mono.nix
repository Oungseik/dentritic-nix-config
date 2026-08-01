{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.zedbrains-mono = pkgs.stdenvNoCC.mkDerivation {
        pname = "zedbrains-mono";
        version = "1.0";
        src = ../../assets/fonts/zedbrains-mono;

        dontBuild = true;
        installPhase = ''
          runHook preInstall
          install -Dm644 *.ttf -t "$out/share/fonts/truetype"
          install -Dm644 OFL.txt "$out/share/licenses/zedbrains-mono/OFL.txt"
          runHook postInstall
        '';

        meta = {
          description = "Zed Mono Nerd Font with JetBrains Mono programming ligatures";
          license = pkgs.lib.licenses.ofl;
          platforms = pkgs.lib.platforms.all;
        };
      };
    };
}
