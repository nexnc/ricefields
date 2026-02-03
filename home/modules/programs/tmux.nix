{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    
    # Optional: Set your preferred settings
    shortcut = "a";  # Changes prefix to Ctrl-a (default is b)
    baseIndex = 1;   # Start window numbering at 1
    terminal = "tmux-256color";
    
    # Enable mouse support
    mouse = true;
    
    # Key bindings and other settings
    extraConfig = ''
      # Reload config
      bind r source-file $HOME/.config/tmux/tmux.conf \; display "Reloaded!"
      
      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
      
      # Enable vi mode
      set-window-option -g mode-keys vi
      
      # Continuum settings
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
      
      # Show continuum status in status bar
      set -g status-right 'Continuum: #{continuum_status}'
      
      # Resurrect additional settings
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-vim 'session'
      
      # Color Fixes
      set-option -ga terminal-overrides ",foot:Tc"
      set -as terminal-features ",foot:RGB"
    '';
    
    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      yank
      {
    	plugin = catppuccin;
    	extraConfig = ''
      	  set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_tabs_enabled on
         '';
      }
    ];
  };
}
