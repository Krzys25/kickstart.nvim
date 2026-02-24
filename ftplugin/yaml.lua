-- ~/.config/nvim/ftplugin/yaml.lua

-- *** Crucial: Explicitly disable vim-sleuth for this buffer ***
-- This needs to be set as early as possible for the buffer.
-- ftplugin files are sourced after the filetype is detected.
vim.b.sleuth_automatic = 0

-- Signal that ftplugin and indent settings have been handled by us.
-- This prevents the default system ftplugin/indent scripts for 'yaml' from loading
-- and potentially overriding settings.
vim.b.did_ftplugin = 1
vim.b.did_indent = 1

-- Now, set your desired local options, knowing they won't be immediately overridden
-- by Sleuth or default ftplugins.
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true -- Use spaces

-- Ensure smartindent/autoindent logic uses the shiftwidth we just set.
-- Clearing indentexpr makes Neovim fall back to autoindent/smartindent.
vim.opt_local.indentexpr = ''

-- Optionally, set comment string specifically for YAML
vim.opt_local.commentstring = '# %s'
