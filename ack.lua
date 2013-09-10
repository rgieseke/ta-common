-- The __common.ack__ module provides an interface to the
-- [ack](http://betterthangrep.com/) command line utility for searching
-- in a directory of source files.<br>
-- As an alternative Textadept's find in files can be used.
-- Ack runs on Windows as well, but since it is not a package
-- repository away, Lua search is the default on Windows.<br>
-- Using `Alt/⌘`+`L` and`Alt/⌘`+`A` you can toggle between the two search
-- modes.
local M = {}

-- To start a search in the project's root directory we use the
-- [common.project](project.html) module.
local project = require 'common.project'

-- ### Fields

-- Ack settings.
-- They can be overwritten in your `init.lua` after loading the
-- _common_ module, for example:
--     _M.common.ack.OPTIONS = '--nocolor --nogroup --ignore-case'
M.OPTIONS = '--nocolor --nogroup'

-- ## Setup
local events = events

local buffer_type = _L['Files Found Buffer']

-- ## Functions

-- If the command entry is open and a search with ack or Lua
-- is active run the search after pressing enter.
events.connect(events.COMMAND_ENTRY_COMMAND,
  function(text)
    if ack_search then
      local search_dir = project.root()
      ui.command_entry.focus()
      local command = 'ack '..M.OPTIONS..' '..text
      local p = io.popen(command..' '..search_dir..' 2>&1')
      local out = p:read('*all')
      p:close()
      ui._print(buffer_type, 'ack: '..search_dir..'\n\n'..out)
      ack_search = false
      buffer:goto_pos(0)
      buffer.read_only = 1
      return true
    end
    if textadept_find_in_files then
      local search_dir = project.root()
      ui.command_entry.focus()
      ui.find.find_entry_text = text
      ui.find.find_in_files(search_dir)
      textadept_find_in_files = false
      return true
    end
  end, 1)

-- Switch the search mode in the command entry.
events.connect(events.COMMAND_ENTRY_KEYPRESS,
  function(code, shift, control, alt)
    local K = _G.keys.KEYSYMS
    if ack_search or textadept_find_in_files then
      if K[code] == 'esc' then
        ack_search = nil
        textadept_find_in_files = nil
        ui.command_entry.focus()
        ui.statusbar_text = ''
        return true
      elseif control and string.char(code) == 'l' then
        ack_search = nil
        textadept_find_in_files = true
        ui.statusbar_text = "Lua find in files: "..project.root()
      elseif control and string.char(code) == 'k' then
        ack_search = true
        textadept_find_in_files = false
        ui.statusbar_text = "ack: "..project.root()
      end
    end
  end, 1)

-- Open command entry to enter search term.
function M.search_entry()
  if buffer.filename then
    if WIN32 then
      textadept_find_in_files = true
    else
      ack_search = true
    end
    ui.command_entry.entry_text = ''
    ui.command_entry.focus()
    ui.statusbar_text = "ack: "..project.root()
  end
end

return M
