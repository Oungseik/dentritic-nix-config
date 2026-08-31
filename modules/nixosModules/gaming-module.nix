# [checkout](https://www.youtube.com/watch?v=qlfm3MEbqYA)
# [NixOS hardware](https://github.com/NixOS/nixos-hardware) hardware for prebuilt machines
{ inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # "game-time" boot entry: CachyOS kernel with BORE scheduler, Clang ThinLTO, x86-64-v3 codegen.
      # Appears in systemd-boot alongside the default generation; default kernel stays untouched.
      specialisation.game-time.configuration = {
        boot.kernelPackages =
          inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-bore-lto-x86_64-v3;
      };

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
