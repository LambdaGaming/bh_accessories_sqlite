-- Enabled Left categories --
-- Here you can disable any of the main category by setting it to false --
    BH_ACC.LeftCategories = {
        ["APPEARANCE"] = true,
        ["HELP"] = true,
        ["POSITIONER"] = true,
        ["EDITOR"] = true
    }
--

-- Chat Tag --
    BH_ACC.ChatTag = "[BH Accessories]"
    BH_ACC.ChatTagMySQL = "[BH Accessories MySQL]"
    BH_ACC.ChatTagColors = {
        ["error"] = Color(255,0,0),
        ["ok"] = Color(64, 194, 230),
    }
--

-- Tool --
    -- Usergroups that are allowed to use the npc spawning tool --
    BH_ACC.NPCToolUsergroups = {
        ["superadmin"] = true,
    }
----------

-- Vendor --
	BH_ACC.Enable_Vendor_Accessories = true

	-- Here you can put all of the accessories the vendor should have on him --
	-- Must have BH_ACC.Enable_Vendor_Accessories enabled or this will not do anything --
	BH_ACC.Vendor_Accessories = {
		"Fedora [Grey]",
		"Bandana",
		"Backpack [Black]"
	}
--

-- Positioner --
	-- All the ranks that can access the positioner for the accessory adjustments --
	BH_ACC.PositionerRanks = {
		--["owner"] = true,
		--["superadmin"] = true
	}

	-- All the ranks that can access the positioner for the playermodel adjustments --
	BH_ACC.PositionerPMDLRanks = {
		["owner"] = true,
		["superadmin"] = true
	}

	-- Slider values --
	-- These are the maximum and minimum amount the player can adjust their accessory -- for ex. 5 would be from -5 to 5
	BH_ACC.PositionerPos = 5
	BH_ACC.PositionerAng = 180
	BH_ACC.PositionerScale = 1

	-- These are the min max amounts for the playermodels offests --
	BH_ACC.PositionerPMDLPos = 30
	BH_ACC.PositionerPMDLAng = 180
	BH_ACC.PositionerPMDLScale = 5

	-- Save all adjustments players make to database? --
	BH_ACC.PositionerSaveToDB = true
--

-- Editor --
	-- All the ranks that can access the editor --
	BH_ACC.EditorRanks = {
		["owner"] = true,
		["superadmin"] = true
	}

	BH_ACC.EditorPos = 30
	BH_ACC.EditorAng = 180
	BH_ACC.EditorScale = 5
--

-- Net Message delay --
BH_ACC.NetDelay = 0.5
--

-- Maximum amount of characters the player can enter for the gifting message --
BH_ACC.GiftMessageMaxLength = 150
--

-- Set to true to allow players use the chat commands below to open the shop --
BH_ACC.CommandOpen = true
--

-- Should the accessories draw while arrested ? --
BH_ACC.DrawWhileArrested = true
--

-- Should the accessories show while dead ? --
BH_ACC.DrawWhileDead = true
--

-- Should the last credit step be there ? --
BH_ACC.Help_Credit = true
--

