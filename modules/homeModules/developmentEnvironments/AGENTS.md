# Development environments

## Purpose

Provide independently selectable Home Manager bundles for platform-specific tooling needed by active development work.

## Ownership

- Each platform module owns its language toolchain and related debugging tools.
- `python-module.nix` owns the Python interpreter and its nixpkgs-provided libraries used to write and run ad-hoc scripts.

## Local Contracts

- Enable a platform by composing its module in `../../home/oung.nix`; disable it there and rebuild Home Manager when that work ends.
- Environment modules install removable platform tooling, not project source, dependencies, or runtime state.
- Python libraries come from nixpkgs through `python3.withPackages` in `python-module.nix`; never install with pip, so removing the module leaves no packages behind.
- Add a platform module only for a real project, using one independently selectable bundle per platform.
- JavaScript global package directories and Rustup toolchains are intentionally user-writable.
- JavaScript runtimes and global package managers come from nixpkgs; do not pin them in the module.
- Rust activation must remain safe during Home Manager dry runs and idempotent on repeated activation.
- Debug adapter source paths must come from packages installed by the same module.

## Work Guidance

- Bundle only platform-specific packages required for the active workflow; keep project dependencies and data in the writable project setup.
- Remove an environment from profile composition when it is no longer needed rather than leaving every platform installed.
- Do not create a shared abstraction for unrelated toolchains.

## Verification

- Run `just check oung`.

## Child DOX Index
