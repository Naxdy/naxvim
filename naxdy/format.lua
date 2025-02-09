local M = {}

M.format = function()
  local can_format = not require "lsp-format".disabled

  if can_format then
    vim.lsp.buf.format()
  end
end

return M
