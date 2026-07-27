# Niri live configuration

## Purpose

Keep hand-maintained Niri configuration editable through the live out-of-store XDG link.

## Ownership

- `config.kdl` owns startup, input, animation, and include settings.
- `keybindings.kdl` owns keyboard and hardware bindings and is the source of truth for compositor navigation bindings.
- `window_rules.kdl` owns workspaces, window rules, and layout.

## Local Contracts

- `config.kdl` includes `keybindings.kdl` and `window_rules.kdl`.
- Group keybindings by purpose: applications, hardware controls, window management, workspaces, screenshots, and session controls.

## Work Guidance

- Keep bindings in the closest related group and use concise hotkey-overlay titles for user-facing actions.
- Prefer Vim-style directional bindings (`H/J/K/L` and `U/I`) over duplicate arrow or paging-key aliases.
- After changing window, workspace, or monitor navigation, mirror every Hyprland-supported semantic equivalent in `../../modules/homeModules/hyprland-module.nix`.

## Verification

- Run `niri validate --config config/niri/config.kdl`.

## Child DOX Index
