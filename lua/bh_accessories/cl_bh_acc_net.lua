local Vector = Vector
local Angle = Angle
local ipairs = ipairs
local IsValid = IsValid
local ClientsideModel = ClientsideModel
local CurTime = CurTime

local net_Start = net.Start
local net_SendToServer = net.SendToServer
local net_Receive = net.Receive
local net_ReadUInt = net.ReadUInt
local net_ReadBool = net.ReadBool
local net_ReadString = net.ReadString
local net_ReadFloat = net.ReadFloat
local net_WriteUInt = net.WriteUInt
local net_WriteString = net.WriteString
local net_WriteBool = net.WriteBool
local net_WriteFloat = net.WriteFloat

local ClearPlayerAdjustments = BH_ACC.ClearPlayerAdjustments
local ClearAllPlayerAdjustments = BH_ACC.ClearAllPlayerAdjustments
local CreatePlayerEquipped = BH_ACC.CreatePlayerEquipped

local ReadAccessoryData = BH_ACC.ReadAccessoryData
local ReadEquippedData = BH_ACC.ReadEquippedData
local ReadAdjustmentData = BH_ACC.ReadAdjustmentData
local ReadPMDLAdjustmentData = BH_ACC.ReadPMDLAdjustmentData
local ReadPlayer = BH_ACC.ReadPlayer
local GetItemData = BH_ACC.GetItemData
local WritePlayer = BH_ACC.WritePlayer
local WriteThreeFloats = BH_ACC.WriteThreeFloats

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/bh_acc_items_config", function(filename)
    if filename == "sh_bh_acc" then
        ReadAccessoryData = BH_ACC.ReadAccessoryData
        ReadEquippedData = BH_ACC.ReadEquippedData
        ReadAdjustmentData = BH_ACC.ReadAdjustmentData
        ReadPMDLAdjustmentData = BH_ACC.ReadPMDLAdjustmentData
        ReadPlayer = BH_ACC.ReadPlayer
        GetItemData = BH_ACC.GetItemData
        WritePlayer = BH_ACC.WritePlayer
        WriteThreeFloats = BH_ACC.WriteThreeFloats
    elseif filename == "cl_bh_acc_draw" then
        ClearPlayerAdjustments = BH_ACC.ClearPlayerAdjustments
        ClearAllPlayerAdjustments = BH_ACC.ClearAllPlayerAdjustments
        CreatePlayerEquipped = BH_ACC.CreatePlayerEquipped
    end
end)

local bit_band = bit.band
local table_remove = table.remove
local chat_AddText = chat.AddText

local _E = FindMetaTable("Entity")
local SetPredictable = _E.SetPredictable
local DrawShadow = _E.DrawShadow
local DestroyShadow = _E.DestroyShadow
local SetNoDraw = _E.SetNoDraw
local SetSkin = _E.SetSkin
local SetMaterial = _E.SetMaterial
local SetColor = _E.SetColor
local ResetSequence = _E.ResetSequence
local SetModel = _E.SetModel

local player_GetAll = player.GetAll

local myself = LocalPlayer()
local function Init()
    myself = LocalPlayer()
    myself.BH_ACC_delay = CurTime()

    net_Start("BH_ACC_RequestSync")
    net_SendToServer()
end
hook.Add("InitPostEntity", "BH_ACC_RequestSyncIPE", Init)

local SetDModelPanelEntitySequence = BH_ACC.SetDModelPanelEntitySequence
local RunNotification = BH_ACC.RunNotification
local GetNotifyKey = BH_ACC.GetNotifyKey
local function RequestSync()
    BH_ACC.ReadEditorData()
    
    myself.bh_acc_equipped_csms = {}

    myself.bh_acc_owned = ReadAccessoryData()

    local owned_lookup = {}
    for k,v in ipairs(myself.bh_acc_owned) do
        owned_lookup[v] = k
    end
    myself.bh_acc_owned_lookup = owned_lookup

    myself.bh_acc_equipped = ReadEquippedData()

    local equipped_lookup = {}
    for k,v in ipairs(myself.bh_acc_equipped) do
        equipped_lookup[v] = k
    end
    myself.bh_acc_equipped_lookup = equipped_lookup

    myself.bh_acc_adjustments = ReadAdjustmentData(myself)

    CreatePlayerEquipped(myself)

    ReadPMDLAdjustmentData()
