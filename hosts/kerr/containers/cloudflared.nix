{ config, pkgs, ... }:

{
  cloudflared = {
    image = "cloudflare/cloudflared:latest";
    autoStart = true;

    volumes = [
      "/run/secrets/cloudflared-token:/etc/cloudflared/token:ro"
    ];

    extraOptions = [
      "--network=host"
    ];

    cmd = [
      "tunnel"
      "--no-autoupdate"
      "run"
      "--token-file" "/etc/cloudflared/token"
      "--icmpv4-src" "0.0.0.0"
      "--icmpv6-src" "::"
    ];
  };
}

