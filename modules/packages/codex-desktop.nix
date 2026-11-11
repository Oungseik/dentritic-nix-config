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
        codex-desktop =
          (pkgs.chatgpt.override {
            codex = null;
            # shortcut: nixpkgs Tectonic lacks AWS-LC; remove when its build inputs include it.
            tectonic-unwrapped = pkgs.tectonic-unwrapped.overrideAttrs (previousAttrs: {
              buildInputs = previousAttrs.buildInputs ++ [ pkgs.aws-lc ];
            });
          }).overrideAttrs
            (previousAttrs: {
              passthru = previousAttrs.passthru // {
                sources.${system} = rec {
                  version = "26.1106.51428";
                  src = {
                    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${version}_amd64.deb";
                    hash = "sha256-g1anghkwsTW3QTR/rMvEPhaStEJMPqtxCpr1bAvrsTU=";
                  };
                };
              };
            });
      };
    };
}
