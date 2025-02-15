local config = require('s21.config')

local preview = config.task.preview
if (type(preview) == 'function') then
  preview()
  return
end

local ok, overseer = pcall(require, 'overseer')
if not ok or not preview then return end

overseer.register_template({
  name = 'preview-start',
  builder = function()
    local api = require('s21.api')
    return {
      name = 'vivify-server-start',
      cmd = (not api.i3.window_title_contains(api:project_dir_name())) and [[
      firefox && sleep .5 && i3-msg resize set 1400 px > /dev/null && vivify-server ../README*.md
    ]] or 'echo Already opened',
      components = {
        'unique',
        'on_exit_set_status',
        'on_complete_notify',
        { 'on_complete_dispose', require_view = { 'FAILURE', }, timeout = 10, },
      },
    }
  end,
})

overseer.run_template({ name = 'preview-start', })
