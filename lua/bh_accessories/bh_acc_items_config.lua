if (BH_ACC.AddedModelOffsets and #BH_ACC.AddedModelOffsets > 0) or (BH_ACC.EditedAccessories and #BH_ACC.EditedAccessories > 0) then
	
	if not BH_ACC.Showed_ErrorPrint then
		BH_ACC.Showed_ErrorPrint = true
		MsgC( BH_ACC.ChatTagColors["ok"], BH_ACC.ChatTag, color_white, " " .. BH_ACC.Language["Refreshed_Items"] .. "\n")
	end
	
	return
end

local Vector, Angle = Vector, Angle

local ui_CamPos, ui_LookAng, ui_FOV

local HEAD_B = "ValveBiped.Bip01_Head1"
local SPINE_B2 = "ValveBiped.Bip01_Spine2"
local FOOT_B = "ValveBiped.Bip01_R_Foot"

local colors = BH_ACC.Colors
local materials = BH_ACC.Materials

local New = BH_ACC.New
local Copy = BH_ACC.Copy
local CreateMiniCategory = BH_ACC.CreateMiniCategory
local CreateCategory = BH_ACC.CreateCategory

-- We need this for auto refresh --
    hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/bh_acc_items_config", function(filename)
        if filename == "bh_acc_config" then
            colors = BH_ACC.Colors
            materials = BH_ACC.Materials
        elseif filename == "cl_bh_acc_ui" then
            CreateMiniCategory = BH_ACC.CreateMiniCategory
            CreateCategory = BH_ACC.CreateCategory
        elseif filename == "sh_bh_acc" then
            New = BH_ACC.New
            Copy = BH_ACC.Copy
        end
    end)

    -- We're cleaning all of the categories and items and also clearing the amounts --
	BH_ACC.ResetAmounts()
	local function cleantable(tab)
		for i = 1, #tab do
            tab[i] = nil
        end
	end
	cleantable(BH_ACC.Categories)
	table.Empty(BH_ACC.Category_IDS)
	cleantable(BH_ACC.Items)
	table.Empty(BH_ACC.Item_IDS)
	cleantable(BH_ACC.MiniCategories)
	table.Empty(BH_ACC.MiniCategory_IDS)
--

-- What addons do you want added? --
-- Check out the list for all supported addons here --
-- https://pastebin.com/jHFm9zLT --

-- All you need to do is grab the workshop addon ID and store it in the BH_ACC.Addons table like the example below --

BH_ACC.Addons = {
	-- Example :
--  ["ID GOES HERE"] = true,

	-- Are you lazy? Here's every addon added just remove the "--[[" infront and the "]]" at the end --
        ["150404359"] = true,
		["827404607"] = true,
		["351194925"] = true,
		["283483231"] = true,
		["166177187"] = true,
		["282958377"] = true,
		["551144079"] = true,
		["826536617"] = true,
		["939706836"] = true,
		["383109137"] = true,
		["282916144"] = true,
		["184937635"] = true,
		["283911615"] = true,
		["283912012"] = true,
		["283483564"] = true,
		["283399070"] = true,
		["749833732"] = true,
		["188866519"] = true,
		["174704263"] = true,
		["174739352"] = true,
		["174745011"] = true,
		["173676413"] = true,
		["943349673"] = true,
		["176185029"] = true,
		["122461372"] = true,
		["107165776"] = true,
		["357350543"] = true,
		["783530452"] = true,
		["572310302"] = true,
		["148215278"] = true,
		["354739227"] = true,
		["158532239"] = true,
		["109312509"] = true,
		["438680332"] = true,
		["192625869"] = true,
		["759456969"] = true,
		["783516789"] = true,
		["1273845833"] = true,
		["938751644"] = true,
		["301607701"] = true,
		["358462651"] = true,
		["894768926"] = true,
		["734200566"] = true,
		["705986207"] = true,
		["327527107"] = true,
		["129736354"] = true,
		["2174343063"] = true
}



-- HERE YOU CAN CREATE YOUR MAIN CATEGORIES --
-- NOTE: Do not create more than 8 categories! in terms of functionality the code will work it just doesn't fit the UI at all --

CreateCategory({
    name = "Body",
    icon = materials.body,
    color = colors.body_icon,
	vector = Vector(-55, -15, -20),
	angle = Angle(-10, 180, 0)
})

CreateCategory({
    name = "Face",
    icon = materials.face,
    color = colors.face_icon,
	vector = Vector(-18, -5, 0),
	angle = Angle(-10, 180, 0)
})

CreateCategory({
    name = "Back",
    icon = materials.backpack,
    color = colors.backpack_icon,
	vector = Vector(-40, -5, -10),
	angle = Angle(0, 0, 0)
})

CreateCategory({
    name = "Accessories",
    icon = materials.hat,
    color = colors.hat_icon,
	vector = Vector(-25, -2, 0),
	angle = Angle(-10, 180, 0)
})

--[[CreateCategory({
    name = "Feet",
    icon = materials.sneakers,
    color = colors.sneaker_icon,
	vector = Vector(0, -2, -50),
	angle = Angle(-35, 160, 0)
})]]


-- HERE YOU CAN CREATE YOUR SUB-CATEGORIES --

CreateMiniCategory({
    category = "Face",
    name = "Glasses",
    icon = materials.glasses,
	color = colors.glasses_icon,
	vector = Vector(-18, -1, 0),
	angle = Angle(-5, 180, 0)
})

CreateMiniCategory({
    category = "Face",
    name = "Masks",
    icon = materials.mask,
	color = colors.mask_icon,
	vector = Vector(-18, -1, 0),
	angle = Angle(-5, 180, 0)
})

CreateMiniCategory({
    category = "Accessories",
    name = "Helmets",
    icon = materials.helmet,
    color = colors.helmet_icon,
	vector = Vector(-25, -2, 0),
	angle = Angle(-10, 180, 0)
})

CreateMiniCategory({
    category = "Accessories",
    name = "Neck",
    icon = materials.shawl,
    color = colors.neck_icon,
	vector = Vector(-15, -2, -5),
	angle = Angle(-10, 180, 0)
})

-- Let's make the categories names here into a variable to save some space
local body = "Body"
local face = "Face"
local back = "Back"
local accessories = "Accessories"
local Feet = "Feet"

-- HERE YOU CAN EDIT THE ITEMS OR ADD MORE --



