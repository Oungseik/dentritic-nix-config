# Live application configuration

## Purpose

Keep frequently changed application configuration outside the Nix store so edits take effect without rebuilding Home Manager.

## Ownership

- Each program directory owns mutable configuration linked into its XDG config or state location by a Home Manager module.
- Only Noctalia v5 configuration and plugins belong under `noctalia/`.
- `noctalia/state/settings.toml` mirrors the v5 UI-managed settings through an out-of-store link from `~/.local/state/noctalia/settings.toml`. Keep it in the `state/` subdirectory so v5 does not also load it as base configuration. Other runtime state and caches remain outside the repository.

## Local Contracts

- Use this directory only for configuration expected to change frequently.
- Link each program through its Home Manager module with `config.lib.file.mkOutOfStoreSymlink`; the module still owns packages, the link, and stable integration settings.
- Keep stable configuration in its Home Manager module. Move it here only when frequent edits make rebuilds an actual burden.
- Out-of-store links are intentionally mutable and path-dependent; do not describe their contents as Nix-store reproducible.
- Configure Noctalia through its UI by default and retain the generated result; direct TOML edits are allowed when explicitly requested by the user.
- Noctalia UI changes must write through the state-file link without rebuilding Home Manager.
- Install, update, configure, and remove Noctalia plugins only through the UI and plugin registry; do not patch registry snapshots locally.
- Review mutable or UI-generated diffs for credentials and unintended machine-local data before committing.

## Work Guidance

- Leave incidental small configuration diffs uncommitted when committing other work; these mutable files change frequently.
- Edit hand-maintained program sources here and let the out-of-store link expose changes immediately.
- Preserve the existing v5 bar, fonts, theme, wallpaper, and clipboard-history preference during integration changes.
- The bar uses Taskbar grouped by workspace with workspace labels hidden and one icon per open window; include inactive workspaces.
- Keep Noctalia screenshots aligned with Niri: in Settings → Screenshot, use Save Folder `~/Pictures/Screenshots` and Filename Pattern `Screenshot from %Y-%m-%d %H-%M-%S` (without `.png`). Enable Save to File; the output format is PNG.
- Keep automatic idle actions disabled; locking is manual.
- Enable Noctalia's native Polkit agent in Settings → Security → Polkit Agent; the Noctalia Home Manager module disables the external GNOME agent.
- If a requested Noctalia change cannot be performed through the available UI, leave its mirror unchanged and report the required UI action unless the user explicitly requests direct TOML editing.
- Create a child DOX when a program directory gains its own durable workflow or constraints.

## Verification

- Run `noctalia config validate` after Noctalia settings changes.

## Child DOX Index
