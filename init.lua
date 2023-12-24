local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)
local path    = minetest.get_modpath(MODNAME).."/"

-- Global
iadecor = {}

dofile(path .. "functional_calendar.lua")
dofile(path .. "church_wine.lua")
dofile(path .. "paintings.lua")
dofile(path .. "cross.lua")
dofile(path .. "bugs.lua")

print ("[MOD] IA Decor loaded")
