local LerpAngle = LerpAngle
local LerpAngle = LerpAngle
local CurTime = CurTime
local IsValid = IsValid

BH_ACC.Selected = BH_ACC.Categories[1] and BH_ACC.Categories[1].name
BH_ACC.OldSelected = BH_ACC.Selected
BH_ACC.CalcView_AnimationStart = CurTime()

function BH_ACC:ChangeSelected(new)
    self.CalcView_AnimationStart = CurTime()
    self.OldSelected = self.Selected
    self.Selected = new
end

local lerpedvector = Vector(0,0,0)
local lerpangle = Angle(0,0,0)
local Anim_Duration = 2

local pow = math.pow
local function OutExpo(t, b, c, d)
	if t == d then return b + c end
	return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
end

local Alive = FindMetaTable("Player").Alive
local GetAngles = FindMetaTable("Entity").GetAngles

function BH_ACC:CalcView(ply, pos, angles, fov)
    if not Alive(ply) or not self.Selected or not IsValid(self.bh_acc_menu) then return end

    local old = self.AllCategoryCameraView[self.OldSelected]
    local new = self.AllCategoryCameraView[self.Selected]
    local fraction = OutExpo((CurTime() - self.CalcView_AnimationStart) / Anim_Duration, 0, 1, 1)
    
    lerpedvector = LerpVector(fraction, old[1], new[1])
    lerpangle = LerpAngle(fraction, old[2], new[2])

    local angles = GetAngles(ply)
    local ang = self.AngleOffset(Angle(0, angles.y, angles.r), lerpangle)
    
    return {
        origin = self.VectorOffset(pos, lerpedvector, ang),
        angles = ang,
        drawviewer = true
    }
end

local function BH_ACC_CalcView(ply, pos, angles, fov)
    local v = BH_ACC:CalcView(ply, pos, angles, fov)
    if v then
	    return v
    end
end
hook.Add( "CalcView", "BH_ACC_CalcView", BH_ACC_CalcView )

function BH_ACC:RemoveChat(name)
	if name == "CHudChat" and (IsValid(self.Acc_Menu) and not self.Show_Chat) then
		return false
	end
end

local function BH_ACC_Remove_Chat(name)
    local b = BH_ACC:RemoveChat(name)
    if b then
	    return b
    end
end
hook.Add( "HUDShouldDraw", "BH_ACC_Remove_Chat", BH_ACC_Remove_Chat )

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "cl_bh_acc_view")
end