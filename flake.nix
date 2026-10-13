{
  description = "My personal NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent/v0.21.7";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.home-manager.follows = "home-manager";
    };
    hermes-jev = {
      url = "github:DoGMaTiiC/hermes-jev/5dddbeaac5be08281e6c3b372eeaba3639971f0a";
      flake = false;
    };
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/v5.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CachyOS gaming kernel for the host's "game-time" boot specialisation.
    # Do not follow nixpkgs here: the repo pins its own nixpkgs so prebuilt kernels hit its binary cache.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
