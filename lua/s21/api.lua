local M = { i3 = {}, }

---@return string
function M.project_root()
  return vim.fs.dirname(vim.fs.find('.git', { upward = true, })[1])
end

---@return string
function M:project_dir_name()
  return vim.fs.basename(self:project_root())
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

---@class WindowTitleContainsOptions
---@field plain boolean | nil treat term as palin text or not

--- Always return false when either jq or i3-msg is not supplied
---@param term string
---@param o WindowTitleContainsOptions | nil
---@return boolean
function M.i3.window_title_contains(term, o)
  if not vim.fn.executable('jq') or not vim.fn.executable('i3-msg') then
    return false
  end

  if o == nil then
    o = { plain = true }
  elseif o.plain == nil then
    o.plain = true
  end

  local jq = vim.system({ 'jq', '-r', '.nodes | .. | objects | .name? // empty', }, {
    stdin = vim.system({ 'i3-msg', '-t', 'get_tree', }):wait().stdout,
  }):wait().stdout
  if not jq then
    vim.notify('Getting i3 status tree failed', vim.log.levels.ERROR)
    return false
  end


  local lines = vim.split(jq, '\n', { plain = true, })
  for i = 1, #lines do
    local s, _ = lines[i]:find(term, 0, o.plain)
    if (s == 1) then
      return true
    end
  end

  return false
end

return M
