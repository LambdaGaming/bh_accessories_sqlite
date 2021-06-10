BH_ACC = BH_ACC or {}
BH_ACC.Version = "1.0.0"

local AddCSLuaFile = AddCSLuaFile
local include = include

include("bh_accessories/bh_acc_config.lua")
include("bh_accessories/sh_bh_acc.lua")
include("bh_accessories/bh_acc_items_config.lua")

local function AddMenus()
    local menus = file.Find("bh_accessories/menus/*.lua", "LUA")
    if SERVER then
        for i = 1, #menus do
            AddCSLuaFile("bh_accessories/menus/" .. menus[i])
        end
    else
        for i = 1, #menus do
            include("bh_accessories/menus/" .. menus[i])
        end
    end
end

if SERVER then
	AddCSLuaFile("autorun/bh_accessories_autorun.lua")

	AddCSLuaFile("bh_accessories/bh_acc_config.lua")
	AddCSLuaFile("bh_accessories/sh_bh_acc.lua")
	AddCSLuaFile("bh_accessories/bh_acc_items_config.lua")

    AddCSLuaFile("bh_accessories/cl_bh_acc_fonts.lua")
	AddCSLuaFile("bh_accessories/cl_bh_acc_draw.lua")
    AddCSLuaFile("bh_accessories/cl_bh_acc_net.lua")
    AddCSLuaFile("bh_accessories/cl_bh_acc_view.lua")
    AddCSLuaFile("bh_accessories/cl_bh_acc_ui.lua")

    AddMenus()

	include("bh_accessories/sv_bh_acc.lua")
	include("bh_accessories/sv_bh_acc_data.lua")
else
    include("bh_accessories/cl_bh_acc_fonts.lua")
	include("bh_accessories/cl_bh_acc_draw.lua")
    include("bh_accessories/cl_bh_acc_net.lua")
    include("bh_accessories/cl_bh_acc_view.lua")
    include("bh_accessories/cl_bh_acc_ui.lua")
    
    AddMenus()
end

BH_ACC.Loaded = true

if SERVER then
	resource.AddWorkshop("1909242903")
end