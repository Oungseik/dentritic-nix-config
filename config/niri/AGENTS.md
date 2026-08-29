# Niri live configuration

## Purpose

Keep hand-maintained Niri configuration editable through the live out-of-store XDG link.

## Ownership

- `config.kdl` owns startup, input, animation, client-side decoration preference, and include settings.
- `keybindings.kdl` owns keyboard and hardware bindings and is the source of truth for compositor navigation bindings.
- `window_rules.kdl` owns workspaces, window rules, and layout.

## Local Contracts

- `config.kdl` includes `keybindings.kdl` and `window_rules.kdl`.
- `Mod+N` opens one dedicated Neovide instance in `~/Notes` on the `stash` workspace, or focuses that window when it already exists.
- `Mod+Shift+M` opens one rmpc Kitty window floating at 60% of the available width and height, or focuses that window when it already exists.
- `Mod+Ctrl+Shift+H/L` moves the current workspace to the monitor on the left or right, not the active window or column.
- `Mod+Alt+H/L` moves the focused window to the monitor on the left or right.
- `Mod+Tab` cycles through windows on the current workspace; `Mod+Shift+Tab` toggles the current and previous workspace.
- Group keybindings by purpose: applications, hardware controls, window management, workspaces, screenshots, and session controls.

## Work Guidance

- Keep bindings in the closest related group and use concise hotkey-overlay titles for user-facing actions.
- Prefer Vim-style directional bindings (`H/J/K/L` and `U/I`) over duplicate arrow or paging-key aliases.
- Keep client-side decorations disabled so applications omit title bars where supported.
- Focus windows when the pointer moves over them.
- Open Kitty, regular Google Chrome, Claude Desktop, and Codex Desktop windows at full column width by default; open matched temporary Chrome dialogs floating at 70% width.
- Hide Google Meet's screen-sharing status popup content while retaining a 3px focus ring as a sharing indicator.
- After changing window, workspace, or monitor navigation, mirror every Hyprland-supported semantic equivalent in `../../modules/homeModules/hyprland-module.nix`.

## Verification

- Run `niri validate --config config/niri/config.kdl`.

## Child DOX Index
