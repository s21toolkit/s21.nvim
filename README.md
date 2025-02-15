# Установка

<details open>
<summary>Lazy</summary>

```lua
return {
  's21toolkit/s21.nvim',
  event = 'VimEnter',
  dependencies = {
    -- Required for sql docker control absence of this disable automatic postgres management
    'stevearc/overseer.nvim',
  },
  keys = {
    { '<leader>;', '<cmd>S21GitlabOpen<cr>', mode = { 'n', }, },
  },
  cond = function() return vim.fn.getcwd():match('/s21/') ~= nil end,
  opts = {
    switch = true, -- Automatically switch to develop branch
    task = {
      -- boolean for controlling built in behaivor (relies on overseer)
      -- preview = false,
      -- function for custom opener
      preview = function ()
        local api = require('s21.api')
        if not api.i3.window_title_contains(api:project_dir_name()) then
          -- https://github.com/jannis-baum/Vivify
          vim.system({ 'sh', '-c', 'viv ' .. vim.fs.joinpath(api:project_root(), 'README*.md') })
        end
      end
    },
    sql = {
      -- Guess exercise number from README.md initializing folder/file structure
      init = true,
      -- Settings for docker and psql requires docker and overseer
      postgres = {
        port = 5432,
        user = 'someuser',
        password = 'somepassword'
      },
      -- Control mapping for psql cli
      keymap = {
        psqlexec = '<leader>p', -- execute sql
        prevex = ',', -- go to previous excercise (no exec)
        nextex = '.', -- go to next excercise (exec with tests if test.sql found in the same folder)
      }
    },
  },
}
```
</details>
