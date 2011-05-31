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
-- The submodules can also be used independently:
--     require 'common.ack'

module('_m.common', package.seeall)

require 'common.ack'
require 'common.bracematching'
require 'common.comments'
require 'common.ctags'
require 'common.display_filename'
require 'common.enclose'
require 'common.filename'
require 'common.findall'
require 'common.lastbuffer'
require 'common.luaonly'
require 'common.multiedit'
require 'common.project'
require 'common.save_strips_ws'
require 'common.theming'
require 'common.vc'

-- ## Key commands
local keys = _G.keys

-- Comment a line: `Ctrl`+`#`
keys['c#'] = { _m.textadept.editing.block_comment }

keys.ct = {}
-- Snapopen.<br>
-- Textadept home: `Ctrl`+`T`, `T` <br>
-- User home: `Ctrl`+`T`, `U` <br>
-- Current project `Ctrl`+`Alt`+`O`:
keys.ct.t = { _m.textadept.snapopen.open, { _HOME }, { '.+%.luadoc',
              folders = { 'images', 'doc', 'manual', '%.hg', '%.git' } } }
keys.ct.u = { _m.textadept.snapopen.open, { _USERHOME },
              { folders = { '%.hg', '%.git' } } }
keys.cao = { function ()
  local root = _m.common.project.root()
  _m.textadept.snapopen.open({ root }, { 'pyc$', folders = { '%.hg', '%.git'} })
end }

-- Close view with message/error buffer and unsplit: `Ctrl`+`W`
keys.cw = { function()
  if buffer._type then
    buffer:close()
    gui.goto_view(-1, false)
    view:unsplit()
  else
    buffer:close()
  end
end }

-- Save and reset Lua state: `F9`
keys['f9'] = { function()
  buffer:save()
  reset()
end }

-- Duplicate current line: `Alt/⌘`+`D`
keys.ad = {
  function ()
    local buffer = buffer
    buffer:line_duplicate()
    buffer:line_down()
  end
}

-- Open command entry for ack/Lua search: `Ctrl`+`Alt/⌘`+`F`<br>
-- In the command entry, switch to Lua find in files, `Alt/⌘`+`L`,
-- or  ack search, `Alt/⌘`+`A`.
keys.caf = _m.common.ack.search_entry

-- Go to the matching brace: `Ctrl`+`E`
keys.ce = _m.common.bracematching.match_brace

-- Open filtered list with symbols using ctags: `Alt/⌘`+`G`
keys.ag = _m.common.ctags.goto_symbol

-- Add another cursor position: `Ctrl`+`J`<br>
-- Select all occurrences of a word: `Ctrl`+`Alt/⌘`+`j`
keys.cj = _m.common.multiedit.add_position
keys.caj = _m.common.multiedit.select_all

-- Switch to last buffer: `Ctrl`+`Alt/⌘`+`B`
keys.cab = _m.common.lastbuffer.last_buffer

-- Switch buffer dialog:<br>
-- `Ctrl`+`B` or `⌘`+`B` (OS X)<br>
-- See [display_filename.lua](display_filename.html).
if OSX then
  keys.ab = _m.common.display_filename.switch_buffer
else
  keys.cb = _m.common.display_filename.switch_buffer
end

-- Show hg status in snapopen dialog: `Ctrl`+`Alt/⌘`+`P`
keys.cap = { function()
  if buffer.filename then _m.common.vc.hg_status( ) end
end}

-- Enclose selection or insert chars: `'` , `"`, `(`, `[`, `{`
keys["'"] = { _m.common.enclose.enclose_selection, "'", "'" }
keys['"'] = { _m.common.enclose.enclose_selection, '"', '"' }
keys['('] = { _m.common.enclose.enclose_selection, '(', ')' }
keys['['] = { _m.common.enclose.enclose_selection, '[', ']' }
keys['{'] = { _m.common.enclose.enclose_selection, '{', '}' }

-- Enclose selection and keep selection or insert single char
-- if nothing is selected: `Ctrl`+`'` or `"` or `(` or `[` or `{`
keys["c'"] = { _m.common.enclose.paste_or_grow_enclose, "'", "'" }
keys['c"'] = { _m.common.enclose.paste_or_grow_enclose, '"', '"' }
keys['c('] = { _m.common.enclose.paste_or_grow_enclose, '(', ')' }
keys['c['] = { _m.common.enclose.paste_or_grow_enclose, '[', ']' }
keys['c{'] = { _m.common.enclose.paste_or_grow_enclose, '{', '}' }
