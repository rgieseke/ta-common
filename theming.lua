-- Some additional theming, independent of the selected theme.
module('_m.common.theming', package.seeall)

-- See also the themes'
-- [buffer.lua](http://code.google.com/p/textadept/source/browse/themes/light/buffer.lua)
-- and
-- [view.lua](http://code.google.com/p/textadept/source/browse/themes/light/view.lua)
-- for more options.
function set_buffer_properties()
  local buffer = buffer
  local c = _SCINTILLA.constants
  buffer.view_ws = 0
  buffer.virtual_space_options = 1 -- enabled only for rectangular selection
  buffer.edge_column = 80
  buffer.edge_mode = 1
  buffer.wrap_mode = 1
  buffer.multiple_selection = true
  buffer.additional_selection_typing = true
  buffer.additional_carets_visible = true
  -- Set number margin for files with more than 1000 lines
  local width = #(buffer.line_count..'')
  width = width > 4 and width or 4
  buffer.margin_width_n[0] = 4 + width *
    buffer:text_width(c.STYLE_LINENUMBER, '9')
end

-- Connect events.
events.connect('file_opened', set_buffer_properties)
events.connect('buffer_new', set_buffer_properties)
events.connect('view_new', set_buffer_properties)
events.connect('reset_after', function ()
  for i=1, #_VIEWS do
    gui.goto_view(1, false)
    view:focus()
    set_buffer_properties()
  end
end)
