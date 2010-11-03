-- Modified from Textadept's editing.lua to keep the caret position
-- when saving.  

_m.textadept.editing.SAVE_STRIPS_WS = false

-- Prepares the buffer for saving to a file.
-- Strips trailing whitespace off of every line,
-- except the current line,
-- ensures an ending newline, and
-- converts non-consistent EOLs.
local function prepare_for_save()
  local buffer = buffer
  buffer:begin_undo_action()
  local current_line = buffer:line_from_position(buffer.current_pos)
  -- Strip trailing whitespace.
  local lines = buffer.line_count
  for line = 0, lines - 1 do
    if line ~= current_line then
      local s = buffer:position_from_line(line)
      local e = buffer.line_end_position[line]
      local i = e - 1
      local c = buffer.char_at[i]
      while i >= s and c == 9 or c == 32 do
        i = i - 1
        c = buffer.char_at[i]
      end
      if i < e - 1 then
        buffer.target_start, buffer.target_end = i + 1, e
        buffer:replace_target('')
      end
    end
  end
  -- Ensure ending newline.
  local e = buffer:position_from_line(lines)
  if lines == 1 or
    lines > 1 and e > buffer:position_from_line(lines - 1) then
    buffer:insert_text(e, '\n')
  end
  -- Convert non-consistent EOLs
  buffer:convert_eo_ls(buffer.eol_mode)
  buffer:end_undo_action()
end
events.connect('file_before_save', prepare_for_save)

