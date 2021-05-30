include("shared.lua")

local offset = Vector(0, 0, 80)

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local Draw_SimpleText = draw.SimpleText

local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize

local color_white = color_white

function ENT:DrawTranslucent()
	self:DrawModel()

	local origin = self:GetPos()
	local ply = LocalPlayer()
	if (ply:GetPos():DistToSqr(origin) >= (768 * 768)) then return end

	local pos = origin + offset
	local ang = (ply:EyePos() - pos):Angle()
	ang.p = 0
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)
	cam.Start3D2D(pos, ang, 0.035)
        -- Text and font sizes --
        local text = BH_ACC.Language["Accessory Vendor"]
        surface_SetFont("BHACC_VendorTextFont")
        local tw, th = surface_GetTextSize(text)

        local iconsize = 200

        -- Icon --
		surface_SetMaterial( BH_ACC.Materials.closet )
		surface_SetDrawColor( color_white )
		surface_DrawTexturedRect(-tw / 2 - iconsize, th / 2 - iconsize / 2, iconsize, iconsize) -- Position the icon accordingly

		--Text --
		Draw_SimpleText(text, "BHACC_VendorTextFont", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	cam.End3D2D()
end