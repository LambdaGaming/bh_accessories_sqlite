AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Accessory Change"
	SWEP.DrawWeaponInfoBox = false
end

SWEP.Category = "BH Weapons"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self.PrintName = BH_ACC.Language["Accessory Changer"]
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	if (SERVER) then
		local ply = self:GetOwner()

		if ply.BH_ACC_delay > CurTime() then return end
		ply.BH_ACC_delay = CurTime() + BH_ACC.NetDelay

		if not BH_ACC.CanUseSystem(ply) then
			BH_ACC.Notify("NoAccesstoSystem", ply)
			return
		end

		BH_ACC.OpenMenu(ply)
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

if (CLIENT) then
	function SWEP:PreDrawViewModel()
		render.SetBlend(0)
	end

	function SWEP:PostDrawViewModel()
		render.SetBlend(1)
	end

	function SWEP:DrawWorldModel()
	end
end