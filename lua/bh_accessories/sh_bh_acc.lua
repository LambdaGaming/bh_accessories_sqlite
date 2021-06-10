local Entity = Entity
local Vector = Vector
local Angle = Angle
local isnumber = isnumber

local table_remove = table.remove
local table_IsEmpty = table.IsEmpty

local net_Start = net.Start
local net_Broadcast = net.Broadcast
local net_Send = net.Send
local net_SendToServer = net.SendToServer

local net_WriteVector = net.WriteVector
local net_WriteAngle = net.WriteAngle
local net_WriteUInt = net.WriteUInt
local net_ReadUInt = net.ReadUInt
local net_WriteString = net.WriteString
local net_ReadString = net.ReadString
local net_WriteFloat = net.WriteFloat
local net_ReadFloat = net.ReadFloat
local net_WriteBool = net.WriteBool
local net_ReadBool = net.ReadBool

local vector_origin = vector_origin
local vector_zero = vector_zero
local pairs = pairs
local table_Copy = table.Copy
local util_PrecacheModel = util.PrecacheModel
local player_GetAll = player.GetAll

local bit_band = bit.band

local GetItemData
local GetItemDataByName

local _E = FindMetaTable("Entity")
local EntIndex = _E.EntIndex

local _P = FindMetaTable("Player")
local SteamID64 = _P.SteamID64

function BH_ACC.WritePlayer(ply)
	net_WriteUInt(EntIndex(ply), 8)
end

function BH_ACC.ReadPlayer()
	local i = net_ReadUInt(8)

	if not i then
		return
	end

	return Entity(i)
end

function BH_ACC.GetPlayerBalance(ply)
	return ply:getDarkRPVar("money")
end

function BH_ACC.SetPlayerBalance(ply, amt)
	ply:setDarkRPVar("money", amt)
end

function BH_ACC.PrintError(msg)
	MsgC(BH_ACC.ChatTagColors["error"], BH_ACC.ChatTag, BH_ACC.ChatTagColors["error"], " ERROR " .. msg .. "\n")
end
local PrintError = BH_ACC.PrintError

function BH_ACC.WriteAccessoryData(ply)
    local owned = ply.bh_acc_owned
    local amt = #owned

    net_WriteUInt(amt, 16)
    for i = 1, amt do
        net_WriteUInt(owned[i], 16)
	end
end

function BH_ACC.ReadAccessoryData()
	local ow = {}
	for i = 1, net_ReadUInt(16) do
		ow[i] = net_ReadUInt(16)
	end

	return ow
end

function BH_ACC.WriteEquippedData(ply)
    local equipped = ply.bh_acc_equipped
    local eq_amt = #equipped

    net_WriteUInt(eq_amt, 8)
    for i = 1, eq_amt do
        net_WriteUInt(equipped[i], 16)
    end
end

function BH_ACC.ReadEquippedData()
	local eq = {}
	for i = 1, net_ReadUInt(8) do
		eq[i] = net_ReadUInt(16)
	end

	return eq
end

function BH_ACC.WriteThreeFloats(v)
	net_WriteFloat(v[1])
	net_WriteFloat(v[2])
	net_WriteFloat(v[3])
end
local WriteThreeFloats = BH_ACC.WriteThreeFloats

function BH_ACC.WriteAdjustmentData(ply)
	local adjustments = ply.bh_acc_adjustments
	local adj_lookup = ply.bh_acc_adjustments_lookup
	local amt = #adj_lookup

	net_WriteUInt(amt, 16)
	for i = 1, amt do
		local model = adj_lookup[i]

		net_WriteString(model)

		local send = 0
		
		local data = adjustments[model]
		local check1 = data.pos ~= vector_origin
		local check2 = data.ang ~= angle_zero
		local check3 = data.scale ~= vector_origin

		if check1 then send = send + 1 end
		if check2 then send = send + 2 end
		if check3 then send = send + 4 end

		net_WriteUInt(send, 4)
		
		if check1 then WriteThreeFloats(data.pos) end
		if check2 then WriteThreeFloats(data.ang) end
		if check3 then WriteThreeFloats(data.scale) end
	end
