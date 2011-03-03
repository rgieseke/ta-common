module('_m.common.bracematching', package.seeall)
-- Modified from Textadept's editing.lua

-- Disable default highlighting of matching braces
_m.textadept.editing.HIGHLIGHT_BRACES = false

braces = { -- () [] {}
  [40] = 1, [91] = 1, [123] = 1,
  [41] = 1, [93] = 1, [125] = 1,
}

-- highlights matching braces, before and after a brace
events.connect('update_ui', function()
  local buffer = buffer
  local pos = buffer.current_pos
  if braces[buffer.char_at[pos - 1]] then pos = pos - 1 end
  if braces[buffer.char_at[pos]] then
    local match_pos = buffer:brace_match(pos)
    if match_pos ~= -1 then
      buffer:brace_highlight(pos, match_pos)
    else
      buffer:brace_bad_light(pos)
    end
  else
    buffer:brace_bad_light(-1)
  end
end)

---
-- Goes to a matching brace position, selecting the text inside if specified.
-- @param select If true, selects the text between matching braces.
function match_brace(select)
  local buffer = buffer
  local caret = buffer.current_pos
  if braces[buffer.char_at[caret - 1]] then
    caret = caret - 1
  end
  local match_pos = buffer:brace_match(caret)
  if match_pos ~= -1 then
    if select then
      if match_pos > caret then
        buffer:set_sel(caret, match_pos + 1)
      else
        buffer:set_sel(caret + 1, match_pos)
      end
    else
      buffer:goto_pos(match_pos)
    end
  end
end

keys.ce = { _m.common.bracematching.match_brace }
