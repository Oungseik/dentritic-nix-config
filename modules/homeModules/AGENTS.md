# Home Manager feature modules

## Purpose

Define reusable user-level applications, desktop behavior, themes, shells, and toolchains exposed through `flake.homeModules`.

## Ownership

- Each top-level Nix file owns one named Home Manager feature.
- `communication-module.nix` owns team and company communication clients.
- `password-managers-module.nix` owns Proton Pass and the legacy `pass` CLI setup during migration.
- `desktop-module.nix` owns user tools and services shared across compositors, including Wayland clipboard persistence.
- `gui-dev-tools.nix` owns graphical coding clients, including the local Claude Desktop package and Codex Desktop from the `codex-desktop-linux` input with its launcher pinned to the nixpkgs Codex CLI.
- `hyprland-module.nix` owns the Hyprland compositor feature.
- `niri-module.nix` owns the out-of-store Niri configuration link and GNOME screencast portal availability.
- `theme.nix` owns shared GTK/Qt styling and the 24px Bibata Modern Ice pointer default.
- `terminal-module.nix` owns Alacritty and Kitty and installs and selects the local ZedBrains Mono package.
- `developmentEnvironments/` is delegated to its child DOX.
- Enablement and ordering remain owned by `../home/oung.nix`.

## Local Contracts

- A feature module must export a unique `flake.homeModules.<name>` value and must not enable itself in a profile.
- Features must work through the standalone `flake.homeConfigurations.oung` profile and must not depend on Home Manager being embedded into NixOS.
- `homeModules.desktop` must remain compositor-independent and compose with the shared `nixosModules.desktop` system base.
- Keep compositor modules strictly compositor-specific and composable with the shared desktop modules.
- Keep binaries invoked by generated configuration or keybindings available from the same profile.
- Zsh reapplies every merged `home.sessionPath` entry for interactive shells when a graphical session carries stale Home Manager source guards.
- Tmux resolves `default-shell` from the current user's passwd entry so dev shells cannot replace it through `$SHELL`.
- Frequently changed application configuration belongs under `config/<program>` and is linked by its module with `config.lib.file.mkOutOfStoreSymlink` so edits do not require a Home Manager rebuild.
- Stable application configuration remains declarative in its module; `hyprland-module.nix` uses Home Manager's classic Hyprlang output, not Lua.
- Niri's `config/niri/keybindings.kdl` is the default source of truth for window, workspace, and monitor navigation; Hyprland mirrors supported semantic equivalents except for explicit Hyprland-specific bindings documented here.
- Keep the GNOME portal in the Home Manager portal set so Niri screen sharing remains available when Hyprland is composed in the same profile.
- Hide Google Meet's screen-sharing status popup in both Niri and Hyprland while retaining a 3px compositor indicator.
- Hyprland starts XDG autostart applications through its Home Manager systemd integration so login services such as GNOME Keyring complete startup.
- Hyprland's `Mod+N` note scratchpad starts `$EDITOR` with `~/Notes` as its working directory.
- The owning module still manages packages, the out-of-store link, and stable integration settings; mutable configuration content is owned by `config/`.
- `noctalia-module.nix` intentionally links `config/noctalia` from the repository's current absolute location.
- `hyprlock-module.nix` consumes the tracked lock-screen asset; preserve the relative source relationship.

## Work Guidance

- Extend an existing feature when ownership is clear; add a new module only for an independently selectable feature.
- Preserve existing Hyprland bindings when they already behave like their Niri counterparts; change only missing, conflicting, or explicitly Hyprland-specific navigation.
- In Hyprland, `Mod+H/L` cycles backward/forward through windows on the current workspace; other directional window and monitor bindings use only `H/L` because this profile treats Hyprland topology as horizontal and leaves `J/K` unbound.
- In both compositors, `Mod+Tab` cycles through windows on the current workspace and `Mod+Shift+Tab` toggles the current and previous workspace.
- Put a desktop tool in `homeModules.desktop` only when it is compositor-independent and intended across desktop profiles.
- Add each new compositor as its own feature and reuse the shared desktop module instead of copying common tools.
- Keep packages, session variables, and stable configuration together when they form one feature; split out only configuration that changes frequently.
- Keep database servers project-specific.

## Verification

- Run `just check oung`.

## Child DOX Index

- [`developmentEnvironments/AGENTS.md`](developmentEnvironments/AGENTS.md) — language toolchains, debugger assets, mutable user toolchain state, and deferred environments.
