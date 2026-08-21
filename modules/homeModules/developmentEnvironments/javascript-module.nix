{ ... }: {
  flake.homeModules.javascriptDevelopmentEnvironment =
    { config, pkgs, ... }:
    let
      home = config.home.homeDirectory;
    in
    {
      home.sessionVariables = {
        BUN_INSTALL = "${home}/.bun";
        NPM_CONFIG_PREFIX = "${home}/.npm-global";
        PNPM_HOME = "${home}/.local/share/pnpm";
        YARN_GLOBAL_FOLDER = "${home}/.local/share/yarn/global";
      };
      home.sessionPath = [
        "${home}/.bun/bin"
        "${home}/.npm-global/bin"
        "${home}/.local/share/pnpm"
        "${home}/.yarn/bin"
      ];

      home.file.".local/share/debuggers/dapDebugServer.js".source =
        "${pkgs.vscode-js-debug}/lib/node_modules/js-debug/dist/src/dapDebugServer.js";

      home.packages = with pkgs; [
        nodejs
        (bun.overrideAttrs (_: rec {
          version = "1.4.0";
          src = fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
            hash = "sha256-LQP7X7g6yLVnrKCigbLOGhoZ1Ij1bClo2Iw/Jekv5FI=";
          };
        }))
        deno
        pnpm
        turbo
        prettier
        svelte-language-server
        vscode-langservers-extracted
        vscode-js-debug
      ];
    };
}
