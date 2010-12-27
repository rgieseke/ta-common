module('_m.common.ack', package.seeall)

-- load with
-- require 'common.ack'
-- in init.lua

options = '--nocolor --nogroup '

local L = _G.locale.localize
local sep = '/'
local buffer_type = L('[Files Found Buffer]')

events.connect('command_entry_command',
  function(text) -- ack search
    if ack_search then
      local current_dir = buffer.filename:match('(.+)[/\\]')
      gui.command_entry.focus()
      local command = 'ack '..options..text
      local p = io.popen(command..' '..current_dir..' 2>&1')
      local out = p:read('*all')
      p:close()
      gui._print(buffer_type, out)
      ack_search = false
      buffer:goto_pos(0)
      buffer.read_only = 1
      return true
    end
    if textadept_find_in_files then
      local current_dir = buffer.filename:match('(.+)[/\\]')
      gui.command_entry.focus()
      gui.find.find_entry_text = text
      gui.find.find_in_files(current_dir)
      textadept_find_in_files = false
      return true
    end
  end, 1)

keys.caf = {
  function()
    if buffer.filename then
      if WIN32 then
        textadept_find_in_files = true
      else
        ack_search = true
      end
      gui.command_entry.entry_text = ''
      gui.command_entry.focus()
    end
  end }