end
net_Receive("BH_ACC_RequestSync", RequestSync)

local function OpenMenu()
    BH_ACC:OpenMenu()
end
net_Receive("BH_ACC_OpenMenu", OpenMenu)

function BH_ACC.HandleRequestPlayerSync(ply)
    if not ply.bh_acc_equipped_csms and (not ply.BH_ACC_delay or ply.BH_ACC_delay < CurTime()) and ply ~= myself then
        ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

        net_Start("BH_ACC_RequestSyncPlayer")
        WritePlayer(ply)
        net_SendToServer()
    end
end

local function GetPlayersData()
    local ply = ReadPlayer()
    
    if not ply or not IsValid(ply) then return end

    ply.bh_acc_equipped = ReadEquippedData()

    ply.bh_acc_equipped_lookup = {}

    local equipped_lookup = {}
    for k,v in ipairs(ply.bh_acc_equipped) do
        equipped_lookup[v] = k
    end
    ply.bh_acc_equipped_lookup = equipped_lookup

    ply.bh_acc_adjustments = ReadAdjustmentData(ply)

    CreatePlayerEquipped(ply)
end
net_Receive("BH_ACC_RequestSyncPlayer", GetPlayersData)

local function Notify()
    RunNotification(GetNotifyKey(net_ReadUInt(8)))
end
net_Receive("BH_ACC_Notify", Notify)

local function BuyAccessory()
    local id = net_ReadUInt(16)

    local owned = myself.bh_acc_owned

    local key = #owned + 1
	owned[key] = id
	myself.bh_acc_owned_lookup[id] = key

    local data = GetItemData(id)
    
    RunNotification("Notify_Bought", { data.name, BH_ACC.GetBuyPrice(myself, data.price) } )
end
net_Receive("BH_ACC_BuyItem", BuyAccessory)

function BH_ACC.FakePlayerModel_SetModel(model)
    local MDL = BH_ACC.bh_acc_model

    if IsValid(MDL) then
        SetModel(MDL, model)
        SetDModelPanelEntitySequence(MDL)

        ClearPlayerAdjustments(myself)
    end
end

function BH_ACC.FakePlayerModel_SetJobModel()
    BH_ACC.FakePlayerModel_SetModel(BH_ACC.GetJobModel(myself))
end

local function EquipAccessory()
    local ply = ReadPlayer()
    
    if not ply or not IsValid(ply) then return end

    local id = net_ReadUInt(16)

    local equipped = ply.bh_acc_equipped
    
    if not equipped then return end

    local equipped_lookup = ply.bh_acc_equipped_lookup
    local csms = ply.bh_acc_equipped_csms

    local data = GetItemData(id)

	for k,v in ipairs(equipped) do
        local v_data = GetItemData(v)

		if v_data.category == data.category then
			table_remove(equipped, k)

			equipped_lookup[v_data.id] = nil
			
            local csm = csms[k]
            if csm then
                if IsValid(csm) then
                    csm:Remove()
                end

                table_remove(csms, k)
            end

            if ply == myself and v_data.IsPlayerModel then
                BH_ACC.FakePlayerModel_SetJobModel()
            end
            
			break
		end
	end
    
    local key = #equipped + 1
	equipped[key] = id
	equipped_lookup[id] = key
    
    if data.IsPlayerModel then
        csms[key] = ""
    else
        csms[key] = BH_ACC.CreateClientSideModel(data, data.model, data.skin, data.material, data.color)
    end

    if ply == myself then
        RunNotification("Notify_Equipped", { data.name } )
        
        if data.IsPlayerModel then
            BH_ACC.FakePlayerModel_SetModel(data.model)
        end
    end
end
net_Receive("BH_ACC_EquipItem", EquipAccessory)

