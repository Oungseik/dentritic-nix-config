{ inputs, lib, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages = lib.optionalAttrs (system == "x86_64-linux") {
        zcode =
          let
            version = "3.8.1";

            src = pkgs.fetchurl {
              url = "https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-x64/ZCode-${version}-linux-x64.AppImage";
              hash = "sha256-tCDepQlht31cdbCLkk2kGrUpxyCn7DLqy+labYQxmeA=";
            };

            appimageContents = pkgs.appimageTools.extract {
              pname = "zcode";
              version = "3.8.1";
              inherit src;
            };
          in
          pkgs.appimageTools.wrapType2 {
            pname = "zcode";
            version = "3.8.1";
            inherit src;

            extraInstallCommands = ''
              install -Dm644 ${appimageContents}/zcode.desktop $out/share/applications/zcode.desktop
              install -Dm644 ${appimageContents}/zcode.png $out/share/icons/hicolor/512x512/apps/zcode.png
              substituteInPlace $out/share/applications/zcode.desktop \
                --replace-fail "Exec=AppRun" "Exec=zcode"
            '';

          meta = {
            description = "ZCode desktop app";
            homepage = "https://z.ai/zcode";
            license = lib.licenses.unfree;
            mainProgram = "zcode";
            platforms = [ "x86_64-linux" ];
            sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
          };
        };
      };
    };
}
