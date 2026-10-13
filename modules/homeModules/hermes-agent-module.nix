{ inputs, ... }:
{
  flake.homeModules.hermesAgent =
    { config, lib, pkgs, ... }:
    {
      imports = [ inputs.hermes-agent.homeManagerModules.default ];

      config = lib.mkIf config.programs.hermes-agent.enable {
        programs.hermes-agent.package =
          (inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.minimal.override {
            version = "0.21.7";
            extraDependencyGroups = [ "anthropic" "ddgs" ];
            # Upstream setup/import implicitly installs a gateway, even when skipped.
            # Patch only its optional service policy in the sealed Python environment.
            callPackage =
              path: args:
              let
                result = pkgs.callPackage path args;
              in
              if toString path == "${inputs.hermes-agent}/nix/python.nix" then
                result // {
                  venv = result.venv.overrideAttrs (old: {
                    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.patch ];
                    postInstall = (old.postInstall or "") + ''
                      packageDir="$out/${result.python.sitePackages}/hermes_cli"
                      sourceDir="$(readlink -f "$packageDir")"
                      rm "$packageDir"
                      cp -rs "$sourceDir" "$packageDir"
                      chmod u+w "$packageDir"
                      cp --remove-destination "$sourceDir/gateway.py" "$packageDir/gateway.py"
                      chmod u+w "$packageDir/gateway.py"
                      patch --batch --fuzz=0 -d "$packageDir" -p1 < ${builtins.toFile "hermes-manual-gateway.patch" (builtins.readFile ./hermes-manual-gateway.patch)}
                    '';
                  });
                }
              else
                result;
          }).overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              for command in hermes hermes-agent hermes-acp; do
                wrapProgram "$out/bin/$command" \
                  --set-default HERMES_HOME ${lib.escapeShellArg config.services.hermes-agent.hermesHome} \
                  --set-default HERMES_MANAGED_DIR ${lib.escapeShellArg "${config.xdg.configHome}/hermes/nix"}
              done
            '';
          });

        # Install the CLI only: no gateway, backend, desktop, or login service.
        services.hermes-agent = {
          enable = false;
          gateway.enable = false;
          backend.mode = "none";
        };
        programs.hermes-agent.desktop.enable = false;

        # A leaf-level overlay keeps setup, model selection, and ~/.hermes writable.
        # Do not enable services.hermes-agent just to manage settings: it writes
        # .managed, which blocks the interactive setup wizard and config saves.
        xdg.configFile."hermes/nix/config.yaml".text = builtins.toJSON {
          agent.disabled_toolsets = [ "cronjob" ];
          gateway.auto_install_service = false;
          memory = {
            memory_enabled = true;
            user_profile_enabled = true;
          };
          plugins.enabled = [ "jev-skill-router" ];
          plugins.entries.jev-skill-router.settings = {
            mode = "auto";
            backend = "typesafe";
          };
        };
        home.file.".hermes/plugins/jev-skill-router".source =
          "${inputs.hermes-jev}/plugins/jev-skill-router";
      };
    };
}
