local M = {}

M.ghdash_toggle = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local ghdash = Terminal:new {
    cmd = "gh-dash",
    hidden = true,
    direction = "float",
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 103,
  }
  ghdash:toggle()
end

M.lazygit_toggle = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    -- float_opts = {
    --   border = "none",
    --   width = 100000,
    --   height = 100000,
    --   zindex = 200,
    -- },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99,
  }
  lazygit:toggle()
end

M.lazygit_filehistory = function()
  local Terminal = require "toggleterm.terminal".Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit --filter \"" .. vim.fn.expand('%') .. "\"",
    hidden = true,
    direction = "float",
    -- float_opts = {
    --   border = "none",
    --   width = 100000,
    --   height = 100000,
    --   zindex = 200,
    -- },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 101,
  }
  lazygit:toggle()
end

return M
