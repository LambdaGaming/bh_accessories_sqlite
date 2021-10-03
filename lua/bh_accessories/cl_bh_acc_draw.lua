local Vector = Vector
local Angle = Angle
local ipairs = ipairs
local IsValid = IsValid
local ClientsideModel = ClientsideModel
local CurTime = CurTime
local Matrix = Matrix
local vector_origin = vector_origin
local angle_zero = angle_zero

local player_GetAll = player.GetAll

local _P = FindMetaTable("Player")
local Alive = _P.Alive
local GetRagdollEntity = _P.GetRagdollEntity

local _E = FindMetaTable("Entity")
local GetModel = _E.GetModel
local GetBoneMatrix = _E.GetBoneMatrix
local SetPos = _E.SetPos
local SetAngles = _E.SetAngles
local SetupBones = _E.SetupBones
local DrawModel = _E.DrawModel
local SetPredictable = _E.SetPredictable
local DrawShadow = _E.DrawShadow
local DestroyShadow = _E.DestroyShadow
local SetNoDraw = _E.SetNoDraw
local LookupBone = _E.LookupBone
local GetPos = _E.GetPos
local SetSkin = _E.SetSkin
local SetMaterial = _E.SetMaterial
local SetColor = _E.SetColor
local ResetSequence = _E.ResetSequence
local SetModel = _E.SetModel

local _VM = FindMetaTable("VMatrix")
local GetTranslation = _VM.GetTranslation
local GetAngles = _VM.GetAngles

local _A = FindMetaTable("Angle")
local RotateAroundAxis = _A.RotateAroundAxis
local Forward = _A.Forward
local Right = _A.Right
local Up = _A.Up
local Set = _A.Set

local DistToSqr = FindMetaTable("Vector").DistToSqr

local hovered_item = NULL

local GetItemData = BH_ACC.GetItemData
local GetItemDataByName = BH_ACC.GetItemDataByName

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/cl_bh_acc_draw", function(filename)
    if filename == "sh_bh_acc" then
        GetItemData = BH_ACC.GetItemData
        GetItemDataByName = BH_ACC.GetItemDataByName
    end
end)

local myself = LocalPlayer()
local function Grab()
    myself = LocalPlayer()
end
hook.Add("InitPostEntity", "BH_ACC_IPEGrabLocalPlayer", Grab)

-- Why not use fetch everything from the data table? --
-- I create the player through this so data is unnecessary --
function BH_ACC.CreateClientSideModel(data, m, s, mat, c)
    local csm = ClientsideModel(m)

    if not IsValid(csm) then return csm end

    if s then SetSkin( csm, s ) end
    if mat then SetMaterial(csm, mat ) end
    if c then SetColor( csm, c ) end

    csm.data = data

    SetPredictable(csm, false)
    DrawShadow(csm, false)
    DestroyShadow(csm)
    SetNoDraw(csm, true )
    
    return csm
end
local CreateClientSideModel = BH_ACC.CreateClientSideModel

function BH_ACC.VectorOffset(pos, offset, ang)
	return Vector(pos + Forward(ang) * offset.x + Right(ang) * offset.y + Up(ang) * offset.z)
end
local VectorOffset = BH_ACC.VectorOffset

function BH_ACC.AngleOffset(ang, offset)
	local newang = Angle(0,0,0)
	Set(newang, ang)
	RotateAroundAxis(newang, Up(newang), offset.y)
	RotateAroundAxis(newang, Right(newang), offset.p)
	RotateAroundAxis(newang, Forward(newang), offset.r)
	return newang
end
local AngleOffset = BH_ACC.AngleOffset

local offsets = BH_ACC.ModelOffsets
function BH_ACC.GetModelOffsetV(model, bone)
    return ((offsets[model] and offsets[model][bone] and offsets[model][bone].pos) or vector_origin)
end
local GetModelOffsetV = BH_ACC.GetModelOffsetV

