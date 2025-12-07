{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "nexnc";
      user.email = "git@nexnc.com";
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
