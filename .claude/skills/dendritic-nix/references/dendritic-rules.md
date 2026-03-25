# Dendritic Rules

Use this reference when creating or reshaping a dendritic Nix flake.

## Table of Contents

- Target layout
- Root rules
- Shared branch rules
- Concrete branch rules
- Migration approach
- Ownership rules

## Target Layout

```text
flake.nix
modules/
  hosts/
    laptop.nix
  nixosModules/
    networkingModule.nix
    gamingModule.nix
  home/
    alice.nix
  homeModules/
    browsersModule.nix
```

Treat each directory as a branch family:

- `flake.nix`: root wiring only
- `modules/hosts/`: concrete machine compositions
- `modules/nixosModules/`: reusable NixOS concerns
- `modules/home/`: concrete user compositions
- `modules/homeModules/`: reusable Home Manager concerns

## Root Rules

- Keep `flake.nix` thin.
- Declare inputs, supported systems, and output assembly only.
- Prefer `import-tree ./modules` when it is already in use, but accept any equivalent explicit tree import or module aggregation strategy.
- Avoid embedding concrete host or user configuration directly in `flake.nix`.

## Shared Branch Rules

- Export exactly one public shared branch per file.
- Keep the exported attribute name aligned with the filename stem.
- Keep the module focused on one concern such as networking, browsers, gaming, shell, or editors.
- Allow composition between shared modules only when the dependency is still generic and does not point at a concrete host or user.

Use this shape for reusable system logic:

```nix
{ ... }:
{
  flake.nixosModules.networkingModule =
    { lib, ... }:
    {
      networking.networkmanager.enable = true;
      networking.useDHCP = lib.mkDefault true;
    };
}
```

Use this shape for reusable home logic:

```nix
{ ... }:
{
  flake.homeModules.browsersModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        firefox
        google-chrome
      ];
    };
}
```

## Concrete Branch Rules

- Export the concrete configuration and keep composition obvious.
- Keep machine identity, disks, boot, platform, and hardware in host branches.
- Keep username, home directory, and user-local defaults in concrete home branches.
- Compose shared branches through `self.*Modules` instead of re-declaring the same options inline.

Use this shape for a host:

```nix
{ inputs, self, ... }:
{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptop
      self.nixosModules.networkingModule
    ];
  };

  flake.nixosModules.laptop =
    { lib, ... }:
    {
      networking.hostName = "laptop";
      system.stateVersion = "26.05";
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
```

Use this shape for a user:

```nix
{ inputs, self, ... }:
{
  flake.homeConfigurations.alice = inputs.home-manager.lib.homeManagerConfiguration {
    modules = [
      self.homeModules.alice
      self.homeModules.browsersModule
    ];
  };

  flake.homeModules.alice =
    { ... }:
    {
      home.username = "alice";
      home.homeDirectory = "/home/alice";
      home.stateVersion = "26.05";
    };
}
```

## Migration Approach

- Create the `modules/` subtree first when moving a non-dendritic flake.
- Move concrete host and user state out of `flake.nix` before splitting generic concerns.
- Extract one shared concern at a time. Recompose it through `self.nixosModules.*` or `self.homeModules.*` before moving on to the next concern.
- Keep the flake evaluating after each small move instead of attempting one large rewrite.

## Ownership Rules

Prefer these boundaries:

- Host branch owns: hostname, boot loader, hardware imports, filesystems, swap, GPU specifics, disk UUIDs, firmware, platform
- Shared NixOS branch owns: reusable services, packages, defaults, policies, shared system programs
- Home branch owns: username, home directory, per-user state version, user identity
- Shared home branch owns: reusable packages, shells, browser settings, editor settings, desktop preferences

When a rule is borderline, ask one question: "Would this still be correct for another host or user?" If not, keep it concrete.
