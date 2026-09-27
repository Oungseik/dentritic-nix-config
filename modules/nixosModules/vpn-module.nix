{ self, ... }: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      sshuttle
      self.packages.${stdenv.hostPlatform.system}.hiddify
      self.packages.${stdenv.hostPlatform.system}.outline-manager
    ];

    programs = {
      throne = {
        enable = true;
        package = pkgs.throne.overrideAttrs (
          finalAttrs: previousAttrs: {
            version = "1.3.1";
            src = pkgs.fetchFromGitHub {
              owner = "throneproj";
              repo = "Throne";
              tag = finalAttrs.version;
              hash = "sha256-G1i8nFMabkg7qUbqYq/GYXsREXRcSXtDSO+RgiuulIE=";
            };
            patches = builtins.filter (
              patch:
              !builtins.elem (builtins.baseNameOf patch) [
                "nixos-disable-setuid-request.patch"
                "fix-desktop-exec.patch"
              ]
            ) previousAttrs.patches;
            cmakeFlags = (previousAttrs.cmakeFlags or [ ]) ++ [
              "-DNKR_CORE_IN_PATH=ON"
              "-DNKR_ELEVATION_HINT=NixOS:programs.throne.tunMode.enable"
              "-DNKR_DESKTOP_EXEC=Throne"
            ];
            passthru = previousAttrs.passthru // {
              core = previousAttrs.passthru.core.overrideAttrs (coreAttrs: {
                modRoot = "./core";
                patches = [ ];
                tags = builtins.filter (tag: tag != "tfogo_checklinkname") coreAttrs.tags ++ [
                  "tfogo_checklinkname0"
                  "with_openvpn"
                  "with_openconnect"
                  "noparentcheck"
                ];
                vendorHash = "sha256-L189eeaYDdDKGJYT5vr412YpTgHptVfC4jpNSjNcyuk=";
              });
            };
          }
        );
        tunMode.enable = true;
      };
    };
  };
}
