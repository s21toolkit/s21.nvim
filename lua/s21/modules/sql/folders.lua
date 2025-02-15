local api = require('s21.api')
local ex = require('s21.modules.sql.ex')

local function get_total_exercise_number()
  local lines = vim.fn.readfile(
    vim.fs.joinpath(api.project_root(), 'README.md')
  )

  local pnum = 0
  for i = 1, #lines do
    local num = tonumber(lines[i]:match('ex(%d+)'))
    if num and num > pnum then
      pnum = num
    end
  end

  return pnum
end

local num = get_total_exercise_number()

local rights = tonumber('755', 8)
for i = 0, num do
  local dir = string.format('ex%02d', i)
  vim.uv.fs_mkdir(dir, rights, nil)
  local file = vim.fs.joinpath(
    dir,
    string.format(
      'day%02d_ex%02d.sql',
      ex.get_current_day(), i
    )
  )

  if vim.fn.filereadable(file) == 0 then
    vim.fn.writefile({''}, file)
  end
end
