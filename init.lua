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

vim.g.mapleader = " "

require("lazy").setup({
  {'nvim-telescope/telescope.nvim', 
   tag = '0.1.5',
   dependencies = { 'nvim-lua/plenary.nvim' },
   lazy = false},
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
})

vim.cmd.colorscheme "catppuccin"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

vim.api.nvim_create_autocmd(
  'FileType', 
  {pattern={'gitcommit', 'gitrebase', 'gitconfig'},
   command=[[set bufhidden=delete]]}
)
