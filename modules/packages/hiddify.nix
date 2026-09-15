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
        hiddify = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "hiddify";
          version = "4.1.1";

          src = pkgs.fetchurl {
            url = "https://github.com/hiddify/hiddify-app/releases/download/v${finalAttrs.version}/Hiddify-Debian-x64.deb";
            hash = "sha256-5iKr0V99RBDFZV8/3ND6kwCURmb6QKwidh8G+TAg8Q4=";
          };

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            dpkg
            wrapGAppsHook3
          ];

          buildInputs = with pkgs; [
            at-spi2-atk
            cairo
            curl
            fontconfig
            gdk-pixbuf
            glib
            gtk3
            harfbuzz
            libayatana-appindicator
            libepoxy
            pango
            stdenv.cc.cc.lib
          ];

          runtimeDependencies = [ (lib.getLib pkgs.libGL) ];
          appendRunpaths = [ "/run/opengl-driver/lib" ];

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

            mkdir -p "$out/bin"
            cp -a usr/share "$out/"
            makeWrapper "$out/share/hiddify/hiddify" "$out/bin/hiddify" \
              --prefix PATH : "${lib.makeBinPath [ pkgs.xdg-utils ]}" \
              --prefix LD_LIBRARY_PATH : "$out/share/hiddify/lib"
            substituteInPlace "$out/share/applications/hiddify.desktop" \
              --replace-fail "Exec=hiddify" "Exec=$out/bin/hiddify" \
              --replace-fail "Version=4.1.1+40101" "Version=1.0"
            printf '\nStartupWMClass=app.hiddify.com\n' >> "$out/share/applications/hiddify.desktop"

            # The bundled CLI otherwise resolves its core relative to the working directory.
            patchelf --replace-needed ./lib/hiddify-core.so hiddify-core.so \
              "$out/share/hiddify/HiddifyCli"

            runHook postInstall
          '';

          preFixup = ''
            addAutoPatchelfSearchPath "$out/share/hiddify/lib"
          '';

          meta = {
            description = "Cross-platform multi-protocol proxy client";
            homepage = "https://hiddify.com";
            # Upstream adds noncommercial restrictions to GPLv3.
            license = lib.licenses.unfree;
            mainProgram = "hiddify";
            platforms = [ "x86_64-linux" ];
            sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
          };
        });
      };
    };
}
