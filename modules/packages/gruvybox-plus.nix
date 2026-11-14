{ ... }: {

  perSystem = { pkgs, ... }: {
    packages.gruvbox-plus = pkgs.stdenv.mkDerivation {
      name = "gruvbox-plus";

      src = pkgs.fetchurl {
        url = "https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v6.7.0/gruvbox-plus-icon-pack-6.7.0.zip";
        sha256 = "sha256-EHrpytxHP4Gq6ojgaiS8uMrNQa87t12B0NXhnwur19k=";
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
