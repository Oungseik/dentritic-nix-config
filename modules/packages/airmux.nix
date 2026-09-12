{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # Builds from the personal fork: upstream v0.2.3 has no tag carrying the
      # `init` and `clean` commands, so the rev is pinned instead of a release.
      packages.airmux = pkgs.rustPlatform.buildRustPackage rec {
        pname = "airmux";
        version = "0.2.3-unstable-2026-09-12";

        src = pkgs.fetchFromGitHub {
          owner = "Oungseik";
          repo = "airmux";
          rev = "77832c6ce353c41f8f0158e450b0ffe13725fca0";
          hash = "sha256-hbr1EyJB7NwBx9VAJG8ZPETJrZ7YQUFnzSW++gad3rQ=";
        };

        cargoHash = "sha256-ulD6LbGHnIJxCic/I+zo3INRwQ9oKTFfte26YqRvjdg=";

        # Several upstream tests mutate the process-wide working directory.
        RUST_TEST_THREADS = "1";

        meta = {
          description = "Tmux session manager";
          homepage = "https://github.com/Oungseik/airmux";
          license = pkgs.lib.licenses.mit;
          mainProgram = "airmux";
        };
      };
    };
}
