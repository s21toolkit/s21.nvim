local M = {}

function M.setup(o)
  M.api = require('api')
  vim.api.nvim_create_user_command('S21GitlabOpen', function()
    vim.system({
      'xdg-open',
      M.api.project_web_url(),
    }):wait()
  end, {})

  -- Automagically switch to develop branch
  if o.switch == true and vim.system({ 'git', 'switch', 'develop', }):wait().code ~= 0 then
    vim.system({ 'git', 'switch', '-b', 'develop', }):wait()
  end

  if vim.fn.getcwd():match('/SQL/') then require('s21.modules.sql'):setup(o.sql) end

  require('tasks')
end

return M
