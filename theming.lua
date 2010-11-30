module('_m.common.theming', package.seeall)

-- Some additional theming, independent of the selected theme.

function set_buffer_properties()
  local buffer = buffer
  local c = _SCINTILLA.constants
  buffer.view_ws = 1
  buffer.virtual_space_options = 1 -- enabled only for rectangular selection
  buffer.edge_column = 80
  buffer.edge_mode = 1
  buffer.multiple_selection = true
  buffer.additional_selection_typing = true
  buffer.additional_carets_visible = true
  -- set number margin for files with more than 1000 lines
  local width = #(buffer.line_count..'')
  width = width > 3 and width or 3
  buffer.margin_width_n[0] = 4 + width *
    buffer:text_width(c.STYLE_LINENUMBER, '9')
end

local m_common = _m.common.theming
events.connect('file_opened', m_common.set_buffer_properties)
events.connect('buffer_new', m_common.set_buffer_properties)
events.connect('view_new', m_common.set_buffer_properties)
events.connect('reset_after', function ()
  for i=1, #_VIEWS do
    gui.goto_view(1, false)
    view:focus()
    set_buffer_properties()
  end
end)
