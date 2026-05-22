-- Rust development: rust-analyzer wrapper with runnables, debuggables,
-- expand-macros, hover actions, etc.
--
-- rust-analyzer itself is expected to be installed via rustup:
--   rustup component add rust-analyzer
--
-- Do NOT add `rust_analyzer = {}` to the servers table in init.lua — this
-- plugin auto-configures and starts the LSP client itself.

return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false, -- plugin handles its own lazy loading via ftplugin
  init = function()
    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            check = { command = 'clippy' },
            checkOnSave = true,
            inlayHints = { enable = true },
          },
        },
        on_attach = function(_, bufnr)
          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { buffer = bufnr, desc = 'Rust hover actions' })
          vim.keymap.set('n', 'gra', function() vim.cmd.RustLsp 'codeAction' end, { buffer = bufnr, desc = 'Rust code [A]ction' })
          vim.keymap.set('n', '<leader>rr', function() vim.cmd.RustLsp 'runnables' end, { buffer = bufnr, desc = '[R]ust [R]unnables' })
          vim.keymap.set('n', '<leader>rd', function() vim.cmd.RustLsp 'debuggables' end, { buffer = bufnr, desc = '[R]ust [D]ebuggables' })
          vim.keymap.set('n', '<leader>rm', function() vim.cmd.RustLsp { 'expandMacro' } end, { buffer = bufnr, desc = '[R]ust expand [M]acro' })
        end,
      },
      tools = {
        enable_clippy = true,
      },
    }
  end,
}
