---
name: dendritic-nix
description: Design, review, migrate, refactor, and extend Nix flake repositories into a strict dendritic module pattern. Use when Codex needs to create or audit `flake.nix`, `modules/hosts/*.nix`, `modules/nixosModules/*.nix`, `modules/home/*.nix`, or `modules/homeModules/*.nix` in any repository, including repos that do not yet have the dendritic tree, while keeping a thin root flake, explicit `self.nixosModules` or `self.homeModules` composition, reusable branch modules, repo-native Nix validation, and avoidance of anti-patterns such as monolithic flakes, host-specific state in shared modules, hidden cross-branch imports, or naming drift.
---

# Dendritic Nix Config

## Workflow

1. Identify the target repo root. Prefer the nearest ancestor containing `flake.nix` from the working directory. If none exists, ask where the new flake should live before creating files.
2. Read `flake.nix` and the existing tree before editing. If the repo is not yet dendritic, plan the migration target as `modules/hosts`, `modules/nixosModules`, `modules/home`, and `modules/homeModules`.
3. Classify each file as one of four roles: root flake, shared NixOS module, shared Home Manager module, or concrete host or user composition.
4. Add new behavior at the smallest valid branch. Put reusable behavior in shared modules. Put identity, hardware, disks, and local state in concrete branches.
5. Compose reusable branches through `self.nixosModules.*` and `self.homeModules.*` so the graph stays explicit. Use `import-tree` when it fits, but accept any equivalent explicit tree assembly.
6. Read `references/dendritic-rules.md` for layout rules. Read `references/anti-patterns.md` when reviewing or refactoring. Read `references/validation.md` when choosing validation commands.
7. Run `scripts/check_dendritic_layout.py [repo-root]` after structural edits. The checker can infer the repo root from the current directory, so the argument is optional.
8. Run repo-native Nix validation after structural or semantic edits. Do not treat the layout checker as a substitute for flake evaluation.

## Branch Rules

- Keep `flake.nix` focused on inputs, systems, and tree assembly.
- Export shared system logic from `modules/nixosModules/*.nix` as `flake.nixosModules.<name>`.
- Export shared home logic from `modules/homeModules/*.nix` as `flake.homeModules.<name>`.
- Export concrete hosts from `modules/hosts/*.nix` as `flake.nixosConfigurations.*` and, when useful, a host-scoped `flake.nixosModules.*`.
- Export concrete users from `modules/home/*.nix` as `flake.homeConfigurations.*` and, when useful, a user-scoped `flake.homeModules.*`.
- Keep shared branches single-purpose. Split concerns instead of growing omnibus modules.

## Placement Rules

- Keep boot loader settings, filesystems, swap devices, hardware imports, platform, hostnames, and machine UUIDs in host branches.
- Keep `home.username`, `home.homeDirectory`, and user-local session defaults in concrete home branches.
- Keep reusable packages, services, and program settings in shared branches only when they apply across multiple hosts or users.
- Keep concrete branches thin. Push duplicated behavior downward into shared branches.
- Create the four dendritic directories before large migrations so new files land in stable locations immediately.

## Refactoring Rules

- Move logic out of a shared branch as soon as it mentions a specific host, disk, username, or hardware probe.
- Extract a shared module when two concrete branches duplicate behavior.
- Keep filenames, exported attribute names, and responsibilities aligned.
- Prefer explicit composition over hidden sibling imports.

## Validation

- Run `scripts/check_dendritic_layout.py [repo-root]` for structural findings.
- Treat checker warnings as heuristics to review, not as proof that the flake is valid or invalid.
- Run the cheapest repo-native Nix verification that covers the changed outputs. Prefer `nix flake check` when the repo defines checks; otherwise evaluate the touched `nixosConfigurations.*` or `homeConfigurations.*` entries directly.
- Run any project-specific formatters, tests, or builds that the target repository already uses.