local function UnEquipAccessory()
    local ply = ReadPlayer()

    if not ply or not IsValid(ply) then return end

    local equipped = ply.bh_acc_equipped
    if not equipped then return end

    local equipped_lookup = ply.bh_acc_equipped_lookup
    local csms = ply.bh_acc_equipped_csms

    local id = net_ReadUInt(16)

    local key = equipped_lookup[id]
    table_remove(equipped, key)
    if IsValid(csms[key]) then
        csms[key]:Remove()
    end
    table_remove(csms, key)
    equipped_lookup[id] = nil

    if ply ~= myself then return end
    
    local data = GetItemData(id)

    RunNotification("Notify_Unequipped", { data.name } )

    if data.IsPlayerModel then
        BH_ACC.FakePlayerModel_SetJobModel()
    end
end
net_Receive("BH_ACC_UnEquipItem", UnEquipAccessory)

local function SellAccessory()
    local id = net_ReadUInt(16)

    local data = GetItemData(id)
    
    local owned = myself.bh_acc_owned
    local owned_lookup = myself.bh_acc_owned_lookup
    local equipped = myself.bh_acc_equipped
    local equipped_lookup = myself.bh_acc_equipped_lookup
    local csms = myself.bh_acc_equipped_csms

    local key = owned_lookup[id]
    table_remove(owned, key)
    owned_lookup[id] = nil

    local key = equipped_lookup[id]
    if key then
	    table_remove(equipped, key)
        equipped_lookup[id] = nil

        local csm = csms[k]
        if csm then
            if IsValid(csm) then
                csm:Remove()
            end

            table_remove(csms, key)
        end

        if data.IsPlayerModel then
            BH_ACC.FakePlayerModel_SetJobModel()
        end
    end

    --[[
	for k,v in ipairs(equipped) do
        local v_data = GetItemData(v)

		if v_data.category == data.category then
			table_remove(equipped, k)

			equipped_lookup[v_data.id] = nil
			
            local csm = csms[k]
            if csm then
                if IsValid(csm) then
                    csm:Remove()
                end

                table_remove(csms, k)
            end

            if v_data.IsPlayerModel then
                BH_ACC.FakePlayerModel_SetJobModel()
            end

			break
		end
	end]]

    RunNotification("Notify_Sold", { data.name, BH_ACC.GetSellPrice(myself, data.price) } )
end
net_Receive("BH_ACC_SellItem", SellAccessory)

local function Gift()
    local amisender = net_ReadBool()

    if amisender then
        chat_AddText(BH_ACC.ChatTagColors["ok"], BH_ACC.ChatTag, color_white, " " .. string.format(BH_ACC.Language["ChatTag_GiftByMe"], net_ReadString(), GetItemData(net_ReadUInt(16)).name))
    else
        local sender = net_ReadString()
        local id = net_ReadUInt(16)
        local data = GetItemData(id)
        local msg = net_ReadString()

        chat_AddText(BH_ACC.ChatTagColors["ok"], BH_ACC.ChatTag , color_white, " " .. string.format(BH_ACC.Language["ChatTag_GiftByOther"], data.name, sender, msg))

        local owned = myself.bh_acc_owned
        local owned_lookup = myself.bh_acc_owned_lookup

        local key = #owned + 1
        owned[key] = id
        owned_lookup[id] = key
    end
end
net_Receive("BH_ACC_GiftItem", Gift)

local function BH_ACC_Adjust()
    local ply = ReadPlayer()
    
    if not ply or not IsValid(ply) then return end
    
    local data = GetItemData(net_ReadUInt(16))
    local amt = net_ReadUInt(4)

    local model = data.model

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
    
    t.pos = t.pos or vector_origin
    t.ang = t.ang or angle_zero
    t.scale = t.scale or vector_origin
    
    ply.bh_acc_adjustments = ply.bh_acc_adjustments or {}
    ply.bh_acc_adjustments[model] = t

    ClearPlayerAdjustments(ply)
end
net_Receive("BH_ACC_Adjust", BH_ACC_Adjust)

