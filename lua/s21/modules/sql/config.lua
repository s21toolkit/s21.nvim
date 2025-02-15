local module_path = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
local utils = require('s21.utils')

local M = {
  init_folders = true,
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
    test = '<leader>\'',
  },
}

return utils.setup_config(M)
