-- Shorten display filenames in buffer title and switch buffer dialog.
-- On Windows
--     C:\Documents and Settings\username\Desktop\...
-- is replaced with
--     Desktop\...,
-- on Max OS X and Linux
--     /home/username/..
-- or
--     /Users/username/...
-- with
--     ~/...
--
-- Modified from Textadept's
-- [core.gui](http://code.google.com/p/textadept/source/browse/core/gui.lua) and
-- [snapopen](http://code.google.com/p/textadept/source/browse/modules/textadept/snapopen.lua)
-- module.
local M = {}

-- ## Fields

local pattern, replacement

-- Read environment variable.
if WIN32 then
  pattern = os.getenv('USERPROFILE')..'\\'
  replacement = ''
else
  pattern = '^'..os.getenv('HOME')
  replacement = '~'
end

-- ## Commands

-- Sets the title of the Textadept window to the buffer's filename.
-- Parameter:<br>
-- _buffer_: The currently focused buffer.
local function set_title(buffer)
  local buffer = buffer
  local filename = buffer.filename or buffer._type or _L['Untitled']
  local dirty = buffer.dirty and '*' or '-'
  gui.title = string.format('%s %s Textadept (%s)', filename:match('[^/\\]+$'),
                            dirty, filename:gsub(pattern, replacement))
end

-- Disconnect events that use `set_title` from `core/gui.lua`
-- and reconnect with new `set_title` function
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
  end)

events.disconnect('view_after_switch', 2)
events.connect('view_after_switch',
  function() -- updates titlebar and statusbar
    set_title(buffer)
    events.emit('update_ui')
  end, 2)

-- Displays a dialog with a list of buffers to switch to and switches to the
-- selected one, if any.
function M.switch_buffer()
  local items = {}
  for _, buffer in ipairs(_BUFFERS) do
    local filename = buffer.filename or buffer._type or _L['Untitled']
    local dirty = buffer.dirty and '*' or ''
    items[#items + 1] = dirty..filename:match('[^/\\]+$')
    items[#items + 1] = filename:gsub(pattern, replacement)
  end
  local response = gui.dialog('filteredlist',
                              '--title', _L['Switch Buffers'],
                              '--button1', 'gtk-ok',
                              '--button2', 'gtk-cancel',
                              '--no-newline',
                              '--columns', 'Name', 'File',
                              '--items', items)
  local ok, i = response:match('(%-?%d+)\n(%d+)$')
  if ok == '1' then view:goto_buffer(tonumber(i) + 1) end
end

return M
