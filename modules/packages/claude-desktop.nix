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
        claude-desktop =
          let
            version = "1.24012.9";

            runtimeLibraries = with pkgs; [
              libGL
              libayatana-appindicator
              libnotify
              libpulseaudio
              libsecret
              libuuid
              libxtst
              pipewire
              wayland
            ];

            unwrapped = pkgs.stdenvNoCC.mkDerivation {
              pname = "claude-desktop-unwrapped";
              inherit version;

              src = pkgs.fetchurl {
                url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${version}_amd64.deb";
                hash = "sha256-MC5tII3YyOnlIGfaoo7zsRcaFhNYb9DhC+3GQiJbbuE=";
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

              runtimeDependencies = map lib.getLib runtimeLibraries;

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
                cp -a usr/lib usr/share "$out/"
                makeWrapper "$out/lib/claude-desktop/claude-desktop" \
                  "$out/bin/claude-desktop" \
                  --prefix PATH : ${
                    lib.makeBinPath (
                      with pkgs;
                      [
                        git
                        glib.bin
                        nodejs
                        openssh
                        procps
                        python3
                        xdg-utils
                      ]
                    )
                  } \
                  --prefix VK_ADD_DRIVER_FILES : "/run/opengl-driver/share/vulkan/icd.d"

                runHook postInstall
              '';

              preFixup = ''
                addAutoPatchelfSearchPath "$out/lib/claude-desktop"
              '';

              appendRunpaths = [
                "${lib.getLib pkgs.libGL}/lib"
                "/run/opengl-driver/lib"
              ];
            };

            fhsEnv = pkgs.buildFHSEnv {
              pname = "claude-desktop";
              inherit version;

              targetPkgs =
                pkgs':
                with pkgs';
                [
                  unwrapped
                  glibc
                  qemu_kvm
                  virtiofsd
                ]
                ++ runtimeLibraries;

              extraBuildCommands = ''
                mkdir -p "$out/usr/share/OVMF" "$out/usr/libexec" "$out/usr/bin"
                ln -sf ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd "$out/usr/share/OVMF/OVMF_CODE.fd"
                ln -sf ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd "$out/usr/share/OVMF/OVMF_CODE_4M.fd"
                ln -sf ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd "$out/usr/share/OVMF/OVMF_VARS.fd"
                ln -sf ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd "$out/usr/share/OVMF/OVMF_VARS_4M.fd"
                ln -sf ${pkgs.virtiofsd}/bin/virtiofsd "$out/usr/libexec/virtiofsd"
                ln -sf ${pkgs.virtiofsd}/bin/virtiofsd "$out/usr/bin/virtiofsd"
                ln -sf ${lib.getExe pkgs.git} "$out/usr/bin/git"
                ln -sf ${pkgs.openssh}/bin/ssh "$out/usr/bin/ssh"
                ln -sf ${pkgs.procps}/bin/pgrep "$out/usr/bin/pgrep"
              '';

              extraBwrapArgs = [
                "--dev-bind-try /dev/kvm /dev/kvm"
                "--dev-bind-try /dev/vhost-vsock /dev/vhost-vsock"
                "--dev-bind-try /dev/vhost-net /dev/vhost-net"
                "--dev-bind-try /dev/net/tun /dev/net/tun"
              ];

              extraInstallCommands = ''
                mkdir -p "$out/share"
                ln -s ${unwrapped}/share/* "$out/share/"
              '';

              runScript = "${unwrapped}/bin/claude-desktop";
              dieWithParent = true;

              meta = {
                description = "Desktop application for Claude.ai";
                homepage = "https://claude.ai/download";
                license = lib.licenses.unfree;
                platforms = [ "x86_64-linux" ];
                sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
              };
            };
          in
          fhsEnv;
      };
    };
}
