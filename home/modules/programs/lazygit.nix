{ config, pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        sidePanelWidth = 0.3;
        showCommandLog = false;
        
        theme = {
          activeBorderColor = [ "#cba6f7" "bold" ];
          inactiveBorderColor = [ "#a6adc8" ];
          optionsTextColor = [ "#89b4fa" ];
          selectedLineBgColor = [ "#313244" ];
          selectedRangeBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#94e2d5" ];
          cherryPickedCommitFgColor = [ "#cba6f7" ];
          unstagedChangesColor = [ "#f38ba8" ];
          defaultFgColor = [ "#cdd6f4" ];
          searchingActiveBorderColor = [ "#f9e2af" ];
        };
      };
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=always";
          }
        ];
      };
      
      keybindings = {
        quit = "q";
      };
    };
  };
}
