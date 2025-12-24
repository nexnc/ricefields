{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/git";
      };
      "github.com" = {
	hostname = "github.com";
	user = "git";
	identityFile = "~/.ssh/git";
      };
      "codeberg.org" = {
	hostname = "codeberg.org";
	user = "git";
	identityFile = "~/.ssh/git";
      };
      "146.190.228.197" = {
	hostname = "146.190.228.197";
	user = "root";
	identityFile = "~/.ssh/cloud";

      };
    };
  };
  services.ssh-agent = {
    enable = true;
  };
}
