-- Block the stock Vim ftplugin/indent scripts for YAML from loading and
-- overriding our settings below. guess-indent is excluded from YAML in
-- init.lua Section 4, so we don't need to fight it here.
vim.b.did_ftplugin = 1
vim.b.did_indent = 1

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- NOTE: don't set `indentexpr` here. init.lua Section 9 registers its FileType
-- autocmd after the filetypeplugin one, so for any language with a treesitter
-- indents query (yaml has one) it overwrites indentexpr right after this runs.
-- The tabstop/shiftwidth/expandtab above still apply.

vim.opt_local.commentstring = '# %s'
