{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jujutsu
    lazyjj
    difftastic
  ];

  programs.jujutsu = {
    enable = true;
    # jj config documentation: https://jj-vcs.github.io/jj/latest/config/
    settings = {
      user = {
        name = "nexnc";
        email = "git@nexnc.com";
      };
      signing = {
        behavior = "force";
	backend = "gpg";
	key = "0xDC9F9D4EAA4F9406";
      };
      ui = {
        default-command = "log";
        # Modern jj uses diff-formatter instead of diff.format
        diff-formatter = ":color-words"; 
        editor = "nvim";
        pager = "less -FRX";
	show-cryptographic-signatures = true;
      };
      diff = {
        tool = "difft";
      };
      tools = {
  	difft = {
        program = "difft";
        diff-args = ["$left" "$right"];
        };
      };
      git = {
        colocate = true;
      };
    };
  };

  # Configuration for lazyjj
  # Documentation: https://github.com/pedro-beirao/lazyjj
  home.file.".config/lazyjj/config.toml".text = ''
    [theme]
    # Match your terminal's aesthetic
    highlight_color = "cyan"

    [keybindings]
    # lazyjj defaults are usually fine, but you can override them here
    # Example: quit = "q"
  '';
}
