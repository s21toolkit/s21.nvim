local M = {}

function M.setup(o)
  local config = require('s21.config')
  config.setup(o)

  vim.api.nvim_create_user_command('S21GitlabOpen', function()
    vim.system({
      'xdg-open',
      require('s21.api').project_web_url(),
    }):wait()
  end, {})

  if config.switch == true and vim.system({ 'git', 'switch', 'develop', }):wait().code ~= 0 then
    vim.system({ 'git', 'switch', '-b', 'develop', }):wait()
  end

  if vim.fn.getcwd():match('/SQL_beginner.Day%d-%d') then
    require('s21.modules.sql').setup(o.sql)
  end

  require('s21.tasks')
end

return M
