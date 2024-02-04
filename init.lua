local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.netrw_browse_split = 2
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 85
vim.g.maplocalleader = " "
-- Set highlight on search
vim.o.hlsearch = false
-- Make line numbers default
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
-- Enable mouse mode
vim.o.mouse = 'a'
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
-- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true


require("lazy").setup({
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                theme = bubbles_theme,
                component_separators = '|',
                section_separators = { left = ' ', right = ' ' },
            },
            sections = {
                lualine_a = {
                    { 'mode', separator = { left = ' ' }, right_padding = 2 },
                },
                lualine_b = { 'filename', 'branch' },
                lualine_c = { 'fileformat' },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress' },
                lualine_z = {
                    { 'location', separator = { right = ' ' }, left_padding = 2 },
                },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {},
        },
    },
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = { },
    },
    {"folke/which-key.nvim", opts = {} },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    },
{
  'olivercederborg/poimandres.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('poimandres').setup {
      -- leave this setup function empty for default config
      -- or refer to the configuration section
      -- for configuration options
    }
  end,

  -- optionally set the colorscheme within lazy config
  init = function()
    vim.cmd("colorscheme poimandres")
  end
},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc","javascript", "html" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end  },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({'n', 'v'}, ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
                vim.keymap.set({'n', 'v'}, '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
            end,
        },
    },
    {'akinsho/toggleterm.nvim', version = "*", config = true},
  {"ThePrimeagen/harpoon"},
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
},
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
},
    {
    "uga-rosa/ccc.nvim",
  },
{
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
})

-- setup must be called before loading
-- vim.cmd.colorscheme "catppuccin"
vim.opt.termguicolors = true

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- Toggle Term Setup
require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    direction = "float"
}
-- CCC Config
local ccc = require("ccc")
local mapping = ccc.mapping
ccc.setup({
  -- Your preferred settings
  -- Example: enable highlighter
  highlighter = {
    auto_enable = true,
    lsp = true,
  },
})

--Oil.nvim
require("oil").setup()
-- PLUGIN SPECIFIC BINDS
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<F5>", "<cmd>put =strftime('%c')<CR>P<cr>", { silent = true })
-- Custom Keymaps from theprimeagen
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "[F]ind [G]rep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "[F]ind [B]uffer" })
vim.keymap.set('n', '<leader>ft', builtin.help_tags, { desc = "[F]ind [T]ags" })

-- Harpoon Configure
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<A-a>", mark.add_file)
vim.keymap.set("n", "<A-;>", ui.toggle_quick_menu)

vim.keymap.set("n", "<A-u>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<A-i>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<A-o>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<A-p>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<A-.>", function() ui.nav_next() end)
vim.keymap.set("n", "<A-,>", function() ui.nav_prev() end)
