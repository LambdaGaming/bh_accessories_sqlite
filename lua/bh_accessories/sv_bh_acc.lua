local CurTime = CurTime
local ipairs = ipairs
local IsValid = IsValid
local istable = istable
local tobool = tobool
local tonumber = tonumber

local player_GetAll = player.GetAll
local random = math.random
local table_remove = table.remove
local Query = sql.Query

local net_Start = net.Start
local net_Receive = net.Receive

local net_Send = net.Send
local net_SendOmit = net.SendOmit
local net_Broadcast = net.Broadcast

local net_ReadVector = net.ReadVector
local net_ReadAngle = net.ReadAngle
local net_ReadUInt = net.ReadUInt
local net_ReadString = net.ReadString
local net_ReadFloat = net.ReadFloat
local net_ReadBool = net.ReadBool

local net_WriteBool = net.WriteBool
local net_WriteUInt = net.WriteUInt
local net_WriteString = net.WriteString
local net_WriteFloat = net.WriteFloat

local WritePlayer = BH_ACC.WritePlayer
local WriteAccessoryData = BH_ACC.WriteAccessoryData
local WriteEquippedData = BH_ACC.WriteEquippedData
local WriteAdjustmentData = BH_ACC.WriteAdjustmentData
local WritePMDLAdjustmentData = BH_ACC.WritePMDLAdjustmentData
local WriteThreeFloats = BH_ACC.WriteThreeFloats

local GetItemData = BH_ACC.GetItemData
local GetItemDataByName = BH_ACC.GetItemDataByName

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/cl_bh_acc_ui", function(filename)
    if filename == "sh_bh_acc" then
        WritePlayer = BH_ACC.WritePlayer
        WriteAccessoryData = BH_ACC.WriteAccessoryData
        WriteEquippedData = BH_ACC.WriteEquippedData
        WriteAdjustmentData = BH_ACC.WriteAdjustmentData
        WritePMDLAdjustmentData = BH_ACC.WritePMDLAdjustmentData
        WriteThreeFloats = BH_ACC.WriteThreeFloats
        
        GetItemData = BH_ACC.GetItemData
        GetItemDataByName = BH_ACC.GetItemDataByName
    end
end)

local bit_band = bit.band

local util_AddNetworkString = util.AddNetworkString
util_AddNetworkString("BH_ACC_OpenMenu")
util_AddNetworkString("BH_ACC_BuyItem")
util_AddNetworkString("BH_ACC_SellItem")
util_AddNetworkString("BH_ACC_GiftItem")
util_AddNetworkString("BH_ACC_EquipItem")
util_AddNetworkString("BH_ACC_UnEquipItem")
util_AddNetworkString("BH_ACC_Notify")
util_AddNetworkString("BH_ACC_RequestSync")
util_AddNetworkString("BH_ACC_RequestSyncPlayer")
util_AddNetworkString("BH_ACC_Adjust")
util_AddNetworkString("BH_ACC_Adjust_PModel")
util_AddNetworkString("BH_ACC_EditorDelete")
util_AddNetworkString("BH_ACC_EditorSave")
util_AddNetworkString("BH_ACC_EditorCreate")
util_AddNetworkString("BH_ACC_SP_Req")
util_AddNetworkString("BH_ACC_SP_Add")
util_AddNetworkString("BH_ACC_SP_Delete")
util_AddNetworkString("BH_ACC_SP_DeleteAll")

function BH_ACC.OpenMenu(ply)
    net_Start("BH_ACC_OpenMenu")
    net_Send(ply)
end

local AddWorkshop = resource.AddWorkshop
for k,v in pairs(BH_ACC.Addons) do
    AddWorkshop(k)
end

local function RequestSync(len, ply)
	if ply.bh_acc_requested then return end
	ply.bh_acc_requested = true

	net_Start("BH_ACC_RequestSync")

	-- Let's write the edited items first --
	BH_ACC.WriteEditorData()
	
    -- Let's write the players items --
    WriteAccessoryData(ply)
	
    -- Let's write the players equipped items --
	WriteEquippedData(ply)

	-- Let's write the players adjustments --
	WriteAdjustmentData(ply)

	-- Let's write all the player model adjustments --
	WritePMDLAdjustmentData()

	net_Send(ply)
end
net_Receive("BH_ACC_RequestSync", RequestSync)

local function RequestSyncPlayer(len, ply)
	local target = BH_ACC.ReadPlayer()

	if not target or not IsValid(target) or target == ply or not target.bh_acc_equipped then return end

	if ply.BH_ACC_SyncDelay and ply.BH_ACC_SyncDelay > CurTime() then return end
	ply.BH_ACC_SyncDelay = CurTime() + 2
	
	if ply.BH_ACC_SyncRequests and ply.BH_ACC_SyncRequests[target] then return end
	ply.BH_ACC_SyncRequests = ply.BH_ACC_SyncRequests or {[target] = true}

	net_Start("BH_ACC_RequestSyncPlayer")
    WritePlayer(target)
	WriteEquippedData(target)
	WriteAdjustmentData(target)
	net_Send(ply)
end
net_Receive("BH_ACC_RequestSyncPlayer", RequestSyncPlayer)

local function BuyItem(len, ply)
	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay
	
	local id = net_ReadUInt(16)
    if not id then return end

	local data = GetItemData(id)

	if not data or data.disabled or BH_ACC.HasAccessory(ply, id) or BH_ACC.GetPlayerBalance(ply) < tonumber( data.price ) or not BH_ACC.CanUseSystem(ply) or not BH_ACC.CanBuyAccessory(ply, id) or not BH_ACC.IsNearVendor(ply) or not BH_ACC.IsEnabledLeftCategory("APPEARANCE") then return end

	BH_ACC.SetPlayerBalance(ply, BH_ACC.GetPlayerBalance(ply) - BH_ACC.GetBuyPrice(ply, data.price))

    local owned = ply.bh_acc_owned

	local key = #owned + 1
	owned[key] = id
	ply.bh_acc_owned_lookup[id] = key

	BH_ACC.SavePlayerAccessory(ply, id)

	net_Start("BH_ACC_BuyItem")
	net_WriteUInt(id, 16)
	net_Send(ply)
