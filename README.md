<p align="center">
  <img src="https://avatars.githubusercontent.com/u/248530250" alt="T-Ruby" height="120">
</p>

<h1 align="center">T-Ruby for Vim / Neovim</h1>

<p align="center">
  <a href="https://type-ruby.github.io">Official Website</a>
  &nbsp;&nbsp;•&nbsp;&nbsp;
  <a href="https://github.com/type-ruby/t-ruby">GitHub</a>
</p>

<p align="center">
  <a href="https://github.com/type-ruby/t-ruby-vim/releases"><img src="https://img.shields.io/github/v/release/type-ruby/t-ruby-vim?label=Version" alt="GitHub Release"></a>
  <a href="https://rubygems.org/gems/t-ruby"><img src="https://img.shields.io/gem/v/t-ruby?label=T-Ruby%20Compiler" alt="T-Ruby Compiler"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/type-ruby/t-ruby-vim" alt="License"></a>
</p>

---

T-Ruby language support for Vim and Neovim. Provides syntax highlighting and LSP integration for [T-Ruby](https://github.com/type-ruby/t-ruby) - a TypeScript-style static type system for Ruby.

## Features

- Syntax highlighting for `.trb` and `.d.trb` files
- File type detection
- LSP integration for Neovim (via nvim-lspconfig or manual setup)
- coc.nvim support

## Requirements

- [T-Ruby Compiler](https://github.com/type-ruby/t-ruby) (`trc`) must be installed and available in your PATH

```bash
gem install t-ruby
```

## Installation

### vim-plug

```vim
Plug 'type-ruby/t-ruby-vim'
```

### Lazy.nvim

```lua
{
  'type-ruby/t-ruby-vim',
  ft = { 'truby' },
}
```

### Packer.nvim

```lua
use {
  'type-ruby/t-ruby-vim',
  ft = { 'truby' },
}
```

### Manual

Clone to your Vim/Neovim plugin directory:

```bash
# Vim
git clone https://github.com/type-ruby/t-ruby-vim ~/.vim/pack/plugins/start/t-ruby-vim

# Neovim
git clone https://github.com/type-ruby/t-ruby-vim ~/.local/share/nvim/site/pack/plugins/start/t-ruby-vim
```

## Neovim LSP Setup

### With nvim-lspconfig

```lua
require('t-ruby').setup()
```

Or with custom options:

```lua
require('t-ruby').setup({
  cmd = { 'trc', '--lsp' },
  on_attach = function(client, bufnr)
    -- Your on_attach function
  end,
})
```

### Manual Setup

```lua
require('t-ruby.lsp').setup_manual({
  cmd = { 'trc', '--lsp' },
})
```

### With coc.nvim

Copy the example configuration to your coc-settings.json:

```json
{
  "languageserver": {
    "t-ruby": {
      "command": "trc",
      "args": ["--lsp"],
      "filetypes": ["truby"],
      "rootPatterns": ["trbconfig.yml", ".git/"]
    }
  }
}
```

## Commands (Neovim)

After setting up LSP, the following commands are available:

- `:TRubyCompile` - Compile the current file
- `:TRubyDecl` - Generate declaration file
- `:TRubyLspInfo` - Show LSP status

## File Structure

```
t-ruby-vim/
├── ftdetect/truby.vim     # File type detection
├── ftplugin/truby.vim     # File type plugin settings
├── syntax/truby.vim       # Syntax highlighting
├── lua/t-ruby/
│   ├── init.lua           # Main module
│   └── lsp.lua            # LSP configuration
└── coc-settings-example.json
```

## Compatibility

| Plugin Version | T-Ruby Compiler | Vim/Neovim |
|----------------|-----------------|------------|
| 0.1.x          | >= 0.0.30       | Vim 8+, Neovim 0.8+ |

## Quick Start Example

1. Create a file `hello.trb`:

```trb
type UserId = String

interface User
  id: UserId
  name: String
  age: Integer
end

def greet(user: User): String
  "Hello, #{user.name}!"
end
```

2. Open in Vim/Neovim - you'll see syntax highlighting

3. For Neovim with LSP: hover over types to see definitions, use `gd` to go to definition

4. Compile with `:TRubyCompile` (Neovim) or `:!trc %` (Vim)

## Vim Configuration

Add to your `~/.vimrc` for customization:

```vim
" Custom key mappings
autocmd FileType truby nnoremap <buffer> <leader>tc :!trc %<CR>
autocmd FileType truby nnoremap <buffer> <leader>td :!trc --decl %<CR>

" Custom settings
augroup truby_settings
  autocmd!
  autocmd FileType truby setlocal shiftwidth=2 softtabstop=2
augroup END
```

## Neovim Key Mappings

Recommended key mappings for Neovim:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "truby",
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", "<leader>tc", ":TRubyCompile<CR>", opts)
    vim.keymap.set("n", "<leader>td", ":TRubyDecl<CR>", opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  end,
})
```

## Troubleshooting

### No syntax highlighting

1. Check filetype: `:set filetype?`
2. Manually set filetype: `:set filetype=truby`
3. Verify syntax file exists: `:echo globpath(&rtp, 'syntax/truby.vim')`

### LSP not starting (Neovim)

1. Check if `trc` is available: `:!trc --version`
2. Check LSP status: `:TRubyLspInfo`
3. View LSP logs: `:lua vim.cmd('e ' .. vim.lsp.get_log_path())`

## Contributing

Issues and pull requests are welcome!
https://github.com/type-ruby/t-ruby-vim/issues

## Related

- [T-Ruby Compiler](https://github.com/type-ruby/t-ruby) - The main T-Ruby compiler
- [T-Ruby VS Code](https://github.com/type-ruby/t-ruby-vscode) - VS Code extension
- [T-Ruby JetBrains](https://github.com/type-ruby/t-ruby-jetbrains) - JetBrains IDE plugin

## License

MIT
