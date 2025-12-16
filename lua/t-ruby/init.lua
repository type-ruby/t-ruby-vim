-- T-Ruby Neovim Plugin
-- Main entry point for the T-Ruby Neovim integration

local M = {}

-- Re-export LSP module
M.lsp = require("t-ruby.lsp")

-- Convenience function to setup LSP
function M.setup(opts)
  M.lsp.setup(opts)
end

return M
