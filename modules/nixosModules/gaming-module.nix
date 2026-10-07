# [checkout](https://www.youtube.com/watch?v=qlfm3MEbqYA)
# [NixOS hardware](https://github.com/NixOS/nixos-hardware) hardware for prebuilt machines
{ inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      nix.settings = {
        substituters = [ "https://attic.xuyh0120.win/lantian" ];
        trusted-public-keys = [
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # Optional "game-time" boot entry: CachyOS BORE ThinLTO x86-64-v3 kernel.
      # Uncomment when needed; the default kernel stays unchanged.
      # specialisation.game-time.configuration = {
      #   boot.kernelPackages =
      #     inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-bore-lto-x86_64-v3;
      # };

      # Nvidia GPU
      # services.xserver.videoDrivers = [ "nvidia" ];
      # hardware.nvidia.modesetting.enable = true;

      # AMD GPU
      # services.xserver.videoDrivers = ["amdgpu"];

      # Nvidia Optimus Prime (for laptops with Nvidia GPU)
      # Prime have OffLoad mode (enable GPU only when necessary) and
      # Sync Mode (which run dedicated GPU all time)
      # hardware.nvidia.prime = {
      #   sync.enable = true;
      # };

      programs = {
        gamemode.enable = true;
        # steam.enable = true;
        # steam.gamescopeSession.enable = true;
      };

      environment.systemPackages = with pkgs; [
        pcsx2
        ppsspp
        # mangohud # overlay monitoring program
        # lutris
        # heoric
        # bottles
      ];
    };
}
