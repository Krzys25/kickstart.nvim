-- Rust development: rust-analyzer wrapper with runnables, debuggables,
-- expand-macros, hover actions, etc.
--
-- rust-analyzer itself is expected to be installed via rustup:
--   rustup component add rust-analyzer
--
-- Do NOT add `rust_analyzer = {}` to the servers table in init.lua —
-- rustaceanvim auto-configures and starts the LSP client itself.

-- Must be set BEFORE the plugin is loaded; rustaceanvim reads this on init.
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
      local map = function(lhs, fn, desc) vim.keymap.set('n', lhs, fn, { buffer = bufnr, desc = desc }) end
      map('K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, 'Rust hover actions')
      map('gra', function() vim.cmd.RustLsp 'codeAction' end, 'Rust code [A]ction')
      map('<leader>rr', function() vim.cmd.RustLsp 'runnables' end, '[R]ust [R]unnables')
      map('<leader>rd', function() vim.cmd.RustLsp 'debuggables' end, '[R]ust [D]ebuggables')
      map('<leader>rm', function() vim.cmd.RustLsp { 'expandMacro' } end, '[R]ust expand [M]acro')
    end,
  },
  tools = { enable_clippy = true },
}

vim.pack.add {
  { src = 'https://github.com/mrcjkb/rustaceanvim', version = vim.version.range '^9' },
}