end

function BH_ACC.ReadAdjustmentData(ply)
	local adjustments = {}
	for i = 1, net_ReadUInt(16) do
		local model = net_ReadString()

		local amt = net_ReadUInt(4)

		local t = {}
		if bit_band(amt, 1) > 0 then
			t.pos = Vector(net_ReadFloat(), net_ReadFloat(), net_ReadFloat())
		end

		if bit_band(amt, 2) > 0 then
			t.ang = Angle(net_ReadFloat(), net_ReadFloat(), net_ReadFloat())
		end

		if bit_band(amt, 4) > 0 then
			t.scale = Vector(net_ReadFloat(), net_ReadFloat(), net_ReadFloat())
		end

        t.pos = vector_origin
        t.ang = angle_zero
        t.scale = vector_origin

		adjustments[model] = t
	end

	return adjustments
end

function BH_ACC.WritePMDLAdjustmentData()
	local mdloffsets = BH_ACC.AddedModelOffsets

	if !mdloffsets then return end

	local amt = #mdloffsets

	net_WriteUInt(amt, 16)
	
	for k = 1, amt do
		local v = mdloffsets[k]

		net_WriteString(v.model)

		local offsets = v.offsets
		local sndamt = #offsets

		net_WriteUInt(sndamt, 8)

		for i = 1, sndamt do
			local o = offsets[i]

			net_WriteString(o.bone)

			local send = 0
		
			local check1 = o.pos ~= vector_origin
			local check2 = o.ang ~= angle_zero
			local check3 = o.scale ~= vector_origin

			if check1 then send = send + 1 end
			if check2 then send = send + 2 end
			if check3 then send = send + 4 end

			net_WriteUInt(send, 4)
			
			if check1 then WriteThreeFloats(o.pos) end
			if check2 then WriteThreeFloats(o.ang) end
			if check3 then WriteThreeFloats(o.scale) end
		end
	end
end

function BH_ACC.ReadPMDLAdjustmentData()
	local mdloffsets = BH_ACC.ModelOffsets

	for k = 1, net_ReadUInt(16) do
		local model = net_ReadString()

		mdloffsets[model] = mdloffsets[model] or {}
		local mdlt = mdloffsets[model]

		for i = 1, net_ReadUInt(8) do
			local bone = net_ReadString()

			local amt = net_ReadUInt(4)

			local t = {}
			if bit_band(amt, 1) > 0 then
				t.pos = Vector(net_ReadFloat(), net_ReadFloat(), net_ReadFloat())
			end

			if bit_band(amt, 2) > 0 then
				t.ang = Angle(net_ReadFloat(), net_ReadFloat(), net_ReadFloat())
			end

			if bit_band(amt, 4) > 0 then
				t.scale = Vector(net_ReadFloat(), net_ReadFloat(), net_ReadFloat())
			end

			mdlt[bone] = t
		end
	end
end

