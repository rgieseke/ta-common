-- Copyright (c) 2010 Brian Schott (Sir Alaran)
-- see license.txt

module('_m.common.findall', package.seeall)


-- @return a table consisting of the start and end positions of the occurances
-- of the word at the cursor position
function findAllAtCursor()
	local retVal = {}
	local position = buffer.current_pos
	-- Grab the word at the current position
	buffer:word_left()
	buffer:word_right_end_extend()
	needle = buffer:get_sel_text()
	-- Trim any whitespace
	needle = needle:gsub('%s', '')
	-- Escape unwanted characters
	needle = needle:gsub('([().*+?^$%%[%]-])', '%%%1')
	-- Don't look for zero-length strings
	if #needle > 0 then
		for i = 0, buffer.line_count do
			local text = buffer:get_line(i)
			if #text>0 then
				local first, last = 0, 0
				while first do
					first, last = text:find("%f[%w]"..needle.."%f[%W]",last)
					if last then
						if (first ~= nil) and (first >0) then
							first = first - 1
						end
						table.insert(retVal, {buffer:position_from_line(i) + first, buffer:position_from_line(i) + last})
						last = last + 1
					end
				end
			end
		end
	end
	buffer:set_sel(position, position)
	return retVal
end
