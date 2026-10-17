# Live application configuration

## Purpose

Keep frequently changed application configuration outside the Nix store so edits take effect without rebuilding Home Manager.

## Ownership

- Each program directory owns mutable configuration linked into its XDG config or state location by a Home Manager module.
- `noctalia/` retains the v4 UI-generated JSON configuration and registry-installed `plugins/`; upstream does not migrate them into v5.
- `noctalia/state/settings.toml` mirrors the v5 UI-managed settings through an out-of-store link from `~/.local/state/noctalia/settings.toml`. Keep it in the `state/` subdirectory so v5 does not also load it as base configuration. Other runtime state and caches remain outside the repository.

## Local Contracts

- Use this directory only for configuration expected to change frequently.
- Link each program through its Home Manager module with `config.lib.file.mkOutOfStoreSymlink`; the module still owns packages, the link, and stable integration settings.
- Keep stable configuration in its Home Manager module. Move it here only when frequent edits make rebuilds an actual burden.
- Out-of-store links are intentionally mutable and path-dependent; do not describe their contents as Nix-store reproducible.
- Never edit files under `noctalia/` by hand; configure Noctalia only through its UI and retain the generated result.
- Seed the v5 mirror by copying its existing UI-generated settings verbatim; subsequent UI changes must write through the state-file link without rebuilding Home Manager.
- Install, update, configure, and remove Noctalia plugins only through the UI and plugin registry; do not patch registry snapshots locally.
- Review mutable or UI-generated diffs for credentials and unintended machine-local data before committing.

## Work Guidance

- Leave incidental small configuration diffs uncommitted when committing other work; these mutable files change frequently.
- Edit hand-maintained program sources here and let the out-of-store link expose changes immediately.
- Keep both Noctalia mirrors available: v4 is the daily shell, while v5 is configured for optional testing. A Home Manager version change must not migrate, reset, or overwrite either mirror.
- Keep the v5 bar close to the v4 layout: a floating transparent top bar with 37px height, 4px margins, 8px widget spacing, and widget capsules; system monitoring, workspaces, and media on the left, the clock centered, and tray/system controls on the right. Use v5-native widget equivalents while preserving the current font and theme.
- If a requested Noctalia change cannot be performed through the available UI, leave its mirror unchanged and report the required UI action.
- Create a child DOX when a program directory gains its own durable workflow or constraints.

## Verification

- Run `noctalia config validate` after Noctalia settings changes.

## Child DOX Index