local function PModelAdjust()
    local model = net_ReadString()
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

	if offsets[model] then
		offsets[model][bone] = t
	else
		offsets[model] = {
			[bone] = t
		}
    end

    ClearAllPlayerAdjustments()
end
net_Receive("BH_ACC_Adjust_PModel", PModelAdjust)

local math_Round = math.Round
local function ReadThreeFloatsAndRound()
	return math_Round(net_ReadFloat(), 2), math_Round(net_ReadFloat(), 2), math_Round(net_ReadFloat(), 2)
end

local function EditorCreate()
    local amt = net_ReadUInt(16)

    local t = {}

    t.IsPlayerModel = net_ReadBool()
    t.ui_Simple = net_ReadBool()

    t.name = net_ReadString()
    t.category = net_ReadString()
    
    if bit_band(amt, 1) > 0 then t.mini_category = net_ReadString() end
    if bit_band(amt, 2) > 0 then t.description = net_ReadString() end
    if bit_band(amt, 4) > 0 then t.model = net_ReadString() end
    if bit_band(amt, 8) > 0 then t.price = net_ReadUInt(32) end
    if bit_band(amt, 16) > 0 then t.bone = net_ReadString() end
    if bit_band(amt, 32) > 0 then t.material = net_ReadString() end
    if bit_band(amt, 64) > 0 then t.skin = net_ReadUInt(8) end
    if bit_band(amt, 128) > 0 then t.offsetV = Vector(ReadThreeFloatsAndRound()) end
    if bit_band(amt, 256) > 0 then t.offsetA = Angle(ReadThreeFloatsAndRound()) end
    if bit_band(amt, 512) > 0 then t.scale = Vector(ReadThreeFloatsAndRound()) end
    if not t.ui_Simple then
        if bit_band(amt, 1024) > 0 then t.ui_FOV = net_ReadFloat() end
        if bit_band(amt, 2048) > 0 then t.ui_CamPos = Vector(ReadThreeFloatsAndRound()) end
        if bit_band(amt, 4096) > 0 then t.ui_LookAng = Angle(ReadThreeFloatsAndRound()) end
    end
    t.price = t.price or 0
    t.id = BH_ACC.GetItemCount() + 1

    local user = {}
    local lookup = {}
    for i = 1, net_ReadUInt(8) do
        local nam = net_ReadString()
        user[i] = nam
        lookup[nam] = true
    end
    if #user <= 0 then user = nil end

    t.user = user
    t.userlookup = lookup

    BH_ACC.EditorCreateUpdateItemData(t)
end
net_Receive("BH_ACC_EditorCreate", EditorCreate)

local function EditorSave()
    local oldid = net_ReadUInt(16)
    local olddata = GetItemData(oldid)
    local amt = net_ReadUInt(16)

    local t = table.Copy(BH_ACC.Items[oldid])

    t.IsPlayerModel = net_ReadBool()
    t.ui_Simple = net_ReadBool()

    if bit_band(amt, 1) > 0 then t.name = net_ReadString() end
    if bit_band(amt, 2) > 0 then t.category = net_ReadString() end
    if bit_band(amt, 4) > 0 then t.mini_category = net_ReadString() end
    if bit_band(amt, 8) > 0 then t.description = net_ReadString() end
    if bit_band(amt, 16) > 0 then t.model = net_ReadString() end
    if bit_band(amt, 32) > 0 then t.price = net_ReadUInt(32) end
    if bit_band(amt, 64) > 0 then t.bone = net_ReadString() end
    if bit_band(amt, 128) > 0 then t.material = net_ReadString() end
    if bit_band(amt, 256) > 0 then t.skin = net_ReadUInt(8) end
    if bit_band(amt, 512) > 0 then t.offsetV = Vector(ReadThreeFloatsAndRound()) end
    if bit_band(amt, 1024) > 0 then t.offsetA = Angle(ReadThreeFloatsAndRound()) end
    if bit_band(amt, 2048) > 0 then t.scale = Vector(ReadThreeFloatsAndRound()) end
    if not t.ui_Simple then
        if bit_band(amt, 4096) > 0 then t.ui_FOV = net_ReadFloat() end
        if bit_band(amt, 8192) > 0 then t.ui_CamPos = Vector(ReadThreeFloatsAndRound()) end
        if bit_band(amt, 16384) > 0 then t.ui_LookAng = Angle(ReadThreeFloatsAndRound()) end
    end
    
    t.price = t.price or 0
    
    local user = {}
    local lookup = {}
    for i = 1, net_ReadUInt(8) do
        local nam = net_ReadString()
        user[i] = nam
        lookup[nam] = true
    end
    if #user <= 0 then user = nil end

    t.name = t.name or olddata.name
    t.user = user
    t.userlookup = lookup

    if olddata.name == t.name then
        BH_ACC.EditorSaveUpdateItemData(oldid, t)
    else
        t.id = BH_ACC.GetItemCount()
        
		BH_ACC.EditorRemoveAndAddNew(oldid, t)

        local newid = t.id

        local ispmodel = t.IsPlayerModel
        local oldispmodel = olddata.IsPlayerModel
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
					v:SetModel(t.model)
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

                if v == myself and olddata.IsPlayerModel then
                    BH_ACC.FakePlayerModel_SetJobModel()
                end
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

    for k,v in ipairs(player_GetAll()) do
        CreatePlayerEquipped(v)
    end
