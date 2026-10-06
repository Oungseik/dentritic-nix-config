{ inputs, lib, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      packages = lib.optionalAttrs (system == "x86_64-linux") {
        soulseek-rs =
          let
            pname = "soulseek-rs";
            version = "19.1.0";
          in
          pkgs.stdenvNoCC.mkDerivation {
            inherit pname version;

            src = pkgs.fetchurl {
              url = "https://github.com/michel/soulseek-rs/releases/download/v${version}/soulseek-rs-v${version}-x86_64-unknown-linux-musl.tar.gz";
              hash = "sha256-y3vpSsRm/JUD6VRwflef39ZucXVp2zqmf4RpstpalPw=";
            };

            # The archive contains bare files, no top-level directory.
            sourceRoot = ".";

            dontConfigure = true;
            dontBuild = true;
            # Static-pie binary, already stripped upstream.
            dontStrip = true;

            installPhase = ''
              runHook preInstall
              install -Dm755 soulseek-rs $out/bin/soulseek-rs
              runHook postInstall
            '';

            meta = {
              description = "Soulseek client for the terminal: TUI, CLI and daemon";
              homepage = "https://github.com/michel/soulseek-rs";
              license = lib.licenses.mit;
              mainProgram = "soulseek-rs";
              platforms = [ "x86_64-linux" ];
              sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
            };
          };
      };
    };
}
