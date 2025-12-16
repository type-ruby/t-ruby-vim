# T-Ruby for Vim / Neovim

[![GitHub Release](https://img.shields.io/github/v/release/type-ruby/t-ruby-vim?label=Version)](https://github.com/type-ruby/t-ruby-vim/releases)
[![GitHub Stars](https://img.shields.io/github/stars/type-ruby/t-ruby-vim)](https://github.com/type-ruby/t-ruby-vim)
[![T-Ruby Compiler](https://img.shields.io/gem/v/t-ruby?label=T-Ruby%20Compiler)](https://rubygems.org/gems/t-ruby)
[![License](https://img.shields.io/github/license/type-ruby/t-ruby-vim)](LICENSE)

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

## Related

- [T-Ruby Compiler](https://github.com/type-ruby/t-ruby) - The main T-Ruby compiler
- [T-Ruby VS Code](https://github.com/type-ruby/t-ruby-vscode) - VS Code extension
- [T-Ruby JetBrains](https://github.com/type-ruby/t-ruby-jetbrains) - JetBrains IDE plugin

## License

MIT
