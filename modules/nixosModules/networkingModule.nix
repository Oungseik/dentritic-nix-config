{ ... }:
{
  flake.nixosModules.networkingModule =
    { pkgs, lib, ... }:
    {

      networking = {
        networkmanager.enable = true;
        networkmanager.dns = "none";
        # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
        nameservers = [
          "8.8.8.8"
          "8.8.4.4"
        ];

        # Configure network proxy if necessary
        # proxy.default = "http://127.0.0.1:2080/";
        proxy.noProxy = lib.strings.concatStringsSep "," [
          "127.0.0.1"
          "192.168.0.0/16"
          "103.186.240.90"
          "localhost"
          "internal.domain"
          "youtube.com"
          "teams.microsoft.com"
          "microsoft.com"
          "reddit.com"

          "cloud.langfuse.com"
          "api.openai.com"
          "openai.com"
          "api-inference.huggingface.co"
          "huggingface.co"
          "registry.npmjs.org"
          "npmjs.org"
          "api.cohere.com"
          "cohere.com"
          "generativelanguage.googleapis.com"
          "googleapis.com"
          "api.anthropic.com"
          "anthropic.com"
        ];
      };
    };
}
