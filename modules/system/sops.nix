{ ... }:
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    defaultSopsFile = ../../secrets/user-password.yaml;
    secrets.password = {
      sopsFile = ../../secrets/user-password.yaml;
      owner = "root";
      group = "root";
      mode = "0400";
      neededForUsers = true;
    };
    secrets.root_password = {
      sopsFile = ../../secrets/user-password.yaml;
      neededForUsers = true;
    };
    secrets."cloudflared-token" = {
      sopsFile = ../../secrets/cloudflared.yaml;
      owner = "root";
      group = "root";
      mode = "0444";
    };
  };
}
