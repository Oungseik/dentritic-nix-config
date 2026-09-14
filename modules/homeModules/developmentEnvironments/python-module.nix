{ ... }: {
  flake.homeModules.pythonDevelopmentEnvironment =
    { pkgs, ... }:
    {
      # Add libraries here from nixpkgs (python3Packages.<name>); no pip, no venv, no
      # user site-packages state — removing this module removes every package with it.
      home.packages = [
        (pkgs.python3.withPackages (
          ps: with ps; [
            requests
          ]
        ))
      ];
    };
}
