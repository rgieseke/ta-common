module('_m.common.luaonly', package.seeall)

-- Load Lua script and exit.
local function luaonly(file)
  if not file then
    print('No script file given.')
    os.exit()
  end
  -- Change argument positions for external script.
  for i = 0, #arg do arg[i - 2] = arg[i] end
  arg[#arg], arg[#arg - 1] = nil
  -- Remove some entries from global table.
  _G.gui, _G.new_buffer = nil
  f, err = loadfile(file)
  if err then
    print(err)
  else
    pcall(f)
  end
  os.exit()
end

args.register('-l', '--luaonly', 1,
  function()
    luaonly(arg[2])
  end,
  'Load lua script and exit')
