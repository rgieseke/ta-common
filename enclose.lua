module('_m.common.enclose', package.seeall)

-- Enables
-- enclosing a selection by typing (,[,{,',",
-- enclosing a selection and keeping the selection (Ctrl-Key),
-- for adding more braces and
-- inserting a single enclosure (Ctrl-Key).

local events = _G.events
local string_char = _G.string.char
local m_editing = _m.textadept.editing

function enclose_selection(left, right)
  if buffer.get_sel_text() == '' then
    return false
  else
    m_editing.enclose(left, right)
  end
end

function paste_or_grow_enclose (left, right)
  if buffer:get_sel_text() == '' then
    buffer:add_text(left)
    return
  else
    start = buffer.anchor
    stop = buffer.current_pos
    if start > stop then
      start, stop = stop, start
    end
    add_start = #left
    add_stop = #right
    m_editing.enclose(left, right)
    buffer:set_sel(start, stop + add_start + add_stop)
  end
end

local keys = _G.keys
keys["'"] = { enclose_selection, "'", "'" }
keys['"'] = { enclose_selection, '"', '"' }
keys['('] = { enclose_selection, '(', ')' }
keys['['] = { enclose_selection, '[', ']' }
keys['{'] = { enclose_selection, '{', '}' }

keys["c'"] = { paste_or_grow_enclose, "'", "'" }
keys['c"'] = { paste_or_grow_enclose, '"', '"' }
keys['c('] = { paste_or_grow_enclose, '(', ')' }
keys['c['] = { paste_or_grow_enclose, '[', ']' }
keys['c{'] = { paste_or_grow_enclose, '{', '}' }
