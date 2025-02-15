local module_path = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))

local M = {
  paths = {
    assets = vim.fs.joinpath(module_path, 'assets'),
    module = module_path,
  },
  postgres = {
    password = 'somepassword',
    user = 'someuser',
    db = 'school21',
    port = 5432,
  },
  keymap = {
    psqlexec = '<leader>p',
    prevex = ',',
    nextex = '.',
  },
}

function M:setup(opts)
  local newconf = vim.tbl_deep_extend('force', M, opts or {})
  for k, v in pairs(newconf) do
    M[k] = v
  end
end

return M