function BH_ACC.WriteEditorData()
	local edd = BH_ACC.EditedAccessories
	local amt = #edd

	net_WriteUInt(amt, 16)

	for k = 1, amt do
		local v = edd[k]
		net_WriteString(v.name)
		net_WriteString(v.category)
		net_WriteBool(v.IsPlayerModel)
		net_WriteBool(v.ui_Simple)
        net_WriteBool(v.disabled)
		
		local send = 0

		local check1 = v.mini_category
		local check2 = v.description
		local check3 = v.model
		local check4 = v.price
		local check5 = v.bone
		local check6 = v.material
		local check7 = v.skin
		local check8 = v.offsetV
		local check9 = v.offsetA
		local check10 = v.scale
		local check11 = v.ui_FOV
		local check12 = v.ui_CamPos
		local check13 = v.ui_LookAng
	
		if check1 then send = send + 1 end
		if check2 then send = send + 2 end
		if check3 then send = send + 4 end
		if check4 then send = send + 8 end
		if check5 then send = send + 16 end
		if check6 then send = send + 32 end
		if check7 then send = send + 64 end
		if check8 then send = send + 128 end
		if check9 then send = send + 256 end
		if check10 then send = send + 512 end
		if not v.ui_Simple then
			if check11 then send = send + 1024 end
			if check12 then send = send + 2048 end
			if check13 then send = send + 4096 end
		end

		net_WriteUInt(send, 16)
		if check1 then net_WriteString(check1) end
		if check2 then net_WriteString(check2 or "") end
		if check3 then net_WriteString(check3) end
		if check4 then net_WriteUInt(check4, 32) end
		if check5 then net_WriteString(check5) end
		if check6 then net_WriteString(check6) end
		if check7 then net_WriteUInt(check7, 8) end
		if check8 then WriteThreeFloats(check8) end
		if check9 then WriteThreeFloats(check9) end
		if check10 then WriteThreeFloats(check10) end
		if not v.ui_Simple then
			if check11 then net_WriteFloat(check11) end
			if check12 then WriteThreeFloats(check12) end
			if check13 then WriteThreeFloats(check13) end
		end
	end
end

local math_Round = math.Round
local function ReadThreeFloatsAndRound()
	return math_Round(net_ReadFloat(), 2), math_Round(net_ReadFloat(), 2), math_Round(net_ReadFloat(), 2)
end
function BH_ACC.ReadEditorData()
	BH_ACC.EditedAccessories = {}
	local edd = BH_ACC.EditedAccessories

	for i = 1, net_ReadUInt(16) do
		edd[i] = {}

		local t = edd[i]
		
		t.name = net_ReadString()
		t.category = net_ReadString()
		t.IsPlayerModel = net_ReadBool()
		t.ui_Simple = net_ReadBool()
        t.disabled = net_ReadBool()

		local send = net_ReadUInt(16)

		t.mini_category = bit_band(send, 1) > 0 and net_ReadString()
		t.description = bit_band(send, 2) > 0 and net_ReadString()
		t.model = bit_band(send, 4) > 0 and net_ReadString()
		t.price = bit_band(send, 8) > 0 and net_ReadUInt(32)
		t.bone = bit_band(send, 16) > 0 and net_ReadString()
		t.material = bit_band(send, 32) > 0 and net_ReadString()
		t.skin = bit_band(send, 64) > 0 and net_ReadUInt(8)
		t.offsetV = bit_band(send, 128) > 0 and Vector(ReadThreeFloatsAndRound())
		t.offsetA = bit_band(send, 256) > 0 and Angle(ReadThreeFloatsAndRound())
		t.scale = bit_band(send, 512) > 0 and Vector(ReadThreeFloatsAndRound())
	
		if not t.ui_Simple then
			t.ui_FOV = bit_band(send, 1024) > 0 and net_ReadFloat()
			t.ui_CamPos = bit_band(send, 2048) > 0 and Vector(ReadThreeFloatsAndRound())
			t.ui_LookAng = bit_band(send, 4096) > 0 and Angle(ReadThreeFloatsAndRound())
		end

		local olddata = GetItemDataByName(t.name)
		
		if olddata then
			t.id = olddata.id

			BH_ACC.EditorSaveUpdateItemData(olddata.id, t)
		else
			t.id = BH_ACC.GetItemCount() + 1
			
			BH_ACC.EditorCreateUpdateItemData(t)
		end
	end
end

BH_ACC.Categories = BH_ACC.Categories or {}
BH_ACC.Category_IDS = BH_ACC.Category_IDS or {}

local categories = BH_ACC.Categories
local category_ids = BH_ACC.Category_IDS

BH_ACC.Items = BH_ACC.Items or {}
BH_ACC.Item_IDS = BH_ACC.Item_IDS or {}

local items = BH_ACC.Items
local item_ids = BH_ACC.Item_IDS

BH_ACC.MiniCategories = BH_ACC.MiniCategories or {}
BH_ACC.MiniCategory_IDS = BH_ACC.MiniCategory_IDS or {}

local minicats = BH_ACC.MiniCategories
local minicat_ids = BH_ACC.MiniCategory_IDS

