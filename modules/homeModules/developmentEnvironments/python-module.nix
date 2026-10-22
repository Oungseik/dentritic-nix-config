{ ... }: {
  flake.homeModules.pythonDevelopmentEnvironment =
    { pkgs, ... }:
    {
      # Keep script libraries declarative; pipx manages isolated user applications.
      home.packages = [
        pkgs.pipx
        (pkgs.python3.withPackages (
          ps: with ps; [
            requests
          ]
        ))
      ];
    };
}
