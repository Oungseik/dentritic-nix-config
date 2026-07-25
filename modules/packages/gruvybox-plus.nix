{ ... }: {

  perSystem = { pkgs, ... }: {
    packages.gruvbox-plus = pkgs.stdenv.mkDerivation {
      name = "gruvbox-plus";

      src = pkgs.fetchurl {
        url = "https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v6.5.0/gruvbox-plus-icon-pack-6.5.0.zip";
        sha256 = "1sqffkypjs9x0sgivw6f4d9blz9simbaklqgx5q5jy37fb8621ji";
      };

      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/share/icons
        ${pkgs.unzip}/bin/unzip $src -d $out/share/icons
      '';
    };
  };
}
