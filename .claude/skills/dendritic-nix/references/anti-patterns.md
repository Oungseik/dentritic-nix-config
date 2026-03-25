# Anti-Patterns

Use this reference when reviewing, refactoring, or explaining why a layout violates the dendritic model.

## Table of Contents

- Root anti-patterns
- Shared branch anti-patterns
- Concrete branch anti-patterns
- Naming anti-patterns
- Review questions

## Root Anti-Patterns

- Put host or user option trees directly in `flake.nix`
  Prefer: keep `flake.nix` as wiring and move concrete state into branch files under `modules/`

- Turn `flake.nix` into a long monolith
  Prefer: add or split branch files and keep the branch graph explicit

## Shared Branch Anti-Patterns

- Put `system.stateVersion`, boot loader settings, filesystems, swap devices, or disk UUIDs in `modules/nixosModules/*`
  Prefer: move them into the owning host branch

- Put `home.username`, `home.homeDirectory`, or `home.stateVersion` in `modules/homeModules/*`
  Prefer: move them into the owning user branch

- Reference `self.nixosConfigurations.*` or `self.homeConfigurations.*` from shared modules
  Prefer: keep shared modules generic and only depend on shared module branches

- Accumulate unrelated concerns in one shared file
  Prefer: split by concern and keep one public branch per file

## Concrete Branch Anti-Patterns

- Duplicate the same service, package set, or editor settings in multiple hosts or users
  Prefer: extract a shared branch and compose it back with `self.*Modules`

- Hide composition through sibling imports that bypass the visible configuration list
  Prefer: keep the main `modules = [ ... ]` list explicit for concrete configurations

- Keep unused shared branches in the tree
  Prefer: delete them or wire them into a concrete configuration intentionally

## Naming Anti-Patterns

- Let the filename and exported attribute drift apart
  Prefer: keep `networkingModule.nix` aligned with `flake.nixosModules.networkingModule`

- Reuse vague names such as `default.nix` as a dumping ground
  Prefer: use names that describe the concern or owner directly

## Review Questions

Ask these before accepting a change:

1. Does this option belong to a reusable concern or to one concrete owner?
2. Can another host or user consume this branch unchanged?
3. Is the composition visible from the concrete configuration entrypoint?
4. Does the file export a branch whose name matches its responsibility?