end
net_Receive("BH_ACC_BuyItem", BuyItem)

local function SellItem(len, ply)
	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

	local id = net_ReadUInt(16)
    if not id then return end

	local data = GetItemData(id)

	if not data or data.disabled or not BH_ACC.HasAccessory(ply, id) or not BH_ACC.CanUseSystem(ply) or not BH_ACC.IsNearVendor(ply) or not BH_ACC.IsEnabledLeftCategory("APPEARANCE") then return end

	local equipped = ply.bh_acc_equipped
	local equipped_lookup = ply.bh_acc_equipped_lookup

    local key = equipped_lookup[id]
    if key then
	    table_remove(equipped, key)
        equipped_lookup[id] = nil

        if data.IsPlayerModel then
            ply:SetModel(BH_ACC.GetJobModel(ply))
        end

        BH_ACC.DeleteEquippedAccessory(ply, data.id)
    end
    
    -- Future usefull code for increasing the limit of equippable accessories per category --
	--[[for k,v in ipairs(equipped) do
		local v_data = GetItemData(v)

		if v_data.category == data.category then
			table_remove(equipped, k)

			equipped_lookup[v_data.id] = nil

			BH_ACC.DeleteEquippedAccessory(ply, v_data.id)

			if v_data.IsPlayerModel then
				ply:SetModel(BH_ACC.GetJobModel(ply))
			end

			break
		end
	end]]

	BH_ACC.SetPlayerBalance(ply, BH_ACC.GetPlayerBalance(ply) + BH_ACC.GetSellPrice(ply, data.price))

    -- Fetching the key from our lookup table and removing the item from both the sequential table and the lookup one
    local owned_lookup = ply.bh_acc_owned_lookup
	local key = owned_lookup[id]
	table_remove(ply.bh_acc_owned, key)
	owned_lookup[id] = nil
	
	BH_ACC.DeletePlayerAccessory(ply, id)

	net_Start("BH_ACC_SellItem")
	net_WriteUInt(id, 16)
	net_Send(ply)

	net_Start("BH_ACC_UnEquipItem")
	WritePlayer(ply)
	net_WriteUInt(id, 16)
	net_Broadcast()
end
net_Receive("BH_ACC_SellItem", SellItem)

local function EquipItem(len, ply)
	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

	local id = net_ReadUInt(16)
    if not id then return end
    
	local data = GetItemData(id)

	if not data or data.disabled or not BH_ACC.HasAccessory(ply, id) or not BH_ACC.CanUseSystem(ply) or not BH_ACC.IsNearVendor(ply) or not BH_ACC.IsEnabledLeftCategory("APPEARANCE") then return end

    local equipped = ply.bh_acc_equipped
	local equipped_lookup = ply.bh_acc_equipped_lookup

	for k,v in ipairs(equipped) do
		local v_data = GetItemData(v)

		if v_data.category == data.category then
			table_remove(equipped, k)

			equipped_lookup[v_data.id] = nil

			BH_ACC.DeleteEquippedAccessory(ply, v_data.id)

			if v_data.IsPlayerModel then
				ply:SetModel(BH_ACC.GetJobModel(ply))
			end

			break
		end
	end

	local key = #equipped + 1
	equipped[key] = id
	equipped_lookup[id] = key

	BH_ACC.SaveEquippedAccessory(ply, id)

	if data.IsPlayerModel then
		ply:SetModel(data.model)
	end

	net_Start("BH_ACC_EquipItem")
	WritePlayer(ply)
	net_WriteUInt(id, 16)
	net_Broadcast()
end
net_Receive("BH_ACC_EquipItem", EquipItem)

local function UnEquipItem(len, ply)
	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

	local id = net_ReadUInt(16)
    if not id then return end

	local data = GetItemData(id)

	if not data or data.disabled or not BH_ACC.CanUseSystem(ply) or not BH_ACC.IsNearVendor(ply) or not BH_ACC.IsEnabledLeftCategory("APPEARANCE") then return end

    local equipped = ply.bh_acc_equipped
	local equipped_lookup = ply.bh_acc_equipped_lookup

	for k,v in ipairs(equipped) do
		local v_data = GetItemData(v)

		if v_data.category == data.category then
			table_remove(equipped, k)

			equipped_lookup[v_data.id] = nil
			
			BH_ACC.DeleteEquippedAccessory(ply, v_data.id)

			if v_data.IsPlayerModel then
				ply:SetModel(BH_ACC.GetJobModel(ply))
			end

			break
		end
	end

	net_Start("BH_ACC_UnEquipItem")
	WritePlayer(ply)
	net_WriteUInt(id, 16)
	net_Broadcast()
end
net_Receive("BH_ACC_UnEquipItem", UnEquipItem)

local function Gift(len, ply)
	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

	local target = ReadPlayer()
	if target or not IsValid(target) or target == ply or not target.bh_acc_equipped then return end

    local id = net_ReadUInt(16)
    if not id then return end

    local data = GetItemData(id)

	if not data or data.disabled or BH_ACC.GetPlayerBalance(ply) < data.price or not BH_ACC.CanBuyAccessory(ply, id) or not BH_ACC.CanUseSystem(ply) or not BH_ACC.IsNearVendor(ply) or not BH_ACC.IsEnabledLeftCategory("APPEARANCE") then return end

	if not BH_ACC.CanBuyAccessory(target, id) then
		BH_ACC.Notify("Notify_Gift_CantBuy", ply)
		return
	end

	if BH_ACC.HasAccessory(target, id) then
		BH_ACC.Notify("Notify_Gift_AlreadyHas", ply)
		return
	end

	if not BH_ACC.CanUseSystem(target) then
		BH_ACC.Notify("Notify_Gift_NoAccessToSystem", ply)
		return
	end

	local msg = net_ReadString() or ""
    if msg == "" then msg = nil end
    
	if msg and #msg > BH_ACC.GiftMessageMaxLength then return end
	
	BH_ACC.SetPlayerBalance(ply, BH_ACC.GetPlayerBalance(ply) - BH_ACC.GetBuyPrice(ply, data.price))
	
	local owned = target.bh_acc_owned
	local owned_lookup = target.bh_acc_owned_lookup

	local key = #owned + 1
	owned[key] = id
	owned_lookup[id] = key
	
	net_Start("BH_ACC_GiftItem")
	net_WriteBool(true)
    net_WriteString(target:Nick())
	net_WriteUInt(id, 16)
	net_Send(ply)

	net_Start("BH_ACC_GiftItem")
	net_WriteBool(false)
	net_WriteString(ply:Nick())
	net_WriteUInt(id, 16)
    net_WriteBool(msg and true or false)
    if msg then
	    net_WriteString(msg:Trim())
    end
	net_Send(target)
