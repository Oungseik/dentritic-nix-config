{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.wrangler = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "wrangler";
        version = "4.120.0";

        src = pkgs.fetchFromGitHub {
          owner = "cloudflare";
          repo = "workers-sdk";
          rev = "wrangler@${finalAttrs.version}";
          hash = "sha256-gb/+mYZRW8RnMFYRTnrktiYVw6TyYZO47lzoCj4Qq4w=";
        };

        pnpmDeps = pkgs.fetchPnpmDeps {
          inherit (finalAttrs)
            pname
            version
            src
            ;
          pnpm = pkgs.pnpm_10;
          fetcherVersion = 3;
          hash = "sha256-eC6mCJ69cwG2xD9ru9drrhCHiza33QY05V2inMxUKtU=";
        };

        buildInputs = [
          pkgs.llvmPackages.libcxx
          pkgs.llvmPackages.libunwind
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          pkgs.musl
          pkgs.libx11
        ];

        nativeBuildInputs = [
          pkgs.makeWrapper
          pkgs.nodejs
          pkgs.pnpmConfigHook
          pkgs.pnpm_10
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];

        buildPhase = ''
          runHook preBuild
          pnpm exec turbo build --filter=wrangler
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/{bin,lib}
          pnpm config set --location=project injectWorkspacePackages true
          pnpm --filter=wrangler --prod deploy $out/lib
          makeWrapper ${pkgs.lib.getExe pkgs.nodejs} $out/bin/wrangler \
            --inherit-argv0 \
            --set NODE_PATH $out/lib/node_modules \
            --add-flags $out/lib/bin/wrangler.js \
            --set-default SSL_CERT_FILE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
          runHook postInstall
        '';

        doInstallCheck = true;
        nativeInstallCheckInputs = [
          pkgs.versionCheckHook
          pkgs.writableTmpDirAsHomeHook
        ];
        versionCheckKeepEnvironment = [ "HOME" ];

        preFixup = ''
          stripExclude+=("*.js" "*.ts" "*.map" "*.json" "*.md")
        '';

        meta = {
          description = "Command-line interface for all things Cloudflare Workers";
          homepage = "https://github.com/cloudflare/workers-sdk";
          license = with pkgs.lib.licenses; [
            mit
            asl20
          ];
          mainProgram = "wrangler";
          inherit (pkgs.nodejs.meta) platforms;
        };
      });
    };
}
