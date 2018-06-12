--[[--

MIT License:

Copyright (c) 2018 Grayson Burton (ocornoc)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copuright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTIUCLAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]--[[--

The dpcy Lua library is a library containing functions for deep copying and
creating deep copying functions. This library assumes Lua 5.1.

The implemented functions in dpcy and their operations are:
	* dpcy.basic( [type] t )
	* returns [type]
	 : Performs a recursive deep copy of t's values while applying the
	 : original (uncopied) metatable of the original value to the copied
	 : value. Keys are not deep copied. If t is not a table, it will be
	 : returned unmodified.
	* dpcy.shallow( [type] t )
	* returns [type]
	 : Performs a non-recursive copy of t's values. It performs no
	 : metatable operations to the copy of t. If t is not a table, it will
	 : be returned unmodified.
	* dpcy.create( [table] t )
	* returns [function]
	 : Creates a deep copy function as per the specification defined in t.
	 : All entries in t are bools.
	 : Format of t: {
	 :  ["recursive"]         --The function acts recursively.
	 :  ["copymts"]           --Metatables are copied over to values.
	 :  ["inckeys"]           --Keys are included in the deep copy.
	 :  ["incmts"]            --Copied metatables are included in the deep
	 :                        --copy. ["copymnts"] must be true if this is
	 :                        --is supposed to have any effect.
	 : }

--]]--

local dpcy = {}
local internal = {
	[true] = {
		[true] = {
			[true] = {},
			
			[false] = {}
		},
		
		[false] = {}
	},
	
	[false] = {	
		[true] = {
			[true] = {},
			
			[false] = {}
		},
		
		[false] = {}
	}
}

function dpcy.create(t)
	assert(type(t) == "table", "You must provide a table for dpcy.create!")
	
	if t.recursive then
		if t.copymnts then
			if t.inckeys then
				if t.incmnts then
					return internals[true][true][true][true]
				else
					return internals[true][true][true][false]
				end
			else
				if t.incmnts then
					return internals[true][true][false][true]
				else
					return internals[true][true][false][false]
				end
			end
		else
			if t.inckeys then
				return internals[true][false][true]
			else
				return internals[true][false][false]
			end
		end
	else
		if t.copymnts then
			if t.inckeys then
				if t.incmnts then
					return internals[false][true][true][true]
				else
					return internals[false][true][true][false]
				end
			else
				if t.incmnts then
					return internals[false][true][false][true]
				else
					return internals[false][true][false][false]
				end
			end
		else
			if t.inckeys then
				return internals[false][false][true]
			else
				return internals[false][false][false]
			end
		end
	end
end

internal[true][true][true][true] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[internal[true][true][true][true](k)] = internal[true][true][true][true](v)
		end
		
		pcall(function() setmetatable(newt, internal[true][true][true][true](getmetatable(t))) end)
		
		return newt
	end
end

internal[true][true][true][false] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[internal[true][true][true][false](k)] = internal[true][true][true][false](v)
		end
		
		pcall(function() setmetatable(newt, getmetatable(t)) end)
		
		return newt
	end
end

internal[true][true][false][true] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[k] = internal[true][true][false][true](v)
		end
		
		pcall(function() setmetatable(newt, internal[true][true][false][true](getmetatable(t))) end)
		
		return newt
	end
end

internal[true][true][false][false] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[k] = internal[true][true][false][false](v)
		end
		
		pcall(function() setmetatable(newt, getmetatable(t)) end)
		
		return newt
	end
end

internal[true][false][true] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[internal[true][false][true](k)] = internal[true][false][true](v)
		end
		
		return newt
	end
end

internal[true][false][false] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[k] = internal[true][false][false](v)
		end
		
		return newt
	end
end

internal[false][true][true][true] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[internal[false][true][true][true](k)] = v
		end
		
		pcall(function() setmetatable(newt, internal[false][true][true][true](getmetatable(t))) end)
		
		return newt
	end
end

internal[false][true][true][false] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[internal[false][true][true][true](k)] = v
		end
		
		pcall(function() setmetatable(newt, getmetatable(t)) end)
		
		return newt
	end
end

internal[false][true][false][true] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[k] = v
		end
		
		pcall(function() setmetatable(newt, internal[false][true][false][true](getmetatable(t))) end)
		
		return newt
	end
end

internal[false][true][false][false] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[k] = v
		end
		
		pcall(function() setmetatable(newt, getmetatable(t)) end)
		
		return newt
	end
end

internal[false][false][true] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[internal[false][false][true](k)] = v
		end
		
		return newt
	end
end

internal[false][false][false] = function(t)
	if type(t) ~= "table" then
		return t
	else
		local newt = {}

		for k,v in pairs(t) do
			newt[k] = v
		end
		
		return newt
	end
end

dpcy.basic = internal[true][true][false][false]
dpcy.shallow = internal[false][false][false]

return dpcy
