local psqlexec = require('s21.modules.sql.psqlexec')
local utils = require('s21.utils')

local M = {}

function M.get_name()
  return vim.fs.joinpath(vim.fn.expand('%:h'), 'test.sql')
end

local winid = nil
function M.close_win()
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_buf_delete(vim.api.nvim_win_get_buf(winid), { force = true, })
    winid = nil
  end
end

function M.run()
  if not M.exists() then return end
  M.close_win()

  vim.cmd('botright vsplit ' .. M.get_name())
  winid = vim.api.nvim_get_current_win()

  vim.api.nvim_set_option_value('modifiable', false, { buf = 0, })
  vim.api.nvim_set_option_value('winfixbuf', true, { win = winid, })

  utils.set_buf_fastclose(0)

  psqlexec({
    height = 0.5,
  })
end

function M.exists()
  print(vim.inspect(M.get_name()))
  return vim.fn.filereadable(M.get_name()) == 1
end

return M
