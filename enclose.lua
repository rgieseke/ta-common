module('_m.common.enclose', package.seeall)

-- Enables
-- enclosing a selection by typing (,[,{,',",
-- enclosing a selection and keeping the selection (Ctrl-Key),
-- for adding more braces and
-- inserting a single enclosure (Ctrl-Key).

local events = _G.events
local enclosure = _m.textadept.editing.enclosure
local string_char = _G.string.char
local m_editing = _m.textadept.editing

function enclose_selection(str)
  if buffer.get_sel_text() == '' then
    return false
  else
    m_editing.enclose(str)
  end
end

function paste_or_grow_enclose (str)
  if buffer:get_sel_text() == '' then
    buffer:add_text(enclosure[str].left)
    return
  else
    start = buffer.anchor
    stop = buffer.current_pos
    if start > stop then
      start, stop = stop, start
    end
    add_start = #m_editing.enclosure[str].left
    add_stop = #m_editing.enclosure[str].right
    m_editing.enclose(str)
    buffer:set_sel(start, stop+add_start+add_stop)
  end
end

local keys = _G.keys
keys["'"] = { enclose_selection, 'sng_quotes' }
keys['"'] = { enclose_selection, 'dbl_quotes' }
keys['('] = { enclose_selection, 'parens' }
keys['['] = { enclose_selection, 'brackets' }
keys['{'] = { enclose_selection, 'braces' }

keys["c'"] = { paste_or_grow_enclose, 'sng_quotes' }
keys['c"'] = { paste_or_grow_enclose, 'dbl_quotes' }
keys['c('] = { paste_or_grow_enclose, 'parens' }
keys['c['] = { paste_or_grow_enclose, 'brackets' }
keys['c{'] = { paste_or_grow_enclose, 'braces' }
