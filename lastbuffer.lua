-- Toggle between two buffers with a key shortcut.
module('_m.common.lastbuffer', package.seeall)

-- ## Commands

-- Save the buffer index before switching.
events.connect('buffer_before_switch',
  function()
    for index, b in ipairs(_BUFFERS) do
      if b == buffer then
        last_buffer_index = index
        break
      end
    end
  end)

-- Switch to last buffer.
function last_buffer()
  if last_buffer_index and #_BUFFERS >= last_buffer_index then
    view:goto_buffer(last_buffer_index, true)
  end
end
