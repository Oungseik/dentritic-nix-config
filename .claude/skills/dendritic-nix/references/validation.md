# Validation

Use this reference after editing a repository with the dendritic skill.

## Table of Contents

- Validation order
- Layout checker
- Repo-native Nix validation
- Change-scoped evaluation

## Validation Order

Run validation in this order:

1. Run the dendritic layout checker for structural findings.
2. Run repo-native Nix evaluation for the outputs you changed.
3. Run project-specific checks already defined by the target repository.

## Layout Checker

Run the checker from any directory inside the target repo:

```bash
python3 /path/to/dendritic-nix-config/scripts/check_dendritic_layout.py
```

Or pass the repo root explicitly:

```bash
python3 /path/to/dendritic-nix-config/scripts/check_dendritic_layout.py /path/to/repo
```

Treat warnings as heuristics. Fix them when they reveal a real ownership problem. Justify exceptions explicitly.

## Repo-Native Nix Validation

Prefer `nix flake check` when the repository already defines useful checks and the command is not disproportionately expensive.

```bash
nix flake check
```

If `nix flake check` is missing, too expensive, or too broad for the change, evaluate only the outputs you touched.

## Change-Scoped Evaluation

For a changed NixOS host:

```bash
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
```

For a changed Home Manager user:

```bash
nix eval .#homeConfigurations.<user>.activationPackage.drvPath
```

For a changed module with multiple consumers, evaluate at least one concrete consumer that composes it.

If the repository already uses formatters, tests, or custom checks, run those too. Do not treat structural validation as a substitute for real evaluation.
