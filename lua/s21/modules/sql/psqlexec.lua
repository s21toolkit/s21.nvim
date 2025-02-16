local config = require('s21.modules.sql.config')
local utils = require('s21.utils')

---@class PSQLExecConfig
---@field silent boolean? Do not show results in scratch buffer
---@field height number? Fraction of current window height

---@param cfg PSQLExecConfig
return function(cfg)
  if vim.api.nvim_buf_line_count(0) < 2 then
    vim.notify('Not executing no lines in current buffer', vim.log.levels.WARN)
    return
  end

  local h = vim.system({
      'psql',
      string.format(
        'postgresql://%s:%s@127.0.0.1:%d/%s',
        config.postgres.user,
        config.postgres.password,
        config.postgres.port,
        config.postgres.db
      ),
    },
    {
      env = { PAGER = 'cat', },
      stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false),
    }):wait()

  if h.code ~= 0 or #h.stderr ~= 0 then
    vim.notify(h.stderr, vim.log.levels.ERROR)
    return
  end

  if cfg and cfg.silent == true then return end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(h.stdout, '\n'))

  vim.keymap.set('n', config.keymap.nextexec, function()
    require('s21.modules.sql.ex').advance(1, true)
  end, { buffer = buf, })

  utils.set_buf_fastclose(buf, { config.keymap.prevex })
  utils.set_buf_nomodify(buf)
  utils.set_buf_delete_on_leave(buf)

  vim.api.nvim_open_win(buf, true, {
    win = 0,
    split = 'below',
    height = math.floor(vim.api.nvim_win_get_height(0) * ((cfg and cfg.height) or 0.9)),
  })
end
