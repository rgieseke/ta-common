-- For supported filetypes, displays a filtered list dialog with symbols
-- in the current document using
-- [Exuberant Ctags](http://ctags.sourceforge.net/).<br>
-- Note that it is possible to add support for additional filetypes, for
-- example for Latex:<br>
-- In `~/.ctags`:
--
--     --langdef=latex
--     --langmap=latex:.tex
--     --regex-latex=/\\label\{([^}]*)\}/\1/l,label/
--     --regex-latex=/\\section\{([^}]*)\}/\1/s,section/
--     --regex-latex=/\\subsection\{([^}]*)\}/\1/t,subsection/
--     --regex-latex=/\\subsubsection\{([^}]*)\}/\1/u,subsubsection/
--     --regex-latex=/\\section\*\{([^}]*)\}/\1/s,section/
--     --regex-latex=/\\subsection\*\{([^}]*)\}/\1/t,subsection/
--     --regex-latex=/\\subsubsection\*\{([^}]*)\}/\1/u,subsubsection/
--
-- Written by
-- [Mitchell](http://caladbolg.net/textadeptwiki/index.php?n=Main.Gotosymbol).
local M = {}

-- ## Fields

-- Path and options for the ctags utility can be defined in the `CTAGS`
-- field.
if WIN32 then
  M.CTAGS = '"c:\\program files\\ctags\\ctags.exe" --sort=yes --fields=+K-f'
else
  M.CTAGS = 'ctags --sort=yes --fields=+K-f'
end

-- ## Commands

-- Goes to the selected symbol in a filtered list dialog.
-- Requires [ctags]((http://ctags.sourceforge.net/)) to be installed.
function M.goto_symbol()
  local buffer = buffer
  if not buffer.filename then return end
  local symbols = {}
  local p = io.popen(M.CTAGS..' --excmd=number -f - "'..buffer.filename..'"')
  for line in p:read('*all'):gmatch('[^\r\n]+') do
    local name, line, ext = line:match('^(%S+)\t[^\t]+\t([^;]+);"\t(.+)$')
    if name and line and ext then
      symbols[#symbols + 1] = name
      symbols[#symbols + 1] = ext
      symbols[#symbols + 1] = line
    end
  end
  if #symbols > 0 then
    local response = gui.dialog('filteredlist',
                                '--title', 'Goto Symbol',
                                '--button1', 'gtk-ok',
                                '--button2', 'gtk-cancel',
                                '--string-output',
                                '--no-newline',
                                '--columns', 'Name', 'Type', 'Line',
                                '--output-column', '3',
                                '--items', symbols)
    local ok, line = response:match('(%S+)\n(%d+)$')
    if ok == 'gtk-ok' then
      buffer:goto_line(tonumber(line) - 1)
      buffer:vertical_centre_caret()
    end
  end
  p:close()
end

return M
