-- Block the stock Vim ftplugin/indent scripts for YAML from loading and
-- overriding our settings below. guess-indent is excluded from YAML in
-- init.lua Section 4, so we don't need to fight it here.
vim.b.did_ftplugin = 1
vim.b.did_indent = 1

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- Clear indentexpr so autoindent/smartindent uses the shiftwidth above
-- instead of any earlier expression-based indent.
vim.opt_local.indentexpr = ''

vim.opt_local.commentstring = '# %s'
