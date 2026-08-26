{ ... }: {
  flake.homeModules.music = { pkgs, config, ... }: {
    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      extraConfig = ''
        audio_output {
          type "pulse"
          name "PipeWire Pulse"
        }
      '';
    };

    services.mpd-mpris.enable = true;

    home.packages = [ pkgs.rmpc ];
  };
}
