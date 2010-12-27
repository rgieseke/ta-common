module('_m.common.filename', package.seeall)

-- Inserts a filename with a relative path from a file select dialog.

function insert_filename()
  local current_dir = (buffer.filename or ''):match('.+[/\\]')
  if not current_dir then
    current_dir = _HOME
  end
  filename =
      gui.dialog('fileselect',
                 '--title', "Insert filename",
                 '--select-multiple',
                 '--with-directory', current_dir)
  if filename then
    filename = filename:gsub('\n', '')
    filename = filename:gsub(current_dir, '')
    buffer:add_text(filename)
  end
end

keys.caO = { insert_filename }

