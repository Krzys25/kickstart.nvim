# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Plugin manager is **`vim.pack`** (Neovim 0.12 built-in). Colorscheme is **onedarkpro** (replaces upstream tokyonight, inlined in init.lua Section 4).

## Branch Strategy

- **`master`**: Always mirrors upstream `nvim-lua/kickstart.nvim`. Only advance via `git merge --ff-only upstream/master`.
- **`krzys25_custom_v2`**: All personal customizations live here. This is the working branch. (The previous `krzys25_custom` branch is kept as a backup from the pre-vim.pack era; do not commit to it.)
- Never commit personal changes to `master`. Never commit upstream syncs to `krzys25_custom_v2`.

Upstream sync workflow (history on `krzys25_custom_v2` is disposable — rebase + force-push):
```bash
git fetch upstream
git checkout master
git merge --ff-only upstream/master
git checkout krzys25_custom_v2
git branch backup/presync_$(date +%Y%m%d) krzys25_custom_v2   # optional safety ref
git rebase master              # most upstream changes land cleanly because our commits
                               # rarely touch the same lines; the main manual area is
                               # Sections 1-2 (Options/Keymaps) when upstream restructures them
git push --force-with-lease origin krzys25_custom_v2
```
When resolving conflicts, always **adopt upstream's structural/renumbering changes** (the `SECTION N:` banners belong to upstream) and re-slot only your content edits into them. Keep this file's section map in sync afterward.

## Architecture

`init.lua` is organized as **10 numbered `do...end` sections**. Read top-to-bottom; each section is self-contained.

1. **Section 1: Options** — vim options, leaders, diagnostic config.
2. **Section 2: Keymaps** — basic keymaps and basic autocommands (e.g. highlight-on-yank).
3. **Section 3: Plugin Manager Intro** — `vim.pack` notes and the `PackChanged` build-hook autocommand (handles telescope-fzf-native, LuaSnip, nvim-treesitter post-install steps).
4. **Section 4: UI / Core UX** — guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini.nvim modules. Icons come from `mini.icons` (mocking `nvim-web-devicons`).
5. **Section 5: Search & Navigation** — Telescope setup, keymaps, LSP picker mappings.
6. **Section 6: LSP** — `LspAttach` autocommand for buffer keymaps, `servers` table, Mason + mason-tool-installer.
7. **Section 7: Formatting** — conform.nvim with whitelist `format_on_save`.
8. **Section 8: Autocomplete & Snippets** — LuaSnip + blink.cmp.
9. **Section 9: Treesitter** — parser preinstall list + auto-install-on-FileType.
10. **Section 10: Optional Examples / Next Steps** — opt-in `require` lines for `lua/kickstart/plugins/*` bundles and the `lua/custom/plugins/*` loader.

### Auxiliary directories

- **`lua/kickstart/plugins/`** — Optional bundled plugin configs from upstream. Each file returns a vim.pack-compatible setup module. Enabled by uncommenting `require` lines in Section 10. Currently enabled: `autopairs.lua`, `indent_line.lua`.

- **`lua/custom/plugins/`** — Personal plugin additions. The `init.lua` here iterates the directory — following symlinks, and loading symlinked `.lua` files too — and `require`s each `.lua` file (return values are ignored — files run for side effects). Each file is an **imperative script**: it calls `vim.pack.add { 'https://github.com/owner/repo' }` (full URL, since the `gh` helper in init.lua isn't exported) and then `require('plugin').setup{}` or sets relevant `vim.g.*` globals.

- **`ftplugin/yaml.lua`** — Forces 2-space expandtab for YAML and blocks the stock Vim ftplugin/indent scripts via `did_ftplugin`/`did_indent`.

## Common Commands

```
:lua vim.pack.update()                       -- Update plugins
:lua vim.pack.update(nil, { offline = true })-- Inspect plugin state, pending updates
:Mason                                       -- LSP/tool installer UI
:ConformInfo                                 -- Active formatters for current buffer
:checkhealth                                 -- Health checks (includes kickstart checks)
```

## Adding Things

**New custom plugin**: Create `lua/custom/plugins/<name>.lua` containing imperative code:
```lua
vim.pack.add { 'https://github.com/owner/repo' }
require('repo').setup { ... }
```
The directory iterator picks it up automatically. Do NOT edit `lua/custom/plugins/init.lua` unless you're changing the loader itself.

**New LSP server**: Add `<name> = { ... }` to the `servers` table in init.lua Section 6. mason-tool-installer ensures install.

**New treesitter parser**: Add the language name to the `parsers` list in init.lua Section 9. The FileType autocmd will also auto-install on first open if you skip this — preinstalling just avoids the first-open delay.

**Format-on-save for a new filetype**: Add `<ft> = true` to `enabled_filetypes` inside the `format_on_save` function in Section 7 (whitelist semantics).

## Lua Code Style

Enforced by `.stylua.toml` + conform.nvim format-on-save (Lua only):
- 160 char column width, 2-space indentation (spaces)
- Single quotes preferred
- No parentheses on single-arg function calls: `require 'foo'` not `require('foo')`
- Simple statements collapsed to one line

## Gotchas

- **vim.pack uses full URLs at the boundary**: in init.lua, the `gh` helper (`local function gh(repo) return 'https://github.com/' .. repo end`) is **local** to that file. Custom plugin files must use full URLs.

- **rustaceanvim owns rust-analyzer**: do not add `rust_analyzer = {}` to the `servers` table in Section 6. `lua/custom/plugins/rustaceanvim.lua` starts the LSP client itself via `vim.g.rustaceanvim`.

- **`vim.g.rustaceanvim` must be set BEFORE `vim.pack.add`** in the custom plugin file, since rustaceanvim reads it on initialization.

- **stylua is an LSP, not an external conform formatter**: upstream Section 6 lists `stylua = {}` in the `servers` table. Conform's `lsp_format = 'fallback'` then routes Lua formatting through it. Do not add stylua to conform's `formatters_by_ft`.

- **Format-on-save is a whitelist** (upstream changed from blacklist). Only the filetypes listed in `enabled_filetypes` inside Section 7 format on save. Currently: `lua`.

- **guess-indent + YAML**: `init.lua` Section 4 excludes `yaml` via `filetype_exclude`. `ftplugin/yaml.lua` then sets the indent options explicitly. If you remove the exclusion, the ftplugin still wins via `did_ftplugin = 1`, but the exclusion is cleaner.

- **Icons come from mini.icons**: upstream migrated off `nvim-web-devicons` to `mini.icons` (a `mini.nvim` submodule already installed). Section 4 calls `require('mini.icons').setup()` then `MiniIcons.mock_nvim_web_devicons()` for plugins that still expect the web-devicons API (e.g. telescope). Do not re-add `nvim-web-devicons`.

- **mini.surround is the only surround plugin** (upstream loads it in Section 4). Keymaps are `sa`/`sd`/`sr`. The previous nvim-surround (`ys`/`ds`/`cs`) was dropped during the vim.pack migration.

- **PackChanged build hooks**: telescope-fzf-native (`make`), LuaSnip (`make install_jsregexp`), and nvim-treesitter (`:TSUpdate`) have post-install logic in Section 3. If you add a plugin with a native build step, add a branch there.

- **Keymap descriptions** use `[B]racket` notation for which-key grouping (e.g., `'[S]earch [F]iles'`).
