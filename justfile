check-nixos:
    nix flake check --no-build

check user:
    nix build --dry-run .#homeConfigurations.{{user}}.activationPackage

run package:
    nix run .#{{package}}
