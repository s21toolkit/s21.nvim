local M = {}

function M.setup(o)
  local config = require('s21.modules.sql.config')
  config.setup(o)

  if config.format then require('s21.modules.sql.formatter') end
  if config.init then require('s21.modules.sql.folders') end
  require('s21.modules.sql.commands')

  local psqlexecbuf = require('s21.modules.sql.psqlexec')
  local ex = require('s21.modules.sql.ex')
  local test = require('s21.modules.sql.test')

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sql',
    callback = function(a)
      local opts = { buffer = a.buf, }
      vim.keymap.set('n', config.keymap.psqlexec, function() psqlexecbuf({}) end, opts)
      vim.keymap.set('n', config.keymap.testexec, function() test.run() end, opts)
      vim.keymap.set('n', config.keymap.nextexec, function() ex.advance(1, true) end, opts)
      vim.keymap.set('n', config.keymap.prevex, function() ex.advance(-1) end, opts)
      vim.keymap.set('n', config.keymap.nextex, function() ex.advance(1) end, opts)
    end,
  })

  vim.api.nvim_exec_autocmds('FileType', {})

  local ok, overseer = pcall(require, 'overseer')
  if ok then
    require('s21.modules.sql.docker')
    overseer.run_template({ name = 'docker up', })
  end
end

return M
