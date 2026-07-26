# Migration notes

Comparison with `/home/oung/nix-config`.

The dendritic layout itself is compatible, and both configurations currently pin the same Nixpkgs and Home Manager revisions. The current dendritic configuration is not ready to switch yet because of the blockers below.

## Intentionally deferred

Do not migrate these until they are needed:

- [ ] PHP development environment (the module may remain disabled)
- [ ] Python development environment and `debugpy`

These are deliberate omissions, not migration bugs.

## Blockers

- [ ] Back up and remove the legacy `~/.config/hypr` and `~/.config/tmux` directory symlinks before switching; otherwise Home Manager would replace files inside `/home/oung/dotfiles`. The existing `~/.config/noctalia` symlink already targets the configured source.

## Decisions needed

### Shell

Decision: keep Zsh for now.

- [ ] Migrate to Nushell later if needed.

The basic Zsh Home Manager module is enabled. Bun, npm, pnpm, Yarn and Cargo paths are managed declaratively through `home.sessionPath`; their installers do not need to modify `.zshrc`. The old custom history/keybindings, `$HOME/.env` loading, aliases, and `.local` PATH entry have not yet been ported.

### Niri

Decision: keep compositor-independent system and user desktop bases, then compose Hyprland, Niri, both, or future compositor features as needed.

Niri remains enabled at the NixOS level, but dendritic does not yet manage `~/.config/niri`.

- [ ] Add a standalone `flake.homeModules.niri` and port the old Niri configuration.

Hyprland is currently selected in `modules/home/oung.nix`; select Niri instead or alongside it after its Home Manager module exists.

Until ported, the old keybindings, window rules, keyboard layout, natural mouse scrolling and Noctalia startup are unavailable under Niri.

## CLI utilities

Intentionally deferred until needed:

- [ ] Helix
- [ ] Zellij

Fastfetch, Firefox, Hyprlock and Tmux are enabled in dendritic. Git and the GitHub CLI are enabled in `modules/homeModules/git-module.nix`.

## Packages to review

Only restore packages that are still used.

### Desktop

- VLC
- Déjà Dup
- appimage-run
- gammastep
- poppler-utils

Discord and Slack are enabled through the communication module. `brightnessctl`, `wl-clip-persist`, PCSX2 and PPSSPP are present and are not lost. Kooha replaces OBS Studio for lightweight meeting video, desktop-audio and microphone recording. `polkit_gnome` supplies the authentication agent, so `hyprpolkitagent` is unnecessary.

### CLI

- age / ssh-to-age
- television
- exercism
- tun2socks
- p7zip

### Development

The JavaScript environment includes Node/npm, Bun, pnpm, Turbo and `vscode-js-debug`. Yarn is intentionally mutable and can be installed globally through npm; writable global package directories are configured outside the Nix store. VS Code and Cursor are enabled through the tracked `gui-dev-tools.nix` module.

The Rust environment includes Rustup and GDB for the existing `rust-gdb` Neovim adapter. Home Manager activation installs the stable default-profile toolchain plus `rust-analyzer` and `rust-src`, sets stable as the default, and keeps the Rustup-managed toolchain mutable.

The Go environment module is prepared with Go, `gopls`, Delve, `gotestsum`, `golangci-lint`, `go-tools`, and an XDG-style GOPATH/PATH setup, but it is intentionally disabled until needed.

The Neovim module provides ripgrep, Hurl, Sleek, Stylua, Vale, nixd, nixfmt, Tombi, markdown-oxide, and `yaml-language-server`. Nixd replaces nil. SQLite and PostgreSQL remain project-specific rather than part of the Home Manager profile.

Review whether to restore:
- Gleam
- ngrok
- Google Cloud SDK
- cloudflared
- bubblewrap
- QEMU
- colmena

PHP and Python are intentionally deferred; see above.

## System behavior changes

### Removed or changed

- Hostname changes from `nixos` to `hongsawatoi`.
- `programs.nix-ld` is disabled.
- The custom FHS shell is removed.
- Bluetooth `mpris-proxy` service is removed.
- `vboxusers` membership is removed.
- `LAUNCH_EDITOR`, `RUSTUP_TOOLCHAIN`, `LD_LIBRARY_PATH`, and the remaining old custom Zsh PATH setup are removed.

### Added

- Steam and Gamescope
- fwupd
- power-profiles-daemon
- Seahorse and GNOME keyring
- Gruvbox Plus icons

Disk UUIDs/filesystems, Bluetooth, PipeWire, NetworkManager, firewall ports, graphics, GDM, Hyprland and Niri remain represented.

## Not actual losses

The old music, statusbar, AGS/Eww, Hyprland, Picom, custom SDDM and custom tree-sitter modules were not wired into the effective old configuration. Their source files do not need to be migrated unless they are wanted again.

Firefox data in `~/.mozilla` should remain. The old declarative Firefox bookmarks were not effective because old `programs.firefox.enable` was false.

## Safe migration checks

Run these after resolving the blockers:

```bash
nix flake check --no-build
nix build .#nixosConfigurations.hongsawatoi.config.system.build.toplevel
nix build .#homeConfigurations.oung.activationPackage

sudo nixos-rebuild test --flake .#hongsawatoi
home-manager switch --flake .#oung -b pre-dendritic
```
