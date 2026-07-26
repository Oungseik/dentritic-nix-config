# Development environments

## Purpose

Provide independently selectable Home Manager bundles for platform-specific tooling needed by active development work.

## Ownership

- `javascript-module.nix` owns Node.js, Bun, pnpm, frontend tooling, and the JavaScript debug adapter.
- `rust-module.nix` owns Rustup, GDB, and stable toolchain activation.
- `go-module.nix` and `php-module.nix` are prepared but intentionally disabled.

## Local Contracts

- Enable a platform by composing its module in `../../home/oung.nix`; disable it there and rebuild Home Manager when that work ends.
- Environment modules install removable platform tooling, not project source or runtime state. Project setups such as a local WordPress tree remain mutable outside the Nix store.
- JavaScript and Rust are currently enabled; Go and PHP remain disabled until active work needs them.
- Add Python, Android, or other platform modules only for a real project, using one independently selectable bundle per platform.
- JavaScript global package directories and Rustup toolchains are intentionally user-writable.
- Rust activation must remain safe during Home Manager dry runs and idempotent on repeated activation.
- Debug adapter source paths must come from packages installed by the same module.

## Work Guidance

- Bundle only platform-specific packages required for the active workflow; keep project dependencies and data in the writable project setup.
- Remove an environment from profile composition when it is no longer needed rather than leaving every platform installed.
- Do not create a shared abstraction for unrelated toolchains.

## Verification

- Run `just check oung`.

## Child DOX Index
