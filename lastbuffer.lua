module('_m.common.lastbuffer', package.seeall)

-- Switch between two buffers with ctrl-alt-b

events.connect('buffer_before_switch',
  function()
    for index, b in ipairs(_BUFFERS) do
      if b == buffer then
        last_buffer_index = index
        break
      end
    end
  end)

keys.cab = {
  function()
    if last_buffer_index then
      view:goto_buffer(last_buffer_index, true)
    end
   end
}