end
net_Receive("BH_ACC_GiftItem", Gift)

local function PlayerSay(ply, say)
	if not BH_ACC.CommandOpen then return end

	say = say:lower():Trim():Replace("!", "/")

	if BH_ACC.OpenCommands[say] then
		if not BH_ACC.CanUseSystem(ply) then
			BH_ACC.Notify("Notify_NoAccesstoSystem", ply)
			return ""
		end

		BH_ACC.OpenMenu(ply)

		return ""
	end
end
hook.Add("PlayerSay", "BH_ACC_PlayerSay", PlayerSay)

local math_Round = math.Round
local math_Clamp = math.Clamp
local function ReadThreeFloatsAndRound()
	return math_Round(net_ReadFloat() or 0, 2), math_Round(net_ReadFloat() or 0, 2), math_Round(net_ReadFloat() or 0, 2)
end
local function ReadThreeFloatsAndClamp(cl)
	return math_Clamp(math_Round(net_ReadFloat() or 0, 2), -cl, cl), math_Clamp(math_Round(net_ReadFloat() or 0, 2), -cl, cl), math_Clamp(math_Round(net_ReadFloat() or 0, 2), -cl, cl)
end

local DBEscape = BH_ACC.DBEscape

hook.Add("BH_ACC_DBConnected", "BH_ACC_GetFunctions", function()
	DBEscape = BH_ACC.DBEscape
end)

