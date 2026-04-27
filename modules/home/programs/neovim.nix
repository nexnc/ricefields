{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Core UI & Status
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons
      nvim-tree-lua
      which-key-nvim
      
      # Git Integration
      gitsigns-nvim

      # Indent Guides & Brackets
      indent-blankline-nvim
      nvim-autopairs

      # Editing Enhancement
      comment-nvim
      nvim-surround

      # Treesitter
      (nvim-treesitter.withPlugins (p: with p; [ 
        nix lua python rust toml bash json yaml markdown
      ]))

      # LSP & Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Formatting
      none-ls-nvim

      # Navigation
      telescope-nvim
      plenary-nvim
    ];

    extraLuaConfig = ''
      -- 1. OPTIONS
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.g.mapleader = " "

      -- Quality of life options
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 250
      vim.opt.undofile = true
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      -- 2. GIT SIGNS SETUP
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
      })

      -- 3. INDENT GUIDES
      require("ibl").setup {
        indent = { char = "│" },
        scope = { enabled = true, show_start = true, show_end = false },
      }

      -- 4. AUTOPAIRS
      local autopairs = require("nvim-autopairs")
      autopairs.setup({ check_ts = true })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      -- 5. COMMENT & SURROUND
      require('Comment').setup()
      require('nvim-surround').setup()

      -- 6. TREESITTER
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- 7. TELESCOPE
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "__pycache__" },
          layout_config = { 
            prompt_position = "top",
            horizontal = { preview_width = 0.55 },
          },
          sorting_strategy = "ascending",
        }
      })

      -- 8. NEOVIM 0.11 LSP CONFIG
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Python (Pyright)
      vim.lsp.config('pyright', {
        cmd = { "${pkgs.pyright}/bin/pyright-langserver", "--stdio" },
        capabilities = capabilities,
      })
      vim.lsp.enable('pyright')

      -- Rust (using rustup)
      vim.lsp.config('rust_analyzer', {
        cmd = { "rust-analyzer" },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
	  check = { 
	    command = "clippy",
	  },
	  checkOnSave = true,
	 }
        }
      })
      vim.lsp.enable('rust_analyzer')

      -- Nix (nil)
      vim.lsp.config('nil_ls', {
        cmd = { "${pkgs.nil}/bin/nil" },
        capabilities = capabilities,
      })
      vim.lsp.enable('nil_ls')

      -- 9. FORMATTING (None-ls)
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
            })
          end
        end,
      })

      -- 10. AUTOCOMPLETE (nvim-cmp)
      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        })
      })

      -- 11. UI & KEYBINDS
      require("which-key").add({
        -- File/Search
        { "<leader>f", group = "Search" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        
        -- File Explorer
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
        
        -- Git
        { "<leader>g", group = "Git" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Change" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git Blame" },
        { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
        { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
        
        -- LSP
        { "<leader>l", group = "LSP" },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>lf", vim.lsp.buf.format, desc = "Format" },
        { "<leader>ld", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        
        { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
        { "K", vim.lsp.buf.hover, desc = "Hover Docs" },
        { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
        { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
      })

      -- Clipboard keymaps (black hole register for deletes)
      vim.keymap.set({"n", "v"}, "d", [["_d]], { desc = "Delete (black hole)" })
      vim.keymap.set({"n", "v"}, "D", [["_D]], { desc = "Delete to EOL (black hole)" })
      vim.keymap.set("n", "c", [["_c]])
      vim.keymap.set("n", "C", [["_C]])
      vim.keymap.set("n", "x", [["_x]])
      vim.keymap.set("n", "X", [["_X]])
      vim.keymap.set("x", "p", [["_dP]])
      vim.keymap.set({"n", "v"}, "<leader>x", [["+d]], { desc = "Cut to clipboard" })

      -- Window navigation
      vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to below window" })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to above window" })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

      -- Better indenting
      vim.keymap.set("v", "<", "<gv")
      vim.keymap.set("v", ">", ">gv")

      -- Move lines up/down
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

      -- Keep cursor centered on jumps
      vim.keymap.set("n", "<C-d>", "<C-d>zz")
      vim.keymap.set("n", "<C-u>", "<C-u>zz")
      vim.keymap.set("n", "n", "nzzzv")
      vim.keymap.set("n", "N", "Nzzzv")

      -- 12. UI THEME
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme "catppuccin"
      require('lualine').setup()
      require('nvim-tree').setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    '';
  };

  home.packages = with pkgs; [
    # Language Servers
    pyright
    nil  # Nix LSP
    
    # Formatters
    black
    nodePackages.prettier
  ];
}
