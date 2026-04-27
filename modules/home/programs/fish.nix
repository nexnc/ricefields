{ config, pkgs, inputs, systemHostname, ... }:
let
  flakePath = "/etc/nixos";
  host = systemHostname;
in
{
  programs.fish = {
    enable = true;

    shellInit = ''
      set -g fish_greeting ""
      set -gx PATH $HOME/.cargo/bin $PATH
      set -gx GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    '';

    interactiveShellInit = ''
      bind "[A" history-search-backward
      bind "[B" history-search-forward
    '';

    shellAbbrs = {
      # ── NixOS Management ──────────────────────────────────────────────────
      flakeupdate  = "sudo nix flake update --flake ${flakePath}";
      systemupdate = "sudo nixos-rebuild switch --flake ${flakePath}#${host}";
      nixupdate    = "sudo nixos-rebuild switch --flake ${flakePath}#${host}";

      # ── Config Shortcuts ──────────────────────────────────────────────────
      nixconfig  = "sudo nvim ${flakePath}/hosts/${host}/default.nix";
      homeconfig = "sudo nvim ${flakePath}/modules/home/home.nix";
      fishconfig = "sudo nvim ${flakePath}/modules/home/programs/fish.nix";
      niriconfig = "sudo nvim ${flakePath}/modules/home/desktop/niri.nix";

      # ── General ───────────────────────────────────────────────────────────
      ff    = "fastfetch";
      music = "rmpc";
      svim  = "sudo nvim";

      # ── Navigation ────────────────────────────────────────────────────────
      cd   = "z";
      ls   = "eza --icons";
      ll   = "eza -l --icons --git";
      la   = "eza -la --icons --git";
      tree = "eza --tree --icons";

      # ── Search & Files ────────────────────────────────────────────────────
      grep = "rg";
      find = "fd";
      cat  = "bat";

      # ── System Utilities ──────────────────────────────────────────────────
      ps  = "procs";
      du  = "dust";
      df  = "duf";
      top = "btop";
      net = "sudo bandwhich";

      # ── Git ───────────────────────────────────────────────────────────────
      gst = "git status";
      gd  = "git diff";
      gl  = "git log --oneline";
      lg  = "lazygit";
      gg  = "lazygit";

      # ── Jujutsu ───────────────────────────────────────────────────────────────
      jjd  = "jj describe -m";                          # jjd "feat: message"
      jjp  = "jj bookmark set main -r @ && jj git push --remote origin -b main";
      jjs  = "jj status";
      jjl  = "jj log";
      jjf  = "jj git fetch --remote origin";
      jjdf = "jj diff";
      jjn  = "jj new";                                  # start a new change
      jju  = "jj undo";                             
    };
  };
}
