{ config, pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      clipboard = "unnamedplus";
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      termguicolors = true;
      foldlevel = 99;
      foldlevelstart = 99;
      ignorecase = true;
      smartcase = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 250;
      undofile = true;
      splitright = true;
      splitbelow = true;
    };

    globals.mapleader = " ";

    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      nvim-tree.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      autopairs.enable = true;
      comment.enable = true;
      surround.enable = true;
      telescope.enable = true;
      
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          rust_analyzer.enable = true;
          nil_ls.enable = true;
        };
      };
    };
  };
}
