# Home Manager feature modules

## Purpose

Define reusable user-level applications, desktop behavior, themes, shells, and toolchains exposed through `flake.homeModules`.

## Ownership

- Each top-level Nix file owns one named Home Manager feature.
- `communication-module.nix` owns team and company communication clients.
- `cli-utils-module.nix` owns CLI utilities and Atuin's command-recording filters.
- `git-module.nix` owns Git, GitHub CLI, Lazygit, and Jujutsu. Jujutsu shares Git's name and email and defaults to colocated Git repositories; repository initialization remains manual.
- `password-managers-module.nix` owns Proton Pass and the legacy `pass` CLI setup during migration, including the Television `pass` channel that copies passwords and OTP codes to the clipboard.
- `desktop-module.nix` owns user tools and services shared across compositors, including `ddcutil`, `wl-clipboard`, and the fallback GNOME Polkit agent; `noctalia-module.nix` disables that agent when Noctalia is composed.
- `e-reader-module.nix` owns the document readers Evince and Zathura and installs the local ZedBrains Mono package for the girara UI font; Zathura carries the Kanagawa Lotus light palette inline (values from rebelot/kanagawa.nvim), rerenders pages as lotus paper with image hues kept, and renders UI text in the configured ZedBrains Mono size.
- `shell-scripts-module.nix` owns generated launcher scripts, the `qr-read` QR-to-clipboard script, and their runtime dependencies.
- `gui-dev-tools.nix` owns graphical coding clients: the local Claude Desktop package, Codex Desktop from the `codex-desktop-linux` input with the nixpkgs Codex CLI exposed through `CODEX_CLI_PATH`, and Zed with declarative vim mode and mutable user settings; VS Code and Cursor stay commented out.
- `gaming-module.nix` owns Lutris through Home Manager's `programs.lutris` module, registers stable WoW64 Wine as its default runner, and exposes Winetricks inside Lutris's runtime environment.
- `hyprland-module.nix` owns the optional Hyprland compositor feature with native Noctalia v5 commands; the selected profile uses Niri.
- `music-module.nix` owns the local-music stack: MPD, mpd-mpris, and rmpc.
- `niri-module.nix` owns declarative Niri settings, generated KDL validation, keybindings, window rules, layout, and GNOME/GTK/GNOME Keyring portal routing.
- `theme.nix` owns shared GTK/Qt styling, per-user fontconfig, and the 24px Bibata Modern Ice pointer default; it installs Roboto and the Noto Sans Thai/Myanmar subsets, keeps Roboto as the primary sans-serif with Thai/Myanmar fallback, supplies Myanmar fallback for explicit Roboto requests (including Zed UI), and supplies Thai/Myanmar fallback for ZedBrainsMono requests. Qt 5/6 general fonts inherit GTK's font family and size.
- `terminal-module.nix` owns Alacritty, Kitty, WezTerm, and Ghostty and installs the local ZedBrains Mono package. Kitty maps the Thai and Myanmar (including Extended-A/B) Unicode blocks to their Noto Sans families without a cell-height override; WezTerm and Ghostty explicitly include those fallbacks, while Alacritty uses shared Fontconfig. WezTerm and Ghostty share the Kanagawa palette and 14pt font and hide their tab bars because Tmux owns multiplexing.
- Ghostty uses 90% background opacity, a non-blinking cursor, and no GTK titlebar; its `Ctrl+Shift+H/L/X/Z/G` bindings are unbound to pass through to terminal applications.
- Keep programming ligatures enabled wherever supported: Kitty uses `disable_ligatures = "never"`; Ghostty and WezTerm retain their enabled defaults. Stock Alacritty does not support ligatures.
- `television-module.nix` owns the Television fuzzy finder; it ships no shell integration because Atuin owns shell history and search.
- `tmux-module.nix` owns Tmux configuration and installs the local Airmux session manager package.
- `developmentEnvironments/` is delegated to its child DOX.
- Enablement and ordering remain owned by `../home/oung.nix`.

## Local Contracts

