-- Some functions, key commands and modifications that change
-- [Textadept](http://code.google.com/p/textadept/)'s
-- default behaviour.
-- It contains modifications to Mitchell's Textadept modules, code from
-- Brian Schott and others who posted to the mailing list or the
-- [Textadept wiki](http://caladbolg.net/textadeptwiki/).
-- Otherwise it is written and maintained by
-- [Robert Gieseke](https://github.com/rgieseke).<br>
-- The source is on
-- [GitHub](https://github.com/rgieseke/ta-common),
-- released under the
-- [MIT license](http://www.opensource.org/licenses/mit-license.php).
--
-- ## Installation
-- Download a
-- [zipped](https://github.com/rgieseke/ta-common/zipball/master)
-- version and save the contained directory as `.textadept/modules/common`
-- or clone the git repository:
--     cd ~/.textadept/modules
--     git clone https://github.com/rgieseke/ta-common.git common
-- Put
--     require 'common'
-- in your `.textadept/init.lua`.<br>

local keys = keys

local M = {}

M.display_filename = require 'common.display_filename'
M.enclose = require 'common.enclose'
M.filename = require 'common.filename'
if not CURSES then require 'common.highlight' end
M.lastbuffer = require 'common.lastbuffer'
M.multiedit = require 'common.multiedit'
M.project = require 'common.project'
require 'common.save_strips_ws'

--
-- ## Key commands

-- Snapopen.<br>
-- (Filtering out some folders and file extensions)<br>
-- Textadept home: `Alt/⌘`+`Shift`+`U`<br>
-- User home : `Alt/⌘`+`U`<br>
-- Current project `Alt/⌘`+`P`<br>
keys[OSX and 'cmd+U' or 'alt+U'] = function()
  io.quick_open(
    _HOME,
    {
      '.+%.luadoc', '.hgtags', 'hg_archival.txt',
      folders = {'images', 'doc', 'manual', '%.hg'}
    })
  end
keys[OSX and 'cmd+u' or 'alt+u'] = function()
  io.quick_open(
    _USERHOME,
    { folders = { '%.hg', '%.git' } }
  )
  end

-- Insert a filename: `Ctrl`+`Alt/⌘`+`Shift`+`O`
keys[OSX and 'cmd+ctrl+O' or 'ctrl+alt+O'] = M.filename.insert_filename

-- Save and reset Lua state: `F9`
keys['f9'] = function()
  reset()
end

-- Switch to last buffer: `Ctrl`+`2`
keys["ctrl+2"] = M.lastbuffer.last_buffer

-- Enclose selection or insert chars: `'` , `"`, `(`, `[`, `{`
keys["'"] = function() M.enclose.enclose_selection("'", "'") end
keys['"'] = function() M.enclose.enclose_selection('"', '"') end
keys['('] = function() M.enclose.enclose_selection('(', ')') end
keys['['] = function() M.enclose.enclose_selection('[', ']') end
keys['{'] = function() M.enclose.enclose_selection('{', '}') end

-- Enclose selection and keep selection or insert single char
-- if nothing is selected: `Ctrl`+`Alt/⌘`+`'` or `"` or `(` or `[` or `{`
keys[OSX and "ctrl+cmd+'" or "ctrl+alt+'"] = function() M.enclose.paste_or_grow_enclose("'", "'") end
keys[OSX and 'ctrl+cmd+"' or 'ctrl+alt+"'] = function() M.enclose.paste_or_grow_enclose('"', '"') end
keys[OSX and 'ctrl+cmd+(' or 'ctrl+alt+('] = function() M.enclose.paste_or_grow_enclose('(', ')') end
keys[OSX and 'ctrl+cmd+[' or 'ctrl+alt+['] = function() M.enclose.paste_or_grow_enclose('[', ']') end
keys[OSX and 'ctrl+cmd+{' or 'ctrl+alt+{'] = function() M.enclose.paste_or_grow_enclose('{', '}') end
return M
