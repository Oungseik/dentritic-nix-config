{ ... }: {
  flake.homeModules.javascriptDevelopmentEnvironment = { pkgs, ... }: {
    home.file.".local/share/debuggers/dapDebugServer.js".source =
      "${pkgs.vscode-js-debug}/lib/node_modules/js-debug/dist/src/dapDebugServer.js";

    home.packages = with pkgs; [
      nodejs
      bun
      turbo
      prettier
      svelte-language-server
      vscode-langservers-extracted
      vscode-js-debug
    ];
  };
}
