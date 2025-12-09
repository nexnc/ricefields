{ config, pkgs, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  #  GITUI - Fast Terminal UI for Git
  # ═══════════════════════════════════════════════════════════════════════════

  programs.gitui = {
    enable = true;

    # ═══════════════════════════════════════════════════════════════════════════
    #  THEME CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    theme = ''
      (
          selected_tab: Rgb(255, 120, 0),
          command_fg: Rgb(220, 220, 220),
          selection_bg: Rgb(70, 130, 180),
          selection_fg: Rgb(255, 255, 255),
          cmdbar_bg: Rgb(30, 30, 46),
          cmdbar_extra_lines_bg: Rgb(30, 30, 46),
          disabled_fg: Rgb(108, 112, 134),
          diff_line_add: Rgb(166, 227, 161),
          diff_line_delete: Rgb(243, 139, 168),
          diff_file_added: Rgb(148, 226, 213),
          diff_file_removed: Rgb(235, 160, 172),
          diff_file_moved: Rgb(203, 166, 247),
          diff_file_modified: Rgb(249, 226, 175),
          commit_hash: Rgb(203, 166, 247),
          commit_time: Rgb(148, 226, 213),
          commit_author: Rgb(166, 227, 161),
          danger_fg: Rgb(243, 139, 168),
          push_gauge_bg: Rgb(70, 130, 180),
          push_gauge_fg: Rgb(255, 255, 255),
          tag_fg: Rgb(245, 194, 231),
          branch_fg: Rgb(249, 226, 175),
      )
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    #  KEY BINDINGS (Vim-style)
    # ═══════════════════════════════════════════════════════════════════════════
    keyConfig = ''
      (
          // ═══════════════════════════════════════════════════════════════════
          //  GENERAL NAVIGATION (Vim-style)
          // ═══════════════════════════════════════════════════════════════════
          open_help: Some(( code: F(1), modifiers: "")),

          move_left: Some(( code: Char('h'), modifiers: "")),
          move_right: Some(( code: Char('l'), modifiers: "")),
          move_up: Some(( code: Char('k'), modifiers: "")),
          move_down: Some(( code: Char('j'), modifiers: "")),
          
          popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
          popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
          page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
          page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
          home: Some(( code: Char('g'), modifiers: "")),
          end: Some(( code: Char('G'), modifiers: "SHIFT")),
          shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
          shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),

          // ═══════════════════════════════════════════════════════════════════
          //  FILE OPERATIONS
          // ═══════════════════════════════════════════════════════════════════
          edit_file: Some(( code: Char('e'), modifiers: "")),
          status_reset_item: Some(( code: Char('D'), modifiers: "SHIFT")),

          // ═══════════════════════════════════════════════════════════════════
          //  DIFF & STAGING
          // ═══════════════════════════════════════════════════════════════════
          diff_reset_lines: Some(( code: Char('d'), modifiers: "")),
          diff_stage_lines: Some(( code: Char('s'), modifiers: "")),

          // ═══════════════════════════════════════════════════════════════════
          //  STASHING
          // ═══════════════════════════════════════════════════════════════════
          stashing_save: Some(( code: Char('w'), modifiers: "")),
          stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),
          stash_open: Some(( code: Char('l'), modifiers: "")),

          // ═══════════════════════════════════════════════════════════════════
          //  MERGE OPERATIONS
          // ═══════════════════════════════════════════════════════════════════
          abort_merge: Some(( code: Char('M'), modifiers: "SHIFT")),
      )
    '';
  };
}
