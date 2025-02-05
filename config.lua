vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false
})

local change_scale_factor = function(change)
  local new_scale = vim.g.neovide_scale_factor + change
  if new_scale > 2 then
    new_scale = 2
  elseif new_scale < 0.2 then
    new_scale = 0.2
  end
  vim.g.neovide_scale_factor = new_scale
end

vim.keymap.set("n", "<C-->", function()
  change_scale_factor(-0.1)
end)

vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(0.1)
end)

require 'scrollbar'.setup()

require 'browsher'.setup({
  default_remote = 'origin',
  default_pin = 'commit',
  open_cmd = '+',
  providers = {
    ["github.com"] = {
      url_template = "%s/blob/%s/%s",
      single_line_format = "#L%d",
      multi_line_format = "#L%d-L%d",
    },
    ["gitlab.com"] = {
      url_template = "%s/-/blob/%s/%s",
      single_line_format = "#L%d",
      multi_line_format = "#L%d-%d",
    },
    ["git.naxdy.org"] = {
      url_template = "%s/src/commit/%s/%s",
      single_line_format = "#L%d",
      multi_line_format = "#L%d-L%d",
    },
  },
})

-- autosave
local group = vim.api.nvim_create_augroup('autosave', {})

vim.api.nvim_create_autocmd('User', {
  pattern = 'AutoSaveWritePre',
  group = group,
  callback = function(opts)
    if opts.data.saved_buffer ~= nil and not (require 'lsp-format'.disabled) then
      vim.lsp.buf.format({
        bufnr = opts.data.saved_buffer
      })
    end
  end
})

local ngroup = vim.api.nvim_create_augroup('Naxdy', {})

-- exrc at home because vim.o.exrc doesn't work for some reason
local joinpath = vim.fs.joinpath or function(...)
  return (table.concat({ ... }, '/'):gsub('//+', '/'))
end

vim.api.nvim_create_autocmd('VimEnter', {
  group = ngroup,
  desc = 'Load init file on startup',
  callback = function()
    local cwd = vim.fn.getcwd(-1, -1)
    local exrc = joinpath(cwd, '.nvim.lua')
    local exists = vim.fn.filereadable(exrc) == 1
    if exists then
      local data = vim.secure.read(exrc)
      if data then
        local ok, result = xpcall(vim.cmd.source, debug.traceback, exrc)
        if not ok then
          error(result)
        end
      end
    end
  end
})


-- treat tfstate files as json
local tfstate_to_json = {
  group = ngroup,
  desc = 'Set syntax to JSON for TF files',
  callback = function()
    local filename = vim.fn.expand('%')
    if vim.endswith(filename, ".tfstate") then
      vim.opt.syntax = 'json'
    end
  end
}

vim.api.nvim_create_autocmd('BufNewFile', tfstate_to_json)
vim.api.nvim_create_autocmd('BufRead', tfstate_to_json)
