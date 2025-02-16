local module_path = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
local utils = require('s21.utils')

local M = {
  init = true,
  format = false,
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
    testexec = '<leader>\'',
    nextexec = '\'',
    prevex = ',',
    nextex = '.',
  },
}

return utils.setup_config(M)
