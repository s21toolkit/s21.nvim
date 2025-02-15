local overseer = require('overseer')
local config = require('s21.modules.sql.config')
local ex = require('s21.modules.sql.ex')

overseer.register_template({
  name = 'init folders',
  params = {
    count = {
      type = 'number',
      name = 'Task count',
    },
  },
  builder = function(p)
    return {
      name = 'init folders',
      cmd = { 'sh', vim.fs.joinpath(config.paths.assets, 'init.sh'), },
      env = { N = p.count, DN = ex.get_current_day(), },
      components = { 'default', 'unique', },
    }
  end,
})
