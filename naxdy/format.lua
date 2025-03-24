local M = {
  disabled = false,
  saving_buffers = {}
}

local format_method = "textDocument/formatting"

local utils = require("null-ls.utils")
local has_treefmt = utils.is_executable("treefmt")

M.setup = function()
  vim.api.nvim_create_user_command("Format", function(args)
    args.buf = vim.api.nvim_get_current_buf()
    M.format(args)
  end, { nargs = "*", bar = true, force = true })

  vim.api.nvim_create_user_command("FormatDisable", M.disable, { nargs = "*", bar = true, force = true })

  vim.api.nvim_create_user_command("FormatEnable", M.enable, { nargs = "*", bar = true, force = true })

  local group = vim.api.nvim_create_augroup("Format", {})

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    desc = "Format on save",
    callback = M.format
  })
end

-- M.on_attach = function(client, bufnr)
--   if not bufnr then
--     bufnr = vim.api.nvim_get_current_buf
--   end
--
--   local group = vim.api.nvim_create_augroup("Format", { clear = false })
--
--   vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
--
--   vim.api.nvim_create_autocmd("BufWritePost", {
--     group = group,
--     desc = "Format on save",
--     buffer = bufnr,
--     callback = M.format
--   })
-- end

M.disable = function()
  M.disabled = true
end

M.enable = function()
  M.disabled = false
end

-- export for null_ls
M.treefmt = function()
  local h = require("null-ls.helpers")
  local methods = require("null-ls.methods")

  local FORMATTING = methods.internal.FORMATTING

  return h.make_builtin({
    name = "treefmt",
    meta = {
      url = "https://github.com/numtide/treefmt",
      description = "One CLI to format your repo",
    },
    method = FORMATTING,
    filetypes = {},
    generator_opts = {
      command = "treefmt",
      args = { "--allow-missing-formatter", "--stdin", "$FILENAME" },
      to_stdin = true,
    },
    -- if treefmt is in the path, it is preconfigured via flake
    condition = function()
      return has_treefmt
    end,
    factory = h.formatter_factory,
  })
end

local make_formatting_params = function(bufnr)
  return {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    options = { tabSize = vim.lsp.util.get_effective_tabstop(bufnr), insertSpaces = vim.api.nvim_get_option_value("expandtab", { buf = bufnr }) }
  }
end

---@param bufnr number
---@param client vim.lsp.Client
---@param remaining_clients table
M._format_single = function(bufnr, client, remaining_clients, sync)
  local next = function()
    if #remaining_clients > 0 then
      M._format_single(bufnr, table.remove(remaining_clients, 1), remaining_clients, sync)
    end
  end

  local callback = function(err, result, ctx)
    if err ~= nil then
      next()
      return
    end

    if result == nil or vim.fn.bufexists(ctx.bufnr) == 0 then
      next()
      return
    end

    if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
      vim.fn.bufload(ctx.bufnr)
      vim.api.nvim_buf_set_var(ctx.bufnr, "format_changedtick", vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick"))
    end

    vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-16")
    if ctx.bufnr == vim.api.nvim_get_current_buf() then
      M.saving_buffers[ctx.bufnr] = true
      vim.cmd('up')
      M.saving_buffers[ctx.bufnr] = nil
    end

    next()
  end

  if not client.supports_method(format_method, { bufnr = bufnr }) then
    next()
    return
  end

  vim.api.nvim_buf_set_var(bufnr, "format_changedtick", vim.api.nvim_buf_get_var(bufnr, "changedtick"))

  local timeout_ms = 2000
  if sync then
    local result = client.request_sync(format_method, make_formatting_params(bufnr), timeout_ms, bufnr)
    if result ~= nil then
      callback(result.err, result.result, { client_id = client.id, bufnr = bufnr })
    end
  else
    client.request(format_method, make_formatting_params(bufnr), callback, bufnr)
  end
end

M.format = function(options)
  local bufnr = options.buf
  if M.saving_buffers[bufnr] or M.disabled then
    return
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  -- if available, prioritize treefmt over everything else, by making it go last
  if has_treefmt then
    local treefmt_client = nil
    for i = 1, #clients do
      if clients[i].name == "null-ls" then
        treefmt_client = table.remove(clients, i)
        break
      end
    end

    table.insert(clients, treefmt_client)
  end

  if #clients > 0 then
    M._format_single(bufnr, table.remove(clients, 1), clients, options.sync or false)
  end
end

return M
