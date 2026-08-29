# Home Manager feature modules

## Purpose

Define reusable user-level applications, desktop behavior, themes, shells, and toolchains exposed through `flake.homeModules`.

## Ownership

- Each top-level Nix file owns one named Home Manager feature.
- `communication-module.nix` owns team and company communication clients.
- `password-managers-module.nix` owns Proton Pass and the legacy `pass` CLI setup during migration, including the Television `pass` channel that copies passwords and OTP codes to the clipboard.
- `desktop-module.nix` owns user tools and services shared across compositors, including Wayland clipboard persistence.
- `shell-scripts-module.nix` owns generated Niri launcher scripts and their runtime dependencies.
- `gui-dev-tools.nix` owns graphical coding clients, including the local Claude Desktop, ZCode, and Codex Desktop packages, Codex Desktop from the `codex-desktop-linux` input with the nixpkgs Codex CLI exposed through `CODEX_CLI_PATH`, and VS Code and Cursor.
- `hyprland-module.nix` owns the Hyprland compositor feature.
- `music-module.nix` owns the local-music stack: MPD, mpd-mpris, and rmpc.
- `niri-module.nix` owns declarative Niri settings, generated KDL validation, keybindings, window rules, layout, and GNOME/GTK/GNOME Keyring portal routing.
- `theme.nix` owns shared GTK/Qt styling and the 24px Bibata Modern Ice pointer default.
- `terminal-module.nix` owns Alacritty and Kitty and installs and selects the local ZedBrains Mono package.
- `television-module.nix` owns the Television fuzzy finder; it ships no shell integration because Atuin owns shell history and search.
- `tmux-module.nix` owns Tmux configuration and installs the local Airmux session manager package.
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
- Niri's `wayland.windowManager.niri.settings.binds` is the default source of truth for window, workspace, and monitor navigation; Hyprland mirrors supported semantic equivalents except for explicit Hyprland-specific bindings documented here.
- Home Manager generates and build-validates Niri's `config.kdl`; do not also link or hand-maintain that path.
- `shellScripts` supplies launcher dependencies through each `writeShellApplication`; do not add those dependencies to `desktop-module.nix` solely for a launcher.
- `launch-notes` opens or focuses one dedicated Neovide instance in `~/Notes`; Niri's `Mod+N` binds it and places it on `stash`.
- `launch-rmpc` opens or focuses one rmpc Kitty window; Niri's `Mod+Shift+M` binds it and floats it at 60% width and height.
- Niri's `Mod+Shift+Insert` opens Television's `pass` channel in a dedicated Kitty window floating at 40% width and 60% height.
- `Mod+Ctrl+Shift+H/L` moves the current workspace between horizontal monitors; `Mod+Alt+H/L` moves the focused window.
- Keep the GNOME portal in the Home Manager portal set so Niri screen sharing remains available when Hyprland is composed in the same profile.
- Hide Google Meet's screen-sharing status popup in both Niri and Hyprland while retaining a 3px compositor indicator.
- Hyprland starts XDG autostart applications through its Home Manager systemd integration so login services such as GNOME Keyring complete startup.
- Hyprland's `Mod+N` note scratchpad starts `$EDITOR` with `~/Notes` as its working directory.
- Modules that expose mutable configuration still manage their packages, out-of-store links, and stable integration settings; their mutable content is owned by `config/`.
- `noctalia-module.nix` intentionally links `config/noctalia` from the repository's current absolute location.
- `hyprlock-module.nix` consumes the tracked lock-screen asset; preserve the relative source relationship.

## Work Guidance

- Extend an existing feature when ownership is clear; add a new module only for an independently selectable feature.
- Group Niri bindings by purpose inside `settings.binds` and keep hotkey-overlay titles concise.
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
