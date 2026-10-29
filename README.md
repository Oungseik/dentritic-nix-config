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

## Pinned packages

Most Nix-managed packages are pinned together by the Nixpkgs revision in
[`flake.lock`](flake.lock). These packages and plugins have individual pins;
the linked Nix files and lock file are the source of truth.

| Package or plugin | Current pin | Where to update it |
| --- | --- | --- |
| Noctalia | `v5.4.0` | [`flake.nix`](flake.nix) and `flake.lock`; keep v5 |
| Claude Desktop | `4.29.0` | [`claude-desktop.nix`](modules/packages/claude-desktop.nix) |
| Airmux | `0.2.3-unstable-2026-09-12`, commit `77832c6` | [`airmux.nix`](modules/packages/airmux.nix); personal fork |
| Outline Manager | `1.22.0` | [`outline-manager.nix`](modules/packages/outline-manager.nix); mutable download URL |
| Gruvbox Plus icons | `6.6.0` | [`gruvybox-plus.nix`](modules/packages/gruvybox-plus.nix) |
| ZedBrains Mono | `1.0` label | [`zedbrains-mono.nix`](modules/packages/zedbrains-mono.nix); font files are bundled locally |
| soulseek-rs | `19.1.0` | [`soulseek-rs.nix`](modules/packages/soulseek-rs.nix); available, not selected for installation |
| Codex Desktop | commit `8594584` | [`flake.lock`](flake.lock), input `codex-desktop-linux` |
| Yazi full-border plugin | commit `896fa5a` | [`cli-utils-module.nix`](modules/homeModules/cli-utils-module.nix) |
| Yazi Starship plugin | commit `ea92cf4` | [`cli-utils-module.nix`](modules/homeModules/cli-utils-module.nix) |

To update pins:

- Update shared Nixpkgs and Home Manager with `nix flake update nixpkgs home-manager`.
  Codex Desktop has a separate Nixpkgs pin, which this command does not update.
- Change Noctalia's v5 tag in `flake.nix`, then run `nix flake update noctalia`.
  Update Codex Desktop with `nix flake update codex-desktop-linux`.
- For the other fetched packages and plugins, update the version or commit and
  the corresponding source hash in the linked file. Airmux also needs its
  `cargoHash` updated. Outline's mutable URL may stop matching its pinned hash.
- Run the [checks below](#check) and apply changes using the order above.

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
