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
        identityFile = "~/.ssh/git.pub";
      };
      "github.com" = {
	hostname = "github.com";
	user = "git";
	identityFile = "~/.ssh/git.pub";
      };
      "codeberg.org" = {
	hostname = "codeberg.org";
	user = "git";
	identityFile = "~/.ssh/git.pub";
      };
    };
  };
}
