{ config, pkgs, inputs, systemHostname, ... }:
let
  flakePath = "/etc/nixos";
  host = systemHostname;
in
{
  programs.fish = {
    enable = true;

    functions = {
      nix-init = ''
        set -l env_type $argv[1]
        if test -z "$env_type"
            echo "Usage: nix-init [rust|cpp|python]"
            return 1
        end

        if test -e flake.nix
            echo "flake.nix already exists, aborting" >&2
            return 1
        end

        # build the generated flake text from the central definition
        set -l out (nix build "path:${flakePath}#$env_type-flake" --no-link --print-out-paths)
        or begin
            echo "No '$env_type-flake' package found in ${flakePath}" >&2
            return 1
        end

        # store files are read-only, so copy with normal permissions
        install -m 644 $out flake.nix

        # in a git repo, flakes only see tracked files
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            git add -N flake.nix
        end

        nix flake lock

        echo "use flake" > .envrc
        direnv allow

        # keep local direnv files out of git
        for p in .direnv/ .envrc
            grep -qxF $p .gitignore 2>/dev/null; or echo $p >> .gitignore
        end

        echo "Initialized $env_type environment (flake.nix, flake.lock, .envrc)."
      '';
    };


    shellInit = ''
      set -g fish_greeting ""
      set -gx PATH $HOME/.cargo/bin $PATH
      set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
      if status is-interactive
        set -gx GPG_TTY (tty)
      end
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
      nixconfig  = "nvim ${flakePath}/hosts/${host}/default.nix";
      homeconfig = "nvim ${flakePath}/modules/home/home.nix";
      fishconfig = "nvim ${flakePath}/modules/home/programs/fish.nix";
      niriconfig = "nvim ${flakePath}/modules/home/desktop/niri.nix";
      flakeconfig = "nvim ${flakePath}/flake.nix";

      # ── General ───────────────────────────────────────────────────────────
      ff    = "fastfetch";
      music = "rmpc";
      bt = "bluetui";
      headphone = "bluetoothctl connect E8:EE:CC:C7:CA:E6";

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
      jjs  = "jj status";
      jjsi = "jj split -i";
      jjl  = "jj log";
      jjdf = "jj diff";
      jjd  = "jj describe -m";
      jjn  = "jj new";
      jjf  = "jj git fetch --remote origin";
      jju  = "jj undo";
      # primary: use after jj split -i (@ is empty, safe to abandon)
      jjp  = "jj abandon @ && jj bookmark set main -r @- && jj git push --remote origin -b main";
      # reference only: use when @ has real described changes and no split was done
      jjpp = "jj bookmark set main -r @ && jj git push --remote origin -b main";
    };
  };
}
