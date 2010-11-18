-- load all files in _USERHOME/modules/common as submodules

local lfs = require 'lfs'

for filename in lfs.dir(_USERHOME..'/modules/common/') do
  if filename:find('%.lua$') and filename ~= 'init.lua' then
    require('common.'..filename:match('^(.+)%.lua$'))
  end
end
