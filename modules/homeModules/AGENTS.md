# Home Manager feature modules

## Purpose

Define reusable user-level applications, desktop behavior, themes, shells, and toolchains exposed through `flake.homeModules`.

## Ownership

- Each top-level Nix file owns one named Home Manager feature.
- `communication-module.nix` owns team and company communication clients.
- `desktop-module.nix` owns user tools and services shared across compositors.
- `hyprland-module.nix` owns the Hyprland compositor feature; a future `niri-module.nix` will own an independent Niri feature.
- `developmentEnvironments/` is delegated to its child DOX.
- Enablement and ordering remain owned by `../home/oung.nix`.

## Local Contracts

- A feature module must export a unique `flake.homeModules.<name>` value and must not enable itself in a profile.
- Features must work through the standalone `flake.homeConfigurations.oung` profile and must not depend on Home Manager being embedded into NixOS.
- `homeModules.desktop` must remain compositor-independent and compose with the shared `nixosModules.desktop` system base.
- Keep compositor modules strictly compositor-specific. Profiles may compose Hyprland, Niri, both, or future compositor features with the shared desktop modules.
- Keep binaries invoked by generated configuration or keybindings available from the same profile.
- Frequently changed application configuration belongs under `config/<program>` and is linked by its module with `config.lib.file.mkOutOfStoreSymlink` so edits do not require a Home Manager rebuild.
- Stable application configuration remains declarative in its module; `hyprland-module.nix` uses Home Manager's classic Hyprlang output, not Lua.
- The owning module still manages packages, the out-of-store link, and stable integration settings; mutable configuration content is owned by `config/`.
- `noctalia-module.nix` intentionally links `config/noctalia` from the repository's current absolute location.
- `hyprlock-module.nix` consumes the tracked lock-screen asset; preserve the relative source relationship.
- `theme.nix` consumes the `gruvbox-plus` package output from `modules/packages/`.

## Work Guidance

- Extend an existing feature when ownership is clear; add a new module only for an independently selectable feature.
- Put a desktop tool in `homeModules.desktop` only when it is compositor-independent and intended across desktop profiles.
- Add each new compositor as its own feature and reuse the shared desktop module instead of copying common tools.
- Keep packages, session variables, and stable configuration together when they form one feature; split out only configuration that changes frequently.
- Keep SQLite and PostgreSQL project-specific; user-level editor modules may provide client-side SQL tooling such as `sleek`.

## Verification

- Run `just check oung`.

## Child DOX Index

- [`developmentEnvironments/AGENTS.md`](developmentEnvironments/AGENTS.md) — language toolchains, debugger assets, mutable user toolchain state, and deferred environments.
