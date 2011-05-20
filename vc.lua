-- Displays a filtered list of files in a project along with their current
-- hg state or a standard snapopen dialog if hg is not used.
module('_m.common.vc', package.seeall)

-- Figure out the projects root and display states of the files in a
-- snapopen dialog.
function hg_status()
  local path = buffer.filename:match('(.+)/')
  local command = 'cd '..path..'; hg root 2>&1'
  local f = io.popen(command)
  local ans = f:read("*a")
  f:close()
  if ans:match(".hg not found") then
     _m.textadept.snapopen.open({path})
  else
    local hg_root = ans:sub(1,-2)
    command = 'cd '..path..'; hg st -amdcu 2>&1'
    f = io.popen(command)
    local status = f:read("*a")
    f:close()
    local items =  {}
    local fstatus, fname
    for fstatus, fname in string.gmatch(status, "([AMDC\?])%s([%w\.]+)[\n]") do
      items[#items+1] = fname
      items[#items+1] = fstatus
    end
    local out =
      gui.dialog('filteredlist',
                 '--title', 'hg ('..hg_root..')',
                 '--button1', 'gtk-ok',
                 '--button2', 'gtk-cancel',
                 '--no-newline',
                 '--string-output',
                 '--columns', 'File', 'Status',
                 '--items', unpack(items))
    local response, file = out:match('([^\n]+)\n([^\n]+)$')
    if response and response ~= 'gtk-cancel' then
      io.open_file(hg_root..'/'..file)
    end
  end
end
