{ ... }: {

  perSystem = { pkgs, ... }: {
    packages.gruvbox-plus = pkgs.stdenv.mkDerivation {
      name = "gruvbox-plus";

      src = pkgs.fetchurl {
        url = "https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v6.6.0/gruvbox-plus-icon-pack-6.6.0.zip";
        sha256 = "sha256-sQqNY3jXuIym0huQeXpKp7vbsZB+p0EBpLnbQ50nc6I=";
      };

      dontUnpack = true;
      dontFixup = true;
      installPhase = ''
        mkdir -p $out/share/icons
        ${pkgs.unzip}/bin/unzip -q $src -d $out/share/icons
      '';
    };
  };
}
