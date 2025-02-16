local formatter_path = nil
local formatter_package = 'sql-formatter'
local formatter_pending_install = false

local ok, registry = pcall(require, 'mason-registry')
if not ok or not registry then return end

---@type fun(whole: boolean): nil
local formatexpr

local function formatter()
  if formatter_path then
    return formatter_path
  end

  if not formatter_pending_install and not registry.is_installed(formatter_package) then
    formatter_pending_install = true
    registry.get_package(formatter_package):install():once('closed', function ()
      formatter_pending_install = false
      vim.schedule(function () formatexpr(true) end)
    end)

    return nil
  end

  formatter_path = vim.fs.joinpath(
    registry.get_package(formatter_package):get_install_path(),
    'node_modules',
    '.bin',
    'sql-formatter'
  )

  return formatter_path
end

formatexpr = function (whole)
  local start = whole and 0 or (vim.v.lnum - 1)
  local _end = whole and -1 or (start + vim.v.count)

  local fmtname = formatter()
  if not fmtname then
    vim.notify(formatter_package .. ' is not installed. Installing...', vim.log.levels.WARN)
    return
  end

  local h = vim.system({ fmtname, '-l', 'postgresql', }, {
    clear_env = true,
    stdin = vim.api.nvim_buf_get_lines(0, start, _end, false),
    text = true,
  }):wait()

  if h.code ~= 0 then
    print(start, _end, h.stderr, h.stdout)
    return
  end

  vim.api.nvim_buf_set_lines(0, start, _end, false, vim.split(h.stdout, '\n'))
end

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function() formatexpr(true) end,
  pattern = '*.sql',
})
