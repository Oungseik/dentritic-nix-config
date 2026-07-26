{ ... }: {
  flake.homeModules.phpDevelopmentEnvironment =
    { pkgs, ... }:
    let
      php = pkgs.php.withExtensions (
        { enabled, all }:
        enabled
        ++ [
          all.mysqli
          all.curl
          all.gd
          all.mbstring
          all.xml
          all.zip
          all.intl
          all.xdebug
        ]
      );
    in
    {
      home.file.".local/share/debuggers/phpDebug.js".source =
        "${pkgs.vscode-extensions.xdebug.php-debug}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js";

      home.packages = with pkgs; [
        nodejs
        apacheHttpd
        mariadb
        php.packages.composer
        php.packages.php-cs-fixer
        intelephense
        php
      ];
    };
}