end
net_Receive("BH_ACC_EditorSave", EditorSave)

local function EditorDelete()
    BH_ACC.EditorDelete(GetItemData(net_ReadUInt(16)))
end
net_Receive("BH_ACC_EditorDelete", EditorDelete)

local net_ReadVector = net.ReadVector
local net_ReadAngle = net.ReadAngle
local function ReceiveSPoints()
    BH_ACC.Spawns = {}
    local spawns = BH_ACC.Spawns

    for i = 1, net_ReadUInt(8) do
        spawns[i] = {
            pos = net_ReadVector(),
            ang = net_ReadAngle()
        }
    end
end
net_Receive("BH_ACC_SP_Req", ReceiveSPoints)

-- Clientside Sending --
function BH_ACC.BuyAccessory(id)
    net_Start("BH_ACC_BuyItem")
    net_WriteUInt(id, 16)
    net_SendToServer()
end

function BH_ACC.EquipAccessory(id)
    net_Start("BH_ACC_EquipItem")
    net_WriteUInt(id, 16)
    net_SendToServer()
end

function BH_ACC.UnEquipAccessory(id)
    net_Start("BH_ACC_UnEquipItem")
    net_WriteUInt(id, 16)
    net_SendToServer()
end

function BH_ACC.SellAccessory(id)
    net_Start("BH_ACC_SellItem")
    net_WriteUInt(id, 16)
    net_SendToServer()
end

function BH_ACC.GiftItem(target, id, msg)
    net_Start("BH_ACC_GiftItem")
    WritePlayer(target)
    net_WriteUInt(id, 16)
    net_WriteString(msg)
    net_SendToServer()
end

function BH_ACC.AdjustAccessory(id, pos, ang, scale)
    net_Start("BH_ACC_Adjust")
    net_WriteUInt(id, 16)
    WriteThreeFloats(pos or vector_origin)
    WriteThreeFloats(ang or angle_zero)
    WriteThreeFloats(scale or vector_origin)
    net_SendToServer()
end

function BH_ACC.AdjustPModel(model, bone, pos, ang, scale)
    net_Start("BH_ACC_Adjust_PModel")
    net_WriteString(model)
    net_WriteString(bone)
    WriteThreeFloats(pos)
    WriteThreeFloats(ang)
    WriteThreeFloats(scale)
    net_SendToServer()
end