local function BH_ACC_Adjust(len, ply)
	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

	local id = net_ReadUInt(16)
    if not id then return end

	local data = GetItemData(id)

	if not data or data.disabled or data.IsPlayerModel or not BH_ACC.IsNearVendor(ply) or not BH_ACC.IsEnabledLeftCategory("POSITIONER") then return end
	
	local model = data.model

	local adjpx, adjpy, adjpz = ReadThreeFloatsAndClamp(BH_ACC.PositionerPos)
	local adjap, adjay, adjar = ReadThreeFloatsAndClamp(BH_ACC.PositionerAng)
	local adjsx, adjsy, adjsz = ReadThreeFloatsAndClamp(BH_ACC.PositionerScale)

	local adjustments = ply.bh_acc_adjustments
	local adj_lookup = ply.bh_acc_adjustments_lookup

	if not adjustments[model] then
		adjustments[model] = {
			pos = Vector(adjpx, adjpy, adjpz),
			ang = Angle(adjap, adjay, adjar),
			scale = Vector(adjsx, adjsy, adjsz)
		}

		adj_lookup[#adj_lookup + 1] = model

		if BH_ACC.PositionerSaveToDB then
			Query("INSERT OR REPLACE INTO bh_accessories_adjusted(steamid, model, vx, vy, vz, ap, ay, ar, sx, sy, sz) VALUES (" .. DBEscape(ply:SteamID64()) .. ", " .. DBEscape(model) .. ", " .. DBEscape(adjpx) .. ", " .. DBEscape(adjpy) .. ", " .. DBEscape(adjpz)  .. ", " .. DBEscape(adjap) .. ", " .. DBEscape(adjay) .. ", " .. DBEscape(adjar)  .. ", " .. DBEscape(adjsx) .. ", " .. DBEscape(adjsy) .. ", " .. DBEscape(adjsz) .. ")")
		end
	else
		adjustments[model] = {
			pos = Vector(adjpx, adjpy, adjpz),
			ang = Angle(adjap, adjay, adjar),
			scale = Vector(adjsx, adjsy, adjsz)
		}

		if BH_ACC.PositionerSaveToDB then
			Query("UPDATE bh_accessories_adjusted SET vx = " .. DBEscape(adjpx) .. ", vy = " .. DBEscape(adjpy) .. ", vz = " .. DBEscape(adjpz) .. ", ap = " .. DBEscape(adjap) .. ", ay = " .. DBEscape(adjay) ..", ar = " .. DBEscape(adjar) .. ", sx = " .. DBEscape(adjsx) .. ", sy = " .. DBEscape(adjsy) .. ", sz = " .. DBEscape(adjsz) .. " WHERE steamid = " .. DBEscape(ply:SteamID64()) .. " AND model = " .. DBEscape(model)  )
		end
	end

	local send = 0
	local thing = adjustments[model]

	local check1 = thing.pos ~= vector_origin
	local check2 = thing.ang ~= angle_zero
	local check3 = thing.scale ~= vector_origin

	if check1 then send = send + 1 end
	if check2 then send = send + 2 end
	if check3 then send = send + 4 end

	net_Start("BH_ACC_Adjust")
	WritePlayer(ply)
	net_WriteUInt(data.id, 16)
	net_WriteUInt(send, 4)
	if check1 then WriteThreeFloats(thing.pos) end
	if check2 then WriteThreeFloats(thing.ang) end
	if check3 then WriteThreeFloats(thing.scale) end
	net_SendOmit(ply)

	BH_ACC.Notify("Notify_Adjustment_Saved", ply)
end
net_Receive("BH_ACC_Adjust", BH_ACC_Adjust)

local function BH_ACC_Adjust_PModel(len, ply)
	if not BH_ACC.CanAccessPositioner(ply) or not BH_ACC.IsEnabledLeftCategory("POSITIONER") then return end

	local model = net_ReadString()
	local bone = net_ReadString()

    if not model or not bone then return end
    
	local adjpx, adjpy, adjpz = ReadThreeFloatsAndClamp(BH_ACC.PositionerPMDLPos)
	local adjap, adjay, adjar = ReadThreeFloatsAndClamp(BH_ACC.PositionerPMDLAng)
	local adjsx, adjsy, adjsz = ReadThreeFloatsAndClamp(BH_ACC.PositionerPMDLScale)

	local mdloffsets = BH_ACC.AddedModelOffsets
	local ids = BH_ACC.AddedModelOffsets_IDS

	local mdlkey = ids[model]
	local offkey
	if mdlkey then
		local mdlt = mdloffsets[mdlkey]
		local offsets = mdlt.offsets
		local offset_ids = mdlt.offset_ids
		
		offkey = offset_ids[bone]
		if offkey then
			offsets[offkey] = {
				bone = bone,
				pos = Vector(adjpx, adjpy, adjpz),
				ang = Angle(adjap, adjay, adjar),
				scale = Vector(adjsx, adjsy, adjsz)
			}
		else
			offkey = #offsets + 1
			offsets[offkey] = {
				bone = bone,
				pos = Vector(adjpx, adjpy, adjpz),
				ang = Angle(adjap, adjay, adjar),
				scale = Vector(adjsx, adjsy, adjsz)
			}
			offset_ids[bone] = offkey
		end
	else
		local key = #mdloffsets + 1
		mdloffsets[key] = {
			model = model,
			offsets = {
				{
					bone = bone,
					pos = Vector(adjpx, adjpy, adjpz),
					ang = Angle(adjap, adjay, adjar),
					scale = Vector(adjsx, adjsy, adjsz)
				}
			},
			offset_ids = {
				[bone] = 1,
			}
		}
		ids[model] = key
		
		mdlkey = key
		offkey = 1
	end

	Query("INSERT OR REPLACE INTO bh_accessories_pmdl_adjusted(model, bone, vx, vy, vz, ap, ay, ar, sx, sy, sz) VALUES (" .. DBEscape(model) .. ", " .. DBEscape(bone) .. ", " .. DBEscape(adjpx) .. ", " .. DBEscape(adjpy) .. ", " .. DBEscape(adjpz)  .. ", " .. DBEscape(adjap) .. ", " .. DBEscape(adjay) .. ", " .. DBEscape(adjar)  .. ", " .. DBEscape(adjsx) .. ", " .. DBEscape(adjsy) .. ", " .. DBEscape(adjsz) .. ")")
	
	local send = 0
	local thing = mdloffsets[mdlkey].offsets[offkey]

	local check1 = thing.pos ~= vector_origin
	local check2 = thing.ang ~= angle_zero
	local check3 = thing.scale ~= vector_origin

	if check1 then send = send + 1 end
	if check2 then send = send + 2 end
	if check3 then send = send + 4 end

	net_Start("BH_ACC_Adjust_PModel")
	net_WriteString(model)
	net_WriteString(bone)
	net_WriteUInt(send, 4)
	if check1 then WriteThreeFloats(thing.pos) end
	if check2 then WriteThreeFloats(thing.ang) end
	if check3 then WriteThreeFloats(thing.scale) end
	net_SendOmit(ply)

	BH_ACC.Notify("Notify_PModel_Saved", ply)
end
net_Receive("BH_ACC_Adjust_PModel", BH_ACC_Adjust_PModel)

-- Escape the entered value if it's not nil or if it's nil turn it into a "NULL" string for sql queries
local function ValidVal(val, oldval)
	return val and DBEscape(val) or "NULL"
end

-- Serverside function for creating accessories through the editor --
local function BH_ACC_EditorCreate(len, ply)
	if not BH_ACC.CanAccessEditor(ply) or not BH_ACC.IsEnabledLeftCategory("EDITOR") then return end

	local newdata = {}

	local amt = net_ReadUInt(16)
	local ispmodel = net_ReadBool()
	local simple = net_ReadBool()

	local name = net_ReadString()
	local category = net_ReadString()

    -- Just incase lets do checks like this if something goes wrong --
    if not amt or not category then return end

	local check1 = bit_band(amt, 1) > 0
	local check2 = bit_band(amt, 2) > 0
	local check3 = bit_band(amt, 4) > 0
	local check4 = bit_band(amt, 8) > 0
	local check5 = bit_band(amt, 16) > 0
	local check6 = bit_band(amt, 32) > 0
	local check7 = bit_band(amt, 64) > 0
	local check8 = bit_band(amt, 128) > 0
	local check9 = bit_band(amt, 256) > 0
	local check10 = bit_band(amt, 512) > 0
	local check11
	local check12
	local check13

	if not simple then
		check11 = bit_band(amt, 1024) > 0
		check12 = bit_band(amt, 2048) > 0
		check13 = bit_band(amt, 4096) > 0
	end

	if not name or #name:Trim() <= 0 then
		self.RunNotification("Notify_Editor_NoName")
		
		return
	end

	if GetItemDataByName(name) then
		return
	end

	local minicat = check1 and net_ReadString()
	local desc = check2 and net_ReadString()
	if desc and #desc:Trim() <= 0 then desc = nil end
	local model = check3 and net_ReadString()
	local price = check4 and net_ReadUInt(32) or 0
	local bone = check5 and net_ReadString()
	local material = check6 and net_ReadString()
	local skin = check7 and net_ReadUInt(8)
	
	local vx, vy, vz
	local ap, ay, ar
	local sx, sy, sz
	if check8 then vx, vy, vz = ReadThreeFloatsAndRound() end
	if check9 then ap, ay, ar = ReadThreeFloatsAndRound() end
	if check10 then sx, sy, sz = ReadThreeFloatsAndRound() end
	local uivx, uivy, uivz
	local uiap, uiay, uiar
	local fov
	if not simple then
		if check11 then fov = net_ReadFloat() end
		if check12 then uivx, uivy, uivz = ReadThreeFloatsAndRound() end
		if check13 then uiap, uiay, uiar = ReadThreeFloatsAndRound() end
	end

    -- Now lets store all of the usergroups allowed in a sequential table and a lookup table --
    -- We have to use reali instead of i from the loop because the client could be sending a nil string --
	local usergroups = {}
	local userlookup = {}
    local reali = 0
	for _ = 1, net_ReadUInt(8) or 0 do
		local nam = net_ReadString()
        if not nam then continue end

        reali = reali + 1

		usergroups[reali] = nam
		userlookup[nam] = true
	end

    -- If it has no usergroups then just turn it into nil
	if #usergroups <= 0 then usergroups = nil end

	local newdata = {
		name = name,
		description = desc,
		model = model,
		price = price,
		bone = bone,
		material = material,
		skin = skin,
		user = usergroups,
		userlookup = userlookup,
		IsPlayerModel = ispmodel,
		offsetV = (vx and Vector(vx, vy, vz)),
		offsetA = (ap and Angle(ap, ay, ar)),
		scale = (sx and Vector(sx, sy, sz)),
		ui_CamPos = (uivx and Vector(uivx, uivy, uivz)),
		ui_LookAng = (uiap and Angle(uiap, uiay, uiar)),
		ui_FOV = fov,
		ui_Simple = simple,
		category = category,
		mini_category = minicat,
		id = BH_ACC.GetItemCount() + 1,
		disabled = false
	}
	
	local newdata_offsetV = newdata.offsetV
	local newdata_offsetA = newdata.offsetA
	local newdata_scale = newdata.scale
	local newdata_ui_CamPos = newdata.ui_CamPos
	local newdata_ui_LookAng = newdata.ui_LookAng

	local t = {
		ValidVal(newdata.name),
		ValidVal(newdata.description),
		ValidVal(newdata.model),
		ValidVal(newdata.price),
		ValidVal(newdata.bone),
		ValidVal(newdata.material),
		ValidVal(newdata.skin),
		newdata.user and DBEscape(util.TableToJSON(newdata.user)) or "NULL",
		DBEscape(tobool(newdata.IsPlayerModel)),
		ValidVal(newdata_offsetV and newdata_offsetV[1]),
		ValidVal(newdata_offsetV and newdata_offsetV[2]),
		ValidVal(newdata_offsetV and newdata_offsetV[3]),
		ValidVal(newdata_offsetA and newdata_offsetA[1]),
		ValidVal(newdata_offsetA and newdata_offsetA[2]),
		ValidVal(newdata_offsetA and newdata_offsetA[3]),
		ValidVal(newdata_scale and newdata_scale[1]),
		ValidVal(newdata_scale and newdata_scale[2]),
		ValidVal(newdata_scale and newdata_scale[3]),
		ValidVal(newdata_ui_CamPos and newdata_ui_CamPos[1]),
		ValidVal(newdata_ui_CamPos and newdata_ui_CamPos[2]),
		ValidVal(newdata_ui_CamPos and newdata_ui_CamPos[3]),
		ValidVal(newdata_ui_LookAng and newdata_ui_LookAng[1]),
		ValidVal(newdata_ui_LookAng and newdata_ui_LookAng[2]),
		ValidVal(newdata_ui_LookAng and newdata_ui_LookAng[3]),
		ValidVal(newdata.ui_FOV),
		DBEscape(tobool(newdata.ui_Simple)),
		ValidVal(newdata.category),
		ValidVal(newdata.mini_category)
	}

	local querytext = t[1] .. ", false"
	for i = 2, #t do
		querytext = querytext .. ", " .. t[i]
	end

	Query([[
		INSERT OR REPLACE INTO bh_accessories_editor(
			name,
			disabled,
			description,
			model,
			price,
			bone,
			material,
			skin,
			user,
			IsPlayerModel,
			vx,vy,vz,
			ap,ay,ar,
			sx,sy,sz,
			uivx,uivy,uivz, 
			uiap,uiay,uiar,
			ui_FOV,
			ui_Simple,
			category,
			mini_category
		) VALUES (]].. querytext .. ")"
	)
	
	BH_ACC.EditorCreateUpdateItemData(newdata)

	net_Start("BH_ACC_EditorCreate")
	net_WriteUInt(amt, 16)
	net_WriteBool(ispmodel)
	net_WriteBool(simple)
	net_WriteString(newdata.name)
	net_WriteString(newdata.category)
	if check1 then net_WriteString(newdata.mini_category) end
	if check2 then net_WriteString(newdata.description or "") end
	if check3 then net_WriteString(newdata.model) end
	if check4 then net_WriteUInt(newdata.price, 32) end
	if check5 then net_WriteString(newdata.bone) end
	if check6 then net_WriteString(newdata.material) end
	if check7 then net_WriteUInt(newdata.skin, 8) end
	if check8 then WriteThreeFloats(newdata_offsetV) end
	if check9 then WriteThreeFloats(newdata_offsetA) end
	if check10 then WriteThreeFloats(newdata_scale) end
	if not simple then
		if check11 then net_WriteFloat(newdata.ui_FOV) end
		if check12 then WriteThreeFloats(newdata_ui_CamPos) end
		if check13 then WriteThreeFloats(newdata_ui_LookAng) end
	end
	if usergroups then
		net_WriteUInt(#usergroups, 8)
		for i = 1, #usergroups do
			net_WriteString(usergroups[i])
		end
	else
		net_WriteUInt(0, 8)
	end
	net_Broadcast()

	BH_ACC.Notify("Notify_Editor_Create", ply)
end
net_Receive("BH_ACC_EditorCreate", BH_ACC_EditorCreate)

local function BH_ACC_EditorSave(len, ply)
	if not BH_ACC.CanAccessEditor(ply) or not BH_ACC.IsEnabledLeftCategory("EDITOR") then return end

    local oldid = net_ReadUInt(16)
    if not oldid then return end

	local olddata = GetItemData(oldid)
	local amt = net_ReadUInt(16)

	if not olddata or olddata.disabled or not amt then return end

	local oldname = olddata.name

    local ispmodel = net_ReadBool()
	local simple = net_ReadBool()

	local check1 = bit_band(amt, 1) > 0
	local check2 = bit_band(amt, 2) > 0
	local check3 = bit_band(amt, 4) > 0
	local check4 = bit_band(amt, 8) > 0
	local check5 = bit_band(amt, 16) > 0
	local check6 = bit_band(amt, 32) > 0
	local check7 = bit_band(amt, 64) > 0
	local check8 = bit_band(amt, 128) > 0
	local check9 = bit_band(amt, 256) > 0
	local check10 = bit_band(amt, 512) > 0
	local check11 = bit_band(amt, 1024) > 0
	local check12 = bit_band(amt, 2048) > 0
	local check13
	local check14
	local check15

	if not simple then
		check13 = bit_band(amt, 4096) > 0
		check14 = bit_band(amt, 8192) > 0
		check15 = bit_band(amt, 16384) > 0
	end

	local newname = check1 and net_ReadString()
	local category = check2 and net_ReadString()
	local minicat = check3 and net_ReadString()
	local desc = check4 and net_ReadString()
	if desc and #desc:Trim() <= 0 then desc = nil end
	local model = check5 and net_ReadString()
	local price = check6 and net_ReadUInt(32)
	local bone = check7 and net_ReadString()
	local material = check8 and net_ReadString()
	local skin = check9 and net_ReadUInt(8)
	
	local vx, vy, vz
	local ap, ay, ar
	local sx, sy, sz
	if check10 then vx, vy, vz = ReadThreeFloatsAndRound() end
	if check11 then ap, ay, ar = ReadThreeFloatsAndRound() end
	if check12 then sx, sy, sz = ReadThreeFloatsAndRound() end
	local uivx, uivy, uivz
	local uiap, uiay, uiar
	local fov
	if not simple then
		if check13 then fov = net_ReadFloat() end
		if check14 then uivx, uivy, uivz = ReadThreeFloatsAndRound() end
		if check15 then uiap, uiay, uiar = ReadThreeFloatsAndRound() end
	end

	local usergroups = {}
	local userlookup = {}
    local reali = 0
	for _ = 1, net_ReadUInt(8) or 0 do
		local nam = net_ReadString()
        if not nam then continue end

        reali = reali + 1

		usergroups[reali] = nam
		userlookup[nam] = true
	end

    -- If it has no usergroups then just turn it into nil
	if #usergroups <= 0 then usergroups = nil end

	local newdata

	local oldispmodel = olddata.IsPlayerModel

	newname = newname or oldname
	if newname == oldname then
		newdata = {
			name = newname,
			description = desc or olddata.description,
			model = model or olddata.model,
			price = price or olddata.price,
			bone = bone or olddata.bone,
			material = material or olddata.material,
			skin = skin or olddata.skin,
			user = usergroups,
			userlookup = userlookup,
			IsPlayerModel = ispmodel,
			offsetV = (vx and Vector(vx, vy, vz)) or olddata.offsetV,
			offsetA = (ap and Angle(ap, ay, ar)) or olddata.offsetA,
			scale = (sx and Vector(sx, sy, sz)) or olddata.scale,
			ui_CamPos = (uivx and Vector(uivx, uivy, uivz)) or olddata.ui_CamPos,
			ui_LookAng = (uiap and Angle(uiap, uiay, uiar)) or olddata.ui_LookAng,
			ui_FOV = fov or olddata.ui_FOV,
			ui_Simple = simple,
			category = category or olddata.category,
			mini_category = minicat or olddata.mini_category,
			id = oldid,
			disabled = false
		}

		BH_ACC.EditorSaveUpdateItemData(oldid, newdata)

		if ispmodel or oldispmodel then
			for k,v in ipairs(player_GetAll()) do
				if not BH_ACC.HasEquippedAccessory(v, oldid) then continue end

				if ispmodel then
					v:SetModel(newdata.model)
				elseif oldispmodel then
					v:SetModel(BH_ACC.GetJobModel(v))
				end
			end
		end
	else
		newdata = {
			name = newname,
			description = desc or olddata.description,
			model = model or olddata.model,
			price = price or olddata.price,
			bone = bone or olddata.bone,
			material = material or olddata.material,
			skin = skin or olddata.skin,
			user = usergroups,
			userlookup = userlookup,
			IsPlayerModel = ispmodel,
			offsetV = (vx and Vector(vx, vy, vz)) or olddata.offsetV,
			offsetA = (ap and Angle(ap, ay, ar)) or olddata.offsetA,
			scale = (sx and Vector(sx, sy, sz)) or olddata.scale,
			ui_CamPos = (uivx and Vector(uivx, uivy, uivz)) or olddata.ui_CamPos,
			ui_LookAng = (uiap and Angle(uiap, uiay, uiar)) or olddata.ui_LookAng,
			ui_FOV = fov or olddata.ui_FOV,
			ui_Simple = simple,
			category = category or olddata.category,
			mini_category = minicat or olddata.mini_category,
			id = BH_ACC.GetItemCount(),
			disabled = false
		}

		local esc_old = DBEscape(oldname)
		local esc_new = DBEscape(newname)

        Query("INSERT OR REPLACE INTO bh_accessories_editor (name, disabled, model, category) VALUES (" .. esc_old .. ", 1, " .. DBEscape(olddata.model) .. ", " .. DBEscape(olddata.category) .. ")" )

		Query("SELECT steamid FROM bh_accessories_owned WHERE name = " .. esc_old)
		for k,v in ipairs(data) do
			local steamid = v.steamid
			local esc = DBEscape(steamid)

			Query("DELETE FROM bh_accessories_owned WHERE steamid = " .. esc .. " AND name = " .. esc_old)
			Query("INSERT OR REPLACE INTO bh_accessories_owned (steamid, name) VALUES (" .. esc .. ", " .. esc_new .. ")")
		end

		Query("SELECT steamid FROM bh_accessories_equipped WHERE name = " .. esc_old)
		for k,v in ipairs(data) do
			local steamid = v.steamid
			local esc = DBEscape(steamid)

			Query("DELETE FROM bh_accessories_equipped WHERE steamid = " .. esc .. " AND name = " .. esc_old)
			Query("INSERT OR REPLACE INTO bh_accessories_equipped (steamid, name) VALUES (" .. esc .. ", " .. esc_new .. ")")
		end

		BH_ACC.EditorRemoveAndAddNew(oldid, newdata)
        local newid = newdata.id

		for k,v in ipairs(player_GetAll()) do
			local owned = v.bh_acc_owned
            if not owned then continue end
            
			local equipped = v.bh_acc_equipped

			local find = BH_ACC.HasAccessory(v, oldid)
			if find then
                v.bh_acc_owned_lookup = {}
                local owned_lookup = v.bh_acc_owned_lookup

				table_remove(owned, find)

                local amt = #owned
                for i = 1, amt do
                    local o = owned[i]
    
                    if o > oldid then
                        owned[i] = o - 1
                    end

                    owned_lookup[owned[i]] = i
                end
                
                owned[amt + 1] = newid
                owned_lookup[newid] = amt + 1
            else
                v.bh_acc_owned_lookup = {}
                local owned_lookup = v.bh_acc_owned_lookup

                for i = 1, #owned do
                    local o = owned[i]
    
                    if o > oldid then
                        owned[i] = o - 1
                    end

                    owned_lookup[owned[i]] = i
                end
            end

			local find = BH_ACC.HasEquippedAccessory(v, oldid)
			if find then
                v.bh_acc_equipped_lookup = {}
                local equipped_lookup = v.bh_acc_equipped_lookup

				if ispmodel then
					v:SetModel(newdata.model)
				elseif oldispmodel then
					v:SetModel(BH_ACC.GetJobModel(v))
				end

				table_remove(equipped, find)

                local amt = #equipped
                for i = 1, amt do
                    local o = equipped[i]
    
                    if o > oldid then
                        equipped[i] = o - 1
                    end

                    equipped_lookup[equipped[i]] = i
                end

                equipped[amt + 1] = newid
                equipped_lookup[newid] = amt + 1
            else
                v.bh_acc_equipped_lookup = {}
                local equipped_lookup = v.bh_acc_equipped_lookup

                for i = 1, #equipped do
                    local o = equipped[i]
    
                    if o > oldid then
                        equipped[i] = o - 1
                    end

                    equipped_lookup[equipped[i]] = i
                end
            end
		end
	end

	local newdata_offsetV = newdata.offsetV
	local newdata_offsetA = newdata.offsetA
	local newdata_scale = newdata.scale
	local newdata_ui_CamPos = newdata.ui_CamPos
	local newdata_ui_LookAng = newdata.ui_LookAng

	local t = {
		ValidVal(newdata.name),
		ValidVal(newdata.description),
		ValidVal(newdata.model),
		ValidVal(newdata.price),
		ValidVal(newdata.bone),
		ValidVal(newdata.material),
		ValidVal(newdata.skin),
		newdata.user and ValidVal(util.TableToJSON(newdata.user)) or "NULL",
		ispmodel and "1" or "0",
		ValidVal(newdata_offsetV and newdata_offsetV[1]),
		ValidVal(newdata_offsetV and newdata_offsetV[2]),
		ValidVal(newdata_offsetV and newdata_offsetV[3]),
		ValidVal(newdata_offsetA and newdata_offsetA[1]),
		ValidVal(newdata_offsetA and newdata_offsetA[2]),
		ValidVal(newdata_offsetA and newdata_offsetA[3]),
		ValidVal(newdata_scale and newdata_scale[1]),
		ValidVal(newdata_scale and newdata_scale[2]),
		ValidVal(newdata_scale and newdata_scale[3]),
		ValidVal(newdata_ui_CamPos and newdata_ui_CamPos[1]),
		ValidVal(newdata_ui_CamPos and newdata_ui_CamPos[2]),
		ValidVal(newdata_ui_CamPos and newdata_ui_CamPos[3]),
		ValidVal(newdata_ui_LookAng and newdata_ui_LookAng[1]),
		ValidVal(newdata_ui_LookAng and newdata_ui_LookAng[2]),
		ValidVal(newdata_ui_LookAng and newdata_ui_LookAng[3]),
		ValidVal(newdata.ui_FOV),
		simple and "1" or "0",
		ValidVal(newdata.category),
		ValidVal(newdata.mini_category)
	}

	local querytext = t[1] .. ", false"
	for i = 2, #t do
		querytext = querytext .. ", " .. t[i]
	end

	Query([[
		INSERT OR REPLACE INTO bh_accessories_editor (
			name,
			disabled,
			description,
			model,
			price,
			bone,
			material,
			skin,
			user,
			IsPlayerModel,
			vx,vy,vz,
			ap,ay,ar,
			sx,sy,sz,
			uivx,uivy,uivz, 
			uiap,uiay,uiar,
			ui_FOV,
			ui_Simple,
			category,
			mini_category
		) VALUES (]].. querytext .. ")"
	)

	net_Start("BH_ACC_EditorSave")
	net_WriteUInt(oldid, 16)
	net_WriteUInt(amt, 16)
	net_WriteBool(ispmodel)
	net_WriteBool(simple)
	if check1 then net_WriteString(newdata.name) end
	if check2 then net_WriteString(newdata.category) end
	if check3 then net_WriteString(newdata.mini_category) end
	if check4 then net_WriteString(newdata.description or "") end
	if check5 then net_WriteString(newdata.model) end
	if check6 then net_WriteUInt(newdata.price, 32) end
	if check7 then net_WriteString(newdata.bone) end
	if check8 then net_WriteString(newdata.material) end
	if check9 then net_WriteUInt(newdata.skin, 8) end
	if check10 then WriteThreeFloats(newdata_offsetV) end
	if check11 then WriteThreeFloats(newdata_offsetA) end
	if check12 then WriteThreeFloats(newdata_scale) end
	if not simple then
		if check13 then net_WriteFloat(newdata.ui_FOV) end
		if check14 then WriteThreeFloats(newdata_ui_CamPos) end
		if check15 then WriteThreeFloats(newdata_ui_LookAng) end
	end
	if usergroups then
		net_WriteUInt(#usergroups, 8)
		for i = 1, #usergroups do
			net_WriteString(usergroups[i])
		end
	else
		net_WriteUInt(0, 8)
	end
	net_Broadcast()

	BH_ACC.Notify("Notify_Editor_Save", ply)
end
net_Receive("BH_ACC_EditorSave", BH_ACC_EditorSave)

local function BH_ACC_EditorDelete(len, ply)
	if not BH_ACC.CanAccessEditor(ply) or not BH_ACC.IsEnabledLeftCategory("EDITOR") then return end

	local id = net_ReadUInt(16)
    if not id then return end

	local data = GetItemData(id)
	if not data then return end

	local t = {
		ValidVal(data.name),
		ValidVal(data.description),
		ValidVal(data.model),
		ValidVal(data.price),
		ValidVal(data.bone),
		ValidVal(data.material),
		ValidVal(data.skin),
		data.user and ValidVal(util.TableToJSON(data.user)) or "NULL",
		DBEscape(tobool(data.IsPlayerModel)),
		ValidVal(data_offsetV and data_offsetV[1]),
		ValidVal(data_offsetV and data_offsetV[2]),
		ValidVal(data_offsetV and data_offsetV[3]),
		ValidVal(data_offsetA and data_offsetA[1]),
		ValidVal(data_offsetA and data_offsetA[2]),
		ValidVal(data_offsetA and data_offsetA[3]),
		ValidVal(data_scale and data_scale[1]),
		ValidVal(data_scale and data_scale[2]),
		ValidVal(data_scale and data_scale[3]),
		ValidVal(data_ui_CamPos and data_ui_CamPos[1]),
		ValidVal(data_ui_CamPos and data_ui_CamPos[2]),
		ValidVal(data_ui_CamPos and data_ui_CamPos[3]),
		ValidVal(data_ui_LookAng and data_ui_LookAng[1]),
		ValidVal(data_ui_LookAng and data_ui_LookAng[2]),
		ValidVal(data_ui_LookAng and data_ui_LookAng[3]),
		ValidVal(data.ui_FOV),
		DBEscape(tobool(data.ui_Simple)),
		ValidVal(data.category),
		ValidVal(data.mini_category)
	}

	local querytext = t[1] .. ", false"
	for i = 2, #t do
		querytext = querytext .. ", " .. t[i]
	end

	Query([[
		INSERT OR REPLACE INTO bh_accessories_editor (
			name,
			disabled,
			description,
			model,
			price,
			bone,
			material,
			skin,
			user,
			IsPlayerModel,
			vx,vy,vz,
			ap,ay,ar,
			sx,sy,sz,
			uivx,uivy,uivz, 
			uiap,uiay,uiar,
			ui_FOV,
			ui_Simple,
			category,
			mini_category
		) VALUES (]].. querytext .. ")"
	)

	local esc_name = DBEscape(data.name)
	Query("DELETE FROM bh_accessories_owned WHERE name = " .. esc_name)
	Query("DELETE FROM bh_accessories_equipped WHERE name = " .. esc_name)

	BH_ACC.EditorDelete(data)

	net_Start("BH_ACC_EditorDelete")
	net_WriteUInt(id, 16)
	net_Broadcast()

	BH_ACC.Notify("Notify_Editor_Delete", ply)
end
net_Receive("BH_ACC_EditorDelete", BH_ACC_EditorDelete)

local net_WriteVector = net.WriteVector
local net_WriteAngle = net.WriteAngle
local function SpawnPoint_Request(len, ply)
    if not BH_ACC.HasAccessToTool(ply) then return end

    net_Start("BH_ACC_SP_Req")
    local spawns = BH_ACC:GetSpawns()
    local amt = #spawns
    net_WriteUInt(amt, 8)
    for i = 1, amt do
        local v = spawns[i]

        net_WriteVector(v.pos)
        net_WriteAngle(v.ang)
    end
    net_Send(ply)
end
net_Receive("BH_ACC_SP_Req", SpawnPoint_Request)

local function SpawnPoint_Add(len, ply)
    if not BH_ACC.HasAccessToTool(ply) then return end

    local pos, ang = net_ReadVector(), net_ReadAngle()

    if not pos or not ang then return end

    BH_ACC:AddSpawn(pos, ang)
end
net_Receive("BH_ACC_SP_Add", SpawnPoint_Add)

local function SpawnPoint_Delete(len, ply)
    if not BH_ACC.HasAccessToTool(ply) then return end

    local id = net_ReadUInt(8)

    if not id then return end

    BH_ACC:DeleteSpawn(id)
end
net_Receive("BH_ACC_SP_Delete", SpawnPoint_Delete)

local function SpawnPoint_DeleteAll(len, ply)
    if not BH_ACC.HasAccessToTool(ply) then return end

    BH_ACC:DeleteAllSpawns()
end
net_Receive("BH_ACC_SP_DeleteAll", SpawnPoint_DeleteAll)

function BH_ACC.SaveSpawns()
	file.Write("bh_accessories/spawnpoints.txt", util.TableToJSON(BH_ACC:GetSpawns()))
end

local function LoadSpawns()
	if not file.Exists("bh_accessories", "DATA") then
		file.CreateDir("bh_accessories")

		BH_ACC.Spawns = {}
		BH_ACC.SaveSpawns()
		
		return
	end

	BH_ACC.Spawns_Entities = {}
	local data = file.Read("bh_accessories/spawnpoints.txt")
	if data then
		BH_ACC.Spawns = util.JSONToTable(data)
	else
		BH_ACC.Spawns = {}
	end
end

hook.Add("InitPostEntity", "BH_ACC_SP_SpawnNPCS", function()
    LoadSpawns()

	for k,v in ipairs(BH_ACC.Spawns) do
		BH_ACC.Spawns_Entities[k] = ents.Create("bh_acc_vendor")
		local ent = BH_ACC.Spawns_Entities[k]
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:Spawn()
	end
end)

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "sv_bh_acc")
end