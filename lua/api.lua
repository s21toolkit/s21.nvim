local M = { i3 = {}, }

---@return string
function M.project_root()
  return vim.fs.find('.git', { upward = true, })[1]
end

---@return string
function M:project_dir_name()
  return vim.fs.basename(vim.fs.dirname(self:project_root()))
end

---@return string
function M.project_ssh_url()
  return vim.system({ 'git', 'remote', 'get-url', 'origin', }):wait().stdout
end

---@return string
function M.project_web_url()
  return string.format(
    'https://repos.21-school.ru%s/-/tree/develop/src',
    string.sub(M.project_ssh_url(), 38, -6)
  )
end

---@param term string
---@return boolean
function M.i3.window_title_contains(term)
  local jq = vim.system({ 'jq', '-r', '.nodes | .. | objects | .name? // empty', }, {
    stdin = vim.system({ 'i3-msg', '-t', 'get_tree', }):wait().stdout,
  }):wait().stdout
  if not jq then
    vim.notify('Getting i3 status tree failed', vim.log.levels.ERROR)
    return false
  end


  local lines = vim.split(jq, '\n', { plain = true, })
  for i = 1, #lines do
    local s, _ = lines[i]:find(term, 0, true)
    if (s == 1) then
      return true
    end
  end

  return false
end

return M
