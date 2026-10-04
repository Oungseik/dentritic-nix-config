# dendritic-nix-config

Personal NixOS flake for `hongsawatoi` and a pending `suvannabhumi` host.
The standalone `oung` Home Manager profile is available only where that user exists.

## Apply

Switch NixOS first, then Home Manager:

```sh
sudo nixos-rebuild switch --flake .#hongsawatoi
home-manager switch --flake .#oung
```

Before installing `suvannabhumi`:

1. On the new machine, generate its hardware configuration with `nixos-generate-config --root /mnt` after mounting its root and boot partitions.
2. In `modules/hosts/suvannabhumi.nix`, replace the placeholder `imports` line with the attributes inside the generated `/mnt/etc/nixos/hardware-configuration.nix` (omit its outer function and braces), as in `hongsawatoi.nix`. Do not reuse the old machine's disk UUIDs or CPU settings.
3. Declare the intended user's account in `modules/hosts/suvannabhumi.nix` before installing: `sharedHost` creates no users, and root SSH login is disabled. Set `system.stateVersion` to the installation release. Identify its trusted network interface and add an interface-scoped SSH firewall rule only if remote login is wanted.
4. Run `just check-nixos`, then install with `sudo nixos-install --flake .#suvannabhumi` from the mounted installation. After boot, switch NixOS with `sudo nixos-rebuild switch --flake .#suvannabhumi`. Run `home-manager switch --flake .#oung` only if `oung` is the chosen user; otherwise configure that person's own Home Manager profile.

Until the inline hardware block is replaced, `suvannabhumi` deliberately fails evaluation;
`just check-nixos` also fails. To check only the existing host in the meantime,
use `nix eval --raw .#nixosConfigurations.hongsawatoi.config.system.build.toplevel.drvPath`.

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
just check-nixos  # after suvannabhumi's hardware configuration is available
just check oung
```
