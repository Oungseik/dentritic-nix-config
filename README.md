# dendritic-nix-config

Personal NixOS and Home Manager flake for:

- Host: `hongsawatoi`
- User: `oung`

## Apply

Switch NixOS first, then Home Manager:

```sh
sudo nixos-rebuild switch --flake .#hongsawatoi
home-manager switch --flake .#oung
```

## Check

```sh
just check-nixos
just check oung
```
