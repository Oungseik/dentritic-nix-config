{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
    };

    # CachyOS gaming kernel for the host's "game-time" boot specialisation.
    # Do not follow nixpkgs here: the repo pins its own nixpkgs so prebuilt kernels hit its binary cache.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
