{ ... }: {
  flake.homeModules.rustDevelopmentEnvironment =
    { config, lib, pkgs, ... }:
    let
      home = config.home.homeDirectory;
    in
    {
      home.packages = with pkgs; [
        gdb
        rustup
      ];

      home.sessionVariables = {
        CARGO_HOME = "${home}/.cargo";
        RUSTUP_HOME = "${home}/.rustup";
      };
      home.sessionPath = [ "${home}/.cargo/bin" ];

      # ponytail: Rustup keeps toolchains mutable by request; pin with Nix when reproducibility matters.
      home.activation.installRustToolchain = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export CARGO_HOME=${lib.escapeShellArg "${home}/.cargo"}
        export RUSTUP_HOME=${lib.escapeShellArg "${home}/.rustup"}
        rustup=${lib.escapeShellArg "${pkgs.rustup}/bin/rustup"}

        if [[ -v DRY_RUN ]]; then
          echo "Would install the stable Rust toolchain, rust-analyzer, and rust-src"
        else
          if ! "$rustup" run stable rustc --version >/dev/null 2>&1; then
            "$rustup" toolchain install stable --profile default
          fi

          installed=$("$rustup" component list --toolchain stable --installed)
          if ! grep -q '^rust-analyzer-' <<< "$installed" || ! grep -q '^rust-src-' <<< "$installed"; then
            "$rustup" component add --toolchain stable rust-analyzer rust-src
          fi

          "$rustup" default stable
        fi
      '';
    };
}