function BH_ACC.GetModelOffsetA(model, bone)
    return ((offsets[model] and offsets[model][bone] and offsets[model][bone].ang) or angle_zero)
end
local GetModelOffsetA = BH_ACC.GetModelOffsetA

BH_ACC.MDLBoneCache = BH_ACC.MDLBoneCache or {}

function BH_ACC.LookupBone(ent, bone)
    local mdl = GetModel(ent)

	local names = {
		["HEAD"] = "ValveBiped.Bip01_Head1",
		["SPINE"] = "ValveBiped.Bip01_Spine2",
		["FOOT"] = "ValveBiped.Bip01_R_Foot",
	}

	if names[bone] then
		bone = names[bone]
	end

    local mc = BH_ACC.MDLBoneCache[mdl]
    if not mc then
        mc = {}
        BH_ACC.MDLBoneCache[mdl] = mc
    end

    local cached = mc[bone]
    if cached then
        return cached
    end

    local boneid = LookupBone(ent, bone)
    mc[bone] = boneid

    return boneid
end
local LookupBone = BH_ACC.LookupBone

local seqcache = {}
function BH_ACC.LookupSequence(ent, name)
	local mdl = ent:GetModel()

	local sc = seqcache[mdl]
	if not sc then
		sc = {}
		seqcache[mdl] = sc
	end

	local cached = sc[name]
	if cached then
		return cached[1], cached[2]
	end

	local id, lenght = ent:LookupSequence(name)
	sc[name] = {id, lenght}

	return sc[name][1], sc[name][2]
end
local LookupSequence = BH_ACC.LookupSequence

function BH_ACC.RunAdjustments(ply, csm)
    if csm.BH_ACC_RanAdjustments then return end
    csm.BH_ACC_RanAdjustments = true

    local data = csm.data

    -- We have to do Vector(csm.data.scale) and Vector(1,1,1) because if you cache them it will override csm.data.scale
    -- Don't do that pls :( The addon is already peak optimization
    local scale = data.scale and Vector(data.scale) or Vector(1,1,1)

    if ply.bh_acc_adjustments then
        local adj = ply.bh_acc_adjustments[GetModel(csm)]
        if adj then
            csm.adjp = adj.pos
            csm.adja =  adj.ang

            scale = scale + adj.scale
        end
    end

    local thing
    if ply == myself then
        thing = offsets[IsValid(BH_ACC.bh_acc_model) and BH_ACC.bh_acc_model:GetModel() or GetModel(ply)]
    else
        thing = offsets[GetModel(ply)]
    end

    local bone = csm.data.bone
    if thing and thing[bone] then
        local mdlscale = thing[bone].scale
        if mdlscale then
            scale = scale + mdlscale
        end
    end

    local mat = Matrix()
    mat:Scale(scale)

    csm:EnableMatrix("RenderMultiply", mat)
end
local RunAdjustments = BH_ACC.RunAdjustments

-- We can clear the adjustments of one specific player here --
function BH_ACC.ClearPlayerAdjustments(ply)
    for k,v in ipairs(ply.bh_acc_equipped_csms) do
        if not IsValid(v) or isstring(v) then continue end

        v.BH_ACC_RanAdjustments = false
    end

    if ply == myself and IsValid(hovered_item) then
        hovered_item.BH_ACC_RanAdjustments = false
    end
end
local ClearPlayerAdjustments = BH_ACC.ClearPlayerAdjustments

-- This function is used for clearing all the adjustments of all the players --
-- Refering to the ones made through the positioner --
function BH_ACC.ClearAllPlayerAdjustments()
    for i, o in ipairs(player_GetAll()) do
        local csms = o.bh_acc_equipped_csms
        if not csms then continue end

        for k,v in ipairs(csms) do
            if not IsValid(v) or isstring(v) then continue end
            
            v.BH_ACC_RanAdjustments = false
        end
    end

    if IsValid(hovered_item) then
        hovered_item.BH_ACC_RanAdjustments = false
    end
