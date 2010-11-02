module('.common.keys', package.seeall)

-- Some additional key commands.

local keys = _G.keys

-- comments
keys['c-'] = { _m.textadept.editing.block_comment }
keys['c#'] = { _m.textadept.editing.block_comment }

-- snapopen
keys.ct.t = { _m.textadept.snapopen.open, { _HOME } }
keys.ct.u = { _m.textadept.snapopen.open, { _USERHOME } }
keys.cao = { function ()
  local buffer = buffer
  if buffer.filename then
    _m.textadept.snapopen.open({ buffer.filename:match('(.+)/') })
  end
end }

-- close message/error buffer view
keys.cw = { function()
  if buffer._type then
    buffer:close()
    gui.goto_view(-1, false)
    view:unsplit()
  else
    buffer:close()
  end
end }

-- save and reset
keys['f9'] = { function()
  buffer:save()
  reset()
end }

-- Duplicate current line
keys.ad = {
  function ()
    local buffer = buffer
    buffer:line_duplicate()
    buffer:line_down()
  end
}