function BH_ACC.EditorCreate(data)
    local send = 0
        
    local check1 = data.mini_category
    local check2 = data.description
    local check3 = data.model
    local check4 = data.price
    local check5 = data.bone
    local check6 = data.material
    local check7 = data.skin
    local check8 = data.offsetV
    local check9 = data.offsetA
    local check10 = data.scale
    local check11 = data.ui_FOV
    local check12 = data.ui_CamPos
    local check13 = data.ui_LookAng

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
    if not data.ui_Simple then
        if check11 then send = send + 1024 end
        if check12 then send = send + 2048 end
        if check13 then send = send + 4096 end
    end

    net_Start("BH_ACC_EditorCreate")
    net_WriteUInt(send, 16)
    net_WriteBool(data.IsPlayerModel)
    net_WriteBool(data.ui_Simple)
    net_WriteString(data.name)
    net_WriteString(data.category)
    if check1 then net_WriteString(check1) end
    if check2 then net_WriteString(check2) end
    if check3 then net_WriteString(check3) end
    if check4 then net_WriteUInt(check4, 32) end
    if check5 then net_WriteString(check5) end
    if check6 then net_WriteString(check6) end
    if check7 then net_WriteUInt(check7, 8) end
    if check8 then WriteThreeFloats(check8) end
    if check9 then WriteThreeFloats(check9) end
    if check10 then WriteThreeFloats(check10) end
    if not data.ui_Simple then
        if check11 then net_WriteFloat(check11) end
        if check12 then WriteThreeFloats(check12) end
        if check13 then WriteThreeFloats(check13) end
    end

    local user = data.user
    local amt = #data.user
    net_WriteUInt(amt, 8)
    for i = 1, amt do
        net_WriteString(user[i])
    end
    net_SendToServer()
end

function BH_ACC.CL_EditorDelete(id)
    net_Start("BH_ACC_EditorDelete")
    net_WriteUInt(id, 16)
    net_SendToServer()
end

function BH_ACC.EditorSave(olddata, data)
    local send = 0
        
    local check1 = data.name ~= olddata.name
    local check2 = data.category ~= olddata.category
    local check3 = data.mini_category and data.mini_category ~= olddata.mini_category
    local check4 = data.description and data.description ~= olddata.description
    local check5 = data.model ~= olddata.model
    local check6 = data.price and data.price ~= olddata.price
    local check7 = data.bone and data.bone ~= olddata.bone
    local check8 = data.material and data.material ~= olddata.material
    local check9 = data.skin and data.skin ~= olddata.skin
    local check10 = data.offsetV ~= olddata.offsetV
    local check11 = data.offsetA ~= olddata.offsetA
    local check12 = data.scale ~= olddata.scale
    local check13 = data.ui_FOV ~= olddata.ui_FOV
    local check14 = data.ui_CamPos ~= olddata.ui_CamPos
    local check15 = data.ui_LookAng ~= olddata.ui_LookAng

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
    if check11 then send = send + 1024 end
    if check12 then send = send + 2048 end
    if not data.ui_Simple then
        if check13 then send = send + 4096 end
        if check14 then send = send + 8192 end
        if check15 then send = send + 16384 end
    end

    net_Start("BH_ACC_EditorSave")
    net_WriteUInt(olddata.id, 16)
    net_WriteUInt(send, 16)
    net_WriteBool(data.IsPlayerModel)
    net_WriteBool(data.ui_Simple)
    if check1 then net_WriteString(data.name) end
    if check2 then net_WriteString(data.category) end
    if check3 then net_WriteString(data.mini_category) end
    if check4 then net_WriteString(data.description) end
    if check5 then net_WriteString(data.model) end
    if check6 then net_WriteUInt(data.price, 32) end
    if check7 then net_WriteString(data.bone) end
    if check8 then net_WriteString(data.material) end
    if check9 then net_WriteUInt(data.skin, 8) end
    if check10 then WriteThreeFloats(data.offsetV) end
    if check11 then WriteThreeFloats(data.offsetA) end
    if check12 then WriteThreeFloats(data.scale) end
    if not data.ui_Simple then
        if check13 then net_WriteFloat(data.ui_FOV) end
        if check14 then WriteThreeFloats(data.ui_CamPos) end
        if check15 then WriteThreeFloats(data.ui_LookAng) end
    end

    local user = data.user
    local amt = #data.user
    net_WriteUInt(amt, 8)
    for i = 1, amt do
        net_WriteString(user[i])
    end
    net_SendToServer()
end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "cl_bh_acc_net")
end