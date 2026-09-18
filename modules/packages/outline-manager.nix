{ inputs, lib, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      packages = lib.optionalAttrs (system == "x86_64-linux") {
        outline-manager =
          let
            pname = "outline-manager";
            version = "1.21.0";
            src = pkgs.fetchurl {
              # Upstream's stable URL is mutable; update version and hash together.
              url = "https://s3.amazonaws.com/outline-releases/manager/linux/stable/Outline-Manager.AppImage";
              hash = "sha256-qvPR7nyLm6Dzh24XQTPVtB7eCukQ7eXtUo0XPdSpz74=";
            };
            appimageContents = pkgs.appimageTools.extract {
              inherit pname version src;
            };
          in
          pkgs.appimageTools.wrapType2 {
            inherit pname version src;

            extraInstallCommands = ''
              install -Dm644 ${appimageContents}/@outlineserver_manager.desktop $out/share/applications/outline-manager.desktop
              install -Dm644 ${appimageContents}/@outlineserver_manager.png $out/share/icons/hicolor/512x512/apps/outline-manager.png
              substituteInPlace $out/share/applications/outline-manager.desktop \
                --replace-fail "Exec=AppRun" "Exec=outline-manager" \
                --replace-fail "Icon=@outlineserver_manager" "Icon=outline-manager"
            '';

            meta = {
              description = "Create and manage access to Outline servers";
              homepage = "https://getoutline.org/";
              license = lib.licenses.asl20;
              mainProgram = pname;
              platforms = [ "x86_64-linux" ];
              sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
            };
          };
      };
    };
}
