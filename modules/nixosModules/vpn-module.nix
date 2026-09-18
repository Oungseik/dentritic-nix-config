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
            version = "1.2.4";
            src = pkgs.fetchFromGitHub {
              owner = "throneproj";
              repo = "Throne";
              tag = finalAttrs.version;
              hash = "sha256-fDaU3xjrpjeW8MePBaj5aNGJ2GrNQ3/M3LhtBoU+I/A=";
            };
            patches = map (
              patch:
              if builtins.baseNameOf patch == "nixos-disable-setuid-request.patch" then
                ./throne-nixos.patch
              else
                patch
            ) previousAttrs.patches;
            passthru = previousAttrs.passthru // {
              core = previousAttrs.passthru.core.overrideAttrs {
                vendorHash = "sha256-qr45kA/xw3NARNUAj5OMjNE1JUeYQXkEXArsyc9K5jA=";
              };
            };
          }
        );
        tunMode.enable = true;
      };
    };
  };
}
