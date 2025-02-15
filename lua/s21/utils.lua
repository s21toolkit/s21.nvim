local M = {}

---Map <cmd>bd!<cr> to every key specified in keys + <cr> + <esc>
---@param buf number
---@param keys table?
function M.set_buf_fastclose(buf, keys)
  local kkeys = {
    '<cr>',
    '<esc>',
    keys and unpack(keys) or nil
  }

  for i = 1, #kkeys do
    if not kkeys[i] then break end
    vim.keymap.set('n', kkeys[i], '<cmd>bd!<CR>', { buffer = buf, })
  end
end

function M.set_buf_nomodify(buf)
  vim.api.nvim_set_option_value('modified', false, { buf = buf, })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf, })
end

function M.set_buf_delete_on_leave(buf)
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = buf,
    callback = function(a)
      vim.api.nvim_buf_delete(a.buf, { force = true, })
    end,
  })
end

return M
