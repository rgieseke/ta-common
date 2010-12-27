module('_m.common.save_strips_ws', package.seeall)

local saved_col

events.connect('file_before_save',
  function()
    local buffer = buffer
    saved_col = buffer.column[buffer.current_pos]
  end, 1)

events.connect('file_after_save',
  function()
    local buffer = buffer
    if saved_col > 0 then
      virtual_space = buffer.virtual_space_options
      buffer.virtual_space_options = 2
      local col = buffer.column[buffer.current_pos]
      local diff = saved_col - col
      if diff > 0 then
        for i=1, diff do
          buffer:char_right()
        end
      end
      buffer.virtual_space_options = virtual_space
    end
  end)
