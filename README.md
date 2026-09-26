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

## SSH from Termux

Install OpenSSH in Termux with `pkg install openssh`. Apply the NixOS change on
the laptop with `sudo nixos-rebuild switch --flake .#hongsawatoi`. On the same
Wi-Fi network, connect from Termux with `ssh oung@192.168.99.192` and enter
your laptop account password. Replace the address with the laptop's current
Wi-Fi IPv4 address from `ip -4 addr show wlp1s0`. Root login is disabled;
port 22 is allowed through the firewall on `wlp1s0` only. Avoid using
untrusted Wi-Fi while this service is enabled.

## Check

```sh
just check-nixos
just check oung
```
