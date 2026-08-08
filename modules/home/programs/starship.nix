{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {

      # ───────────────────────────────────────────
      # Prompt layout
      # ───────────────────────────────────────────

      format =
        "[░▒▓](#a3aed2)"
        + "$os"
        + "[](bg:#769ff0 fg:#a3aed2)"
        + "$directory"
        + "[](fg:#769ff0 bg:#394260)"
        + "$git_branch"
        + "$git_status"
        + "[](fg:#394260 bg:#212736)"
        + "$nix_shell"
        + "$c"
        + "$rust"
        + "$python"
        + "[](fg:#212736 bg:#1d2230)"
        + "$time"
        + "[ ](fg:#1d2230)"
        + "$line_break"
        + "$character";


      # ───────────────────────────────────────────
      # OS
      # ───────────────────────────────────────────

      os = {
        disabled = false;
        style = "bg:#a3aed2 fg:#090c0c";
        format = "[ $symbol ]($style)";

        symbols = {
          Arch = "󰣇";
          Debian = "󰣚";
          Fedora = "󰣛";
          NixOS = "";
          Linux = ""; # Tux icon
        };
      };


      # ───────────────────────────────────────────
      # Directory
      # ───────────────────────────────────────────

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";

        truncation_length = 3;
        truncation_symbol = "…/";

        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };


      # ───────────────────────────────────────────
      # Git branch
      # ───────────────────────────────────────────

      git_branch = {
        symbol = "";
        style = "bg:#394260";

        format =
          "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };


      # ───────────────────────────────────────────
      # Git status
      # ───────────────────────────────────────────

      git_status = {
        style = "bg:#394260";

        format =
          "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };


      # ───────────────────────────────────────────
      # Nix shell (flakes / direnv)
      # ───────────────────────────────────────────

      nix_shell = {
        disabled = false;
        symbol = "󱄅";
        style = "bg:#212736";

        format =
          "[[ $symbol $state ](fg:#769ff0 bg:#212736)]($style)";
      };


      # ───────────────────────────────────────────
      # C / C++
      # ───────────────────────────────────────────

      c = {
        symbol = "";
        style = "bg:#212736";

        format =
          "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };


      # ───────────────────────────────────────────
      # Rust
      # ───────────────────────────────────────────

      rust = {
        symbol = "";
        style = "bg:#212736";

        format =
          "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };


      # ───────────────────────────────────────────
      # Python
      # ───────────────────────────────────────────

      python = {
        symbol = "";
        style = "bg:#212736";

        format =
          "[[ $symbol ($version)(\\($virtualenv\\)) ](fg:#769ff0 bg:#212736)]($style)";
      };


      # ───────────────────────────────────────────
      # Time
      # ───────────────────────────────────────────

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";

        format =
          "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };


      # ───────────────────────────────────────────
      # Prompt character
      # ───────────────────────────────────────────

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };
}
