local M = {}

function M:setup(o)
  local config = require('s21.modules.sql.config')
  config:setup(o)

  require('s21.modules.sql.docker')
  require('s21.modules.sql.init-folders')
  require('s21.modules.sql.commands')

  M.formatexpr = require('s21.modules.sql.formatter')
  local psqlexecbuf = require('s21.modules.sql.psqlexec')
  local ex = require('s21.modules.sql.ex')

  vim.api.nvim_create_autocmd({ 'BufRead', 'FileType', }, {
    pattern = '*.sql',
    callback = function(a)
      local opts = { buffer = a.buf, }
      vim.keymap.set('n', config.keymap.psqlexec, function() psqlexecbuf({}) end, opts)
      vim.keymap.set('n', config.keymap.prevex, function() ex.advance(-1) end, opts)
      vim.keymap.set('n', config.keymap.nextex, function() ex.advance(1, true) end, opts)
    end,
  })

  vim.cmd('edit')

  local ok, overseer = pcall(require, 'overseer')
  if ok then overseer.run_template({ name = 'docker up', }) end
end

return M
