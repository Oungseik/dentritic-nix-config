check-nixos:
    nix flake check --no-build

check user:
    nix build --dry-run .#homeConfigurations.{{user}}.activationPackage

run package:
    nix run .#{{package}}

remove-generations +generations:
    sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations {{generations}}

remove-hm-generations +generations:
    home-manager remove-generations {{generations}}
