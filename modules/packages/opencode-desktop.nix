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
        opencode-desktop =
          let
            version = "1.18.23";
          in
          pkgs.stdenvNoCC.mkDerivation {
            pname = "opencode-desktop";
            inherit version;

            src = pkgs.fetchurl {
              url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-amd64.deb";
              hash = "sha256-T7B5VtRrEbAoCAPvrmngUP6bwz1yVBwwzxoaP9qrzEY=";
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
              makeWrapper "$out/opt/OpenCode/ai.opencode.desktop" "$out/bin/opencode-desktop" \
                --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"
              for desktop in "$out"/share/applications/*.desktop; do
                substituteInPlace "$desktop" \
                  --replace-fail "Exec=/opt/OpenCode/ai.opencode.desktop" "Exec=opencode-desktop"
              done

              runHook postInstall
            '';

            preFixup = ''
              addAutoPatchelfSearchPath "$out/opt/OpenCode"
            '';

            # musl prebuilts ship SONAMEs autoPatchelfHook can't resolve on glibc;
            # they aren't loaded at runtime on the host libc anyway.
            autoPatchelfIgnoreMissingDeps = [ "libc.musl-*.so.*" ];

            appendRunpaths = [
              "${lib.getLib pkgs.libGL}/lib"
              "/run/opengl-driver/lib"
            ];

            meta = {
              description = "OpenCode desktop app";
              homepage = "https://opencode.ai";
              license = lib.licenses.mit;
              mainProgram = "opencode-desktop";
              platforms = [ "x86_64-linux" ];
              sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
            };
          };
      };
    };
}
