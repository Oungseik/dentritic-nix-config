# Nix module tree

## Purpose

Implement flake outputs as composable feature modules discovered recursively by `import-tree`.

## Ownership

- `flake-parts.nix` defines shared flake-parts systems and the `flake.homeModules` option.
- `home/` composes Home Manager profiles and owns per-user base settings.
- `hosts/` composes NixOS systems and owns hardware, filesystems, users, and state versions.
- `nixosModules/` owns reusable system features; its Niri feature provides `xwayland-satellite` for Niri's on-demand X11 compatibility, and its Waydroid feature enables containerized Android apps with nftables networking for current kernels.
- `packages/` owns custom package outputs, including Airmux, Wrangler, ZCode, the OpenCode Desktop deb package, and the locally bundled four-face ZedBrains Mono font family.
- `homeModules/` is delegated to its child DOX.

## Local Contracts

- Every Nix file below this directory is auto-imported; each must be a valid flake-parts module without manual import wiring.
- Export stable, unique names through `flake.homeModules`, `flake.nixosModules`, `flake.homeConfigurations`, `flake.nixosConfigurations`, or `perSystem.packages`.
- Defining a module does not enable it. Compose Home Manager features in `home/oung.nix` and NixOS features in the applicable file under `hosts/`.
- Organize reusable modules by feature rather than building monolithic host or desktop modules; profiles gain behavior by composing the required features.
- Keep `flake.nixosConfigurations` and `flake.homeConfigurations` independent; do not embed Home Manager into the NixOS configuration.
- Keep machine and system settings in `hosts/` or `nixosModules/`; keep user programs and settings in `home/` or `homeModules/` so they can switch without rebuilding NixOS.
- Change `system.stateVersion` or `home.stateVersion` only as part of an explicit migration.
- The `oung` base profile exposes `~/.local/bin` on the shell path for user-installed executables.

## Work Guidance

- Put runtime dependencies in the same scope as their consumer: `home.packages` for user features and `environment.systemPackages` for system features.
- Keep `nixosModules.desktop` focused on shared system services and `homeModules.desktop` focused on shared user tools and services; both desktop bases must remain compositor- and display-manager-independent.
- Compose graphical hosts with one display-manager module and whichever compositor features the profile needs.
- Keep compositor-specific behavior in separate feature modules so adding or replacing a compositor does not duplicate or disturb shared desktop behavior.

## Verification

- Run `just check-nixos` for system or package changes.
- Run `just check oung` for Home Manager changes.

## Child DOX Index

- [`homeModules/AGENTS.md`](homeModules/AGENTS.md) — reusable Home Manager feature modules and optional development environments.