-- Should players be able to hover and preview an accessory ? --
-- The accessories they preview will only show for him noone else -- ( Doesn't Cause lag )
BH_ACC.Preview_Enabled = true
--

---- Chat commands to open the accessory shop ----
-- These will only work if CommandOpen is set to true --
-- The system automatically supports both "!" and "/" for the symbol infront of the text --
BH_ACC.OpenCommands = {
	["/accessory"] = true,
	["/accessories"] = true,
	["/acc"] = true
}
for k,v in pairs(BH_ACC.OpenCommands) do
	BH_ACC.OpenCommands[k:lower():Trim():Replace("!", "/")] = true -- Don't touch this code
end
--

-----------------------

-- In units / Dist where the accessories get rendered --
-- 0 for infinite distance --
BH_ACC.RenderDistance = 0
--

-- What ranks / usergroups should be able to use the system ? --
BH_ACC.Allowed_Ranks = {
	-- If this table is empty then everyone can access it --
	-- ["owner"] = true
}
--

-- This is how much the items can be bought for ( price * 0.5 ) --
BH_ACC.BuyFraction = 0.5
--

-- Buy fraction for ranks/usergroups --
-- This will override BH_ACC.Buy_Fraction --
BH_ACC.BuyFraction_Ranks = {
--	["owner"] = 1,
--	["vip"] = 0.75
}
--

-- Buy fraction for steamid64s --
-- This will override both Buy_fraction and Buy_Fraction_Ranks --
BH_ACC.BuyFraction_SteamID64 = {
--	["76561198078444928"] = 0.75
}
--

-- This is how much the items can be sold for ( price * 0.5 ) --
BH_ACC.SellFraction = 0.5
--

-- Sell fraction for ranks/usergroups --
-- This will override BH_ACC.Sell_Fraction --
BH_ACC.SellFraction_Ranks = {
--	["owner"] = 1,
--	["vip"] = 0.75
}
--

-- Sell fraction for steamid64s --
-- This will override both Sell_fraction and Sell_Fraction_Ranks --
BH_ACC.SellFraction_SteamID64 = {
--	["76561198078444928"] = 0.75
}
--

------------------------

-- Font for everything else than npc --
BH_ACC.Font = "Roboto"
--

-- The text above the NPC font
BH_ACC.NPC_Font = "Circular Std Bold"
--

-- All the materials used on UI --
BH_ACC.Materials = {
	["user"] = Material("bh_accessories/user.png"),
	["rocket"] = Material("bh_accessories/rocket.png"),
	["help"] = Material("bh_accessories/help.png"),
	["wrench"] = Material("bh_accessories/wrench.png"),
	["editor"] = Material("bh_accessories/gear.png"),

	["body"] = Material("bh_accessories/body.png"),
	["face"] = Material("bh_accessories/face.png"),
	["backpack"] = Material("bh_accessories/backpack.png"),
	["hat"] = Material("bh_accessories/hat.png"),
	["sneaker"] = Material("bh_accessories/sneakers.png"),

	["closet"] = Material( "bh_accessories/closet.png" ),
	["trashcan"] = Material( "bh_accessories/trashcan.png" ),

	["glasses"] = Material( "bh_accessories/glasses.png" ),
	["mask"] = Material( "bh_accessories/mask.png" ),
	["helmet"] = Material( "bh_accessories/helmet.png" ),
	["shawl"] = Material( "bh_accessories/shawl.png" ),
	["sword"] = Material( "bh_accessories/sword.png" ),

	["back"] = Material( "bh_accessories/reply.png" ),

	["x"] = Material( "bh_accessories/close.png" )
}

-- You can change language here
BH_ACC.Language = {
	-- Above NPC Text --
	["Accessory Vendor"] = "Accessory Vendor",
    --

	-- Swep --
	["Accessory Changer"] = "Accessory Changer",
	--

	-- Left Options of menu --
	["APPEARANCE"] = "APPEARANCE",
	["HELP"] = "HELP",
	["POSITION_OPTION"] = "POSITION",
	["EDITOR"] = "EDITOR",
    --

	-- Finish --
	["EXIT"] = "EXIT",
    --

	-- Currency symbol --
	["Currency"] = "$",
    --

	-- Description --
	["Max_Text_GiftingMSG"] = "You have %s characters left.",
	--

	-- Dropbox options --
	["Buy"] = "Buy",
	["Equip"] = "Equip",
	["Unequip"] = "Unequip",
	["Sell"] = "Sell",
	["Gift"] = "Gift",
	--

	-- Help Tab --
	["StepOne"] = "Step One: Introduction",
	["StepOneText"] = "Welcome to our store! You need some help picking the right clothing? Well in this guide i'll help you choose whats best!",

	["StepTwo"] = "Step Two: Drop box options",
	["StepTwoText"] = "Once you click on an accessory it will open a menu allowing you to buy/sell/equip/unequip/gift that accessory. Here, click on the accessory below to open the menu. This is a test accessory, clicking the options won't do anything.",

	["StepThree"] = "Step Three: Gifting",
	["StepThreeText"] = "In the gifting menu you can gift that accessory to any player you choose as long as you have enough money and that player doesn't own the accessory already. The system will notify you if he does. Below you can see how the menu looks like and on the right side you can choose which player will receive the accessory you want to gift.",

	["LastStep"] = "Last Step: Thanks!",
	["LastStepText"] = "Thanks for using our shop! Do you want to support the creator or buy this shop? Click the link below",
	
	["ClickToPreview"] = "Click here to preview the gifting menu",
	--

	-- Gifting --
	["Accessory details"] = "Accessory details",
	["Gifting menu"] = "Gifting menu",
	["Enter message"] = "Enter message",
	["Enter player name"] = "Enter player name",
	["Name:"] = "Name:",
	["Price:"] = "Price:",
	["Playermodel:"] = "Playermodel:",
	["Yes"] = "Yes",
	["No"] = "No",
	["Message"] = "Message",
	["Confirm"] = "Confirm",
	["Equippable"] = "Equippable",
	["None"] = "None",
	["Other"] = "Other",
	--

	-- Positioning Tab --
	["Already_Exists"] = "That Accessory already exists. Change its name!",
	["Note"] = "Note",
	["Adjusting_Note"] = "This menu allows you to adjust your accessories changing their position, angle or scale so the model can fit nicely. Note the changes you apply will affect all playermodels.",
	["Position"] = "Position",
	["Angle"] = "Angle",
	["Scale"] = "Scale",
	["Enter name"] = "Enter name",
	["Enter model"] = "Enter model",
	["Accessories"] = "Accessories",
	["Equipped"] = "Equipped",
	["ClickToPick"] = "Click to pick an accessory",
	["Accessory"] = "Accessory",
	["Playermodel"] = "Playermodel",
	["Playermodels"] = "Playermodels",
	["Bone:"] = "Bone:",
	["ClickToPickBone"] = "Click to pick a bone",
	["PModel_PositionerText"] = "In this menu you can adjust the position, angle and scale for accessories related to a certain playermodel. Note, it will only adjust those accessories related to the selected bone.",
	["OR"] = "OR",
	["EnterModel"] = "Enter model path",
	["Model:"] = "Model:",
	["ClickToPickModel"] = "Click to pick a playermodel",
	["Bones"] = "Bones",
    --

	-- Editor --
	["Enter description"] = "Enter description",
	["EDIT"] = "EDIT",
	["Editor_Text"] = "In this menu you can create, edit or delete accessories. You can also adjust the UI position of the accessory just by clicking the item box under this text.",
	["Simple_Pos"] = "Enable Simple Position",
	["Description"] = "Description",
	["NoPrice"] = "No Price",
	["DontNeedBone"] = "Playermodels don't require bones",
	["EnterBone"] = "Enter bone",
	["DontNeedMat"] = "Playermodels don't need a material",
	["Enter material"] = "Enter material",
    ["Material:"]= "Material:",
    ["Skin:"] = "Skin:",
    ["Usergroups:"] = "Usergroups:",
	["DontNeedSkin"] = "Playermodels don't need skins",
    ["IsPModel"] = "Is Player-Model",
	["All Allowed"] = "All Allowed",
	["Add new"] = "Add new",
	["DontNeedPosition"] = "Playermodels don't require positioning",
	["Delete"] = "Delete",
	["Save"] = "Save",
	["Create"] = "Create",
	["CREATE"] = "CREATE",
	["NEW"] = "NEW",
    --

    -- Tool --
    ["Tool_Title"] = "BH Accessories - NPC Spawn Points",
    ["Tool_Description"] = "Add and remove spawn points",
    ["AddSpawn"] = "Add spawn",
    ["DeleteSpawn"] = "Delete the spawn you are looking at",
    ["DeleteAll"] = "Delete all spawns",
    ["NoAccessTool"] = "You don't have permission to use this tool!",
    ["DeleteAllTool"] = "You deleted %s spawns!",
    --
    
    -- Not important text --
        -- These are just notifications when you mess something up in the config file --
        -- The reason these exist is because maybe in the future i will add other languages and i will change these --
        ["MainCat_NoName"] = "You created a main category without a name!",
        ["MainCat_DupeName"] = "You created a main category that has a duplicate name! Name of main category:",

        ["MiniCat_NoName"] = "You created a mini category without a name!",
        ["MiniCat_NoCat"] = "You created a mini category without a main category! Name of mini category:",
        ["MiniCat_NonExistantCat"] = "You created a mini category that has a non existant main category! Name of mini category:",
        ["MiniCat_DupeName"] = "You created a mini category that has a duplicate name! Name of mini category:",
        
        ["Accessory_NoName"] = "You have created an accessory without a name!",
        ["Accessory_NoPrice"] = "You have created an accessory without a price! Name for accessory:",
        ["Accessory_NoBone"] = "You have created an accessory without a bone! Name for accessory:",
        ["Accessory_NoModel"] = "You have created an accessory without a model! Name for accessory:",
        ["Accessory_NoCat"] = "You have created an accessory without a main_category! Name for accessory:",
        ["Accessory_NonExistantCat"] = "You have created an accessory that has a non existant main category! Name for accessory:",
        ["Accessory_NonExistantMiniCat"] = "You have created an accessory that has a non existant mini category! Name for accessory:",
        ["Accessory_DupeName"] = "You have created an accessory that has a duplicated name! Name for accessory:",

        ["Refreshed_Items"] = "We detected that you refreshed your item config. The config won't be refreshed to protect you from breaking the editor! Please restart your server.",
        ["No_Enabled_Addons"] = "We detected that you haven't enabled any addons. Check sh_bh_acc_items.lua!",
        --
    --

    -- Notification Text --
        -- First %s represents the item name while the second %s is the amount it was sold/bought for
        ["Notify_Sold"] = "Successfully sold %s for %s!",
        ["Notify_Bought"] = "Successfully bought %s for %s!",
        ["Notify_Equipped"] = "Successfully equipped %s!",
        ["Notify_Unequipped"] = "Successfully unequipped %s!",

        -- Other Notifications --
        ["Notify_Already_Owns"] = "You already own this accessory!",
        ["Notify_No_Money"] = "You don't have enough money to purchase this accessory!",
        ["Notify_Cant_Buy"] = "You don't have access to this accessory!",
        ["Notify_NotNear_Vendor"] = "You are too far way from the vendor!",
        ["Notify_NoAccesstoSystem"] = "You don't have access to use this vendor!",
        --

        -- Gifting --
        ["Notify_Gift_No_Money"] = "You don't have enough money to buy and gift this accessory!",
        ["Notify_Gift_NoPlayer"] = "This player doesn't exist!",
        ["Notify_Gift_MsgTooBig"] = "The message you entered exceeds " .. BH_ACC.GiftMessageMaxLength .. " characters!",
        ["Notify_Gift_CantBuy"] = "This player doesn't have access to that accessory!",
        ["Notify_Gift_AlreadyHas"] = "This player already owns that accessory!",
        ["Notify_Gift_NoAccessToSystem"] = "This player doesn't have access to the store!",

        ["ChatTag_GiftByMe"] = "You have successfully gifted %s an %s!", -- first %s is a player second is the accessory
        ["ChatTag_GiftByOther"] = "You have received an %s from %s with message: %s", -- item, player, message
        --

        -- Positioner --
        ["Notify_Adjustment_Saved"] = "Successfully saved adjustment!",
        ["Notify_PModel_Saved"] = "Successfully saved adjustment!",
        --

        -- Editor --
        ["Notify_Editor_NoName"] = "You need to enter a valid name!",
        ["Notify_Editor_AlreadyExist"] = "There's already an accessory with that name!",
        ["Notify_Editor_NoModel"] = "You need to enter a valid model!",
        ["Notify_Editor_Create"] = "Successfully created accessory",
        ["Notify_Editor_Save"] = "Successfully edited accessory",
        ["Notify_Editor_Delete"] = "Successfully deleted accessory"
        --
    --
}

-- Notifications --
-- Notifications require text, a notification type and a sound --
-- Notification text can be changed in the Language table coresponding to it's key --

-- Types of notifications --
-- NOTIFY_GENERIC -- Generic notification --
-- NOTIFY_ERROR -- Error notification --
-- NOTIFY_UNDO -- Undo notification --
-- NOTIFY_HINT -- Hint notification --
-- NOTIFY_CLEANUP -- Cleanup notification --
BH_ACC.Notifications = {
	-- First %s represents the item name while the second %s is the amount it was sold/bought for
	["Notify_Sold"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	["Notify_Bought"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	--

	-- %s ( item name ) --
	["Notify_Equipped"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	["Notify_Unequipped"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	--
    
    -- Other Notifications --
	["Notify_Already_Owns"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_No_Money"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Cant_Buy"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_NotNear_Vendor"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_NoAccesstoSystem"] = {NOTIFY_ERROR, "buttons/button24.wav"},
    --

	-- Gifting --
	["Notify_Gift_No_Money"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Gift_NoPlayer"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Gift_MsgTooBig"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Gift_CantBuy"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Gift_AlreadyHas"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Gift_NoAccessToSystem"] = {NOTIFY_ERROR, "buttons/button24.wav"},
    --

	-- Positioner --
	["Notify_Adjustment_Saved"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	["Notify_PModel_Saved"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
    --

	-- Editor --
	["Notify_Editor_NoName"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Editor_AlreadyExist"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Editor_NoModel"] = {NOTIFY_ERROR, "buttons/button24.wav"},
	["Notify_Editor_Create"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	["Notify_Editor_Save"] = {NOTIFY_GENERIC, "buttons/button24.wav"},
	["Notify_Editor_Delete"] = {NOTIFY_GENERIC, "buttons/button24.wav"}
    --
}

BH_ACC.Colors = {
    -- Main colors --
	["body"] = Color(24, 34, 58), -- The Main Color
	["body_transparent"] = Color(35, 48, 80),-- The Main Color but transparent
	["hover"] = Color(255,255,255,15), -- The color that appears when you hover on stuff
    ["hover_light"] = Color(255,255,255,2), -- This color is used as a "trim" color for small pop-up menus
	["hovercatoritem"] = Color(255,255,255,100), -- The color that appears when you hover on categories and items
	["selected_color"] = Color(255,255,255,150), -- This is the color that shows when you click on a category of accessories
	["circle_button"] = Color(0, 156, 255), -- color for the thing you click to go back to main category
	["itembg"] = Color(50,50,50,100), -- Background for categories and items ( items you own )
	["itembg_unowned"] = Color(14,13,13,250), -- Background for items that you do not own
	["picked"] = Color(50, 176, 255, 100), -- This is the background for the equipped items
	["picked_dark"] = Color(29, 37, 55, 200), -- This is the background for the equipped items

	["exit"] = Color(159, 15, 34), -- Color of the exit button
	["confirm_color"] = Color(7,112,7), -- Color of anything thats finishable
	["currency_color"] = Color(255,255,0), -- Color of player balance
    --

	-- Left categories --
	["left_cat_clicked"] = Color(255,255,255), -- Color of the rectangles for the left categories when clicked
	["unclicked_icon_left"] = Color(255,255,255,50), -- icon color for when the categories on the left aren't clicked
	["unclicked_text_left"] = Color(255,255,255,50), -- text too
	["clicked_icon_left"] = Color(0,0,0,255),
	["clicked_text_left"] = Color(0,0,0,255),
    --

	-- Categories --
	["clicked_icon"] = Color(0,0,0,255), -- color of the icons when the category is selected
	["unclicked_icon"] = Color(255,255,255,255), -- not clicked
	["unclicked_text"] = Color(255,255,255,50), -- not clicked text
    --

    -- Dropbox --
	["dropbox_color"] = Color(0,0,0,200), -- The color of the options in the dropbox menu
    --

	-- Help Menu --
	["help_body"] = Color(29, 37, 55, 200),
	["help_next"] = Color(255,255,255), -- ">" color
    --
    
	-- Gift Menu --
	["hovered_onplayer"] = Color(255,255,255,5),
	["gray_text"] = Color(150,150,150,255),
	["gift_body"] = Color(29, 37, 55, 200),
    --
    
	-- Editor --
	["addnew"] = Color(0,200,0),
	["editcol"] = Color(255,255,255,150),
    --

	-- Small Bar colors --
	["Bar_One"] = Color(100, 150, 255),
	["Bar_Two"] = Color(150,0,0),
	["Bar_Three"] = Color(0,150,0),
	["Bar_Four"] = Color(255, 255, 0),
    --

    -- Icon Colors --
	["body_icon"] = Color(255,255,255),
	["face_icon"] = Color(255,255,255),
	["backpack_icon"] = Color(255,255,255),
	["hat_icon"] = Color(255,255,255),
	["sneaker_icon"] = Color(255,255,255),
	["glasses_icon"] = Color(255,255,255),
	["mask_icon"] = Color(255,255,255),
	["helmet_icon"] = Color(255,255,255),
	["neck_icon"] = Color(255,255,255)
    --
}

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "bh_acc_config")
end