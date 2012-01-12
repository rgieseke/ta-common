-- Displays a filtered list of files in a project along with their current
-- hg state or a standard snapopen dialog if hg is not used.
local M = {}

-- Figure out the projects root and display states of the files in a
-- snapopen dialog.
function M.hg_status()
  local path = buffer.filename:match('(.+)[/\\]')
  local cd_path
  if WIN32 then
    cd_path = 'cd /d '..path
  else
    cd_path = 'cd '..path
  end
  local command = cd_path..' && hg root 2>&1'
  local f = io.popen(command)
  local ans = f:read("*a")
  f:close()
  if ans:match(".hg not found") then
     _M.textadept.snapopen.open(path)
  else
    local hg_root = ans:sub(1,-2)
    command = cd_path..' && hg st -amdcu 2>&1'
    f = io.popen(command)
    local status = f:read("*a")
    f:close()
    local items =  {}
    local fstatus, fname
    for fstatus, fname in string.gmatch(status, "(.)%s(%C+)\r?\n") do
      items[#items+1] = fname
      items[#items+1] = fstatus
    end
    local utf8_filenames = gui.filteredlist(_L['Open'], {_L['File'], 'Status'}, items, false,
                                          '--select-multiple') or ''
    for filename in utf8_filenames:gmatch('[^\n]+') do
      io.open_file(hg_root..'/'..filename)
    end
  end
end

return M
