{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.airmux = pkgs.rustPlatform.buildRustPackage rec {
        pname = "airmux";
        version = "0.2.3";

        src = pkgs.fetchFromGitHub {
          owner = "dermoumi";
          repo = "airmux";
          rev = "v${version}";
          hash = "sha256-LAwnFAlBpJEcoKelFFJTIGSM4Auf37+eoJVZcNQgDqw=";
        };

        cargoHash = "sha256-mWUcCV6r/dIlcFnl3sZ/3t4gnRIIROM1YtKHA9Nab9s=";

        # Several upstream tests mutate the process-wide working directory.
        RUST_TEST_THREADS = "1";

        meta = {
          description = "Tmux session manager";
          homepage = "https://github.com/dermoumi/airmux";
          license = pkgs.lib.licenses.mit;
          mainProgram = "airmux";
        };
      };
    };
}
