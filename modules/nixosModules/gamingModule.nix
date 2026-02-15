# [checkout](https://www.youtube.com/watch?v=qlfm3MEbqYA)
# [NixOS hardware](https://github.com/NixOS/nixos-hardware) hardware for prebuilt machines
{ ... }:
{
  flake.nixosModules.gamingModule =
    { pkgs, ... }:
    {

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
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
        steam.enable = true;
        steam.gamescopeSession.enable = true;
      };

      environment.systemPackages = with pkgs; [
        pcsx2
        # mangohud # overlay monitoring program
        # lutris
        # heoric
        # bottles
      ];
    };
}
