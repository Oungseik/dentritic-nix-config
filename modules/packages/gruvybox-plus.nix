{ ... }: {

  perSystem = { pkgs, ... }: {
    packages.gruvbox-plus = pkgs.stdenv.mkDerivation {
      name = "gruvbox-plus";

      src = pkgs.fetchurl {
        url = "https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v6.5.0/gruvbox-plus-icon-pack-5.4.zip";
        sha256 = "12xg5150kqz459704m6amy7qqyd6rfi3d7k7l1xnkapafad00vqh";
      };

      dontUnpack = true;
      installPhase = ''
        mkdir -p $out
        ${pkgs.unzip}/bin/unzip $src -d $out/
      '';
    };
  };
}
