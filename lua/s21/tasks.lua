local config = require('s21.config')

local preview = config.task.preview
if (type(preview) == 'function') then
  preview()
  return
end

if not preview then return end

local overseer = require('overseer')

overseer.register_template({
  name = 'preview-start',
  builder = function()
    local fargs = '--new-window'
    local width = 1400
    local delay = 0.5
    if type(preview) == 'table' then
      if preview.width then width = preview.width end
      if preview.delay then delay = preview.delay end
      if preview.fargs then fargs = preview.fargs end
    end

    local api = require('s21.api')
    return {
      name = 'vivify-server-start',
      cmd = (
        not api.i3.window_title_contains(api:project_dir_name()))
        and string.format([[
          firefox %s && sleep %d && i3-msg resize set %d px > /dev/null && vivify-server ../README*.md
        ]], fargs, delay, width
      ) or 'echo Already opened',
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
