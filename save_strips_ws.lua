module('_m.common.save_strips_ws', package.seeall)

events.connect('file_before_save',
  function()
    local buffer = buffer
    _m.common.save_strips_ws.col = buffer.column[buffer.current_pos]
  end, 1
)

events.connect('file_after_save',
  function()
    local buffer = buffer
    if _m.common.save_strips_ws.col > 0 then
      _m.common.save_strips_ws.virtual_space = buffer.virtual_space_options
      buffer.virtual_space_options = 2
      local col = buffer.column[buffer.current_pos]
      local diff = _m.common.save_strips_ws.col - col
      if diff > 0 then
        for i=1, diff do
          buffer:char_right()
        end
      end
      buffer.virtual_space_options = _m.common.save_strips_ws.virtual_space
    end
  end
)
