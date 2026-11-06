{ ... }: {
  flake.homeModules.rustDevelopmentEnvironment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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

      home.activation.installRustToolchain = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export CARGO_HOME=${lib.escapeShellArg "${home}/.cargo"}
        export RUSTUP_HOME=${lib.escapeShellArg "${home}/.rustup"}

        run ${pkgs.rustup}/bin/rustup install stable --profile default
        run ${pkgs.rustup}/bin/rustup component add --toolchain stable rust-analyzer rust-src rustfmt clippy
        run ${pkgs.rustup}/bin/rustup default stable
      '';
    };
}
