{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "nexnc";
      user.email = "git@nexnc.com";
      user.signingKey = "0xDC9F9D4EAA4F9406"; # [S] subkey
      commit.gpgsign = true;
      tag.gpgsign = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = "auto";
      core.editor = "nvim";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