end

-- We use this function to set the animation sequence onto an entity --
-- It doesn't have to be a dmodelpanel it's just named like that because i took the code from dmodelpanel --
-- github.com/Facepunch/garrysmod/blob/282331d7a05f5cdefd1f5b4802fc95aae7f09030/garrysmod/lua/vgui/dmodelpanel.lua#L61
function BH_ACC.SetDModelPanelEntitySequence(ent)
    if not IsValid(ent) then return end

    local iSeq = LookupSequence(ent, "walk_all" )
    if iSeq then
        if ( iSeq <= 0 ) then iSeq = LookupSequence(ent, "WalkUnarmed_all" ) end
        if ( iSeq <= 0 ) then iSeq = LookupSequence(ent, "walk_all_moderate" ) end

        if ( iSeq > 0 ) then ent:ResetSequence( iSeq ) end
    end
end
local SetDModelPanelEntitySequence = BH_ACC.SetDModelPanelEntitySequence

function BH_ACC.SetDModelPanelModel(dmdlp, strModelName)
	if IsValid( dmdlp.Entity ) then
		dmdlp.Entity:Remove()
		dmdlp.Entity = nil
	end

	dmdlp.Entity = ClientsideModel( strModelName, RENDERGROUP_OTHER )
    local ent = dmdlp.Entity
	if not IsValid( ent ) then return end

	ent:SetNoDraw( true )
	ent:SetIK( false )
    
    SetDModelPanelEntitySequence(ent)
end

function BH_ACC:HoverOnItem(data)
    if not self.Preview_Enabled then return end

    if IsValid(hovered_item) then
        hovered_item:Remove()
    end

    if not data.model then return end

    if data.IsPlayerModel then
        local MDL = self.bh_acc_model

        if IsValid(MDL) then
            SetModel(MDL, data.model)

            SetDModelPanelEntitySequence(MDL)
        end

        ClearPlayerAdjustments(myself)
    else
        hovered_item = CreateClientSideModel(data, data.model, data.skin, data.material, data.color)
    end
end

function BH_ACC:ExitHoverOnItem()
    if not self.Preview_Enabled then return end
    
    if IsValid(hovered_item) then
        hovered_item:Remove()
    end

    local MDL = self.bh_acc_model
    if IsValid(MDL) then
        SetModel(MDL, GetModel(myself))

        SetDModelPanelEntitySequence(MDL)
        
        ClearPlayerAdjustments(myself)
    end
end

function BH_ACC:DrawEquipped(target, csms)
    local model = GetModel(target)

    for k = 1, #csms do
        local v = csms[k]

        if not IsValid(v) or v == "" then continue end

        local data = v.data

        local data_bone = data.bone

        if not data_bone then continue end

        local bone = LookupBone(target, data_bone)

        if not bone then continue end

        local matrix = GetBoneMatrix(target, bone)

        if not matrix then continue end
    
        local boneV = GetTranslation(matrix)
        local boneA = GetAngles(matrix)
    
        if not boneV or not boneA then continue end
        
        RunAdjustments(myself, v)

        local offsetV, offsetA = data.offsetV, data.offsetA
        
        if v.adjp then offsetV = offsetV + v.adjp end

        if v.adja then offsetA = offsetA + v.adja end

        SetPos(v, VectorOffset(boneV, offsetV + GetModelOffsetV(model, data_bone), boneA) )
        SetAngles(v, AngleOffset(boneA, offsetA + GetModelOffsetA(model, data_bone)) )
        SetupBones(v)
        DrawModel(v)
    end
end
local DrawEquipped = BH_ACC.DrawEquipped