-- Hidden Gmod Accessories --
New(body, "Skeleton", {price = 450, IsPlayerModel = true, model = "models/player/skeleton.mdl", description = "Spooky scary skeleton", ui_CamPos = Vector(59.69, 20.9, 61.2), ui_LookAng = Angle(-1.7, -160.1, 0), ui_FOV = 17})
New(accessories, "Graduation Cap", {price = 250, model = "models/player/items/humans/graduation_cap.mdl", bone = HEAD_B, offsetV = Vector(-1.33, 1.77, 0), offsetA = Angle(180, 100, 90), ui_CamPos = Vector(-67.43, 51.43, 12.23), ui_LookAng = Angle(4.13, -37.15, 0), ui_FOV = 12 } )
New(accessories, "Top Hat [Blue]", {price = 250, model = "models/player/items/humans/top_hat.mdl", bone = HEAD_B, offsetV = Vector(-0.5, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = Vector(76.93, 24.17, 25.49), ui_LookAng = Angle(12.53, -162.64, 0), ui_FOV = 10  } )
New(back, "Donut", {price = 1000, model = "models/noesis/donut.mdl", bone = SPINE_B2, offsetV = Vector(0, 8, 0), offsetA = Angle(180, 180, 90), ui_CamPos = Vector(67.77, -29.37, 45.22), ui_LookAng = Angle(31.65, -203.61, 0), ui_FOV = 16 })
-----------------------------



-- GMT Playermodels --
if BH_ACC.Addons["150404359"] then
	ui_CamPos = Vector(59.69, 20.9, 61.2)
	ui_FOV = 17
	ui_LookAng = Angle(-1.7, -160.1, 0)
	
	New(body, "Anon", {price = 1000, IsPlayerModel = true, model = "models/player/anon/anon.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV, ui_FOV = ui_FOV})
	New(body, "Leon", {price = 750, IsPlayerModel = true, model = "models/player/leon.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Whaler", {price = 1000, IsPlayerModel = true, model = "models/player/dishonored_assassin1.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Dude", {price = 1000, IsPlayerModel = true, model = "models/player/dude.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Samus", {price = 450, IsPlayerModel = true, model = "models/player/samusz.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Jack Sparrow", {price = 750, IsPlayerModel = true, model = "models/player/jack_sparrow.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Joker", {price = 750, IsPlayerModel = true, model = "models/player/joker.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Normal", {price = 750, IsPlayerModel = true, model = "models/player/normal.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Hunter", {price = 750, IsPlayerModel = true, model = "models/player/hunter.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Scorpion", {price = 750, IsPlayerModel = true, model = "models/player/scorpion.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Robber", {price = 1000, IsPlayerModel = true, model = "models/player/robber.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Roman Bellic", {price = 1000, IsPlayerModel = true, model = "models/player/romanbellic.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Rorschach", {price = 1000, IsPlayerModel = true, model = "models/player/rorschach.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Sam", {price = 1000, IsPlayerModel = true, model = "models/player/sam.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "ScareCrow", {price = 1000, IsPlayerModel = true, model = "models/player/scarecrow.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Shaun", {price = 1000, IsPlayerModel = true, model = "models/player/shaun.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Smith", {price = 1000, IsPlayerModel = true, model = "models/player/smith.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Sub Zero", {price = 1000, IsPlayerModel = true, model = "models/player/subzero.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Tesla Power", {price = 1000, IsPlayerModel = true, model = "models/player/teslapower.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Zoey", {price = 1000, IsPlayerModel = true, model = "models/player/zoey.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Spy", {price = 1000, IsPlayerModel = true, model = "models/player/drpyspy/spy.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Spartan", {price = 1000, IsPlayerModel = true, model = "models/player/lordvipes/haloce/spartan_classic.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Jack Player", {price = 1000, IsPlayerModel = true, model = "models/vinrax/player/jack_player.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Carley", {price = 1000, IsPlayerModel = true, model = "models/nikout/carleypm.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "DeathStroke", {price = 1000, IsPlayerModel = true, model = "models/norpo/arkhamorigins/assassins/deathstroke_valvebiped.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Big Boss", {price = 1000, IsPlayerModel = true, model = "models/player/big_boss.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Chewbacca", {price = 1000, IsPlayerModel = true, model = "models/player/chewbacca.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Faith", {price = 1000, IsPlayerModel = true, model = "models/player/faith.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Chris", {price = 1000, IsPlayerModel = true, model = "models/player/chris.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Freddy Kruger", {price = 1000, IsPlayerModel = true, model = "models/player/freddykruger.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Gordon", {price = 1000, IsPlayerModel = true, model = "models/player/gordon.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Green Arrow", {price = 1000, IsPlayerModel = true, model = "models/player/greenarrow.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Mass Effect", {price = 1000, IsPlayerModel = true, model = "models/player/masseffect.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-5, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Sunabouzu", {price = 1000, IsPlayerModel = true, model = "models/player/sunabouzu.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Crimson Lance", {price = 1000, IsPlayerModel = true, model = "models/player/lordvipes/bl_clance/crimsonlanceplayer.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	-- broken New(body, "Gray Fox", {price = 1000, IsPlayerModel = true, model = "models/player/lordvipes/metal_gear_rising/gray_fox_playermodel_cvp.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Isaac", {price = 1000, IsPlayerModel = true, model = "models/player/security_suit.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-5, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Midna", {price = 1000, IsPlayerModel = true, model = "models/player/midna.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-15, -160.1, 0), ui_FOV = 30})
	New(body, "Space suit", {price = 1000, IsPlayerModel = true, model = "models/player/spacesuit.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Altair", {price = 1000, IsPlayerModel = true, model = "models/player/altair.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Dinosaur", {price = 1000, IsPlayerModel = true, model = "models/player/foohysaurusrex.mdl", ui_CamPos = Vector(59.69, 20.9, 70.2), ui_LookAng = Angle(-1, -160.1, 0), ui_FOV = 22})
	New(body, "Aphaztech", {price = 1000, IsPlayerModel = true, model = "models/player/aphaztech.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Robot", {price = 1000, IsPlayerModel = true, model = "models/player/robot.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-5, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Zelda", {price = 1000, IsPlayerModel = true, model = "models/player/zelda.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Gmen", {price = 1000, IsPlayerModel = true, model = "models/player/gmen.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-9, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Steve", {price = 1000, IsPlayerModel = true, model = "models/player/mcsteve.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-10, -160.1, 0), ui_FOV = 40})
	New(body, "Clopsy", {price = 1000, IsPlayerModel = true, model = "models/player/clopsy.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Boxman", {price = 1000, IsPlayerModel = true, model = "models/player/nuggets.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-8, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Macdguy", {price = 1000, IsPlayerModel = true, model = "models/player/macdguy.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Rayman", {price = 1000, IsPlayerModel = true, model = "models/player/rayman.mdl", ui_CamPos =  Vector(48, 22, 79), ui_LookAng = Angle(11, -155, 0), ui_FOV = 30})
	New(body, "Raz", {price = 1000, IsPlayerModel = true, model = "models/player/raz.mdl", ui_CamPos = Vector(67, 15, 84), ui_LookAng = Angle(4, -166, 0), ui_FOV = 45})
	New(body, "Haroldlott", {price = 1000, IsPlayerModel = true, model = "models/player/haroldlott.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Harry Potter", {price = 1000, IsPlayerModel = true, model = "models/player/harry_potter.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Jawa", {price = 1000, IsPlayerModel = true, model = "models/player/jawa.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Martymcfly", {price = 1000, IsPlayerModel = true, model = "models/player/martymcfly.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Luigi", {price = 1000, IsPlayerModel = true, model = "models/player/suluigi_galaxy.mdl", ui_CamPos = Vector(70, 22, 79), ui_LookAng = Angle(0, -160.1, 0), ui_FOV = 40})
	New(body, "Stormtrooper", {price = 1000, IsPlayerModel = true, model = "models/player/stormtrooper.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Mario", {price = 1000, IsPlayerModel = true, model = "models/player/sumario_galaxy.mdl", ui_CamPos = Vector(70, 22, 79), ui_LookAng = Angle(5, -160.1, 0), ui_FOV = 45})
	New(body, "Zero", {price = 1000, IsPlayerModel = true, model = "models/player/lordvipes/MMZ/Zero/zero_playermodel_cvp.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Yoshi", {price = 1000, IsPlayerModel = true, model = "models/player/yoshi.mdl", ui_CamPos = Vector(60, 24, 90), ui_LookAng = Angle(13, -153, 0), ui_FOV = 60})
	New(body, "Walter White", {price = 1000, IsPlayerModel = true, model = "models/Agent_47/agent_47.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-3, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Alice", {price = 1000, IsPlayerModel = true, model = "models/player/alice.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-3, -160.1, 0), ui_FOV = ui_FOV})
	New(body, "Red", {price = 1000, IsPlayerModel = true, model = "models/player/red.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Megaman", {price = 1000, IsPlayerModel = true, model = "models/vinrax/player/megaman64_no_gun_player.mdl", ui_CamPos = ui_CamPos, ui_LookAng = Angle(-3, -160.1, 0), ui_FOV = 22})
	New(body, "Ironman", {price = 1000, IsPlayerModel = true, model = "models/Avengers/Iron Man/mark7_player.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Doomguy", {price = 1000, IsPlayerModel = true, model = "models/ex-mo/quake3/players/doom.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(body, "Link", {price = 1000, IsPlayerModel = true, model = "models/player/linktp.mdl", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
end
-----------------------------

-- Wrench Mask --
if BH_ACC.Addons["827404607"] then
	New(face, "Wrench Mask", {price = 750, model = "models/models/wrenchmask.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(-2, 5.28, 0), offsetA = Angle(180, 100, 90), scale = 0.41, ui_CamPos = Vector(74.29, 34.63, 14.96), ui_LookAng = Angle(-355.02, -515.68, 0), ui_FOV = 17.12 } )
end
-----------------



-- Alienware Mask --
if BH_ACC.Addons["283483231"] then
	New(face, "[PD] Alien", {price = 750, model = "models/snowzgmod/payday2/masks/maskalienware.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), ui_CamPos = Vector(75.65, 39.68, 5.54), ui_LookAng = Angle(3.68, -153, 0), ui_FOV = 11.72 } )
end
--------------------



-- Horse Mask Prop --
if BH_ACC.Addons["166177187"] then
	New(face, "Horse Mask", {price = 500, model = "models/horsie/horsiemask.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(3.52, 3.37, 0), offsetA = Angle(-90, 0, -26.9), ui_CamPos = Vector(60.87, -61.25, 7.2), ui_LookAng = Angle(5.03, -225.49, 0), ui_FOV = 16.27 } )
end
---------------------



-- Freddy mask --
if BH_ACC.Addons["383109137"] then
	New(face, "Freddy Mask", {price = 1000, model = "models/errolliamp/five_nights_at_freddys/freddy_mask.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(-3.15, 1.5, 0), offsetA = Angle(180, 90, 90), ui_CamPos = Vector(72.49, 38.58, 16.94), ui_LookAng = Angle(6.88, -152.02, 0), ui_FOV = 15.36 } )
end
-----------------



-- 6 Other Clown Masks --
if BH_ACC.Addons["282916144"] then
	ui_CamPos = Vector(70.03, 49.34, 9.69)
	ui_FOV = 13.06
	ui_LookAng = Angle(6.86, -145.54, 0)
	
	New(face, "[PD] Big Lips", {price = 750, model = "models/snowzgmod/payday2/masks/maskbiglips.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Black Heart", {price = 750, model = "models/snowzgmod/payday2/masks/maskblackhearted.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Cry Baby", {price = 750, model = "models/snowzgmod/payday2/masks/maskcrybaby.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Dripper", {price = 750, model = "models/snowzgmod/payday2/masks/maskthedripper.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Rage", {price = 750, model = "models/snowzgmod/payday2/masks/masktherage.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Starved", {price = 750, model = "models/snowzgmod/payday2/masks/maskthestarved.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end

-------------------------



-- Payday 2 Masks --
if BH_ACC.Addons["282958377"] then
	ui_CamPos = Vector(70.03, 49.34, 9.69)
	ui_FOV = 13.06
	ui_LookAng = Angle(6.86, -145.54, 0)
	
	New(face, "[PD] Arnold", {price = 750, model = "models/snowzgmod/payday2/masks/maskarnold.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Rhino", {price = 750, model = "models/snowzgmod/payday2/masks/maskbabyrhino.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Chuck", {price = 750, model = "models/snowzgmod/payday2/masks/maskdolph.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Dolph", {price = 750, model = "models/snowzgmod/payday2/masks/maskbiglips.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Jean-Claude", {price = 750, model = "models/snowzgmod/payday2/masks/maskjeanclaude.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Mark", {price = 750, model = "models/snowzgmod/payday2/masks/maskmark.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Monkey", {price = 750, model = "models/snowzgmod/payday2/masks/maskmonkeybusiness.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Hog", {price = 750, model = "models/snowzgmod/payday2/masks/maskthehog.mdl", bone = HEAD_B, offsetV = Vector(2, 4, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-----------------

if BH_ACC.Addons["148215278"] then
	ui_CamPos = Vector(82.14, 26.93, 5.27)
	ui_FOV = 5.98
	ui_LookAng = Angle(3.23, 198.07, 0)	

	New(face, "Shades", {price = 750, model = "models/captainbigbutt/skeyler/accessories/glasses01.mdl", bone = HEAD_B, offsetV = Vector(2, 2, 0), offsetA = Angle(180, 105, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(81.4, 27, 10.5)
	ui_FOV = 6
	ui_LookAng = Angle(6.5, -161.6, 0)

	New(face, "Shades [Gradient]", {price = 750, model = "models/captainbigbutt/skeyler/accessories/glasses02.mdl", bone = HEAD_B, offsetV = Vector(1.2, 2.4, 0), offsetA = Angle(180, 100, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(face, "Shades [Shutter]", {price = 750, model = "models/captainbigbutt/skeyler/accessories/glasses03.mdl", bone = HEAD_B, offsetV = Vector(1.5, 3, 0), offsetA = Angle(180, 110, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(face, "Shades [OverSize]", {price = 750, model = "models/captainbigbutt/skeyler/accessories/glasses04.mdl", bone = HEAD_B, offsetV = Vector(1.3, 3, 0), offsetA = Angle(180, 110, 90), mini_category = "Glasses", scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	New(face, "Aviators", {price = 750, model = "models/gmod_tower/aviators.mdl", bone = HEAD_B, offsetV = Vector(1.7, 2, 0), offsetA = Angle(180, 100, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(face, "3D Glasses", {price = 45, model = "models/gmod_tower/3dglasses.mdl", bone = HEAD_B, offsetV = Vector(2.5, 2.4, 0), offsetA = Angle(180, 90, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(face, "Kliener Glasses", {price = 45, model = "models/gmod_tower/klienerglasses.mdl", bone = HEAD_B, offsetV = Vector(2.5, 2.3, 0), offsetA = Angle(180, 90, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(81.7, 29.4, 7.1)
	ui_FOV = 6
	ui_LookAng = Angle(4.6, -159.5, 0)

	New(face, "Snow Glasses", {price = 45, model = "models/gmod_tower/snowboardgoggles.mdl", bone = HEAD_B, offsetV = Vector(2.5, 0, 0), offsetA = Angle(180, 90, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(-73.6, 38, -25)
	ui_FOV = 6
	ui_LookAng = Angle(-16.6, -27.3, 0)	

	New(face, "Star Glasses", {price = 45, model = "models/gmod_tower/starglasses.mdl", bone = HEAD_B, offsetV = Vector(2.5, 2.33, 0), offsetA = Angle(180, 90, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(-84.7, 16.7, 3.6)
	ui_FOV = 4
	ui_LookAng = Angle(1, -11.2, 0)	

	New(face, "Monocle", {price = 750, model = "models/captainbigbutt/skeyler/accessories/monocle.mdl", bone = HEAD_B, offsetV = Vector(2.7, 2.4, -1.5), offsetA = Angle(0, -60, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(75.34, 39.79, 13.02)
	ui_FOV = 3.19
	ui_LookAng = Angle(8.66, 207.65, 0)	

	New(face, "Mustache", {price = 750, model = "models/captainbigbutt/skeyler/accessories/mustache.mdl", bone = HEAD_B, offsetV = Vector(0, 5.35, 0), offsetA = Angle(180, 110, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(78.49, 33.63, -0.26)
	ui_FOV = 11.58
	ui_LookAng = Angle(-0.83, -156.74, 0)	

	New(face, "Batman Mask", {price = 750, model = "models/gmod_tower/batmanmask.mdl", bone = HEAD_B, offsetV = Vector(1.8, 1.5, 0), mini_category = "Masks", offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(76.17, 32.4, 9.22)
	ui_FOV = 16.22
	ui_LookAng = Angle(6.35, -156.96, 0)	

	New(face, "Adross Mask", {price = 750, model = "models/gmod_tower/androssmask.mdl", bone = HEAD_B, offsetV = Vector(0, 1.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	New(face, "BomberMan", {price = 750, model = "models/gmod_tower/bombermanhelmet.mdl", bone = HEAD_B, offsetV = Vector(1, 1.5, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(78.36, 30.58, 9.14)
	ui_FOV = 12.41
	ui_LookAng = Angle(2.33, -158.01, 0)	

	New(face, "Jason Mask", {price = 750, model = "models/gmod_tower/halloween_jasonmask.mdl", bone = HEAD_B, offsetV = Vector(-4.7, 0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(76.22, 39.79, 7.81)
	ui_FOV = 14.38
	ui_LookAng = Angle(5.03, -152.35, 0)	
	
	New(face, "Lego Head", {price = 750, model = "models/gmod_tower/legohead.mdl", bone = HEAD_B, offsetV = Vector(2, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(76.54, 28.64, 14.77)
	ui_FOV = 17.17
	ui_LookAng = Angle(4.81, -159.28, 0)	

	New(face, "Happy Pumpkin", {price = 45, model = "models/gmod_tower/halloween_pumpkinhat.mdl", bone = HEAD_B, offsetV = Vector(-5, 2, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(59.26, 55.06, 6.08)
	ui_FOV = 14.47
	ui_LookAng = Angle(1.68, -136.54, 0)	

	New(face, "Pumpkin", {price = 45, model = "models/captainbigbutt/skeyler/hats/pumpkin.mdl", bone = HEAD_B, offsetV = Vector(0, 1, 0), offsetA = Angle(180, 100, 90), scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(71.88, 42.51, 16.39)
	ui_FOV = 23.75
	ui_LookAng = Angle(8.64, -150.05, 0)	

	New(face, "DeadMau", {price = 45, model = "models/captainbigbutt/skeyler/hats/deadmau5.mdl", bone = HEAD_B, offsetV = Vector(1.5, 1.5, 0), offsetA = Angle(180, 100, 90), scale = 0.7, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(77.37, 27.14, -2.47)
	ui_FOV = 16.12
	ui_LookAng = Angle(-1.78, -159.94, 0)	

	New(face, "Majora Mask", {price = 45, model = "models/gmod_tower/majorasmask.mdl", bone = HEAD_B, offsetV = Vector(1.5, 0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(74.98, 34.08, 8.07)
	ui_FOV = 10.52
	ui_LookAng = Angle(0.08, -155.52, 0)	
	
	New(face, "Majora Mask 2", {price = 45, model = "models/lordvipes/majoramask/majoramask.mdl", bone = HEAD_B, offsetV = Vector(-5.5, 6.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(81.59, 28.98, 1.68)
	ui_FOV = 11.14
	ui_LookAng = Angle(1.08, -160.78, 0)	
	
	New(face, "No Face", {price = 45, model = "models/gmod_tower/noface.mdl", bone = HEAD_B, offsetV = Vector(1.8, 5.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(82.54, 25.96, -0.46)
	ui_FOV = 12.41
	ui_LookAng = Angle(0.2, -162.44, 0)

	New(face, "Samus Helmet", {price = 45, model = "models/gmod_tower/samushelmet.mdl", bone = HEAD_B, offsetV = Vector(2, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(77.25, 38.34, 8.32)
	ui_FOV = 11.72
	ui_LookAng = Angle(4.72, -152.85, 0)	

	New(face, "Toro Mask", {price = 45, model = "models/gmod_tower/toromask.mdl", bone = HEAD_B, offsetV = Vector(1.8, -0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(78.09, 38.1, 2.67)
	ui_FOV = 11.14
	ui_LookAng = Angle(2.05, -153.52, 0)

	New(face, "Thomas", {price = 45, model = "models/lordvipes/daftpunk/thomas.mdl", bone = HEAD_B, offsetV = Vector(3, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(-68.12, 36.28, 5.12)
	ui_FOV = 18.13
	ui_LookAng = Angle(2.86, -26.34, 0)	
	
	New(face, "Keaton Mask", {price = 45, model = "models/lordvipes/keatonmask/keatonmask.mdl", bone = HEAD_B, offsetV = Vector(1.5, -0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
	
	ui_CamPos = Vector(76.18, 37.38, 14.21)
	ui_FOV = 17.47
	ui_LookAng = Angle(9.62, -153.7, 0)	

	New(face, "Servbot Head", {price = 45, model = "models/lordvipes/servbothead/servbothead.mdl", bone = HEAD_B, offsetV = Vector(1, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})

	ui_CamPos = Vector(-72.03, -36.45, 23.95)
	ui_FOV = 29.3
	ui_LookAng = Angle(17.07, 26.65, 0)	

	New(face, "Rubiks Cube", { price = 900, model = "models/gmod_tower/rubikscube.mdl", bone = HEAD_B, offsetV = Vector(0,0,0), offsetA = Angle(180,100,90), scale = 0.65, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV})
end


-- Halloween Pumpkin --
if BH_ACC.Addons["826536617"] then
	ui_CamPos = Vector(74.86, 40.81, 11.75)
	ui_FOV = 29.49
	ui_LookAng = Angle(6.71, -151, 0)

	New(face, "Spooky Pumper", {price = 750, model = "models/props/pumpkin_z.mdl", bone = HEAD_B, offsetV = Vector(1.8, 1.5, 0), offsetA = Angle(180, 100, 90), scale = 0.41, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end

-- Venom Respirator --
if BH_ACC.Addons["939706836"] then
	ui_CamPos = Vector(79.28, 36.66, 0.04)
	ui_FOV = 9.44
	ui_LookAng = Angle(-0.25, -155.37, 0)

	New(face, "Respirator", {price = 750, model = "models/mgsv/gear/venom_respirator.mdl", bone = HEAD_B, offsetV = Vector(0, 3.5, 0), offsetA = Angle(180, 110, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
----------------------

-- [GTA V] Giant Accessories Pack --
if BH_ACC.Addons["572310302"] then
	ui_CamPos = Vector(68.47, 33.97, 15.24)
	ui_FOV = 15.34
	ui_LookAng = Angle(10.11, -152.8, 0)	
	
	local mini_category = "Mask"

	New(face, "Owl Mask", {price = 750, model = "models/sal/owl.mdl", bone = HEAD_B, offsetV = Vector(0, 1, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Penguin Mask", {price = 750, model = "models/sal/penguin.mdl", bone = HEAD_B, offsetV = Vector(0, 0, -0.25), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Wolf Mask", {price = 750, model = "models/sal/wolf.mdl", bone = HEAD_B, offsetV = Vector(-0.5, 0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Pig Mask", {price = 750, model = "models/sal/pig.mdl", bone = HEAD_B, offsetV = Vector(-0.5, 0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	local base = New(face, "Monkey Mask", {price = 750, model = "models/sal/halloween/monkey.mdl", bone = HEAD_B, offsetV = Vector(-0.3, 0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Monkey [Gorilla]", base, { skin = 1 } )
	Copy(face, "Monkey [Zombie]", base, { skin = 2 } )
	Copy(face, "Monkey [Old]", base, { skin = 3 } )

	New(face, "Bear Mask", {price = 750, model = "models/sal/bear.mdl", bone = HEAD_B, offsetV = Vector(1, 0, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV} )
	New(face, "Eagle [White]", {price = 750, model = "models/sal/hawk_1.mdl", bone = HEAD_B, offsetV = Vector(-2, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Eagle [Brown]", {price = 750, model = "models/sal/hawk_2.mdl", bone = HEAD_B, offsetV = Vector(-2, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Cat Mask", {price = 750, model = "models/sal/cat.mdl", bone = HEAD_B, offsetV = Vector(1, 0.3, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Fox Mask", {price = 750, model = "models/sal/fox.mdl", bone = HEAD_B, offsetV = Vector(1, 0, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "GingerB Mask", {price = 750, model = "models/sal/gingerbread.mdl", bone = HEAD_B, offsetV = Vector(0.4, 0, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	local base = New(face, "Ninja [Black]", {price = 750, model = "models/sal/halloween/ninja.mdl", bone = HEAD_B, offsetV = Vector(0, 0.5, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Ninja [White]", base, { skin = 1 } )
	Copy(face, "Ninja [Tan]", base, { skin = 2 } )
	Copy(face, "Ninja [L.S Benders]", base, { skin = 3 } )
	Copy(face, "Ninja [Justice]", base, { skin = 4 } )
	Copy(face, "Ninja [Camo]", base, { skin = 5 } )
	Copy(face, "Ninja [Red Stripes]", base, { skin = 6 } )
	Copy(face, "Ninja [Love Fist]", base, { skin = 7 } )
	Copy(face, "Ninja [T.P.I]", base, { skin = 8 } )
	Copy(face, "Ninja [Candy]", base, { skin = 9 } )
	Copy(face, "Ninja [Police]", base, { skin = 10 } )

	New(face, "Skull", {price = 750, model = "models/sal/halloween/skull.mdl", bone = HEAD_B, offsetV = Vector(1.5, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Zombie Mask", {price = 750, model = "models/sal/halloween/zombie.mdl", bone = HEAD_B, offsetV = Vector(0, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(76.56, 33.37, 8.43)
	ui_FOV = 5.89
	ui_LookAng = Angle(5.71, -156.02, 0)	

	New(face, "Glasses", {price = 450, model = "models/modified/glasses02.mdl", bone = HEAD_B, offsetV = Vector(1.8, 0, 0), offsetA = Angle(180, 100, 90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(71.13, 48.34, 10.55)
	ui_FOV = 15.32
	ui_LookAng = Angle(6.71, -146.03, 0)	

	local base = New(face, "Wrap [Warning]", {price = 750, model = "models/sal/halloween/headwrap1.mdl", bone = HEAD_B, offsetV = Vector(0, 1, 0), offsetA = Angle(180, 100, 90), scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Wrap [Warning1]", base, { skin = 1 } )
	Copy(face, "Wrap [Warning2]", base, { skin = 2 } )
	Copy(face, "Wrap [Warning3]", base, { skin = 3 } )

	local base = New(face, "Wrap [Grey]", {price = 450, model = "models/sal/halloween/headwrap2.mdl", bone = HEAD_B, offsetV = Vector(0, 1, 0), offsetA = Angle(180, 100, 90), scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Wrap [Black]", base, { skin = 1 } )
	Copy(face, "Wrap [White]", base, { skin = 2 } )
	Copy(face, "Wrap [Rainbow]", base, { skin = 3 } )

	New(face, "Bandana", {price = 750, model = "models/modified/bandana.mdl", bone = HEAD_B, offsetV = Vector(-2, 0.75, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(28.55, 19.2, 11.95)
	ui_FOV = 376.07
	ui_LookAng = Angle(-339.22, -503.4, 0)	

	local base = New(face, "Glasses [Grey]", {price = 750, model = "models/modified/glasses01.mdl", bone = HEAD_B, offsetV = Vector(1.5, -0.4, 0), offsetA = Angle(180, 100, 90), mini_category = "Glasses" , ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Glasses [White]", base, { skin = 1 } )
	Copy(face, "Glasses [Green]", base, { skin = 2 } )
	Copy(face, "Glasses [Brown]", base, { skin = 3 } )
	Copy(face, "Glasses [Orange]", base, { skin = 4 } )
	Copy(face, "Glasses [L Grey]", base, { skin = 5 } )

	ui_CamPos = Vector(56.14, 38.96, 11.16)
	ui_FOV = 17.44
	ui_LookAng = Angle(7.88, -143.94, 0)	

	New(face, "Hockey [Yellow]", { price = 450, model = "models/modified/mask5.mdl", bone = HEAD_B, offsetV = Vector(-0.5,0,0), offsetA = Angle(180,100,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	local base = New(face, "Hockey [Blue]", {price = 750, model = "models/sal/acc/fix/mask_2.mdl", bone = HEAD_B, offsetV = Vector(0.35, 0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", scale = 0.934, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Hockey [Dog]", base, { skin = 2 } )
	Copy(face, "Hockey [Cat]", base, { skin = 3 } )
	Copy(face, "Hockey [Crown]", base, { skin = 4 } )
	Copy(face, "Hockey [Rotten]", base, { skin = 5 } )
	Copy(face, "Hockey [Vile]", base, { skin = 6 } )
	Copy(face, "Hockey [Flame]", base, { skin = 7 } )
	Copy(face, "Hockey [Nightmare]", base, { skin = 8 } )
	Copy(face, "Hockey [Electric]", base, { skin = 9 } )
	Copy(face, "Hockey [Skull]", base, { skin = 10 } )
	Copy(face, "Hockey [Stitch]", base, { skin = 11 } )
	Copy(face, "Hockey [Stitch 2]", base, { skin = 12 } )
	Copy(face, "Hockey [Hockey [X]]", base, { skin = 13 } )

	local base = New(face, "Skull [Black]", {price = 750, model = "models/modified/mask6.mdl", bone = HEAD_B, offsetV = Vector(-1, 1, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Skull [Grey]", base, { skin = 1 } )
	Copy(face, "Skull [White]", base, { skin = 2 } )
	Copy(face, "Skull [Dark Green]", base, { skin = 3 } )

	local base = New(face, "Warrior [Metal]", {price = 750, model = "models/sal/acc/fix/mask_4.mdl", bone = HEAD_B, offsetV = Vector(-0.5, 1, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Warrior [Circuit]", base, { skin = 1 } )
	Copy(face, "Warrior [Molten]", base, { skin = 2 } )
	Copy(face, "Warrior [Purple]", base, { skin = 3 } )
	Copy(face, "Warrior [Carbon]", base, { skin = 4 } )
	Copy(face, "Warrior [Target]", base, { skin = 5 } )
	Copy(face, "Warrior [Concrete]", base, { skin = 6 } )
	Copy(face, "Warrior [Thunder]", base, { skin = 7 } )

	local base = New(face, "Paper Bag", {price = 750, model = "models/sal/halloween/bag.mdl", bone = HEAD_B, offsetV = Vector(0, 0.2, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Paper [Grin]", base, { skin = 1 } )
	Copy(face, "Paper [Crying]", base, { skin = 2 } )
	Copy(face, "Paper [Smile]", base, { skin = 3 } )
	Copy(face, "Paper [Boss]", base, { skin = 4 } )
	Copy(face, "Paper [Teeth]", base, { skin = 5 } )
	Copy(face, "Paper [Timid]", base, { skin = 6 } )
	Copy(face, "Paper [Burger]", base, { skin = 7 } )
	Copy(face, "Paper [Kill Me]", base, { skin = 8 } )
	Copy(face, "Paper [Satan]", base, { skin = 9 } )
	Copy(face, "Paper [Pig]", base, { skin = 10 } )
	Copy(face, "Paper [Tongue]", base, { skin = 11 } )
	Copy(face, "Paper [Angry]", base, { skin = 12 } )
	Copy(face, "Paper [Confused]", base, { skin = 13 } )
	Copy(face, "Paper [Death]", base, { skin = 14 } )
	Copy(face, "Paper [Dog]", base, { skin = 15 } )
	Copy(face, "Paper [Ghost]", base, { skin = 16 } )
	Copy(face, "Paper [Alien]", base, { skin = 17 } )
	Copy(face, "Paper [Help Me]", base, { skin = 18 } )
	Copy(face, "Paper [Rectangles]", base, { skin = 19 } )
	Copy(face, "Paper [Middle Finger]", base, { skin = 20 } )
	Copy(face, "Paper [Gentleman]", base, { skin = 21 } )
	Copy(face, "Paper [Stickers]", base, { skin = 22 } )
	Copy(face, "Paper [Picasso]", base, { skin = 23 } )
	Copy(face, "Paper [Heart]", base, { skin = 24 } )
	Copy(face, "Paper [Black]", base, { skin = 25 } )

	ui_CamPos = Vector(79.96, 32.17, 7.29)
	ui_FOV = 7.51
	ui_LookAng = Angle(3.64, -156.94, 0)

	New(face, "Doctor Mask", {price = 750, model = "models/sal/halloween/doctor.mdl", bone = HEAD_B, offsetV = Vector(-0.5, -0.5, 0), offsetA = Angle(180, 100, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(57.82, 56.72, 76.73)
	ui_FOV = 7.19
	ui_LookAng = Angle(6.4, -495, 0)	
	
	local base = New(face, "Ballet Mask", {price = 750, model = "models/sal/acc/fix/mask_1.mdl", bone = HEAD_B, offsetV = Vector(-64.7, -0.2, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Ballet [Blue]", base, { skin = 1 } )
	Copy(face, "Ballet [Black]", base, { skin = 2 } )
	Copy(face, "Ballet [Grey]", base, { skin = 3 } )
	Copy(face, "Ballet [Yellow]", base, { skin = 4 } )
	Copy(face, "Ballet [Black 2]", base, { skin = 5 } )
end
----------------------------------

-- GTA IV Bike Helmets --
if BH_ACC.Addons["551144079"] then
	ui_CamPos = Vector(73.01, 57.06, 5.53)
	ui_FOV = 11.72
	ui_LookAng = Angle(3.7, -141.4, 0)	
	
	local base = New(face, "Motorcycle [Black]", {price = 850, model = "models/dean/gtaiv/helmet.mdl", bone = HEAD_B, offsetV = Vector(2, 0, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Motorcycle [Grey]", base, { skin = 1 } )
	Copy(face, "Motorcycle [White]", base, { skin = 2 } )
	Copy(face, "Motorcycle [Red]", base, { skin = 3 } )
	Copy(face, "Motorcycle [Orange]", base, { skin = 4 } )
	Copy(face, "Motorcycle [Yellow]", base, { skin = 5 } )
	Copy(face, "Motorcycle [Blue]", base, { skin = 6 } )
	Copy(face, "Motorcycle [Pink]", base, { skin = 7 } )
	Copy(face, "Motorcycle [Rainbow]", base, { skin = 8 } )
	Copy(face, "Motorcycle [Stars]", base, { skin = 9 } )
	Copy(face, "Motorcycle [Gradient]", base, { skin = 10 } )
	Copy(face, "Motorcycle [America]", base, { skin = 11 } )
	Copy(face, "Motorcycle [Black Str]", base, { skin = 12 } )
	Copy(face, "Motorcycle [White Str]", base, { skin = 13 } )
end
-------------------------

-- Payday 2 Classic Masks --
if BH_ACC.Addons["184937635"] then
	ui_CamPos = Vector(71.42, 36.76, 18.94)
	ui_FOV = 12.57
	ui_LookAng = Angle(9.91, -152.28, 0)

	New(face, "[PD] Chains", {price = 750, model = "models/shaklin/payday2/masks/pd2_mask_chains.mdl", bone = HEAD_B, offsetV = Vector(-3.5, 0.5, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Dallas", {price = 750, model = "models/shaklin/payday2/masks/pd2_mask_dallas.mdl", bone = HEAD_B, offsetV = Vector(-3.5, 0.5, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Hoxton", {price = 750, model = "models/shaklin/payday2/masks/pd2_mask_hoxton.mdl", bone = HEAD_B, offsetV = Vector(-3.5, 0.5, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Wolf", {price = 750, model = "models/shaklin/payday2/masks/pd2_mask_wolf.mdl", bone = HEAD_B, offsetV = Vector(-3.5, 0.5, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } ) 
end
----------------------------

-- Payday 2 Gagball Mask --
if BH_ACC.Addons["283911615"] then
	New(face, "[PD] Gagball", {price = 750, model = "models/snowzgmod/payday2/masks/maskthegagball.mdl", bone = HEAD_B, offsetV = Vector(2.5, 4, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = Vector(69.23, 50.28, 6.71), ui_LookAng = Angle(4.69, -144.55, 0), ui_FOV = 12.4 } )
end
---------------------------

-- Payday 2 Hockey Masks --
if BH_ACC.Addons["283912012"] then
	ui_CamPos = Vector(71.19, 48.03, 8.57)
	ui_FOV = 12.38
	ui_LookAng = Angle(5.84, -146.25, 0)	
	
	New(face, "[PD] Hockey Heat", {price = 750, model = "models/snowzgmod/payday2/masks/maskhockeyheat.mdl", bone = HEAD_B, offsetV = Vector(2.5, 4, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Hockey Mask", {price = 750, model = "models/snowzgmod/payday2/masks/maskhockeymask.mdl", bone = HEAD_B, offsetV = Vector(2.5, 4, 0), offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
---------------------------


-- Cthulhu Mask --
if BH_ACC.Addons["283483564"] then
	New(face, "[PD] Cthulhu Mask", { price = 750, model = "models/snowzgmod/payday2/masks/maskcthulhu.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = Vector(71.42, 36.76, 18.94), ui_LookAng = Angle(9.91, -152.28, 0), ui_FOV = 12.57 } )
end
------------------



-- Payday 2 Skull Masks --
if BH_ACC.Addons["283399070"] then
	ui_CamPos = Vector(80.91, 26.28, 11.12)
	ui_FOV = 12.38
	ui_LookAng = Angle(7.7, -162.21, 0)	
	
	New(face, "[PD] Skull Calaca", { price = 750, model = "models/snowzgmod/payday2/masks/maskcalaca.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Skull DeathWish", { price = 1500, model = "models/snowzgmod/payday2/masks/maskdeathwishskull.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Skull OverKill", { price = 1500, model = "models/snowzgmod/payday2/masks/maskoverkillskull.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Skull", { price = 1200, model = "models/snowzgmod/payday2/masks/masktheskull.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Skull VeryHard", { price = 1500, model = "models/snowzgmod/payday2/masks/maskveryhardskull.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[PD] Skull Hard", { price = 1000, model = "models/snowzgmod/payday2/masks/maskhardskull.mdl", mini_category = "Masks", bone = HEAD_B, offsetV = Vector(2.5,3.6,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
--------------------------



-- Gas Mask Ports --
if BH_ACC.Addons["749833732"] then
	ui_CamPos = Vector(4.17, -6.29, 88.19)
	ui_FOV = 15.27
	ui_LookAng = Angle(95.1, -414.43, 0)	

	New(face, "Gas Mask [GP5]", {price = 750, model = "models/gasmasks/gp5.mdl", bone = HEAD_B, offsetV = Vector(-1, 3, -0.02), offsetA = Angle(90, 0, 90), mini_category = "Masks", scale = 1.05, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Gas Mask [MP7]", {price = 750, model = "models/gasmasks/m17.mdl", bone = HEAD_B, offsetV = Vector(2, 2, 0), offsetA = Angle(90, 0, 90), mini_category = "Masks", scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Gas Mask [M40]", {price = 750, model = "models/gasmasks/m40.mdl", bone = HEAD_B, offsetV = Vector(2.33, 2, -0.5), offsetA = Angle(90, 0, 90), mini_category = "Masks", scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Gas Mask [PBF]", {price = 750, model = "models/gasmasks/pbf.mdl", bone = HEAD_B, offsetV = Vector(2.33, 1.5, 0), offsetA = Angle(90, 0, 90), mini_category = "Masks", scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Gas Mask [S10]", {price = 750, model = "models/gasmasks/s10.mdl", bone = HEAD_B, offsetV = Vector(1.5, 2.1, -0.77), offsetA = Angle(90, 0, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
--------------------

-- Gas Masks --
if BH_ACC.Addons["188866519"] then
	ui_CamPos = Vector(79.14, 39.32, 3.03)
	ui_FOV = 11.07
	ui_LookAng = Angle(1.39, -154.02, 0)

	New(face, "Metro Digger", { price = 900, model = "models/maver1k_xvii/metro_digger_helmet.mdl", bone = HEAD_B, offsetV = Vector(1.5,3.5,-0.1), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Metro Ushanka", { price = 500, model = "models/maver1k_xvii/metro_ushanka.mdl", bone = HEAD_B, offsetV = Vector(3.5,0.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(70.66, 48.08, -2.05)
	ui_FOV = 11.11
	ui_LookAng = Angle(-2.99, -145.28, 0)
	
	local base = New(face, "Stcop [Green]", { price = 250, model = "models/maver1k_xvii/stcop_helm_battle.mdl", bone = HEAD_B, offsetV = Vector(0,0.8,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Stcop [Green/Black]", base, { skin = 1 } )
	Copy(face, "Stcop [Black/Green]", base, { skin = 2 } )
	Copy(face, "Stcop [Black]", base, { skin = 3 } )

	local base = New(face, "Stcop Exo", { price = 250, model = "models/maver1k_xvii/stcop_helm_exo.mdl", bone = HEAD_B, offsetV = Vector(1,0.5,0), offsetA = Angle(180,100,90), scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Stcop Exo [Red]", base, { skin = 1 } )
	Copy(face, "Stcop Exo [Green]", base, { skin = 2 } )
	Copy(face, "Stcop Exo [Yellow]", base, { skin = 3 } )
	
	ui_CamPos = Vector(79.04, 35.15, -1.26)
	ui_FOV = 11.14
	ui_LookAng = Angle(-1.48, -155.49, 0)	

	New(face, "Stcop Tactic", { price = 650, model = "models/maver1k_xvii/stcop_helm_tactic.mdl", bone = HEAD_B, offsetV = Vector(1,0.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Stsoc Gasmask", { price = 450, model = "models/maver1k_xvii/stsoc_helm_gasmask_02.mdl", bone = HEAD_B, offsetV = Vector(1,2,0), offsetA = Angle(180,-15,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
---------------

-- Halo part 1 --
if BH_ACC.Addons["174704263"] then
	ui_CamPos = Vector(-41.35, 76.02, 0.26)
	ui_FOV = 11.76
	ui_LookAng = Angle(0.32, -61.57, 0)	
	
	local base = New(face, "Halo Adrianna", { price = 300, model = "models/damaged helmets/adrianna.mdl", bone = HEAD_B, offsetV = Vector(2,2,-0.1), offsetA = Angle(80,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Adrianna [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Adrianna [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Adrianna [Black]", base, { skin = 3 } )
	Copy(face, "Halo Adrianna [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Carter", { price = 300, model = "models/damaged helmets/carter.mdl", bone = HEAD_B, offsetV = Vector(2,2,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Carter [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Carter [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Carter [Black]", base, { skin = 3 } )
	Copy(face, "Halo Carter [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo [Default]", { price = 400, model = "models/damaged helmets/default.mdl", bone = HEAD_B, offsetV = Vector(3,2,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo [Grey]", base, { skin = 1 } )
	Copy(face, "Halo [Blue]", base, { skin = 2 } )
	Copy(face, "Halo [Black]", base, { skin = 3 } )
	Copy(face, "Halo [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Issac", { price = 300, model = "models/damaged helmets/issac.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Issac [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Issac [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Issac [Black]", base, { skin = 3 } )
	Copy(face, "Halo Issac [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Jai", { price = 350, model = "models/damaged helmets/jai.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Jai [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Jai [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Jai [Black]", base, { skin = 3 } )
	Copy(face, "Halo Jai [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo John", { price = 350, model = "models/damaged helmets/john117.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo John [Grey]", base, { skin = 1 } )
	Copy(face, "Halo John [Blue]", base, { skin = 2 } )
	Copy(face, "Halo John [Black]", base, { skin = 3 } )
	Copy(face, "Halo John [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Joshua", { price = 350, model = "models/damaged helmets/joshua.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Joshua [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Joshua [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Joshua [Black]", base, { skin = 3 } )
	Copy(face, "Halo Joshua [Yellow]", base, { skin = 4 } )

end
-----------------

-- Halo part 2 --
if BH_ACC.Addons["174739352"] then
	ui_CamPos = Vector(-50.03, 69.39, 3.05)
	ui_FOV = 11.11
	ui_LookAng = Angle(2.55, -54.02, 0)	

	local base = New(face, "Halo Jun", { price = 350, model = "models/damaged helmets/jun.mdl", bone = HEAD_B, offsetV = Vector(3,1.5,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Jun [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Jun [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Jun [Black]", base, { skin = 3 } )
	Copy(face, "Halo Jun [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Kat", { price = 350, model = "models/damaged helmets/kat.mdl", bone = HEAD_B, offsetV = Vector(2.5,1.2,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Kat [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Kat [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Kat [Black]", base, { skin = 3 } )
	Copy(face, "Halo Kat [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Kelly", { price = 500, model = "models/damaged helmets/kelly.mdl", bone = HEAD_B, offsetV = Vector(2,2,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Kelly [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Kelly [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Kelly [Black]", base, { skin = 3 } )
	Copy(face, "Halo Kelly [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Kurt", { price = 450, model = "models/damaged helmets/kurt.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Kurt [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Kurt [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Kurt [Black]", base, { skin = 3 } )
	Copy(face, "Halo Kurt [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Li", { price = 600, model = "models/damaged helmets/li.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Li [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Li [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Li [Black]", base, { skin = 3 } )
	Copy(face, "Halo Li [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Linda", { price = 550, model = "models/damaged helmets/linda.mdl", bone = HEAD_B, offsetV = Vector(2.8,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Linda [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Linda [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Linda [Black]", base, { skin = 3 } )
	Copy(face, "Halo Linda [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Nicole", { price = 450, model = "models/damaged helmets/nicole.mdl", bone = HEAD_B, offsetV = Vector(2,1.8,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Nicole [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Nicole [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Nicole [Black]", base, { skin = 3 } )
	Copy(face, "Halo Nicole [Yellow]", base, { skin = 4 } )
end
-----------------

-- Halo part 3 --
if BH_ACC.Addons["174745011"] then
	ui_CamPos = Vector(-50.03, 69.39, 3.05)
	ui_FOV = 11.11
	ui_LookAng = Angle(2.55, -54.02, 0)
	
	local base = New(face, "Halo Odst", { price = 350, model = "models/damaged helmets/odst.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Odst [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Odst [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Odst [Black]", base, { skin = 3 } )
	Copy(face, "Halo Odst [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Rosenda", { price = 750, model = "models/damaged helmets/rosenda.mdl", bone = HEAD_B, offsetV = Vector(2,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Rosenda [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Rosenda [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Rosenda [Black]", base, { skin = 3 } )
	Copy(face, "Halo Rosenda [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Sam", { price = 650, model = "models/damaged helmets/sam.mdl", bone = HEAD_B, offsetV = Vector(2,2,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Sam [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Sam [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Sam [Black]", base, { skin = 3 } )
	Copy(face, "Halo Sam [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Skull", { price = 650, model = "models/damaged helmets/skull.mdl", bone = HEAD_B, offsetV = Vector(2,1.3,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Skull [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Skull [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Skull [Black]", base, { skin = 3 } )
	Copy(face, "Halo Skull [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Vinh", { price = 450, model = "models/damaged helmets/vinh.mdl", bone = HEAD_B, offsetV = Vector(2,2,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Vinh [Grey]", base, { skin = 1 } )
	Copy(face, "Halo Vinh [Blue]", base, { skin = 2 } )
	Copy(face, "Halo Vinh [Black]", base, { skin = 3 } )
	Copy(face, "Halo Vinh [Yellow]", base, { skin = 4 } )

	local base = New(face, "Halo Will", { price = 550, model = "models/damaged helmets/will.mdl", bone = HEAD_B, offsetV = Vector(2.7,1,0), offsetA = Angle(90,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Halo Will [Grey]", base, { skin = 1 } ) 
	Copy(face, "Halo Will [Blue]", base, { skin = 2 } ) 
	Copy(face, "Halo Will [Black]", base, { skin = 3 } ) 
	Copy(face, "Halo Will [Yellow]", base, { skin = 4 } ) 
end
-----------------

-- Imperial Helmets --
if BH_ACC.Addons["943349673"] then
	ui_CamPos = Vector(57.08, 46.77, 35.32)
	ui_FOV = 14.56
	ui_LookAng = Angle(3.97, -140.07, 0)	

	New(face, "Stormtrooper Helmet", { price = 450, model = "models/player/mewtwo/icn_helmet_prop.mdl", bone = HEAD_B, offsetV = Vector(-29,6.5,-0.1), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Stormtrooper Helmet [Orange]", { price = 450, model = "models/player/mewtwo/mew2_212_helm.mdl", bone = HEAD_B, offsetV = Vector(-30.5,5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(64.1, 35.81, 34.06)
	ui_FOV = 16.27
	ui_LookAng = Angle(2.11, -149.56, 0)	

	New(face, "Boba Fett Helmet", { price = 550, model = "models/player/mewtwo/mew2_boba_fett_helm.mdl", bone = HEAD_B, offsetV = Vector(-29,4.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(58.54, 44.02, 34.66)
	ui_FOV = 13.79
	ui_LookAng = Angle(3.14, -142.39, 0)

	New(face, "Scout Helmet", { price = 500, model = "models/player/mewtwo/mew2_scout_helm.mdl", bone = HEAD_B, offsetV = Vector(-29,7,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Shore Helmet", { price = 450, model = "models/player/mewtwo/mew2_shore_helm.mdl", bone = HEAD_B, offsetV = Vector(-29,4.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "Darth Vader Helmet", { price = 450, model = "models/player/mewtwo/mew2_vader_helm.mdl", bone = HEAD_B, offsetV = Vector(-29,5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
----------------------

-- Fancy Masks --
if BH_ACC.Addons["173676413"] then
	ui_CamPos = Vector(70.38, 46.01, 10.15)
	ui_FOV = 7.07
	ui_LookAng = Angle(3.84, 213.05, 0)
	
	local base = New(face, "Hers [Gold]", { price = 250, model = "models/mask/mask_hers.mdl", bone = HEAD_B, offsetV = Vector(-4.5,4.3,0), offsetA = Angle(180,100,90), mini_category = "Masks", scale = 1.345, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Hers [Green]", base, { skin = 1 } )
	Copy(face, "Hers [Illusion]", base, { skin = 2 } )
	Copy(face, "Hers [Satanic]", base, { skin = 3 } )
	Copy(face, "Hers [Scar]", base, { skin = 4 } )

	ui_CamPos = Vector(77.99, 29.42, 12.81)
	ui_FOV = 5.33
	ui_LookAng = Angle(5.01, -519.38, 0)
		
	local base = New(face, "Hers Eye [Gold]", { price = 150, model = "models/mask/mask_hers_eye.mdl", bone = HEAD_B, offsetV = Vector(-3,4.6,0.1), offsetA = Angle(180,100,90), mini_category = "Masks", scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "Hers Eye [Green]", base, { skin = 1 } )
	Copy(face, "Hers Eye [Illusion]", base, { skin = 2 } )
	Copy(face, "Hers Eye [Satanic]", base, { skin = 3 } )
	Copy(face, "Hers Eye [Scar]", base, { skin = 4 } )

	ui_CamPos = Vector(75.82, 36.43, 10.34)
	ui_FOV = 7.1
	ui_LookAng = Angle(3.96, -154.37, 0)	
	
	local base = New(face, "His [Gold]", { price = 250, model = "models/mask/mask_his.mdl", bone = HEAD_B, offsetV = Vector(-4.6,4.4,0), offsetA = Angle(180,100,90), mini_category = "Masks", scale = 1.335, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "His [Green]", base, { skin = 1 } )
	Copy(face, "His [Illusion]", base, { skin = 2 } )
	Copy(face, "His [Satanic]", base, { skin = 3 } )
	Copy(face, "His [Scar]", base, { skin = 4 } )

	ui_CamPos = Vector(69.96, 45.63, 8.75)
	ui_FOV = 5.33
	ui_LookAng = Angle(2.07, -506.9, 0)
	
	local base = New(face, "His Eye", { price = 150, model = "models/mask/mask_his_eye.mdl", bone = HEAD_B, offsetV = Vector(-3.3,4.6,0), offsetA = Angle(180,100,90), mini_category = "Masks", scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(face, "His Eye [Green]", base, { skin = 1 } )
	Copy(face, "His Eye [Illusion]", base, { skin = 2 } )
	Copy(face, "His Eye [Satanic]", base, { skin = 3 } )
	Copy(face, "His Eye [Scar]", base, { skin = 4 } )
end
-----------------

-- Guy Fawkes Mask --
if BH_ACC.Addons["176185029"] then
	ui_CamPos = Vector(69.07, 28.82, 70.55)
	ui_FOV = 12.38
	ui_LookAng = Angle(3.15, -154.94, 0)	
	
	New(face, "Guy Fawkes Mask", { price = 450, model = "models/v/mask.mdl", bone = HEAD_B, offsetV = Vector(-65.9,8.5,0), offsetA = Angle(180,100,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
---------------------

-- US & Soviet Tank Crew Helmets -- 
if BH_ACC.Addons["327527107"] then
	ui_CamPos = Vector(62.39, 55.19, 9.22)
	ui_FOV = 12.38
	ui_LookAng = Angle(2, -138.28, 0)	
	
	local base = New(accessories, "CVC Helmet", { price = 650, model = "models/kali/miscstuff/cvc_helmet.mdl", bone = HEAD_B, offsetV = Vector(-3.7,2,0), offsetA = Angle(180,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "CVC Helmet [Sand]", base, { skin = 1 } )
	Copy(accessories, "CVC Helmet [Black]", base, { skin = 2 } )
	
	ui_CamPos = Vector(60.95, 40.09, 69.38)
	ui_FOV = 13.06
	ui_LookAng = Angle(1.25, -146.35, 0)	
	
	local base = New(accessories, "Soviet Tanker [Sand]", { price = 550, model = "models/kali/miscstuff/soviet_tanker_helmet.mdl", bone = HEAD_B, offsetV = Vector(-64.5,12.1,0), mini_category = "Helmets", offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Soviet Tanker [Black]", base, { skin = 1 } )
	Copy(accessories, "Soviet Tanker [Grey]", base, { skin = 2 } )
end
-----------------------------------

-------- Third Selection ( BACK ) ---------

-- [GTA V] Giant Accessories Pack --
if BH_ACC.Addons["572310302"] then
	ui_CamPos = Vector(-74.05, -35.6, 27.52)
	ui_FOV = 25.63
	ui_LookAng = Angle(18.46, 26.94, 0)	

	local base = New(back, "Backpack [Red]", { price = 750, model = "models/modified/backpack_1.mdl", bone = SPINE_B2, offsetV = Vector(-3,-1,0), offsetA = Angle(0,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "Backpack [Black]", base, { skin = 1 } )
	Copy(back, "Backpack [Orange]", base, { skin = 2 } ) 
	
	ui_CamPos = Vector(-82.16, -38.93, 16.13)
	ui_FOV = 30.99
	ui_LookAng = Angle(13.39, 27.99, 0)	

	local base = New(back, "Camp Backpack", {price = 500, model = "models/modified/backpack_2.mdl", bone = SPINE_B2, offsetV = Vector(-2, -2, 0), offsetA = Angle(0, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "Camp Backpack [Gr]", base, { skin = 1 } )
	Copy(back, "Camp Backpack [Red]", base, { skin = 2 } )
	
	ui_CamPos = Vector(-65.69, -24.63, 8.31)
	ui_FOV = 31.17
	ui_LookAng = Angle(6.96, 22.33, 0)	

	local base = New(back, "Military Backpack", {price = 450, model = "models/modified/backpack_3.mdl", bone = SPINE_B2, offsetV = Vector(-2, -2, 0), offsetA = Angle(0, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "Military Backpack [Grey]", base, { skin = 1 } )
end
------------------------------------

-- GMT Back Accessories --
if BH_ACC.Addons["148215278"] then
	ui_CamPos = Vector(-83.88, -6.25, 11.29)
	ui_FOV = 4.23
	ui_LookAng = Angle(7.61, 7.03, 0)	
	
	New(back, "Bunny Tail", { price = 450, model = "models/captainbigbutt/skeyler/accessories/tail_bunny.mdl", bone = SPINE_B2, offsetV = Vector(-15, 0, 0.5), offsetA = Angle(0, 40, 180), scale = 2, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(74.1, 33.07, 15.79)
	ui_FOV = 13.62
	ui_LookAng = Angle(10.03, -155.56, 0)	

	New(back, "Duck Tube", { price = 450, model = "models/captainbigbutt/skeyler/accessories/duck_tube.mdl", bone = SPINE_B2, offsetV = Vector(-10,0,0), offsetA = Angle(0,100,90), scale = 1.5, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(-92.29, -25.39, 10.53)
	ui_FOV = 24.99
	ui_LookAng = Angle(4.44, 16.86, 0)	

	New(back, "JetPack", { price = 450, model = "models/gmod_tower/jetpack.mdl", bone = SPINE_B2, offsetV = Vector(-3,16,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(69.66, 38.43, 25.92)
	ui_FOV = 39.81
	ui_LookAng = Angle(-0.25, -155.98, 0)	
	
	New(back, "BlackMage Cape", {price = 450, model = "models/lordvipes/blackmage/blackmage_cape.mdl", bone = SPINE_B2, offsetV = Vector(-25, -1.5, 0), offsetA = Angle(0, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV  } )
	
	ui_CamPos = Vector(-54.89, -59.08, 28.69)
	ui_FOV = 24.69
	ui_LookAng = Angle(10.27, 47.26, 0)	

	New(back, "Pokemon Backpack", {price = 450, model = "models/pokemon/backpack.mdl", bone = SPINE_B2, offsetV = Vector(-15, 3, 0), offsetA = Angle(0, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-52.42, 67.12, 10.53)
	ui_FOV = 23.46
	ui_LookAng = Angle(6.78, -55.97, 0)	

	New(back, "Fairy Wings", {price = 450, model = "models/gmod_tower/fairywings.mdl", bone = SPINE_B2, offsetV = Vector(5, -2, 0), offsetA = Angle(-90, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(46.93, -15.91, 70.97)
	ui_FOV = 27.51
	ui_LookAng = Angle(55.45, -556.22, 0)	

	New(back, "Balloonicorn", { price = 1500, model = "models/gmod_tower/balloonicorn_nojiggle.mdl", bone = SPINE_B2, offsetV = Vector(0,5,0), offsetA = Angle(-90,90,150), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
--------------------------

-- Wings --
if BH_ACC.Addons["107165776"] then
	ui_CamPos = Vector(73.9, 48.72, 59.92)
	ui_FOV = 37.35
	ui_LookAng = Angle(9.11, -153.64, 0)	

	local base = New(back, "Wings [White]", { price = 750, model = "models/wings/wings_folded.mdl", bone = SPINE_B2, offsetV = Vector(-47.4,17.4,0), offsetA = Angle(0,110,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "Wings [Black]", base, { skin = 1 } )
	
	ui_CamPos = Vector(101.4, 64.88, 68.91)
	ui_FOV = 29.71
	ui_LookAng = Angle(4.49, -149.75, 0)
	
	local base = New(back, "Wings Spread [White]", {price = 450, model = "models/wings/wings_spread.mdl", bone = SPINE_B2, offsetV = Vector(-47, -1, 0), offsetA = Angle(0, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "Wings Spread [Black]", base, { skin = 1 } )
end
-----------

-- Acoustic Guitar --
if BH_ACC.Addons["122461372"] then
	ui_CamPos = Vector(14.71, 27.56, 89.29)
	ui_FOV = 34.67
	ui_LookAng = Angle(69.72, -118.73, 0)	

	New(back, "Acoustic Guitar", {price = 450, model = "models/acoustic guitar/acousticguitar.mdl", bone = SPINE_B2, offsetV = Vector(5, -1, 0), offsetA = Angle(160, 0, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
---------------------

-- Payday 2 Bags --
if BH_ACC.Addons["357350543"] then
	ui_CamPos = Vector(63.87, 52.45, 23.43)
	ui_FOV = 32.65
	ui_LookAng = Angle(15.34, -140.75, 0)	

	New(back, "[PD] Painting Bag", { price = 1250, model = "models/jessev92/payday2/item_bag_artroll.mdl", bone = SPINE_B2, offsetV = Vector(0,6,0), offsetA = Angle(180,100,64.3), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(57.38, 50.58, 30.1)
	ui_FOV = 29.12
	ui_LookAng = Angle(22.52, -138.64, 0)
	
	New(back, "[PD] Body Bag", { price = 750, model = "models/jessev92/payday2/item_bag_body_jb.mdl", bone = SPINE_B2, offsetV = Vector(0,9,0), offsetA = Angle(107.9,90,180), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(68.7, 28.59, 34.75)
	ui_FOV = 25
	ui_LookAng = Angle(24.26, 206.52, 0)
	
	local base = New(back, "[PD] Loot Bag", { price = 550, model = "models/jessev92/payday2/item_bag_loot_jb.mdl", bone = SPINE_B2, offsetV = Vector(-7,9,0), offsetA = Angle(80,5,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "[PD] Loot [Orange]", base, { skin = 1 } ) 
	Copy(back, "[PD] Loot [Green]", base, { skin = 2 } ) 
	Copy(back, "[PD] Loot [Yellow]", base, { skin = 3 } ) 
end
-------------------

-- Rust Backpack --
if BH_ACC.Addons["783530452"] then
	ui_CamPos = Vector(28.03, 0.82, 87.66)
	ui_FOV = 21.25
	ui_LookAng = Angle(108.59, 0.62, 0)	

	New(back, "Rust Backpack", { price = 750, model = "models/blacksnow/backpack.mdl", bone = SPINE_B2, offsetV = Vector(0,3.25,0), offsetA = Angle(0,0,91.1), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
----- Fourth Selection ( Accessories ) -----

-- Pirate Hat --
if BH_ACC.Addons["351194925"] then
	ui_CamPos = Vector(-75.73, -37.14, 12.53)
	ui_FOV = 11.01
	ui_LookAng = Angle(6.56, 25.91, 0)
	
	New(accessories, "Pirate Hat", {price = 250, model = "models/piratehat/piratehat.mdl", bone = HEAD_B, offsetV = Vector(2.5, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-----------------

-- [GTA V] Giant Accessories Pack --
if BH_ACC.Addons["572310302"] then
	ui_CamPos = Vector(-53.58, -58.15, 23.36)
	ui_FOV = 10.81
	ui_LookAng = Angle(15.68, 47, 0)	
	
	local base = New(accessories, "Fedora [Grey]", {price = 750, model = "models/modified/hat01_fix.mdl", bone = HEAD_B, offsetV = Vector(3, -0.25, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Fedora [Black]", base, { skin = 1 } )
	Copy(accessories, "Fedora [White]", base, { skin = 2 } )
	Copy(accessories, "Fedora [Yellow]", base, { skin = 3 } )
	Copy(accessories, "Fedora [Red]", base, { skin = 4 } )
	Copy(accessories, "Fedora [Black/Red]", base, { skin = 5 } )
	Copy(accessories, "Fedora [Brown/White]", base, { skin = 6 } )
	Copy(accessories, "Fedora [Blue/Black]", base, { skin = 7 } )

	local base = New(accessories, "Beanie [Red Stripes]", {price = 750, model = "models/modified/hat03.mdl", bone = HEAD_B, offsetV = Vector(3, 0.25, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Beanie [Blue]", base, { skin = 1 } )
	Copy(accessories, "Beanie [Red]", base, { skin = 2 } )
	Copy(accessories, "Beanie [White]", base, { skin = 3 } )
	Copy(accessories, "Beanie [Black/Grey]", base, { skin = 4 } )

	local base = New(accessories, "Wool [Black]", {price = 750, model = "models/modified/hat04.mdl", bone = HEAD_B, offsetV = Vector(4, -1.3, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Wool [Grey]", base, { skin = 1 } )
	Copy(accessories, "Wool [Greyish]", base, { skin = 2 } )
	Copy(accessories, "Wool [Jamaica]", base, { skin = 3 } )
	Copy(accessories, "Wool [Dark Blue]", base, { skin = 4 } )

	New(accessories, "Flat Cap", {price = 750, model = "models/modified/hat06.mdl", bone = HEAD_B, offsetV = Vector(4, 0.25, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(59.55, 57.2, 10.03)
	ui_FOV = 10
	ui_LookAng = Angle(6.31, -135.17, 0)	

	local base = New(accessories, "Cap [Grey F]", {price = 750, model = "models/modified/hat07.mdl", bone = HEAD_B, offsetV = Vector(4, -0.35, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Cap [Black F]", base, { skin = 1 } )
	Copy(accessories, "Cap [Light Grey]", base, { skin = 2 } )
	Copy(accessories, "Cap [White LS]", base, { skin = 3 } )
	Copy(accessories, "Cap [Green Feud]", base, { skin = 4 } )
	Copy(accessories, "Cap [Green Magnetics]", base, { skin = 5 } )
	Copy(accessories, "Cap [Brown OG]", base, { skin = 6 } )
	Copy(accessories, "Cap [Stank]", base, { skin = 7 } )
	Copy(accessories, "Cap [Brown]", base, { skin = 8 } )
	Copy(accessories, "Cap [Dark Green]", base, { skin = 9 } )
	Copy(accessories, "Cap [Olive Kn]", base, { skin = 10 } )

	local base = New(accessories, "Cap [Orange LH]", {price = 750, model = "models/modified/hat08.mdl", bone = HEAD_B, offsetV = Vector(3.5, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Cap [Censored]", base, { skin = 1 } )
	Copy(accessories, "Cap [Nut House]", base, { skin = 2 } )
	Copy(accessories, "Cap [Rusty Br]", base, { skin = 3 } )
	Copy(accessories, "Cap [Biskop's]", base, { skin = 4 } )
	Copy(accessories, "Cap [247]", base, { skin = 5 } )
	Copy(accessories, "Cap [Fruit]", base, { skin = 6 } )
	Copy(accessories, "Cap [Ron]", base, { skin = 7 } )
	Copy(accessories, "Cap [Meteorite]", base, { skin = 8 } )
	Copy(accessories, "Cap [Dusche]", base, { skin = 9 } )
	Copy(accessories, "Cap [Vespucci]", base, { skin = 10 } )
	Copy(accessories, "Cap [Orang Tang]", base, { skin = 11 } )
	
	ui_CamPos = Vector(-79.87, -27.42, 13.93)
	ui_FOV = 9.39
	ui_LookAng = Angle(8.18, 19.04, 0)	

	local base = New(accessories, "Headphones [Red]", {price = 750, model = "models/modified/headphones.mdl", bone = HEAD_B, offsetV = Vector(1, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Headphones [Pink]", base, { skin = 1 } )
	Copy(accessories, "Headphones [Gr]", base, { skin = 2 } )
	Copy(accessories, "Headphones [Yellow]", base, { skin = 3 } )
	
	ui_CamPos = Vector(87.5, 34.1, 23.45)
	ui_FOV = 12.42
	ui_LookAng = Angle(13.59, -158.38, 0)	

	local base = New(accessories, "Beer [Pisswasser]", {price = 750, model = "models/sal/acc/fix/beerhat.mdl", bone = HEAD_B, offsetV = Vector(2, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Beer [Supa Wet]", base, { skin = 1 } )
	Copy(accessories, "Beer [Patriot]", base, { skin = 2 } )
	Copy(accessories, "Beer [Benedict]", base, { skin = 3 } )
	Copy(accessories, "Beer [Blarneys]", base, { skin = 4 } )
	Copy(accessories, "Beer [J Lager]", base, { skin = 5 } )

	ui_CamPos = Vector(63.67, 29.81, 43.99)
	ui_FOV = 23.45
	ui_LookAng = Angle(20.44, -154.1, 0)	

	local base = New(accessories, "Scarf [White]", {price = 750, model = "models/sal/acc/fix/scarf01.mdl", bone = SPINE_B2, offsetV = Vector(-14, 3, 0), offsetA = Angle(180, 100, 90), mini_category = "Neck", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(accessories, "Scarf [Grey]", base, { skin = 1 } )
	Copy(accessories, "Scarf [Black]", base, { skin = 2 } )
	Copy(accessories, "Scarf [Dark Blue]", base, { skin = 3 } )
	Copy(accessories, "Scarf [Red]", base, { skin = 4 } )
	Copy(accessories, "Scarf [Green]", base, { skin = 5 } )
	Copy(accessories, "Scarf [Pink]", base, { skin = 6 } )
end
------------------------------------

-- GMod Tower: Accessories Pack --
if BH_ACC.Addons["148215278"] then
	ui_CamPos = Vector(73.99, 43.83, 8.7)
	ui_FOV = 17.17
	ui_LookAng = Angle(2.99, -150.29, 0)	

	New(accessories, "Afro", {price = 45, model = "models/captainbigbutt/skeyler/hats/afro.mdl", bone = HEAD_B, offsetV = Vector(1.5, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(76.07, 33.79, 23.91)
	ui_FOV = 15.36
	ui_LookAng = Angle(16.07, -155.92, 0)	
	
	New(accessories, "Afro 2", {price = 45, model = "models/gmod_tower/afro.mdl", bone = HEAD_B, offsetV = Vector(4.5, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Cowboy Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/cowboyhat.mdl", bone = HEAD_B, offsetV = Vector(6.5, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.7, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV} )
	New(accessories, "Fedora", {price = 45, model = "models/captainbigbutt/skeyler/hats/fedora.mdl", bone = HEAD_B, offsetV = Vector(4.5, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.7, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV} )

	ui_CamPos = Vector(-65.31, -52.54, 1.92)
	ui_FOV = 12.26
	ui_LookAng = Angle(-2.32, 39.01, 0)	

	New(accessories, "Heart Band", {price = 45, model = "models/captainbigbutt/skeyler/hats/heartband.mdl", bone = HEAD_B, offsetV = Vector(2, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Maid Band", {price = 45, model = "models/captainbigbutt/skeyler/hats/maid_headband.mdl", bone = HEAD_B, offsetV = Vector(2, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.7, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(59, 57.39, 19.27)
	ui_FOV = 13.75
	ui_LookAng = Angle(10.75, -136.1, 0)	

	New(accessories, "Santa Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/santa.mdl", bone = HEAD_B, offsetV = Vector(4.5, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.7, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(56.72, 60.81, 9.16)
	ui_FOV = 13.1
	ui_LookAng = Angle(2.62, -132.95, 0)	

	New(accessories, "Star Band", {price = 45, model = "models/captainbigbutt/skeyler/hats/starband.mdl", bone = HEAD_B, offsetV = Vector(2, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-85.28, -3.08, 6.75)
	ui_FOV = 15.32
	ui_LookAng = Angle(4.08, 2.2, 0)
	
	New(accessories, "Straw Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/strawhat.mdl", bone = HEAD_B, offsetV = Vector(4.5, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(15.42, 77.16, 32.75)
	ui_FOV = 15.32
	ui_LookAng = Angle(22.26, -98.91, 0)	

	New(accessories, "Sun Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/sunhat.mdl", bone = HEAD_B, offsetV = Vector(3.6, -2, 0), offsetA = Angle(180, 100, 90), scale = 0.73, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(2.24, 86.46, -11.73)
	ui_FOV = 7.49
	ui_LookAng = Angle(-7.33, 268.71, 0)	

	New(accessories, "Top Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/tophat02.mdl", bone = HEAD_B, offsetV = Vector(7, 1.7, -0.5), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV  } )
	
	ui_CamPos = Vector(-58.67, -58.98, 1.08)
	ui_FOV = 11.47
	ui_LookAng = Angle(-0.57, 45.03, 0)	

	New(accessories, "Z Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/zhat.mdl", bone = HEAD_B, offsetV = Vector(3, 0, -0.33), offsetA = Angle(180, 100, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(76.56, 41.07, 4.75)
	ui_FOV = 7.96
	ui_LookAng = Angle(2.85, -151.12, 0)	

	New(accessories, "BaseBall Cap", {price = 45, model = "models/gmod_tower/baseballcap.mdl", bone = HEAD_B, offsetV = Vector(5, 0, -0.2), offsetA = Angle(180, 100, 90), scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-78.05, -33.9, 1.64)
	ui_FOV = 9.44
	ui_LookAng = Angle(0.76, 23.63, 0)

	New(accessories, "Fedora Hat", {price = 45, model = "models/gmod_tower/fedorahat.mdl", bone = HEAD_B, offsetV = Vector(5, 0, -0.2), offsetA = Angle(180, 100, 90), scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-78.61, -22.7, 10.81)
	ui_FOV = 11.76
	ui_LookAng = Angle(4.43, 15.81, 0)	
	
	New(accessories, "Nightmare Hat", {price = 45, model = "models/gmod_tower/halloween_nightmarehat.mdl", bone = HEAD_B, offsetV = Vector(3, 0, -0.2), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(70.4, 53.44, 10.86)
	ui_FOV = 26.46
	ui_LookAng = Angle(10.71, -142.73, 0)	

	New(accessories, "HeadCrab Hat", {price = 45, model = "models/gmod_tower/headcrabhat.mdl", bone = HEAD_B, offsetV = Vector(7.5, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(63.8, 57.4, 6.87)
	ui_FOV = 10.56
	ui_LookAng = Angle(3.81, -137.87, 0)	

	New(accessories, "Headphones", {price = 45, model = "models/gmod_tower/headphones.mdl", bone = HEAD_B, offsetV = Vector(3, 0, -0.1), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(64.51, -50.27, 22.9)
	ui_FOV = 13.7
	ui_LookAng = Angle(12.33, 142.18, 0)	

	New(accessories, "KFC Bucket", {price = 45, model = "models/gmod_tower/kfcbucket.mdl", bone = HEAD_B, offsetV = Vector(3, 1, 0), offsetA = Angle(180, 100, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-82.21, 20.35, 12.59)
	ui_FOV = 6.7
	ui_LookAng = Angle(6.91, -13.89, 0)	

	New(accessories, "King Boos", {price = 45, model = "models/gmod_tower/king_boos_crown.mdl", bone = HEAD_B, offsetV = Vector(5, 1, 0), offsetA = Angle(180, 100, 90), scale = 1.3, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(65.36, 36.19, 41.6)
	ui_FOV = 12.26
	ui_LookAng = Angle(28.44, 205.52, 0)	

	New(accessories, "Link Hat", {price = 45, model = "models/gmod_tower/linkhat.mdl", bone = HEAD_B, offsetV = Vector(2, 0, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(65.09, 43.6, 18.05)
	ui_FOV = 17.17
	ui_LookAng = Angle(8.77, 214.04, 0)	

	New(accessories, "Midna Hat", {price = 45, model = "models/gmod_tower/midnahat.mdl", bone = HEAD_B, offsetV = Vector(1.8, 1, 0), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(70.38, 46.88, 6.93)
	ui_FOV = 11.14
	ui_LookAng = Angle(2.64, -146.31, 0)	

	New(accessories, "Pilgrim Hat", {price = 45, model = "models/gmod_tower/pilgrimhat.mdl", bone = HEAD_B, offsetV = Vector(3, 1, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-35.59, 77.95, 0.3)
	ui_FOV = 9.44
	ui_LookAng = Angle(-0.42, -66.08, 0)	

	New(accessories, "Santa [Small]", {price = 45, model = "models/gmod_tower/santahat.mdl", bone = HEAD_B, offsetV = Vector(4, 1, 0), offsetA = Angle(180, 100, 90), scale = 1.15, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-68.33, 46.35, 11.51)
	ui_FOV = 17.12
	ui_LookAng = Angle(3.25, -34.06, 0)	

	New(accessories, "Seuss Hat", {price = 45, model = "models/gmod_tower/seusshat.mdl", bone = HEAD_B, offsetV = Vector(3, 1, 0), offsetA = Angle(180, 100, 90), scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(64.97, 53.63, 17.72)
	ui_FOV = 7.96
	ui_LookAng = Angle(10.72, -139.66, 0)	

	New(accessories, "Team Rocket", {price = 45, model = "models/gmod_tower/teamrockethat.mdl", bone = HEAD_B, offsetV = Vector(3, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-39.09, 72.49, 15.97)
	ui_FOV = 14.56
	ui_LookAng = Angle(7.08, -61.06, 0)	
	
	New(accessories, "Top Hat 2", {price = 45, model = "models/gmod_tower/tophat.mdl", bone = HEAD_B, offsetV = Vector(3.3, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV  } )
	New(accessories, "Turkey", {price = 45, model = "models/gmod_tower/turkey.mdl", bone = HEAD_B, offsetV = Vector(5, 0, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV  } )
	New(accessories, "Witch Hat", {price = 45, model = "models/gmod_tower/witchhat.mdl", bone = HEAD_B, offsetV = Vector(4, 0, 0), offsetA = Angle(90, 100, 90), scale = 1.2, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV} )
	New(accessories, "Cubone Skull", {price = 45, model = "models/lordvipes/cuboneskull/cuboneskull.mdl", bone = HEAD_B, offsetV = Vector(0, 1.5, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "General Pepper", {price = 45, model = "models/lordvipes/generalpepperhat/generalpepperhat.mdl", bone = HEAD_B, offsetV = Vector(2, 0.5, 0.33), offsetA = Angle(180, 100, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Klonoa Hat", {price = 45, model = "models/lordvipes/klonoahat/klonoahat.mdl", bone = HEAD_B, offsetV = Vector(2, 0.6, 0), offsetA = Angle(180, 100, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(66.8, 36.63, 39.87)
	ui_FOV = 11.11
	ui_LookAng = Angle(22.56, -151.32, 0)	

	New(accessories, "Luigi Hat", {price = 45, model = "models/lordvipes/luigihat/luigihat.mdl", bone = HEAD_B, offsetV = Vector(-0.33, 0, 0), offsetA = Angle(180, 90, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(67.19, 47.04, 23.57)
	ui_FOV = 10
	ui_LookAng = Angle(12.58, -144.61, 0)	
	
	New(accessories, "Mario Hat", {price = 45, model = "models/lordvipes/mariohat/mariohat.mdl", bone = HEAD_B, offsetV = Vector(0, 0, 0), offsetA = Angle(180, 90, 90), scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Peach Crown", {price = 45, model = "models/lordvipes/peachcrown/peachcrown.mdl", bone = HEAD_B, offsetV = Vector(3.5, 2, 0.2), offsetA = Angle(180, 110, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(63.05, 56.59, 10.38)
	ui_FOV = 11.76
	ui_LookAng = Angle(5.09, -136.87, 0)	
	
	New(accessories, "Reds Hat", {price = 45, model = "models/lordvipes/redshat/redshat.mdl", bone = HEAD_B, offsetV = Vector(2.5, 0, 0), offsetA = Angle(180, 110, 90), scale = 0.78, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(28.4, 78.7, 17.74)
	ui_FOV = 29.49
	ui_LookAng = Angle(0.41, -113.16, 0)	

	New(accessories, "Toad Hat", {price = 45, model = "models/lordvipes/toadhat/toadhat.mdl", bone = HEAD_B, offsetV = Vector(0, 3, 0), offsetA = Angle(180, 110, 90), scale = 0.4, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(73.26, 39.86, 0.93)
	ui_FOV = 18.55
	ui_LookAng = Angle(-1.55, -150.66, 0)	
	
	New(accessories, "Viewtiful Joe", {price = 45, model = "models/lordvipes/viewtifuljoehelmet/viewtifuljoehelmet.mdl", bone = HEAD_B, offsetV = Vector(1, 0, 0), offsetA = Angle(180, 110, 90), scale = 0.7, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(68.2, 39.1, 35.62)
	ui_FOV = 13.06
	ui_LookAng = Angle(23.73, -149.95, 0)	

	New(accessories, "Frog Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/frog_hat.mdl", bone = HEAD_B, offsetV = Vector(4, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.64, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(70.07, 44.18, 18.62)
	ui_FOV = 10
	ui_LookAng = Angle(11.78, -147.56, 0)	

	New(accessories, "Cat Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/cat_hat.mdl", bone = HEAD_B, offsetV = Vector(4, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(61.13, 56.04, 22.57)
	ui_FOV = 6.7
	ui_LookAng = Angle(13.89, -137.28, 0)	

	New(accessories, "Cat Hat [White]", {price = 45, model = "models/gmod_tower/toetohat.mdl", bone = HEAD_B, offsetV = Vector(3, 0, 0), offsetA = Angle(180, 100, 90), scale = 1.25, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(67.98, 48.7, 22.68)
	ui_FOV = 9.42
	ui_LookAng = Angle(15.24, -144.31, 0)	

	New(accessories, "Bear Hat", {price = 45, model = "models/captainbigbutt/skeyler/hats/bear_hat.mdl", bone = HEAD_B, offsetV = Vector(5, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(66.63, 45.52, 23.66)
	ui_FOV = 11.11
	ui_LookAng = Angle(10.78, -145.73, 0)	

	New(accessories, "Cat Ears", {price = 750, model = "models/captainbigbutt/skeyler/hats/cat_ears.mdl", bone = HEAD_B, offsetV = Vector(0, 2, 0), offsetA = Angle(180, 100, 90), scale = 0.6, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(67.62, 48.15, 22.11)
	ui_FOV = 6.68
	ui_LookAng = Angle(13.5, -144.51, 0)
	
	New(accessories, "Cat Ears [Pink]", {price = 750, model = "models/gmod_tower/catears.mdl", bone = HEAD_B, offsetV = Vector(3, 2, 0), offsetA = Angle(180, 100, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(60.28, 56.71, 16.79)
	ui_FOV = 11.76
	ui_LookAng = Angle(7.86, -136.64, 0)
	
	New(accessories, "Bunny Ears", {price = 750, model = "models/captainbigbutt/skeyler/hats/bunny_ears.mdl", bone = HEAD_B, offsetV = Vector(3, 0, 0), offsetA = Angle(180, 100, 90), scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(54.62, -62.28, -4.95)
	ui_FOV = 9.44
	ui_LookAng = Angle(-6.25, 131.23, 0)
	
	New(accessories, "Party Hat", {price = 450, model = "models/gmod_tower/partyhat.mdl", bone = HEAD_B, offsetV = Vector(4, 0, 1), offsetA = Angle(180, 100, 110), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(61.21, 53.6, 16.81)
	ui_FOV = 17.85
	ui_LookAng = Angle(9.44, -140.22, 0)
	
	New(accessories, "Chicken Hat", {price = 45, model = "models/lordvipes/billyhatcherhat/billyhatcherhat.mdl", bone = HEAD_B, offsetV = Vector(2, 1, 0.5), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(70.77, 35.89, 15.55)
	ui_FOV = 14.07
	ui_LookAng = Angle(7.44, -152.92, 0)
	
	New(accessories, "Bhoon's Hat", {price = 450, model = "models/captainbigbutt/skeyler/hats/devhat.mdl", bone = HEAD_B, offsetV = Vector(3, 0.8, 0), offsetA = Angle(180, 110, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV, user = { "owner", "76561198078444928" } } )
	
	ui_CamPos = Vector(68.58, -13.2, 58.04)
	ui_FOV = 59.37
	ui_LookAng = Angle(-0.43, -190.96, 0)	

	New(accessories, "BlackMage Hat", { price = 450, model = "models/lordvipes/blackmage/blackmage_hat.mdl", bone = HEAD_B, offsetV = Vector(-15,3,0), offsetA = Angle(180,100,90), scale = 0.4, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
----------------------------------

-- Russian Hat Ushanka --
if BH_ACC.Addons["354739227"] then
	ui_CamPos = Vector(-65.6, -43.34, 28.84)
	ui_FOV = 7.96
	ui_LookAng = Angle(11.8, 33.57, 0)	
	
	New(accessories, "Ushanka", {price = 450, model = "models/russianhat1.mdl", bone = HEAD_B, offsetV = Vector(-7, 0, 0), offsetA = Angle(0, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-------------------------

-- Polished Military Beret- FO3 HAT --
if BH_ACC.Addons["158532239"] then
	ui_CamPos = Vector(52.82, 65.02, 16.4)
	ui_FOV = 7.86
	ui_LookAng = Angle(10.87, -130.06, 0)	
	
	local base = New(accessories, "Beret [Red]", {price = 50, model = "models/fallout 3/polish_beret.mdl", bone = HEAD_B, offsetV = Vector(5, 1, 1), offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV} )
	Copy(accessories, "Beret [Black]", base, { skin = 1 } )
	Copy(accessories, "Beret [Green]", base, { skin = 2 } )
end
--------------------------------------

-- Ducks --
if BH_ACC.Addons["109312509"] then
	ui_CamPos = Vector(-34.13, 76.16, 17.87)
	ui_FOV = 6.7
	ui_LookAng = Angle(9.96, -65.66, 0)
	
	New(accessories, "Duck [Head]", {price = 50, model = "models/mld/duck.mdl", bone = HEAD_B, offsetV = Vector(5, 0, 0), offsetA = Angle(90, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Duck", {price = 50, model = "models/mld/duck.mdl", bone = SPINE_B2, offsetV = Vector(8, 0, -4.5), offsetA = Angle(-90, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-----------

-- KF2 Cosmetics --
if BH_ACC.Addons["438680332"] then
	ui_CamPos = Vector(69.24, 41.58, 22.14)
	ui_FOV = 9.33
	ui_LookAng = Angle(12.2, -148.69, 0)	

	New(accessories, "Albert Hat", {price = 50, model = "models/splinks/kf2/cosmetics/albert_hat.mdl", bone = HEAD_B, offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Bowler Hat", {price = 50, model = "models/splinks/kf2/cosmetics/bowler_hat.mdl", bone = HEAD_B, offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(79.15, 32.78, 6.21)
	ui_FOV = 13.06
	ui_LookAng = Angle(2.91, -157.06, 0)	

	New(accessories, "Briar's Helmet", {price = 50, model = "models/splinks/kf2/cosmetics/briars_helmet.mdl", bone = HEAD_B, offsetV = Vector(0, 0, 0.2), offsetA = Angle(180, 90, 90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(71.08, 42.32, 22.99)
	ui_FOV = 7.93
	ui_LookAng = Angle(12.61, -148.75, 0)

	New(accessories, "Coleman Hat", {price = 50, model = "models/splinks/kf2/cosmetics/coleman_hat.mdl", bone = HEAD_B, offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Scully Beanie", {price = 50, model = "models/splinks/kf2/cosmetics/scully_beanie.mdl", bone = HEAD_B, offsetA = Angle(180, 90, 90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Scully Phones", {price = 50, model = "models/splinks/kf2/cosmetics/scullyphones.mdl", bone = HEAD_B, offsetA = Angle(180, 90, 90), scale = 0.9, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(77.28, 36.32, 15.39)
	ui_FOV = 7.1
	ui_LookAng = Angle(9.07, -154.03, 0)	

	New(face, "3D Glasses 2", {price = 50, model = "models/splinks/kf2/cosmetics/3d_glasses.mdl", bone = HEAD_B, offsetV = Vector(0.5, -0.33, 0), offsetA = Angle(180, 90, 90), mini_category = "Glasses" , ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(74.17, 40.5, 18.34)
	ui_FOV = 15.36
	ui_LookAng = Angle(11.98, -151.24, 0)	

	New(face, "Gas Mask [KF2]", {price = 50, model = "models/splinks/kf2/cosmetics/gas_mask.mdl", bone = HEAD_B, offsetA = Angle(180, 90, 90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV  } )

	ui_CamPos = Vector(69.82, 51.31, 12.15)
	ui_FOV = 7.96
	ui_LookAng = Angle(9.01, -143.13, 0)
	
	New(face, "Bandana [Tanaka]", {price = 50, model = "models/splinks/kf2/cosmetics/tanaka_bandana.mdl", bone = HEAD_B, offsetV = Vector(0.77, -0.5, 0), offsetA = Angle(180, 90, 90), scale = 1.15, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end

-- Mister Saturn --
if BH_ACC.Addons["192625869"] then
	ui_CamPos = Vector(64.91, 54.27, 15.15)
	ui_FOV = 20.13
	ui_LookAng = Angle(9.12, -139.65, 0)	
	
	New(accessories, "Mister Saturn", {price = 10000, model = "models/nintendo/mother/saturn.mdl", bone = HEAD_B, offsetV = Vector(9, 0, 0), offsetA = Angle(180, 90, 90), scale = 0.55, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-------------------

-- Red Scarf --
if BH_ACC.Addons["1273845833"] then
	ui_CamPos = Vector(-76.63, -20.69, 58.67)
	ui_FOV = 15.41
	ui_LookAng = Angle(30.03, -345.75, 0)	
	
	New(accessories, "Red Scarf", { price = 500, model = "models/molly/cute/scarf.mdl", bone = SPINE_B2, offsetV = Vector(-11,3,-1.8), offsetA = Angle(180,100,90), mini_category = "Neck", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
---------------

-- Roman Helmets --
if BH_ACC.Addons["938751644"] then
	ui_CamPos = Vector(-79.04, -15.5, 12.16)
	ui_FOV = 19.07
	ui_LookAng = Angle(3.17, 11.35, 0)	
	
	New(accessories, "Roman Helmet", { price = 650, model = "models/roman_helmet/roman_helmet1.mdl", bone = HEAD_B, offsetV = Vector(-2,1,0), offsetA = Angle(0,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-51.6, -27.8, 91.43)
	ui_FOV = 29.36
	ui_LookAng = Angle(5.81, 28.21, 0)	

	New(accessories, "Roman Helmet 1", { price = 650, model = "models/roman_helmet/roman_helmet2.mdl", bone = HEAD_B, offsetV = Vector(-78,15,0.1), offsetA = Angle(0,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-54.71, -33.66, 84.61)
	ui_FOV = 20.26
	ui_LookAng = Angle(16.63, -689.18, 0)	

	New(accessories, "Roman Helmet 2", { price = 650, model = "models/roman_helmet/roman_helmet3.mdl", bone = HEAD_B, offsetV = Vector(-62.5,13,0), offsetA = Angle(-14,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-75.94, -31.21, 11.19)
	ui_FOV = 13.06
	ui_LookAng = Angle(4.42, 22.22, 0)	

	New(accessories, "Roman Helmet 3", { price = 650, model = "models/roman_helmet/roman_helmet4.mdl", bone = HEAD_B, offsetV = Vector(-2,1,0), offsetA = Angle(0,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-75.61, -30.91, 13.13)
	ui_FOV = 14.29
	ui_LookAng = Angle(5.27, 22.38, 0)

	New(accessories, "Roman Helmet 4", { price = 650, model = "models/roman_helmet/roman_helmet5.mdl", bone = HEAD_B, offsetV = Vector(-2,1,0), offsetA = Angle(0,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Roman Helmet 5", { price = 650, model = "models/roman_helmet/roman_helmet6.mdl", bone = HEAD_B, offsetV = Vector(-2,1,0), offsetA = Angle(0,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Roman Helmet 6", { price = 650, model = "models/roman_helmet/roman_helmet7.mdl", bone = HEAD_B, offsetV = Vector(-2,1,0), offsetA = Angle(0,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-------------------

-- Dezel's Hat --
if BH_ACC.Addons["759456969"] then
	ui_CamPos = Vector(-76.08, -82.66, 22.16)
	ui_FOV = 7.8
	ui_LookAng = Angle(8.67, 47.23, 0)

	New(accessories, "Dezel's Hat", { price = 450, model = "models/dezel's hat/dezelhat.mdl", bone = HEAD_B, offsetV = Vector(1.8,1,0.3), offsetA = Angle(180,110,90), scale = 0.95, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-----------------

-- Crown --
if BH_ACC.Addons["783516789"] then
	ui_CamPos = Vector(63.31, 57.73, 8.06)
	ui_FOV = 7.1
	ui_LookAng = Angle(3.76, 222.32, 0)	
	
	New(accessories, "Crown", { price = 450, model = "models/crown/crown.mdl", bone = HEAD_B, offsetV = Vector(3.9,0.7,-0.1), offsetA = Angle(180,110,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-----------

-- Hokage Hats --
if BH_ACC.Addons["301607701"] then
	ui_CamPos = Vector(66.81, 28.03, 75.06)
	ui_FOV = 18.07
	ui_LookAng = Angle(5.42, -157.01, 0)	
	
	New(accessories, "Hokage", { price = 250, model = "models/hats/hokage.mdl", bone = HEAD_B, offsetV = Vector(-66.4,12,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Kazekage", { price = 450, model = "models/hats/kazekage.mdl", bone = HEAD_B, offsetV = Vector(-65.4,12,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Mizukage", { price = 450, model = "models/hats/mizukage.mdl", bone = HEAD_B, offsetV = Vector(-65,12,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Raikage", { price = 450, model = "models/hats/raikage.mdl", bone = HEAD_B, offsetV = Vector(-66,12,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Tsuchikage", { price = 450, model = "models/hats/tsuchikage.mdl", bone = HEAD_B, offsetV = Vector(-66,12,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
-----------------

-- Fallout 3 Accessories --
if BH_ACC.Addons["734200566"] then
	ui_CamPos = Vector(-53.46, -48.76, 51.13)
	ui_FOV = 23.68
	ui_LookAng = Angle(21.34, 42.6, 0)	

	New(face, "[Fo3] Diver", { price = 650, model = "models/fo3_diver.mdl", bone = HEAD_B, offsetV = Vector(-23,0,2.4), offsetA = Angle(0,88,97), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(71.59, 40.29, 26.9)
	ui_FOV = 7.96
	ui_LookAng = Angle(14.48, -147.22, 0)

	New(accessories, "[Fo3] General Cap", { price = 350, model = "models/fo3_general_cap.mdl", bone = HEAD_B, offsetV = Vector(-0.5,0,-4.4), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(105.06, 60.03, 14.57)
	ui_FOV = 8.78
	ui_LookAng = Angle(7.11, -150.64, 0)	

	New(accessories, "[Fo3] Aviator Helm", { price = 250, model = "models/fallout 3/aviator_helmet.mdl", bone = HEAD_B, offsetV = Vector(2.8,1,0.2), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(65.03, 55.34, 14.76)
	ui_FOV = 7.96
	ui_LookAng = Angle(8.51, -141.06, 0)	
	
	New(accessories, "[Fo3] Confederate Hat", { price = 350, model = "models/fallout 3/confederate_hat.mdl", bone = HEAD_B, offsetV = Vector(3,2.5,1.8), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(60.59, 61, 13.5)
	ui_FOV = 7.51
	ui_LookAng = Angle(9.97, -140.34, 0)	

	New(accessories, "[Fo3] Officer Cap", { price = 250, model = "models/fallout 3/enclave_officer_cap.mdl", bone = HEAD_B, offsetV = Vector(8,8.3,4.8), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(14.85, -27.66, -80.2)
	ui_FOV = 17.79
	ui_LookAng = Angle(-111.57, -63.14, 0)	

	local base = New(back, "Kukri", { price = 500, model = "models/fallout 3/kukri.mdl", bone = SPINE_B2, offsetV = Vector(0,4.5,-1), offsetA = Angle(161.6,8,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	Copy(back, "Kukri [Clean]", base, { skin = 1 } )
	
	ui_CamPos = Vector(81.43, 22.59, 11.57)
	ui_FOV = 5.98
	ui_LookAng = Angle(7.42, -165.98, 0)	
	
	New(face, "[FO3] Goggles", { price = 250, model = "models/fallout 3/motorcycle_goggles.mdl", bone = HEAD_B, offsetV = Vector(2.5,5.2,1), offsetA = Angle(180,100,90), mini_category = "Glasses", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(76.18, 37.33, 5.99)
	ui_FOV = 8.92
	ui_LookAng = Angle(2.91, -155.81, 0)

	New(accessories, "[FO3] Motorcycle Helm", { price = 350, model = "models/fallout 3/motorcycle_helmet.mdl", bone = HEAD_B, offsetV = Vector(2.9,3,2), offsetA = Angle(180,100,90), mini_category = "Helmets", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
----------------------------

-- Fallout 3 Custom Accessories --
if BH_ACC.Addons["705986207"] then
	ui_CamPos = Vector(-38.68, 65.65, 27.03)
	ui_FOV = 12.38
	ui_LookAng = Angle(15.23, -55.97, 0)	

	New(face, "[FO3] Aqua Mask", { price = 350, model = "models/fo3_aqua_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Camo Mask", { price = 350, model = "models/fo3_camo_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Flag Mask", { price = 350, model = "models/fo3_flag_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Grim Mask", { price = 350, model = "models/fo3_grim_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Gtool Mask", { price = 350, model = "models/fo3_gtool_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Ironman Mask", { price = 350, model = "models/fo3_ironman_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Jason Mask", { price = 350, model = "models/fo3_jason_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Metal Mask", { price = 350, model = "models/fo3_metal_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Punisher Mask", { price = 350, model = "models/fo3_punisher_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Skull Mask", { price = 350, model = "models/fo3_skull_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Spawn Mask", { price = 350, model = "models/fo3_spawn_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(face, "[FO3] Talon Mask", { price = 350, model = "models/fo3_talon_mask.mdl", bone = HEAD_B, offsetV = Vector(-3,0.5,-4.7), offsetA = Angle(90,82,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
----------------------------------

-- Kingdom Hearts Crowns --
if BH_ACC.Addons["894768926"] then
	ui_CamPos = Vector(-60.23, 59.98, 9.09)
	ui_FOV = 7.51
	ui_LookAng = Angle(4.38, -44.98, 0)	
	
	New(accessories, "Crown [Bronze]", { price = 450, model = "models/ianmata1998/kingdomhearts2/crown_bronce.mdl", bone = HEAD_B, offsetV = Vector(5,-0.5,0.5), offsetA = Angle(180,120.2,112.4), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Crown [Silver]", { price = 450, model = "models/ianmata1998/kingdomhearts2/crown_silver.mdl", bone = HEAD_B, offsetV = Vector(5,-0.5,0.5), offsetA = Angle(180,120.2,112.4), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "Crown [Gold]", { price = 450, model = "models/ianmata1998/kingdomhearts2/crown_gold.mdl", bone = HEAD_B, offsetV = Vector(5,-0.5,0.5), offsetA = Angle(180,120.2,112.4), scale = 0.8, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
---------------------------

-- Hat Pack --
if BH_ACC.Addons["358462651"] then
	ui_CamPos = Vector(59.45, 55.37, 21.94)
	ui_FOV = 10.71
	ui_LookAng = Angle(6.08, -136.22, 0)	
	
	New(face, "Red Bandana", { price = 150, model = "models/hats/bandana/bandana.mdl", bone = HEAD_B, offsetV = Vector(-17,3.6,-0.1), offsetA = Angle(180,100,90), scale = 1.1, ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(-70.07, -44.94, 23.01)
	ui_FOV = 1.61
	ui_LookAng = Angle(15.17, 32.63, 0)

	New(face, "Cigarette", { price = 5, model = "models/hats/cig/cig.mdl", bone = HEAD_B, offsetV = Vector(-0.3,7,-0.4), offsetA = Angle(15.1,97.8,122.4), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(69.26, 48.21, 18.33)
	ui_FOV = 2.02
	ui_LookAng = Angle(11.69, -145.2, 0)

	New(face, "Cigar", { price = 10, model = "models/hats/cigar/cigar.mdl", bone = HEAD_B, offsetV = Vector(-0.3,7,-1), offsetA = Angle(-155,115,104.5), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(57.07, 57.76, 26)
	ui_FOV = 7.91
	ui_LookAng = Angle(13.78, -134.58, 0)

	New(accessories, "Hat Pack Fedora", { price = 250, model = "models/hats/fedora/fedora.mdl", bone = HEAD_B, offsetV = Vector(-0.5,1.5,0), offsetA = Angle(12.9,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(68.78, 46.13, 6.69)
	ui_FOV = 14.6
	ui_LookAng = Angle(-0.53, -145.74, 0)

	New(face, "Skimask", { price = 250, model = "models/hats/skimask/skimask.mdl", bone = HEAD_B, offsetV = Vector(-6.3,2,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end
--------------

-- Roblox hats --
if BH_ACC.Addons["129736354"] then
	ui_CamPos = Vector(65.15, 53.35, 6.98)
	ui_FOV = 14.85
	ui_LookAng = Angle(0.25, -140.48, 0)
	
	New(face, "[RB] Paper Bag", { price = 125, model = "models/paperbag/paperbag.mdl", bone = HEAD_B, offsetV = Vector(-4.7,2,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(69.09, 48.78, 6.31)
	ui_FOV = 9.91
	ui_LookAng = Angle(2.09, -144.82, 0)	

	New(accessories, "[RB] American Hat", { price = 650, model = "models/americahat/americahat.mdl", bone = HEAD_B, offsetV = Vector(4,0.8,0), offsetA = Angle(180,110,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	New(accessories, "[RB] Beer Hat", { price = 250, model = "models/beerhat/beerhat.mdl", bone = HEAD_B, offsetV = Vector(4,0,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(59.55, 62.09, -5.43)
	ui_FOV = 11.14
	ui_LookAng = Angle(-3.89, -133.62, 0)		

	New(accessories, "[RB] Bunny Ears", { price = 125, model = "models/bunnyears/bunnyears.mdl", bone = HEAD_B, offsetV = Vector(6,0,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(76.96, 37.8, 4.24)
	ui_FOV = 7.1
	ui_LookAng = Angle(1.7, -153.76, 0)	

	New(accessories, "[RB] Captain Hat", { price = 275, model = "models/captainshat/captainshat.mdl", bone = HEAD_B, offsetV = Vector(4.8,0,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(68.76, 50.28, 11.44)
	ui_FOV = 9.97
	ui_LookAng = Angle(6.56, -143.52, 0)
	
	New(accessories, "[RB] Police Hat [Pink]", { price = 250, model = "models/gaypolicehat/gaypolicehat.mdl", bone = HEAD_B, offsetV = Vector(4,0,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )

	ui_CamPos = Vector(82.15, 20.31, 4.65)
	ui_FOV = 10
	ui_LookAng = Angle(0.81, -166.14, 0)
	
	New(accessories, "[RB] High Hat", { price = 175, model = "models/highhat/highhat.mdl", bone = HEAD_B, offsetV = Vector(3.0,0.8,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(67.76, 51.84, 10.4)
	ui_FOV = 7.51
	ui_LookAng = Angle(5.83, -142.23, 0)

	New(accessories, "[RB] Mario Hat", { price = 225, model = "models/mariohat/mariohat.mdl", bone = HEAD_B, offsetV = Vector(3.7,0.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(60.79, 59.2, 6.54)
	ui_FOV = 13.1
	ui_LookAng = Angle(2.51, -135.81, 0)

	New(accessories, "[RB] Mushroom", { price = 75, model = "models/mushroom/mushroom.mdl", bone = HEAD_B, offsetV = Vector(4,0,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-80.06, 18.84, 21.71)
	ui_FOV = 11.76
	ui_LookAng = Angle(11.65, -13.25, 0)
	
	New(accessories, "[RB] Party Hat", { price = 25, model = "models/partyhat/partyhat.mdl", bone = HEAD_B, offsetV = Vector(4.5,-1,1), offsetA = Angle(180,112,121.3), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-83.26, 9.64, 9.1)
	ui_FOV = 11.14
	ui_LookAng = Angle(3, -6.7, 0)

	New(accessories, "[RB] Party Hat 2", { price = 30, model = "models/partyhat2/partyhat2.mdl", bone = HEAD_B, offsetV = Vector(4.5,-1,1), offsetA = Angle(180,120,121.3), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(70.12, 47.57, 14.57)
	ui_FOV = 9.44
	ui_LookAng = Angle(8.77, -145.5, 0)
	
	New(accessories, "[RB] Police Hat", { price = 125, model = "models/policehat/policehat.mdl", bone = HEAD_B, offsetV = Vector(3.5,0.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(-31.94, 78.62, 14.76)
	ui_FOV = 9.42
	ui_LookAng = Angle(9.22, -67.88, 0)
	
	New(accessories, "[RB] Salesman Hat", { price = 75, model = "models/salesmanhat/salesmanhat.mdl", bone = HEAD_B, offsetV = Vector(4.5,0.5,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(76.4, 39.17, 13.33)
	ui_FOV = 6.7
	ui_LookAng = Angle(8.72, -152.56, 0)

	New(accessories, "[RB] Half Hat", { price = 150, model = "models/solarthing/solarthing.mdl", bone = HEAD_B, offsetV = Vector(4,0,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
	
	ui_CamPos = Vector(79.92, 28.64, 12.53)
	ui_FOV = 9.97
	ui_LookAng = Angle(7.37, -160.15, 0)
	
	New(accessories, "[RB] Viros Hat", { price = 150, model = "models/viroshat/viroshat.mdl", bone = HEAD_B, offsetV = Vector(3.3,0.1,0), offsetA = Angle(180,100,90), ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end

if BH_ACC.Addons["2174343063"] then
	ui_CamPos = Vector(80.47, 34.8, 8.86)
	ui_FOV = 6.52
	ui_LookAng = Angle(5.55, -157.17, 0)	
	
	New(face, "Surgical Mask", { price = 125, model = "models/rebs/maske/maske.mdl", bone = HEAD_B, offsetV = Vector(0,4.9,0), offsetA = Angle(180,100,90), mini_category = "Masks", ui_CamPos = ui_CamPos, ui_LookAng = ui_LookAng, ui_FOV = ui_FOV } )
end





if not next(BH_ACC.Addons) then
	if not BH_ACC.Showed_AddonErrorPrint then
		BH_ACC.Showed_AddonErrorPrint = true

		if SERVER then
			MsgC( BH_ACC.ChatTagColors["error"], BH_ACC.ChatTag, color_white, " " .. BH_ACC.Language["No_Enabled_Addons"] .. "\n")
		else
			chat.AddText(BH_ACC.ChatTagColors["error"], BH_ACC.ChatTag, color_white, " " .. BH_ACC.Language["No_Enabled_Addons"] .. "\n")
		end
	end
end

--------------------------------



if CLIENT then
-- Model specific offsets --
-- Normally you wouldnt have to use this if your playermodels have normal bones and your using the hl base but if ur not on that then use this --
BH_ACC.ModelOffsets = {
	----------------------------------------------------------------
	-- Heres some space for you if you wanna add your own offsets --

















	----------------------------------------------------------------
	-- Below here are just default added offsets --
	["models/player/breen.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.33, 0, 0.2)
		},
		[SPINE_B2] = {
			pos = Vector(2.33, -1.77, 0)
		},
	},
	["models/player/alyx.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0, -0.5, 0.2)
		},
	},
	["models/player/p2_chell.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.1, -0.3, 0.1)
		},
	},
	["models/player/barney.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.5, 0.33, 0.05)
		},
		[SPINE_B2] = {
			pos = Vector(4, -1.5, 0)
		},
	},
	["models/player/monk.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.33, -0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4, -1, 0)
		},
	},
	["models/player/gman_high.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.5, -0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3, -1.77, 0)
		},
	},
	["models/player/odessa.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.77, 0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(2.33, -1.77, 0)
		},
	},
	["models/player/mossman.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.2, 0, 0.15)
		},
	},
	["models/player/eli.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, -0.77, 0.15)
		},
		[SPINE_B2] = {
			pos = Vector(2.77, -1.77, 0)
		},
	},
	["models/player/charple.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-0.33, -2, 0)
		},
		[SPINE_B2] = {
			pos = Vector(2, -1.77, 0)
		},
	},
	["models/player/soldier_stripped.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-0.33, -1.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(2, -1.77, 0)
		},
	},

	["models/player/group01/male_01.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 0.77, 0)
		},
		[SPINE_B2] = {
			pos = Vector(2.5, -1.5, 0)
		},
	},
	["models/player/group01/male_02.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/group01/male_04.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.33, -0.15, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/group01/male_05.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.77, -0.1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/group01/male_06.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.33, 0.77, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/group01/male_08.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.77, -0.4, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/group01/male_09.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 0.21, 0.1)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},

	["models/player/group02/male_02.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.33, 0.1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/group02/male_04.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.4, -0.1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},

	["models/player/group01/female_02.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.15, 0.33, 0.1)
		},
	},
	["models/player/group01/female_03.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0, 0.33, 0.1)
		},
	},
	["models/player/group01/female_04.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.05, 0.1, 0.05)
		},
	},
	["models/player/group01/female_05.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.33, 0.1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},

	-- GMT PLAYERMODEL OFFSETS --
	["models/player/anon/anon.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.5, 0.2, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, 0, 0)
		},
	},
	["models/player/dude.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.5, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4.5, 0, 0)
		},
	},
	["models/player/hunter.mdl"] = {
		[SPINE_B2] = {
			pos = Vector(5, 0, 0)
		},
	},
	["models/vinrax/player/jack_player.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.5, -0.5, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, 0, 0)
		},
	},
	["models/player/jack_sparrow.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.77, 1.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, 0, 0)
		},
	},
	["models/player/joker.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2, -1.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -1, 0)
		},
	},
	["models/player/leon.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-0.77, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.5, -2, 0)
		},
	},
	["models/player/normal.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.77, 0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -1, 0)
		},
	},
	["models/player/robber.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.77, 0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4, -1, 0)
		},
	},
	["models/player/romanbellic.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.33, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -2, 0)
		},
	},
	["models/player/rorschach.mdl"] = {
		[HEAD_B] = {
			pos = Vector(3.33, 0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(7, -2, 0)
		},
	},
	["models/player/sam.mdl"] = {
		[HEAD_B] = {
			pos = Vector(3.77, -1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(7, -2, 0)
		},
	},
	["models/player/skeleton.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.77, -2, 0)
		},
	},
	["models/player/scarecrow.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.33, 1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -2, 0)
		},
	},
	["models/player/scorpion.mdl"] = {
		[HEAD_B] = {
			pos = Vector(3, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(7, -2, 0)
		},
	},
	["models/player/shaun.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 0.41, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4, -2, 0)
		},
	},
	["models/player/smith.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.33, -1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -2, 0)
		},
	},
	["models/player/lordvipes/haloce/spartan_classic.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0, 1.5, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4, -2, 0)
		},
	},
	["models/player/drpyspy/spy.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.77, -1.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4.5, -2, 0)
		},
	},
	["models/player/subzero.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.5, -2.5, 0)
		},
		[SPINE_B2] = {
			pos = Vector(6, -2, 0)
		},
	},
	["models/player/teslapower.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.5, 1.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(7, -2, 0)
		},
	},
	["models/player/dishonored_assassin1.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4, -2, 0)
		},
	},
	["models/player/zoey.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.33, -1.77, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3, -2, 0)
		},
	},
	["models/nikout/carleypm.mdl"] = {
		[HEAD_B] = {
			pos = Vector(3.77, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.5, 0, 0)
		},
	},
	["models/norpo/arkhamorigins/assassins/deathstroke_valvebiped.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-0.33, -0.5, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4.5, 0, 0)
		},
	},
	["models/player/big_boss.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-1, -1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(2, -1, 0)
		},
	},
	["models/player/chewbacca.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1, 1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(6.5, -1, 0)
		},
	},
	["models/player/chris.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(6.5, -1, 0)
		},
	},
	["models/player/faith.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-0.33, -0.5, 0)
		},
		[SPINE_B2] = {
			pos = Vector(0, -1, 0)
		},
	},
	["models/player/freddykruger.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.33, -0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(6.33, -2, 0)
		},
	},
	["models/player/gordon.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.5, -1, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -1, 0)
		},
	},
	["models/player/greenarrow.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.5, 2, 0)
		},
		[SPINE_B2] = {
			pos = Vector(5, -2, 0)
		},
	},
	["models/player/masseffect.mdl"] = {
		[HEAD_B] = {
			pos = Vector(3, 1.5, 0)
		},
		[SPINE_B2] = {
			pos = Vector(6, -2, 0)
		},
	},
	["models/player/samusz.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.33, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(1, -1, 0)
		},
	},
	["models/player/lordvipes/bl_clance/crimsonlanceplayer.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-0.77, 0, 0)
		},
		[SPINE_B2] = {
			pos = Vector(4, -1, 0)
		},
	},
	["models/player/lordvipes/metal_gear_rising/gray_fox_playermodel_cvp.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0, 0.6, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/sunabouzu.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.33, 0.33, 0)
		},
		[SPINE_B2] = {
			pos = Vector(3.33, -1, 0)
		},
	},
	["models/player/security_suit.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.58, 1.43, 0),
			scale = Vector(0.32, 0.32, 0.32),
		},
	},
	["models/player/midna.mdl"] = {
		[HEAD_B] = {
			pos = Vector(11.90, 1.75, 0),
			scale = Vector(1.76, 2.51, 1.72),
		},
		[SPINE_B2] = {
			pos = Vector(6.88, 0, 0),
		},
	},
	["models/player/clopsy.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.15, 0.43, 0),
		},
	},
	["models/player/mcsteve.mdl"] = {
		[HEAD_B] = {
			pos = Vector(9.25, 0.86, 0),
			scale = Vector(1.94, 3.66, 2.58),
		},
	},
	["models/player/foohysaurusrex.mdl"] = {
		[HEAD_B] = {
			pos = Vector(9.8, 0.72, 0),
			scale = Vector(0.9, 0.5, 0.36),
		},
		[SPINE_B2] = {
			pos = Vector(5.73, -0.86, 0),
		},
	},
	["models/player/zelda.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.15, 1, 0),
		},
		[SPINE_B2] = {
			pos = Vector(1.5, 0, 0),
		},
	},
	["models/player/robot.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.57, 2.15, 0),
			scale = Vector(0.25, 0.25, 0.25),
		},
		[SPINE_B2] = {
			pos = Vector(3.58, 0, 0),
		},
	},
	["models/player/aphaztech.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.08, 0, 0),
		},
	},
	["models/player/altair.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-1.15, -0.43, 0),
		}
	},
	["models/player/nuggets.mdl"] = {
		[HEAD_B] = {
			pos = Vector(5.16, -0.86, 0),
			scale = Vector(0.93, 0.93, 0.93),
		}
	},
	["models/player/haroldlott.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.65, 1.08, 0.22),
		}
	},
	["models/player/rayman.mdl"] = {
		[HEAD_B] = {
			pos = Vector(4.09, -6.02, 0),
			angle = Angle(0, 11.61, 0),
			scale = Vector(1.18, 0.79, 0.72),
		}
	},
	["models/player/raz.mdl"] = {
		[HEAD_B] = {
			pos = Vector(16.77, -1.51, 0),
			scale = Vector(2.26, 4.70, 2.29),
		}
	},
	["models/player/knight.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0.29, 3.15, 0),
		}
	},
	["models/player/harry_potter.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.57, 0.72, 0),
			scale = Vector(0.22, 0.22, 0.22),
		}
	},
	["models/player/jawa.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0, 0, 0),
			scale = Vector(0.75, 0.79, 0.39),
		}
	},
	["models/player/gmen.mdl"] = {
		[HEAD_B] = {
			pos = Vector(9.3, 0, 0.72),
		}
	},
	["models/player/martymcfly.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.58, 1.72, 0),
			scale = Vector(0.25, 0.25, 0.25),
		}
	},
	["models/player/suluigi_galaxy.mdl"] = {
		[HEAD_B] = {
			pos = Vector(16.77, -2.37, 0),
			scale = Vector(1.83, 2.15, 1.79),
		}
	},
	["models/player/stormtrooper.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.51, 1, 0),
			scale = Vector(0.47, 0.57, 0.47),
		}
	},
	["models/player/sumario_galaxy.mdl"] = {
		[HEAD_B] = {
			pos = Vector(13.9, 0.65, 0.22),
			scale = Vector(3.51, 3.41, 2.94),
		}
	},
	["models/player/lordvipes/MMZ/Zero/zero_playermodel_cvp.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-5.59, 0, 0),
			scale = Vector(0.29, 0.29, 0.29),
		}
	},
	["models/player/lordvipes/mmz/zero/zero_playermodel_cvp.mdl"] = {
		[HEAD_B] = {
			pos = Vector(-5.59, 0, 0),
			scale = Vector(0.29, 0.29, 0.29),
		}
	},
	["models/player/yoshi.mdl"] = {
		[HEAD_B] = {
			pos = Vector(27, -5.30, 0),
			scale = Vector(3.80, 3.80, 3.80),
		}
	},
	["models/player/spacesuit.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2, 1.08, 0),
		}
	},
	["models/Agent_47/agent_47.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.85, 1, 0),
		}
	},
	["models/agent_47/agent_47.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.85, 1, 0),
		}
	},
	["models/player/alice.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.7, 0, 0),
			scale = Vector(0.18, 0.18, 0.18),
		}
	},
	["models/player/red.mdl"] = {
		[HEAD_B] = {
			pos = Vector(1.58, 0, 0),
			scale = Vector(0.50, 0.50, 0.50),
		}
	},
	["models/vinrax/player/megaman64_no_gun_player.mdl"] = {
		[HEAD_B] = {
			pos = Vector(2.37, -3.30, 0.43),
			scale = Vector(0.79, 0.79, 0.75),
		}
	},
	["models/ex-mo/quake3/players/doom.mdl"] = {
		[HEAD_B] = {
			pos = Vector(0, 0.86, 0),
			scale = Vector(0.25, 0.25, 0.25),
		}
	},
	["models/player/linktp.mdl"] = {
		[HEAD_B] = {
			pos = Vector(3.15, 0.86, 0),
			scale = Vector(0.43, 0.43, 0.43),
		}
	},
}

local ModelOffsets = BH_ACC.ModelOffsets

ModelOffsets["models/player/mossman_arctic.mdl"] = ModelOffsets["models/player/mossman.mdl"]
ModelOffsets["models/player/group01/male_03.mdl"] = ModelOffsets["models/player/group01/male_01.mdl"]
ModelOffsets["models/player/group02/male_02.mdl"] = ModelOffsets["models/player/group01/male_09.mdl"]
ModelOffsets["models/player/group01/male_07.mdl"] = ModelOffsets["models/player/group01/male_05.mdl"]
ModelOffsets["models/player/group02/male_06.mdl"] = ModelOffsets["models/player/group01/male_06.mdl"]
ModelOffsets["models/player/group02/male_08.mdl"] = ModelOffsets["models/player/group01/male_08.mdl"]
for i = 1,4 do
	ModelOffsets["models/player/group03/female_0" .. i .. ".mdl"] = ModelOffsets["models/player/group01/female_0" .. i .. ".mdl"]
end
ModelOffsets["models/player/group03/female_05.mdl"] = ModelOffsets["models/player/group03/female_03.mdl"]
ModelOffsets["models/player/group03/female_06.mdl"] = ModelOffsets["models/player/group03/female_03.mdl"]

for i = 1,6 do
	ModelOffsets["models/player/group03m/female_0" .. i .. ".mdl"] = ModelOffsets["models/player/group03/female_0" .. i .. ".mdl"]
end

for i = 1,9 do
	ModelOffsets["models/player/group03m/male_0" .. i .. ".mdl"] = ModelOffsets["models/player/group01/male_0" .. i .. ".mdl"]
end
ModelOffsets["models/player/hostage/hostage_01.mdl"] = ModelOffsets["models/player/group01/male_05.mdl"]
ModelOffsets["models/player/hostage/hostage_02.mdl"] = ModelOffsets["models/player/group01/male_06.mdl"]
ModelOffsets["models/player/hostage/hostage_03.mdl"] = ModelOffsets["models/player/group01/male_08.mdl"]
ModelOffsets["models/player/hostage/hostage_04.mdl"] = ModelOffsets["models/player/group01/male_09.mdl"]

end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "bh_acc_items_config")
end