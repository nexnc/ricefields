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

      # Treesitter
      (nvim-treesitter.withPlugins (p: with p; [ nix lua python rust toml bash json yaml markdown ]))

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

      -- 5. NEOVIM 0.11 LSP CONFIG
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
          ["rust-analyzer"] = { checkOnSave = { command = "clippy" } }
        }
      })
      vim.lsp.enable('rust-analyzer')

      -- 6. FORMATTING (None-ls)
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

      -- 7. AUTOCOMPLETE (nvim-cmp)
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

      -- 8. UI & KEYBINDS
      require("which-key").add({
        { "<leader>f", group = "Search" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
        { "<leader>g", group = "Git" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Change" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git Blame" },
        { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
        { "K", vim.lsp.buf.hover, desc = "Hover Docs" },
      })

      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme "catppuccin"
      require('lualine').setup()
      require('nvim-tree').setup()
    '';
  };

  home.packages = with pkgs; [
    pyright
    black
    nodePackages.prettier
    ripgrep
    fd
  ];
}