BH_ACC.AllCategoryCameraView = BH_ACC.AllCategoryCameraView or {}

local cat_count = #categories

function BH_ACC.CreateCategory(data)
    local name = data.name

    -- Let's run our checks now and notify the server --
	if not name then
		PrintError(BH_ACC.Language["MainCat_NoName"])
		return
	end

	if category_ids[name] then
		PrintError(BH_ACC.Language["MainCat_DupeName"] ..  " " .. name)
		return
	end

    cat_count = cat_count + 1
    
    data.allitems = {}
    categories[cat_count] = data
	
	BH_ACC.AllCategoryCameraView[name] = {data.vector, data.angle}

    category_ids[name] = cat_count
end

local minicat_count = #minicats

function BH_ACC.CreateMiniCategory(data)
    local name = data.name
    local category_name = data.category

    -- Let's run our checks now and notify the server --
    if not name then
		PrintError(BH_ACC.Language["MiniCat_NoName"])
		return
	end

	if not category_name then
		PrintError(BH_ACC.Language["MiniCat_NoCat"] .. " " .. category_name)
		return
	end

	if not category_ids[category_name] then
		PrintError(BH_ACC.Language["MiniCat_NonExistantCat"] .. " " .. category_name)
		return
	end

	if minicat_ids[name] then
		PrintError(BH_ACC.Language["MiniCat_DupeName"] .. " " .. category_name)
		return
	end

	minicat_count = minicat_count + 1
    
    data.items = {}
    minicats[minicat_count] = data

    minicat_ids[name] = minicat_count
    
    local category = categories[category_ids[category_name]]
    
    category.Mini_Categories = category.Mini_Categories or {}
    category.Mini_Categories[#category.Mini_Categories + 1] = minicat_count

	BH_ACC.AllCategoryCameraView[name] = {data.vector, data.angle}
end

local item_count = #items

BH_ACC.Precached_Models = BH_ACC.Precached_Models or {}
local precached_models = BH_ACC.Precached_Models

function BH_ACC.New(main_category, name, data)
	local model = data.model

    -- Now we can notify the server console that there's been an issue with our newly created item --
	if not name then
		PrintError(BH_ACC.Language["Accessory_NoName"])
		
		return
	end

	if not data.price then
		PrintError(BH_ACC.Language["Accessory_NoPrice"] .. " " .. name)
		
		return
	end

	if not data.IsPlayerModel and not data.bone then
		PrintError(BH_ACC.Language["Accessory_NoBone"] .. " " .. name)
		return
	end

	if not model then
		PrintError(BH_ACC.Language["Accessory_NoModel"] .. " " .. name)
		return
	end

	if not main_category then
		PrintError(BH_ACC.Language["Accessory_NoCat"] .. " " .. name)
	
		return
	end

	if not category_ids[main_category] then
		PrintError(BH_ACC.Language["Accessory_NonExistantCat"] .. " " .. name)
	
		return
	end

    local mini_category = data.mini_category
	if mini_category and not minicat_ids[mini_category] then
		PrintError(BH_ACC.Language["Accessory_NonExistantMiniCat"] .. " " .. name)
		return
	end

	if item_ids[name] then
		PrintError(BH_ACC.Language["Accessory_DupeName"] .. " " .. name)
		return
	end

    -- Increase the item count, this will act as the id of the item --
    item_count = item_count + 1

    -- Turning the scale into a Vector if it's a number --
    -- Why? Because you can just write 0.5 if you want the vector to be Vector(0.5,0.5,0.5), just makes it easier --
	local scale = data.scale
	if scale and isnumber(scale) then
		data.scale = Vector(scale, scale, scale)
	end

    -- We are also gonna create a lookup table for our allowed users table for performance --
	local userlookup = {}
	local user = data.user
	if user then
		for i = 1, #user do
			userlookup[user[i]] = true
		end

        data.userlookup = userlookup
	end

    -- Let's set the values to the data table itself rather than recreating a new one --
    -- Just so we can have that extra loading time and performance --
    data.category = main_category
    data.name = name
    data.id = item_count
    data.offsetV = data.offsetV or vector_origin
    data.offsetA = data.offsetA or angle_zero
    data.ui_Simple = data.ui_Simple or (not data.ui_CamPos and not data.ui_LookAng and not data.ui_FOV)
    disabled = data.disabled or false

    -- Inserting the data into the items table and also making a lookup to the item --
    items[item_count] = data
    item_ids[name] = item_count
    
    -- We need to insert our new created item to the table related to its category and sub-category --
    -- We do this to get the most performance as possible --
    if not mini_category then
        local category_items = categories[category_ids[main_category]].allitems
        category_items[#category_items + 1] = item_count
    else
		local minicat_items = minicats[minicat_ids[mini_category]].items
		minicat_items[#minicat_items + 1] = item_count
    end

    -- Let's precache the model if it hasn't been precached before --
	if not precached_models[model] then
		precached_models[model] = true

		util_PrecacheModel( model )
	end

	return items[item_count]
end

local New = BH_ACC.New
function BH_ACC.Copy(main_category, name, base, data)
	base = table_Copy(base)

	for k,v in pairs(data) do
		base[k]	= v
	end

	New(main_category, name, base)
end

function BH_ACC.EditorCreateUpdateItemData(newdata)
	items[newdata.id] = newdata
	item_ids[newdata.name] = newdata.id

	item_count = item_count + 1

	local category_items = categories[category_ids[newdata.category]].allitems
	category_items[#category_items + 1] = newdata.id

	if newdata.mini_category then
		local minicat_items = minicats[minicat_ids[newdata.mini_category]].items
		minicat_items[#minicat_items + 1] = newdata.id
	end

	BH_ACC.EditedAccessories[#BH_ACC.EditedAccessories + 1] = table_Copy(newdata)
end

function BH_ACC.EditorSaveUpdateItemData(oldid, newdata)
	local olddata = items[oldid]
	items[oldid] = newdata

	local oldcat = olddata.category
	local newcat = newdata.category
	if oldcat == newcat then
		local category_items = categories[category_ids[oldcat]].allitems
		for k,v in ipairs(category_items) do
			if v == oldid then
				category_items[k] = newdata.id
				break
			end
		end
	else
		for k = 1, cat_count do
			local category_items = categories[k].allitems
			for i = 1, #category_items do	
				if category_items[i] == oldid then
					table_remove(category_items, i)
					break
				end
			end
		end

		local category_items = categories[category_ids[newcat]].allitems
		category_items[#category_items + 1] = newdata.id
	end

	local oldminicat = olddata.mini_category
	local newminicat = newdata.mini_category

	if newminicat then
		if oldminicat then
			if oldminicat == newminicat then
				local minicat_items = minicats[minicat_ids[oldminicat]].items
				for k,v in ipairs(minicat_items) do
					if v == oldid then
						minicat_items[k] = newdata.id
						break
					end
				end
			else
				for k = 1, minicat_count do
					local minicat_items = minicats[k].items
					for i = 1, #minicat_items do	
						if minicat_items[i] == oldid then
							table_remove(minicat_items, i)
							break
						end
					end
				end

				local minicat_items = minicats[minicat_ids[newminicat]].items
				minicat_items[#category_items + 1] = newdata.id
			end
		else
			local minicat_items = minicats[minicat_ids[newminicat]].items
			minicat_items[#minicat_items + 1] = newdata.id
		end
	elseif oldminicat then
		for k = 1, minicat_count do
			local minicat_items = minicats[k].items
			for i = 1, #minicat_items do	
				if minicat_items[i] == oldid then
					table_remove(minicat_items, i)
					break
				end
			end
		end
	end

	local edd = BH_ACC.EditedAccessories
	for i = 1, #edd do
		if edd[i].id == oldid then
			edd[i] = table_Copy(newdata)
			break
		end
	end
end

local function RemoveFromTable_WithID(t, id)
    local i = 0
    local notfound = true
    for _ = 1, #t do
        i = i + 1
        -- Cache the id --
        local v = t[i]

        -- Save some calculations with notfound --
        if notfound and v == id then
            notfound = false
            table_remove(t, i)
            i = i - 1
        elseif v > id then
            t[i] = v - 1
        end
    end
    -- We can return i here just in case we want to use it to add something onto the table --
    return i, t
end

local function RemoveFromTable_WithItemData(t, id)
    local i = 0
    local notfound = true
    for _ = 1, #t do
        i = i + 1
        -- Cache the id --
        local v = t[i]
        local v_id = v.id

        -- Save some calculations with notfound --
        if notfound and v_id == id then
            notfound = false
            table_remove(t, i)
            i = i - 1
        elseif v_id > id then
            v.id = v_id - 1
        end
    end

    -- We can return i here just in case we want to use it to add something onto the table --
    return i, t
end

function BH_ACC.EditorRemoveAndAddNew(id, newdata)
	local olddata = items[id]

	local category_items = categories[category_ids[olddata.category]].allitems
	for k = 1, cat_count do
		RemoveFromTable_WithID(categories[k].allitems, id)
	end
	category_items[#category_items + 1] = newdata.id
    
	local newminicat = newdata.mini_category
	local oldminicat = olddata.mini_category

	if newminicat then
		if oldminicat then
			if newminicat == oldminicat then
				for k = 1, minicat_count do
					RemoveFromTable_WithID(minicats[k].items, id)
				end

				local minicat_items = minicats[minicat_ids[oldminicat]].items
				minicat_items[#minicat_items + 1] = newdata.id
			else
				for k = 1, minicat_count do
				    RemoveFromTable_WithID(minicats[k].items, id)
				end

				local minicat_items = minicats[minicat_ids[newminicat]].items
				minicat_items[#minicat_items + 1] = newdata.id
			end
		else
			local minicat_items = minicats[minicat_ids[newminicat]].items
			minicat_items[#minicat_items + 1] = newdata.id
		end
	elseif oldminicat then
		for k = 1, minicat_count do
			RemoveFromTable_WithID(minicats[k].items, id)
		end
	end

    table_remove(items, id)
    item_ids[olddata.name] = nil

    for i = id, item_count - 1 do
        local v = items[i]
    
        v.id = i
        item_ids[v.name] = i
    end

	items[item_count] = newdata
	item_ids[newdata.name] = item_count

    -- We have to use table.Copy because it will keep a reference to the actual items table --
    -- We don't want to overwrite things so we do this --
    local edd = BH_ACC.EditedAccessories
    edd[#edd + 1] = table_Copy(newdata)
end

function BH_ACC.EditorDelete(data)
	local id = data.id

	for k = 1, cat_count do
        RemoveFromTable_WithID(categories[k].allitems, id)
	end

	for k = 1, minicat_count do
        RemoveFromTable_WithID(minicats[k].items, id)
	end

	for k,v in ipairs(player_GetAll()) do
		local owned = v.bh_acc_owned
        if not owned then continue end

        v.bh_acc_owned_lookup = {}
		local owned_lookup = v.bh_acc_owned_lookup

		local equipped = v.bh_acc_equipped
        v.bh_acc_equipped_lookup = {}
		local equipped_lookup = v.bh_acc_equipped_lookup

		local find = BH_ACC.HasAccessory(v, id)
		if find then
			table_remove(owned, find)
		end

        for i = 1, #owned do
            local o = owned[i]
            
            if o > id then
                owned[i] = o - 1
            end

            owned_lookup[owned[i]] = i
        end

		local find = BH_ACC.HasEquippedAccessory(v, id)
		if find then
			if data.IsPlayerModel then
				v:SetModel(BH_ACC.GetJobModel(v))
			end

			table_remove(equipped, find)

			if CLIENT then
				BH_ACC.CreatePlayerEquipped(v)
            end
        end
        
        for i = 1, #equipped do
            local o = equipped[i]

            if o > id then
                equipped[i] = o - 1
            end

            equipped_lookup[equipped[i]] = i
        end
	end

    table_remove(items, id)
    item_ids[data.name] = nil
    
    item_count = item_count - 1
    
    for i = id, item_count do
        local v = items[i]
    
        v.id = i
        item_ids[v.name] = i
    end

    local edd = BH_ACC.EditedAccessories
    local amt = #edd
    for i = 1, amt do
        if edd[i].id == id then
            edd[i].disabled = true
        end
    end
    BH_ACC.EditedAccessories[amt + 1] = table_Copy(newdata)
end

function BH_ACC.GetItemData(id)
	return items[id]
end
GetItemData = BH_ACC.GetItemData


function BH_ACC.GetItemIDByName(name)
	return item_ids[name]
end

function BH_ACC.GetItemDataByName(name)
	return items[item_ids[name]]
end
GetItemDataByName = BH_ACC.GetItemDataByName

function BH_ACC.GetItemIDByName(name)
	return item_ids[name]
end

function BH_ACC.HasAccessory(ply, id)
	return ply.bh_acc_owned_lookup[id]
end

function BH_ACC.HasEquippedAccessory(ply, id)
	return ply.bh_acc_equipped_lookup[id]
end

function BH_ACC.GetMainCategory(id)
	return categories[id]
end

function BH_ACC.GetMainCategoryByName(name)
	return categories[category_ids[name]]
end

-- Here is where you can edit the usergroup function for supporting whatever admin system you are using --
function BH_ACC.GetRank(ply)
	local rank = "user"

	if serverguard and serverguard.player then
		rank = serverguard.player:GetRank(ply)
	elseif ply:GetUserGroup() then
		rank = ply:GetUserGroup()
	end

	return rank
end
local GetRank = BH_ACC.GetRank

function BH_ACC.CanUseSystem(ply)
	local t = BH_ACC.Allowed_Ranks
	return table_IsEmpty(t) and true or t[GetRank(ply)]
end

function BH_ACC.CanBuyAccessory(ply, id)
	local data = GetItemData(id)

	if data.user then
		local userlookup = data.userlookup
		
		return userlookup[GetRank(ply)] or userlookup[SteamID64(ply)]
	end

	return true
end

function BH_ACC.GetJobModel(ply)
    local model = ply:getJobTable().model
    if istable(model) then
        model = model[1]
    end

    return model
end

local math_Round = math.Round
function BH_ACC.GetSellPrice(ply, price)
	return math_Round(( price * ( BH_ACC.SellFraction_SteamID64[SteamID64(ply)] or BH_ACC.SellFraction_Ranks[GetRank(ply)] or BH_ACC.SellFraction )))
end

function BH_ACC.GetBuyPrice(ply, price)
	return math_Round(( price * ( BH_ACC.BuyFraction_SteamID64[SteamID64(ply)] or BH_ACC.BuyFraction_Ranks[GetRank(ply)] or BH_ACC.BuyFraction )))
end

BH_ACC.VendorEntities = BH_ACC.VendorEntities or {}
local vendor_entites = BH_ACC.VendorEntities
hook.Add( "OnEntityCreated", "BH_ACC_Update_Vendors", function( ent )
	if ent:GetClass() ~= "bh_acc_vendor" then return end
	
	vendor_entites[#vendor_entites + 1] = ent
end)

hook.Add("EntityRemoved", "BH_ACC_Remove_Vendor", function(ent)
	if ent:GetClass() ~= "bh_acc_vendor" then return end
	
	local amt = #vendor_entites
	local reali = 0
	for _ = 1, amt do
		reali = reali + 1

		local v = vendor_entites[reali]
		if not IsValid(v) or v == ent then
			table_remove(vendor_entites, reali)

			reali = reali - 1

			continue
		end
	end
end)

local DistToSqr = FindMetaTable("Vector").DistToSqr

function BH_ACC.IsNearVendor(ply)
	if BH_ACC.CommandOpen then
		return true
	end
	
	local pos = ply:GetPos()
	
	local dist = 256*256

	for k,v in ipairs(vendor_entites) do
		if DistToSqr(v:GetPos(), pos) >= dist then
			return true
		end
	end
	
	return false
end

function BH_ACC.IsEnabledLeftCategory(key)
	return BH_ACC.LeftCategories[key]
end

function BH_ACC.CanAccessPositioner(ply)
	local t = BH_ACC.PositionerRanks
	return table_IsEmpty(t) and true or t[GetRank(ply)]
end

function BH_ACC.CanAccessPMDLPositioner(ply)
	local t = BH_ACC.PositionerPMDLRanks
	return table_IsEmpty(t) and true or t[GetRank(ply)]
end

function BH_ACC.CanAccessEditor(ply)
	local t = BH_ACC.EditorRanks
	return table_IsEmpty(t) and true or t[GetRank(ply)]
end

function BH_ACC.ResetAmounts()
	cat_count = 0
	minicat_count = 0
	item_count = 0
end

function BH_ACC.UpdateAmounts()
	cat_count = #categories
	minicat_count = #minicats
	item_count = #items
end

function BH_ACC.SetItemCount(amt)
    item_count = amt
end

function BH_ACC.GetItemCount()
	return item_count
end

function BH_ACC.GetCatAmount()
	return cat_count
end

local notifys = {}
local notify_ids = {}

for k,v in pairs(BH_ACC.Notifications) do
    local id = #notifys + 1
    notifys[id] = k
    notify_ids[k] = id
end

if CLIENT then
	function BH_ACC.GetNotifyKey(id)
		return notifys[id]
	end

	local unpack = unpack
	local notification_AddLegacy = notification.AddLegacy
	local string_format = string.format
	local surface_PlaySound = surface.PlaySound
	function BH_ACC.RunNotification(name, args)
		local notif = BH_ACC.Notifications[name]

		if args then
			notification_AddLegacy( string_format(BH_ACC.Language[name], unpack(args)), notif[1], 4 )
		else
			notification_AddLegacy( BH_ACC.Language[name], notif[1], 4 )
		end
		surface_PlaySound( notif[2] )
	end
else
	function BH_ACC.Notify(name, plys)
		net_Start("BH_ACC_Notify")
		net_WriteUInt(notify_ids[name], 8)
		if plys then
			net_Send(plys)
		else
			net_Broadcast()
		end
	end
end

function BH_ACC.HasAccessToTool(ply)
    return BH_ACC.NPCToolUsergroups[GetRank(ply)]
end

function BH_ACC:AddSpawn(pos, ang)
	self.Spawns = self.Spawns or {}

    local id = #self.Spawns + 1
    self.Spawns[id] = {
        pos = pos,
		ang = ang
    }

	if (CLIENT) then
		net_Start("BH_ACC_SP_Add")
			net_WriteVector(pos)
			net_WriteAngle(ang)
		net_SendToServer()
	elseif (SERVER) then
		self.Spawns_Entities[id] = ents.Create("bh_acc_vendor")
		local ent = self.Spawns_Entities[id]
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()

		self.SaveSpawns()
	end
end

function BH_ACC:GetSpawns()
	return self.Spawns or {}
end

function BH_ACC:DeleteSpawn(id)
	table.remove(self.Spawns, id)

	if (CLIENT) then
		net_Start("BH_ACC_SP_Delete")
			net_WriteUInt(id, 16)
		net_SendToServer()
	elseif (SERVER) then
		if IsValid(self.Spawns_Entities[id]) then
			self.Spawns_Entities[id]:Remove()
		end
        table.remove(self.Spawns_Entities, id)

		self.SaveSpawns()
	end
end

function BH_ACC:DeleteAllSpawns()
	self.Spawns = {}

	if (CLIENT) then
		net_Start("BH_ACC_SP_DeleteAll")
		net_SendToServer()
	elseif (SERVER) then
		for k,v in ipairs(self.Spawns_Entities) do
			if not IsValid(v) then continue end
			
			v:Remove()
		end
		self.Spawns_Entities = {}

		self.SaveSpawns()
	end
end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "sh_bh_acc")
end