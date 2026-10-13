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

## Hermes — manual use

The `oung` profile installs [Hermes v0.21.7](https://github.com/NousResearch/hermes-agent/releases/tag/v0.21.7)
and the catalog-reviewed [JEV skill router](https://hermes-agent.nousresearch.com/docs/plugins/jev-skill-router).
This is Home Manager-only: no NixOS switch is needed for this feature.
No gateway, backend, desktop application, or startup service is enabled.
The local package also disables upstream setup/import's implicit service installation,
and the agent's cronjob toolset is disabled.

Activate and configure a main reasoning provider:

```sh
home-manager switch --flake .#oung
hermes model
hermes skills opt-in --sync
```

`hermes model` handles the main model's login/API key. JEV is a decision model,
not a replacement for that provider. The skill-sync command copies bundled skills
into writable state and preserves edited and agent-created skills.

Keep the JEV key in a private runtime file, never in this checkout:

```sh
install -d -m 700 ~/.hermes
touch ~/.hermes/.env
chmod 600 ~/.hermes/.env
nvim ~/.hermes/.env
```

Add `TYPESAFE_API_KEY=your-key` there for a direct TypeSafe/JEV key.
The router uses `auto` mode: it runs during an explicitly started Hermes session
when that key is present, otherwise it stays silent. Its backend is pinned to
`typesafe`, so a main-model OpenRouter key is not silently reused for JEV.
If the JEV key comes from OpenRouter or Vercel instead, change the router's
`backend` in `modules/homeModules/hermes-agent-module.nix` and use the corresponding
`OPENROUTER_API_KEY` or `AI_GATEWAY_API_KEY`. Endpoint/model overrides remain normal
Hermes runtime settings.

Run only when wanted, preferably from a dedicated job-research directory rather
than this configuration checkout:

```sh
hermes jev-skill-router status
hermes jev-skill-router check  # checks local readiness; no inference call
hermes
```

The JEV hook makes typed decisions about relevant skills before the main model
call; it does not answer arbitrary questions without that model. It sends the
request text, skill names/descriptions, and short shortlisted skill excerpts to
the selected JEV endpoint. It can add latency; the quoted millisecond response
and 40% learning-loop speedup are not installation guarantees.

Sessions, memories, credentials, and learned skills persist in `~/.hermes`.
Skills accumulate during use, and `/learn` in a conversation can save a reusable
workflow. No background daemon is required. DuckDuckGo search is packaged for
keyless web research; remote search availability and site access restrictions
still apply. `career-ops` is not installed or integrated.

To uninstall from the profile, set `programs.hermes-agent.enable = false;` in
`modules/home/oung.nix`, then run `home-manager switch --flake .#oung`.
This removes the program, JEV link, and managed settings but preserves
`~/.hermes`, including its API keys, so learning survives reinstallation.
Delete that directory separately only if you also want to erase all Hermes data.
Previous Nix generations/store paths are retained until explicitly cleaned up.
Updates go through the pinned flake inputs and Home Manager, not `hermes update`
or pip.

## Check

```sh
just check-nixos  # after suvannabhumi's hardware configuration is available
just check oung
```
