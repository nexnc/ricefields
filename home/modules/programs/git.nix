{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "nexnc";
    userEmail = "git@nexnc.com";

    # Optional but recommended features
    delta.enable = true;
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = "auto";
      core.editor = "nvim";
    };
  };
}
