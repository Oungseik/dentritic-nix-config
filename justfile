check-nixos:
    nix flake check --no-build

check-oung:
    nix build --dry-run .#homeConfigurations.oung.activationPackage
