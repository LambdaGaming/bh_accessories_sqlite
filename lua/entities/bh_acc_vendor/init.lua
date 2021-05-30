AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_01.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)
end

function ENT:Use(ply)
	if not ply:IsPlayer() then return end

	if ply.BH_ACC_delay > CurTime() then return end
	ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

	if not BH_ACC.CanUseSystem(ply) then
		BH_ACC.Notify("NoAccesstoSystem", ply)
		return
	end

	BH_ACC.OpenMenu(ply)
end