{ ... }:
{
  flake.homeModules.gaming =
    { pkgs, ... }:
    {
      programs.lutris = {
        enable = true;
        winePackages = [ pkgs.wineWow64Packages.stable ];
        defaultWinePackage = pkgs.wineWow64Packages.stable;
        extraPackages = [ pkgs.winetricks ];
      };
    };
}
