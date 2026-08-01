# Development environments

## Purpose

Provide independently selectable Home Manager bundles for platform-specific tooling needed by active development work.

## Ownership

- Each platform module owns its language toolchain and related debugging tools.

## Local Contracts

- Enable a platform by composing its module in `../../home/oung.nix`; disable it there and rebuild Home Manager when that work ends.
- Environment modules install removable platform tooling, not project source, dependencies, or runtime state.
- Add a platform module only for a real project, using one independently selectable bundle per platform.
- JavaScript global package directories and Rustup toolchains are intentionally user-writable.
- The JavaScript environment overrides nixpkgs Bun with the latest x86_64 Linux GitHub release; update its version and source hash together.
- Rust activation must remain safe during Home Manager dry runs and idempotent on repeated activation.
- Debug adapter source paths must come from packages installed by the same module.

## Work Guidance

- Bundle only platform-specific packages required for the active workflow; keep project dependencies and data in the writable project setup.
- Remove an environment from profile composition when it is no longer needed rather than leaving every platform installed.
- Do not create a shared abstraction for unrelated toolchains.

## Verification

- Run `just check oung`.

## Child DOX Index
