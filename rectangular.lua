module('_.common.rectangular', package.seeall)

-- Rectangular selection
-- press alt r
-- keep alt down and use arrow keys to select

keys.ar = { function()
  local events = events
  local gui = gui
  local KEYSYMS = _m.textadept.keys.KEYSYMS
    gui.statusbar_text = 'Rectangular selection'
    rselect = events.connect('keypress',
      function(code, shift, control, alt)
        if alt and KEYSYMS[code] == 'left' then
          buffer:char_left_rect_extend()
          return true
        elseif alt and KEYSYMS[code] == 'up' then
          buffer:line_up_rect_extend()
          return true
        elseif alt and KEYSYMS[code] == 'right' then
          buffer:char_right_rect_extend()
          return true
        elseif alt and KEYSYMS[code] == 'down' then
          buffer:line_down_rect_extend()
          return true
        else
          events.disconnect('keypress', rselect)
          events.emit('update_ui')
          return
         end
      end, 1)
end
}
