{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    # This tells SSH: "When I visit gitlab.com, use the key named 'gitlab'"
    matchBlocks = {
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/gitlab";
      };
    };
  };

  services.ssh-agent = {
    enable = true;
  };
}