local function DrawHoveredOn()
    local MDL = BH_ACC.bh_acc_model

    if not IsValid(BH_ACC.bh_acc_menu) or not IsValid(MDL) then return end
    
    if IsValid(MDL) then
        SetPos(MDL, GetPos(myself) )
        local ang = myself:GetAngles()
        SetAngles(MDL, Angle(0, ang.y, ang.r) )
        SetupBones(MDL)
        DrawModel(MDL)
    end

    if not IsValid(hovered_item) then
        DrawEquipped(BH_ACC, MDL, myself.bh_acc_equipped_csms)
        
        return
    end

    DrawEquipped(BH_ACC, IsValid(MDL) and MDL or myself, {hovered_item})
end
hook.Add( "PostDrawTranslucentRenderables", "BH_ACC_DrawHoveredOn", DrawHoveredOn)

local DrawWhileDead = BH_ACC.DrawWhileDead
local DrawWhileArrested = BH_ACC.DrawWhileArrested

local function DrawRagdollEquipped()
    if not DrawWhileDead then return end

	local plys = player_GetAll()
	for i = 1, #plys do
		local ply = plys[i]
        local csms = ply.bh_acc_equipped_csms

		if ply:Alive() or not csms or not DrawWhileArrested and ply:isArrested() then continue end

		local ragdoll = GetRagdollEntity(ply)

		if not IsValid(ragdoll) then continue end

        DrawEquipped(BH_ACC, ragdoll, csms)
	end
end
hook.Add( "PostDrawTranslucentRenderables", "BH_ACC_Equipped_Accessories", DrawRagdollEquipped)

local function DrawEquippedPPD(ply)
    local csms = ply.bh_acc_equipped_csms

	if not Alive(ply) or not csms then return end

	if not DrawWhileArrested and ply:isArrested() then return end

	local plymodel = GetModel(ply)

	if ply ~= myself then
		local dist = BH_ACC.RenderDistance
		if dist > 0 then
			local mypos = GetPos(myself)
			if DistToSqr(mypos, GetPos(ply)) >= (dist*dist) then
				return
			end
		end
    else
        if IsValid(hovered_item) then
            return
        end
	end

	DrawEquipped(BH_ACC, ply, csms)
end
hook.Add( "PostPlayerDraw", "BH_ACC_Draw_Equiped_Me", DrawEquippedPPD)

function BH_ACC.CreatePlayerEquipped(ply)
    local csms = ply.bh_acc_equipped_csms
    if csms then
        for i = 1, #csms do
            local v = csms[i]

            if IsValid(v) then
                v:Remove()
            end
        end
    end

    ply.bh_acc_equipped_csms = {}

    csms = ply.bh_acc_equipped_csms

    local equipped = ply.bh_acc_equipped
    for k = 1, #equipped do
        local data = GetItemData(equipped[k])
        if data.IsPlayerModel then
            csms[k] = ""
        else
            csms[k] = CreateClientSideModel(data, data.model, data.skin, data.material, data.color)
        end
    end
end

if BH_ACC.Enable_Vendor_Accessories then
    BH_ACC.NPCAccessories = BH_ACC.NPCAccessories or {}
    for k,v in ipairs(BH_ACC.NPCAccessories) do
        if IsValid(v) then
            v:Remove()
        end
    end
    local NPCAccessories = BH_ACC.NPCAccessories
    
    local reai = 0
    for k,v in ipairs(BH_ACC.Vendor_Accessories) do
        local data = GetItemDataByName(v)

        if not data or data.IsPlayerModel then continue end -- If the item does not exist or it's a playermodel then just ignore --

        reai = reai + 1

        NPCAccessories[reai] = CreateClientSideModel(data, data.model, data.skin, data.material, data.color)
    end
    
    local function DrawNPCAccessories()
        offsets = BH_ACC.ModelOffsets

        for i, o in ipairs(BH_ACC.VendorEntities) do
            if not IsValid(o) then continue end

            DrawEquipped(BH_ACC, o, NPCAccessories)
        end
    end
    hook.Add("PostDrawTranslucentRenderables", "BH_ACC_DrawVendorAccessories", DrawNPCAccessories)
end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "cl_bh_acc_draw")
end