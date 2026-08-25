-- Sticky scope context at the top of the window (function/class header).
-- Depends on nvim-treesitter, which is installed in init.lua Section 9.

vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-context' }

-- All other options are already the plugin defaults.
require('treesitter-context').setup { max_lines = 5 }
