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
            version = "3.9.2";
          in
          pkgs.stdenvNoCC.mkDerivation {
            pname = "zcode";
            inherit version;

            src = pkgs.fetchurl {
              url = "https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-x64/ZCode-${version}-linux-x64.deb";
              hash = "sha256-2z9CEaJ4r7sRkrY2MaC/b5c98xgeIV/h+YoypB0nXWw=";
            };

            nativeBuildInputs = with pkgs; [
              autoPatchelfHook
              dpkg
              makeWrapper
            ];

            buildInputs = with pkgs; [
              alsa-lib
              at-spi2-atk
              at-spi2-core
              atk
              cairo
              cups
              dbus
              expat
              glib
              gtk3
              libcap_ng
              libgbm
              libseccomp
              libx11
              libxcb
              libxcomposite
              libxdamage
              libxext
              libxfixes
              libxkbcommon
              libxrandr
              nspr
              nss
              pango
              stdenv.cc.cc.lib
              systemd
            ];

            runtimeDependencies = with pkgs; [
              libGL
              libpulseaudio
              wayland
            ];

            unpackPhase = ''
              runHook preUnpack
              dpkg-deb --fsys-tarfile "$src" \
                | tar -x --no-same-owner --no-same-permissions
              runHook postUnpack
            '';

            dontConfigure = true;
            dontBuild = true;
            dontStrip = true;

            installPhase = ''
              runHook preInstall

              mkdir -p "$out"
              cp -a opt "$out/"
              cp -a usr/share "$out/"
              makeWrapper "$out/opt/ZCode/zcode" "$out/bin/zcode"
              substituteInPlace "$out/share/applications/zcode.desktop" \
                --replace-fail "Exec=/opt/ZCode/zcode" "Exec=zcode"

              runHook postInstall
            '';

            preFixup = ''
              addAutoPatchelfSearchPath "$out/opt/ZCode"
            '';

            appendRunpaths = [
              "${lib.getLib pkgs.libGL}/lib"
              "/run/opengl-driver/lib"
            ];

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