- A feature module must export a unique `flake.homeModules.<name>` value and must not enable itself in a profile.
- Features must work through the standalone `flake.homeConfigurations.oung` profile and must not depend on Home Manager being embedded into NixOS.
- `homeModules.desktop` must remain compositor-independent and compose with the shared `nixosModules.desktop` system base.
- `homeModules.desktop` installs `ddcutil` for DDC/CI external-monitor control independently of the desktop shell; `nixosModules.desktop` supplies I²C device access.
- Keep compositor modules strictly compositor-specific and composable with the shared desktop modules.
- Keep binaries invoked by generated configuration or keybindings available from the same profile.
- Lutris's default Wine selection and packaged runner links are Nix-managed; installed games, Wine prefixes, and per-game settings remain mutable and managed through Lutris. Do not declaratively replace its game database or import game installers into the Nix store.
- Zsh reapplies every merged `home.sessionPath` entry for interactive shells when a graphical session carries stale Home Manager source guards.
- Interactive Zsh sources `~/.config/zsh/local.zsh` at startup when readable; keep local secrets and installer-managed exports there, outside the Nix store.
- Keep Atuin history slim by excluding simple navigation/listing, screen/session noise, bare editor/UI launches, and bare Git inspections. Preserve argument-bearing editor/UI calls, compound commands, Git mutations, and rare meaningful commands; frequency alone is not an exclusion criterion.
- Atuin filters match whole commands, never arbitrary command-name prefixes. Filter changes affect future recordings; pruning existing history requires explicit approval.
- Tmux resolves `default-shell` from the current user's passwd entry so dev shells cannot replace it through `$SHELL`.
- Tmux snapshots are per server: `tmux-resurrect` writes under `~/.local/state/tmux/resurrect/<socket>` and restores all pane processes with `@resurrect-processes ':all:'`; pane contents are not captured.
- Tmux save and restore stay manual on the plugin's `prefix C-s` / `prefix C-r` bindings, and snapshot retention deliberately stays at the plugin default (age-based cleanup, never below five files).
- Tmux owns pane navigation and keeps 50,000 lines of history; preserve Kitty's disabled `Ctrl+Shift+H/L/X/Z/G` bindings for the Tmux/Vim workflow.
- Kitty keeps 10,000 scrollback lines, uses the default repaint delay, and leaves remote control disabled.
- Frequently changed application configuration belongs under `config/<program>` and is linked by its module with `config.lib.file.mkOutOfStoreSymlink` so edits do not require a Home Manager rebuild.
- Stable application configuration remains declarative in its module; `hyprland-module.nix` uses Home Manager's classic Hyprlang output, not Lua.
- Niri's `wayland.windowManager.niri.settings.binds` is the default source of truth for window, workspace, and monitor navigation; Hyprland mirrors supported semantic equivalents except for explicit Hyprland-specific bindings documented here.
- Home Manager generates and build-validates Niri's `config.kdl`; do not also link or hand-maintain that path.
- Niri screenshots save to `~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png`; keep this aligned with Noctalia's UI-managed output policy in `../../config/AGENTS.md`.
- `shellScripts` supplies launcher dependencies through each `writeShellApplication`; do not add those dependencies to `desktop-module.nix` solely for a launcher.
- `launch-notes` opens or focuses one dedicated Neovide instance in `~/Notes`; Niri's `Mod+N` binds it and places it on `stash`.
- `launch-rmpc` opens or focuses one rmpc Kitty window; Niri's `Mod+Shift+M` binds it and floats it at 60% width and 80% height.
- Niri spawns Discord and Slack at startup; its window rule opens every new window with app-id `discord` or `slack` on the `communication` workspace, including later launches.
- Niri opens Google Chrome windows on the `browser` workspace by app-id `google-chrome` or `google-chrome-stable`; Playwright drives Chrome for Testing, which reports app-id `chromium-browser` and is intentionally left on the focused workspace.
- `qr-read` selects a screen region with `slurp`, pipes a `grim` capture into `zbarimg`, prints every decoded code to stdout, and copies them to the clipboard; without a QR code it exits nonzero and leaves the clipboard untouched.
- Niri's `Mod+Shift+Insert` opens Television's `pass` channel in a dedicated Kitty window floating at 60% width and 80% height. This window uses `close_on_child_death=yes` so clipboard background processes cannot hold it open after the copy action exits; retain the channel's `execute` actions and one-second clipboard delay.
- `Mod+Ctrl+Shift+H/L` moves the current workspace between horizontal monitors; `Mod+Alt+H/L` moves the focused window.
- Keep the GNOME portal in the Home Manager portal set so Niri screen sharing remains available when Hyprland is composed in the same profile.
- Hide Google Meet's screen-sharing status popup in both Niri and Hyprland while retaining a 3px compositor indicator.
- Hyprland starts XDG autostart applications through its Home Manager systemd integration so login services such as GNOME Keyring complete startup.
- Hyprland's `Mod+N` note scratchpad starts `$EDITOR` with `~/Notes` as its working directory.
- Modules that expose mutable configuration still manage their packages, out-of-store links, and stable integration settings; their mutable content is owned by `config/`.
- `noctalia-module.nix` installs the pinned upstream Noctalia v5 package, links `config/noctalia` as its config directory, and links `${xdg.stateHome}/noctalia/settings.toml` to the existing `config/noctalia/state/settings.toml` mirror. Adopt existing state files with Home Manager's `-b` backup option rather than forcing replacement.
- Noctalia owns native locking and clipboard persistence; do not install Hyprlock, Hypridle, or `wl-clip-persist`. Automatic idle locking stays disabled by user preference; `Mod+Shift+Delete` locks manually with `noctalia msg session lock`. Keep Noctalia's existing lock-before-suspend behavior.
- Noctalia owns Polkit authentication prompts: keep `shell.polkit_agent` enabled through its UI and `services.polkit-gnome.enable = false` in `noctalia-module.nix`. Keep the system's `security.polkit.enable` enabled.
- Niri and optional Hyprland use native Noctalia startup, launcher, audio, brightness, screenshot, and lock commands. Niri also uses native monitor-power commands; its `Alt+Print` retains the window screenshot. Re-enter the graphical session after activating the migration so the old shell and idle services are no longer running.

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
- Build `homeConfigurations.oung.activationPackage` after Noctalia integration changes; verify native IPC bindings and absence of the retired shell, locker, and idle services.

## Child DOX Index

- [`developmentEnvironments/AGENTS.md`](developmentEnvironments/AGENTS.md) — language toolchains, debugger assets, mutable user toolchain state, and deferred environments.
