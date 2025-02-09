local M = {}

M.toggle = function()
  if vim.diagnostic.config().virtual_lines then
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = false
    })
  else
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = true
    })
  end
end

return M
