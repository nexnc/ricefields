{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      
      # Correct palette name for Stylix integration
      palette = "base16";

      # Cleaned up format (Removed backslashes and floating separators)
      format = "$os$username$directory$git_branch$git_status$rust$nodejs$time $line_break$character";

      os = {
        disabled = false;
        symbols = { NixOS = " "; Linux = "󰌽 "; Ubuntu = "󰕈 "; Arch = "󰣇 "; };
        style = "bg:base09 fg:base00";
        format = "[ $symbol ]($style)";
      };

      username = {
        show_always = true;
        style_user = "bg:base09 fg:base00";
        style_root = "bg:base08 fg:base00";
        format = "[$user ]($style)";
      };

      directory = {
        style = "bg:base0A fg:base00";
        # This triangle bridges Username(09) to Directory(0A)
        format = "[](fg:base09 bg:base0A)[ $path ]($style)";
      };

      git_branch = {
        symbol = " ";
        style = "bg:base0B fg:base00";
        # This triangle bridges Directory(0A) to Git(0B)
        format = "[](fg:base0A bg:base0B)[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bg:base0B fg:base00";
        format = "[ $all_status$ahead_behind ]($style)";
      };

      rust = {
        symbol = " ";
        style = "bg:base0D fg:base00";
        # This triangle bridges Git(0B) to Rust(0D)
        format = "[](fg:base0B bg:base0D)[ $symbol$version ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:base02 fg:base05";
        # Bridges last module to Time(02). 
        # Note: If no Rust/Node, this might look slightly off, which is why 
        # putting triangles INSIDE modules is safer.
        format = "[](fg:base0B bg:base02)[  $time ]($style)";
      };

      character = {
        success_symbol = "[](bold fg:base0B)";
        error_symbol = "[](bold fg:base08)";
      };
    };
  };
}
