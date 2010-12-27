module('_m.common.display_filename', package.seeall)

-- Shortens filenames for switch buffer dialog and buffer titles.

local L = _G.locale.localize

local userhome = os.getenv(not WIN32 and 'HOME' or 'USERPROFILE')

if WIN32 then
  -- C:\Documents and Settings\username\Desktop\... -> Desktop\...
  pattern = os.getenv('USERPROFILE')..'\\'
  replacement = ''
else
  -- /home/username/... -> ~/...
  -- /Users/username/... -> ~/...
  pattern = '^'..os.getenv('HOME')
  replacement = '~'
end

-- Sets the title of the Textadept window to the buffer's filename.
-- @param buffer The currently focused buffer.
local function set_title(buffer)
  local buffer = buffer
  local filename = buffer.filename or buffer._type or L('Untitled')
  local dirty = buffer.dirty and '*' or '-'
  gui.title = string.format('%s %s Textadept (%s)', filename:match('[^/\\]+$'),
                            dirty, filename:gsub(pattern, replacement))
end

-- Disconnect events that use events.lua's set_title
-- and reconnect with new set_title function
local events = _G.events
events.disconnect('save_point_reached', 1)
events.connect('save_point_reached',
  function() -- changes Textadept title to show 'clean' buffer
    buffer.dirty = false
    set_title(buffer)
  end)

events.disconnect('save_point_left', 1)
events.connect('save_point_left',
  function() -- changes Textadept title to show 'dirty' buffer
    buffer.dirty = true
    set_title(buffer)
  end)

events.disconnect('buffer_after_switch', 3)
events.connect('buffer_after_switch',
  function() -- updates titlebar and statusbar
    set_title(buffer)
    events.emit('update_ui')
  end, 3)

events.disconnect('view_after_switch', 2)
events.connect('view_after_switch',
  function() -- updates titlebar and statusbar
    set_title(buffer)
    events.emit('update_ui')
  end, 2)

function switch_buffer()
  local items = {}
  for _, buffer in ipairs(_BUFFERS) do
    local filename = buffer.filename or buffer._type or L('Untitled')
    local dirty = buffer.dirty and '*' or ''
    items[#items + 1] = dirty..filename:match('[^/\\]+$')
    items[#items + 1] = filename:gsub(pattern, replacement)
  end
  local response = gui.dialog('filteredlist',
                              '--title', L('Switch Buffers'),
                              '--button1', 'gtk-ok',
                              '--button2', 'gtk-cancel',
                              '--no-newline',
                              '--columns', 'Name', 'File',
                              '--items', items)
  local ok, i = response:match('(%-?%d+)\n(%d+)$')
  if ok == '1' then view:goto_buffer(tonumber(i) + 1, true) end
end

keys.cb = { switch_buffer }
