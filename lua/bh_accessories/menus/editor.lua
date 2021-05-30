local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local IsValid = IsValid
local Lerp = Lerp
local CurTime = CurTime
local color_white = color_white
local table_remove = table.remove

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local RoundedBox = draw.RoundedBox
local RoundedBoxEx = draw.RoundedBoxEx
local SimpleText = draw.SimpleText
local DrawText = draw.DrawText
local SetMaterial = surface.SetMaterial
local DrawTexturedRect = surface.DrawTexturedRect
local GetTextSize = surface.GetTextSize
local SetFont = surface.SetFont

local function EmptyFunc() end

local string_sub = string.sub

local bh_language = BH_ACC.Language
local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

local LerpColor = BH_ACC.LerpColor
local Create_DNumSlider = BH_ACC.Create_DNumSlider
local CreateDPanel = BH_ACC.CreateDPanel
local CreateDButton = BH_ACC.CreateDButton
local CreateDModelPanel = BH_ACC.CreateDModelPanel
local CreateBetterTextEntry = BH_ACC.CreateBetterTextEntry
local CreateTextEntry = BH_ACC.CreateTextEntry
local CreateDFrame = BH_ACC.CreateDFrame
local ChangeSelected = BH_ACC.ChangeSelected
local RemovePanel = BH_ACC.RemovePanel
local TextWrap = BH_ACC.TextWrap

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/editor", function(filename)
    if filename == "bh_acc_config" then
        bh_language = BH_ACC.Language
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors
    elseif filename == "cl_bh_acc_ui" then
        Create_DNumSlider = BH_ACC.Create_DNumSlider
        CreateDPanel = BH_ACC.CreateDPanel
        CreateDButton = BH_ACC.CreateDButton
        CreateDModelPanel = BH_ACC.CreateDModelPanel
        CreateBetterTextEntry = BH_ACC.CreateBetterTextEntry
        CreateTextEntry = BH_ACC.CreateTextEntry
        CreateDFrame = BH_ACC.CreateDFrame
        RemovePanel = BH_ACC.RemovePanel
    elseif filename == "cl_bh_acc_fonts" then
        TextWrap = BH_ACC.TextWrap
    elseif filename == "cl_bh_acc_view" then
        ChangeSelected = BH_ACC.ChangeSelected
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/editor", function()
    ScaleY = BH_ACC.ScaleY
end)

function BH_ACC:CreateEditorUIPos(olddata, callback)
    RemovePanel(self.bh_acc_uiposmenu)

    local data = table.Copy(olddata)

    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()
    local space = ScaleY(5)

    local mdl = data.model
    local vector = data.ui_CamPos or Vector(50, 50, 50)
    local angle = data.ui_LookAng or Angle(0,0,0)
    local fov = data.ui_FOV or 10
    
    local x, y = ScaleY(1000), ScaleY(800)
    self.bh_acc_uiposmenu = CreateDFrame(scrw / 2 - x / 2, scrh / 2 - y / 2, scrw, scrh)
    local bg = self.bh_acc_uiposmenu
    bg.Time = SysTime()
    bg.Paint = function(me, w, h)
        Derma_DrawBackgroundBlur(me, me.Time - 0.6)
    end

    local m = CreateDPanel(bg, 0, 0, x, y)
    m.Paint = function(me,w,h)
        RoundedBox( ScaleY(5), 0, 0, w , h, colors.body_transparent )
    end

    local remsize = ScaleY(46)
    local rem = CreateDButton(m, x - remsize, space, remsize, remsize)
    rem.Paint = function(me,w,h)
        SimpleText("X", "BHACC_HelpArrowFont", w / 2, h / 2, colors.exit, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    rem.DoClick = function()
        bg:Remove()
    end

    local confirm = CreateDButton(m, space, y - ScaleY(46) - space, x - space * 2, ScaleY(46))
    confirm.Paint = function(me,w,h)
        RoundedBox( ScaleY(5), 0, 0, w , h, colors.confirm_color )

        SimpleText(bh_language["Confirm"], "BHACC_FLarge", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local poswithoutsimple = {
        fov,
        vector,
        angle
    }

    local model = m:Add("DAdjustableModelPanel")
    model:SetPos(space, remsize + space * 2)
    model:SetSize(x - space * 2, y - space * 4 - remsize * 2)
    model:SetModel( mdl )
    function model:LayoutEntity( Entity )
        if not data.ui_Simple then
            poswithoutsimple[1] = model:GetFOV()
            poswithoutsimple[2] = model:GetCamPos()
            poswithoutsimple[3] = model:GetLookAng()
        end

        return
    end
    confirm.DoClick = function()
        bg:Remove()

        callback({
            data.ui_Simple,
            model:GetFOV(),
            model:GetCamPos(),
            model:GetLookAng()
        })
    end
    
    if data.ui_Simple then
        local ent = model:GetEntity()
        local pos = ent:GetPos()
        local ang = ent:GetAngles()
    
        local tab = PositionSpawnIcon( ent, pos, true )
    
        ent:SetAngles( ang )
        if ( tab ) then
            model:SetCamPos( tab.origin )
            model:SetFOV( tab.fov )
            model:SetLookAng( tab.angles )
        end

        model:SetMouseInputEnabled(false)
    else
        model:SetFOV(fov)
        model:SetCamPos(vector)
        model:SetLookAng(angle)

        model:SetMouseInputEnabled(true)
    end

    local time = CurTime() + 1
    local round = math.Round
    local function roundval(val)
        return round(val, 2)
    end
    model.PaintOver = function(me,w,h)
        SetDrawColor(color_white)
        surface.DrawOutlinedRect(0,0,w,h)

        if CurTime() >= time then
            time = CurTime() + 1
            print()
            local v = me.vCamPos
            print("ui_CamPos = Vector(" .. roundval(v[1]) .. ", " .. roundval(v[2]) .. ", " .. roundval(v[3]) .. ")")
            v = me.fFOV
            print("ui_FOV = " .. roundval(v))
            v = me.aLookAngle
            print("ui_LookAng = Angle(" .. roundval(v[1]) .. ", " .. roundval(v[2]) .. ", " .. roundval(v[3]) .. ")")
        end
    end

    local enablesimplpw, enablesimpleh = ScaleY(356), ScaleY(46)
    local enablesimple = CreateDPanel(m, space, space, enablesimplpw, enablesimpleh)
    enablesimple.Paint = function(me,w,h)
        RoundedBox( space, 0, 0, w , h, colors.body )

        SimpleText(bh_language["Simple_Pos"], "BHACC_FLarge", space, h / 2, colors.x, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local btnsimple = CreateDButton(enablesimple, enablesimplpw - ScaleY(42) - space,  space, ScaleY(42), enablesimpleh - space * 2)
    btnsimple.Paint = function(me,w,h)
        RoundedBox( space, 0, 0, w , h, colors.body_transparent )

        if data.ui_Simple then
            SimpleText("✔", "BHACC_FLarge", w / 2, h / 2, colors.addnew, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            SimpleText("X", "BHACC_FLarge", w / 2, h / 2, colors.exit, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    btnsimple.DoClick = function()
        data.ui_Simple = !data.ui_Simple

        if data.ui_Simple then
            local ent = model:GetEntity()
            local pos = ent:GetPos()
            local ang = ent:GetAngles()
        
            local tab = PositionSpawnIcon( ent, pos, true )
        
            ent:SetAngles( ang )
            if ( tab ) then
                model:SetCamPos( tab.origin )
                model:SetFOV( tab.fov )
                model:SetLookAng( tab.angles )
            end

            model:SetMouseInputEnabled(false)
        else
            model:SetFOV( poswithoutsimple[1] )
            model:SetCamPos( poswithoutsimple[2] )
            model:SetLookAng( poswithoutsimple[3] )

            model:SetMouseInputEnabled(true)
        end
    end
end

function BH_ACC:CreateEditorMenu(olddata, create, cat, minicat)
    RemovePanel(self.bh_acc_editormenu)

    local scrh = ScrH()
    local ply = LocalPlayer()
    local space = ScaleY(5)
    
    local data
    if create then
        data = {}
    else
        data = table.Copy(olddata)
    end

    if data.model then
        self:HoverOnItem(data)
    end

    data.category = data.category or cat
    data.mini_category = data.mini_category or minicat

    local x, y = ScaleY(500), scrh * 0.75
    local px, py = ScaleY(275) + ScaleY(5), scrh / 2 - (scrh * 0.75) / 2
    self.bh_acc_editormenu = CreateDPanel(self.bh_acc_menu, px, py, x, y)
    local p = self.bh_acc_editormenu
    p.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body_transparent)
    end

    local btnw, btnh = ScaleY(44), ScaleY(44)
    self.bh_acc_minigoback = CreateDButton(self.bh_acc_menu, px + x - btnw / 2, py - btnh / 2, btnw, btnh)
    local btn = self.bh_acc_minigoback
    local iconsize = ScaleY(32)
    btn.Paint = function(me,w,h)
        RoundedBox(h / 2,0,0,w,h,colors.circle_button)

        if materials.back then
            SetDrawColor(color_white)
            SetMaterial(materials.back)
            DrawTexturedRect(w / 2 - iconsize / 2 - 2, h / 2 - iconsize / 2 - 2, iconsize, iconsize)
        end
    end
    btn.DoClick = function()
        p:Remove()
        btn:Remove()
        
        local category = self.Categories[self.Category_IDS[data.category]]

        ChangeSelected(self, category.name)

        self:EditorOptions()

        if data.mini_category then
            local minicat_items = self.MiniCategories[self.MiniCategory_IDS[data.mini_category]].items
            self:CreateBottomEditorMiniCatItems(minicat_items, category)
        else
            self:CreateBottomEditorFirstItems(category)
        end
    end

    p.OnRemove = function()
        RemovePanel(btn)
        self:ExitHoverOnItem()
    end
    
    local text = bh_language["Editor_Text"]
    text = TextWrap(text, "BHACC_PositionDesc", x - ScaleY(20))
    SetFont("BHACC_PositionDesc")
    local textw, texth = GetTextSize(text)

    local textp = CreateDPanel(p, space, space, x - space * 2, texth + space * 2)
    textp.Paint = function(me, w, h)
        RoundedBox(space, 0, 0, w, h, colors.body)

        DrawText(text, "BHACC_PositionDesc", space, space, color_white)
    end

    local trim = ScaleY(28)
    local itemsize = ScaleY(128)
    local ix, iy = space, textp:GetTall() + space * 2

    local item = CreateDButton(p, ix, iy, itemsize, itemsize)

    local mdl = CreateDModelPanel(item, 0, 0, itemsize, itemsize - trim + 1, data)
    mdl.PaintOver = function(me,w,h)
        if item.Hovered then
            SimpleText(bh_language["EDIT"], "BHACC_ItemFontOverlay", w * 0.5, h / 2, colors.editcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    local dur = 0.75
    item.Paint = function(me,w,h)
        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end
        
        RoundedBoxEx(space, 0, 0, w, h, hoverlerp, true, true, false, false)

        RoundedBoxEx(space, 0, 0, w, h, colors.itembg, true, true, false, false)

        SetDrawColor(colors.body)
        DrawRect(0,h - trim + 1,w,trim)

        SimpleText(data.name, "BHACC_ItemFont", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    item.DoClick = function()
        if not data.model then return end

        self:CreateEditorUIPos(data, function(newdata)
            data.ui_Simple = newdata[1]
            data.ui_FOV = newdata[2]
            data.ui_CamPos = newdata[3]
            data.ui_LookAng = newdata[4]

            if data.ui_Simple then
                local ent = mdl:GetEntity()
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
            
                local tab = PositionSpawnIcon( ent, pos, true )
            
                ent:SetAngles( ang )
                if ( tab ) then
                    mdl:SetCamPos( tab.origin )
                    mdl:SetFOV( tab.fov )
                    mdl:SetLookAng( tab.angles )
                end
            else
                mdl:SetFOV(data.ui_FOV)
                mdl:SetCamPos(data.ui_CamPos)
                mdl:SetLookAng(data.ui_LookAng)
            end
        end)
    end
    local function OnCursorEntered()
        starthoverlerp = CurTime()
    end
    item.OnCursorEntered = OnCursorEntered

    local function OnCursorExited()
        starthoverlerp = CurTime()
    end
    item.OnCursorExited = OnCursorExited
    local ix, iy = item:GetPos()

    local desctop = CreateDPanel(p, ix + space + item:GetWide(), iy, x - itemsize - space * 3, ScaleY(32))
    desctop.Paint = function(me, w, h)
        RoundedBoxEx(space,0,0,w,ScaleY(32),colors.body, true, true, false, false)

        SimpleText(bh_language["Description"], "BHACC_PositionBoneModel", w * 0.5, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local desc = CreateBetterTextEntry(p, ix + space + item:GetWide(), iy + ScaleY(32), x - itemsize - space * 3, itemsize - ScaleY(32), data.description)
    desc.BH_ACC_OnChangedText = function(newtext)
        data.description = newtext
    end
    local oldPaint = desc.Paint
    desc.Paint = function(me, w, h)
        oldPaint(me,w,h)

        if not data.description or #data.description == 0 then
	        SimpleText(bh_language["Enter description"] .. "...", "BHACC_FMedium", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    
    local namx, namy = ix, iy + item:GetTall() + space
    local namw, namh = x - space * 2, ScaleY(42)
    local namp = CreateDPanel(p, namx, namy, namw, namh)
    namp.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Name:"]
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(namp, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local textentrywide = namw - left:GetWide()
    local right = CreateTextEntry(namp, namw - textentrywide, 0, textentrywide, namh)
	right:SetText(data.name or "")
	right:SetFont("BHACC_PositionBoneModel")
	right.Paint = function(me,w,h)
        me:DrawTextEntryText(color_white, color_white, color_white)

        if #me:GetText() == 0 then
	        SimpleText(bh_language["Enter name"] .. "...", "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
	end
    right.OnChange = function()
        data.name = right:GetValue()
    end

    local modelp = CreateDPanel(p, space, namy + namh + space, namw, namh)
    modelp.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Model:"]
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(modelp, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local textentrywide = namw - left:GetWide()
    local right = CreateTextEntry(modelp, namw - textentrywide, 0, textentrywide, namh)
	right:SetText(data.model or "")
	right:SetFont("BHACC_PositionBoneModel")
	right.Paint = function(me,w,h)
        me:DrawTextEntryText(color_white, color_white, color_white)

        if #me:GetText() == 0 then
	        SimpleText(bh_language["Enter model"] .. "...", "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
	end
    right.OnChange = function()
        data.model = right:GetValue()
        self.SetDModelPanelModel(mdl, data.model)
        self:HoverOnItem(data)
    end

    local pricep = CreateDPanel(p, space, namy + namh * 2 + space * 2, namw, namh)
    pricep.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Price:"]
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(pricep, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local textentrywide = namw - left:GetWide()
    local right = CreateTextEntry(pricep, namw - textentrywide, 0, textentrywide, namh)
	right:SetText(data.price or 0)
	right:SetFont("BHACC_PositionBoneModel")
    right:SetNumeric(true)
	right.Paint = function(me,w,h)
        me:DrawTextEntryText(color_white, color_white, color_white)

        if #me:GetText() == 0 then
	        SimpleText(bh_language["NoPrice"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
	end
    right.OnChange = function()
        data.price = tonumber(right:GetValue())
    end

    local bonep = CreateDPanel(p, space, namy + namh * 3 + space * 3, namw, namh)
    bonep.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Bone:"]

    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(bonep, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local textentrywide = namw - left:GetWide()
    local right = CreateTextEntry(bonep, namw - textentrywide, 0, textentrywide, namh)
	right:SetText(data.bone or "")
	right:SetFont("BHACC_PositionBoneModel")
	right.Paint = function(me,w,h)
        if data.IsPlayerModel then
            right:SetMouseInputEnabled(false)
            SimpleText(bh_language["DontNeedBone"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            return
        else
            right:SetMouseInputEnabled(true)
        end

        me:DrawTextEntryText(color_white, color_white, color_white)

        if #me:GetText() == 0 then
	        SimpleText(bh_language["EnterBone"] .. "...", "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
	end
    right.OnChange = function()
        data.bone = right:GetValue()

        self:HoverOnItem(data)
    end

    local matp = CreateDPanel(p, space, namy + namh * 4 + space * 4, namw, namh)
    matp.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Material:"]
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(matp, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local textentrywide = namw - left:GetWide()
    local right = CreateTextEntry(matp, namw - textentrywide, 0, textentrywide, namh)
	right:SetText(data.material or "")
	right:SetFont("BHACC_PositionBoneModel")
	right.Paint = function(me,w,h)
        if data.IsPlayerModel then
            right:SetMouseInputEnabled(false)
            SimpleText(bh_language["DontNeedMat"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            return
        else
            right:SetMouseInputEnabled(true)
        end
        
        me:DrawTextEntryText(color_white, color_white, color_white)

        if #me:GetText() == 0 then
	        SimpleText(bh_language["Enter material"] .. "...", "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
	end
    right.OnChange = function()
        if data.IsPlayerModel then return end

        data.material = right:GetValue()
        
        if not IsValid(mdl.Entity) then return end

        mdl.Entity:SetMaterial(data.material)
        self:HoverOnItem(data)
    end

    local skinp = CreateDPanel(p, space, namy + namh * 5 + space * 5, namw, namh)
    skinp.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Skin:"]
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(skinp, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local right = skinp:Add("DComboBox")
    right:SetSize(namw - left:GetWide(), namh)
    right:SetPos(namw - right:GetWide(), 0)
	right:SetTextColor(color_white)
	right:SetText("")
	right:SetFont("BHACC_PositionBoneModel")
    if IsValid(mdl.Entity) then
        for i = 0, mdl.Entity:SkinCount() - 1 do
            right:AddChoice(i)
        end
    end
    right.Paint = function(me,w,h)
        if data.IsPlayerModel then
            right:SetMouseInputEnabled(false)
            SimpleText(bh_language["DontNeedSkin"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            return
        else
            right:SetMouseInputEnabled(true)
        end

		SimpleText(data.skin or 0, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

    right.OldOpen = right.OldOpen or right.OpenMenu
    function right:OpenMenu(...)
        self.OldOpen(self, ...)
        if not IsValid(self.Menu) then return end
        self.Menu.Paint = EmptyFunc

        local t = self.Menu:GetCanvas():GetChildren()
        
        for k = 1, #t do
            local v = t[k]

            local text = v:GetText()
            v.Paint = function(me,w,h)
                RoundedBox(space,0,0,w,h,colors.body)
                RoundedBox(space,0,0,w,h,colors.hover_light)
                
                if me.Hovered then
                    RoundedBox(space, 0, 0, w, h, colors.hover)
                end

                SimpleText(text, "BHACC_PositionBoneModel", w * 0.5, h * 0.5, greyish_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                return true
            end
        end
    end
    right.OnSelect = function( me, index, value )
        me:SetText("")

        data.skin = tonumber(value)

        if not IsValid(mdl.Entity) then return end

        mdl.Entity:SetSkin(value)
        self:HoverOnItem(data)
    end

    local usergrp = CreateDPanel(p, space, namy + namh * 6 + space * 6, namw, namh)
    usergrp.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local text = bh_language["Usergroups:"]
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(usergrp, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    data.user = data.user or {}
    local right = CreateDButton(usergrp, namw - (namw - left:GetWide()), 0, namw - left:GetWide(), namh)
	right.Paint = function(me,w,h)
        if #data.user == 0 then
	        SimpleText(bh_language["All Allowed"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            local text = ""
            for k,v in ipairs(data.user) do
                if k == 1 then
                    text = text .. v
                else
                    text = text .. ", " .. v
                end
            end

            if #text >= 23 then
                text = string_sub(text, 0, 23) .. "..."
            end

            SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
	end
    right.DoClick = function()
        local ply = LocalPlayer()
        
        local x, y = ScaleY(300), ScaleY(125)
        local dmenu = self:CreateDermaMenu(x, y)

        local addnew = CreateDButton(dmenu, 0, 0, x - ScaleY(32) - 2, ScaleY(32))
        SetFont("BHACC_PositionBoneModel")
        local plusw, plush = GetTextSize("+ ")
        addnew.Paint = function(me,w,h)
            SimpleText("+", "BHACC_PositionBoneModel", space, h / 2, colors.addnew, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            SimpleText(bh_language["Add new"], "BHACC_PositionBoneModel", space + plusw, h / 2, colors.addnew, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local panels = {}
        local count = 0

        local confirm = CreateDButton(dmenu, x - ScaleY(32), 0, ScaleY(32), ScaleY(32))
        confirm.Paint = function(me,w,h)
            SimpleText("✔", "BHACC_PositionBoneModel", w / 2, h / 2, colors.addnew, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        confirm.DoClick = function()
            data.user = {}

            for k,v in ipairs(panels) do
                local name = v.textentry:GetText():Trim()

                if #name <= 0 then continue end

                data.user[#data.user + 1] = name
            end

            RemovePanel(self.bh_acc_pickaccessory)
        end

        local bottom = CreateDPanel(dmenu, 0, addnew:GetTall(), x, y - addnew:GetTall())
        bottom.Paint = function(me,w,h)
            RoundedBox(space,0,0,w,h,colors.hover_light)
        end
        local uwidth, uheight = bottom:GetWide(), bottom:GetTall() / 3

        addnew.DoClick = function()
            if dmenu:GetTall() >= scrh then return end

            count = count + 1

            local dmenux, dmenuy = dmenu:GetPos()
            dmenu:SetSize(x, addnew:GetTall() + math.max(uheight * count, uheight * 3))
            if dmenuy + dmenu:GetTall() > scrh then
                dmenu:SetPos(dmenux, scrh - dmenu:GetTall())
            end
            bottom:SetSize(x, dmenu:GetTall() - addnew:GetTall())

            panels[count] = CreateDPanel(bottom, 0, count * uheight - uheight, uwidth, uheight)
            local p = panels[count]

            local iconsize = ScaleY(32)

            local name = CreateTextEntry(p, 2, 2, uwidth - iconsize - 4, uheight - 4)
            name:SetFont("BHACC_FSmall")
            p.textentry = name

            local del = CreateDButton(p, uwidth - iconsize - 2, 0, iconsize, iconsize)
            del.Paint = function(me,w,h)
                local size = ScaleY(24)

                SetDrawColor(colors.exit)
                SetMaterial(materials.trashcan)
                DrawTexturedRect(w / 2 - size / 2,h / 2 - size / 2,size,size)
            end
            del.DoClick = function()
                p:Remove()

                for k,v in ipairs(panels) do
                    if not IsValid(v) then
                        table_remove(panels, k)
                        count = count - 1
                        break
                    end
                end

                for i = 1, count do
                    local v = panels[i]

                    v:SetPos(0, i * uheight - uheight)
                end

                local dmenux, dmenuy = dmenu:GetPos()
                dmenu:SetSize(x, addnew:GetTall() + math.max(uheight * count, uheight * 3))
                if dmenuy + dmenu:GetTall() > scrh then
                    dmenu:SetPos(dmenux, scrh - dmenu:GetTall())
                end
                bottom:SetSize(x, dmenu:GetTall() - addnew:GetTall())
            end
        end
    end
    
    local IsPlayerModelp = CreateDPanel(p, space, namy + namh * 7 + space * 7, namw, namh)
    IsPlayerModelp.Paint = function(me,w,h)
        RoundedBox(space,0,0,w,h,colors.body)
    end

    local CreateOffset
    local offsetbottom
    
    local text = bh_language["IsPModel"] .. ":"
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(text)
    local left = CreateDPanel(IsPlayerModelp, 0, 0, tw + space * 2, namh)
    left.Paint = function(me,w,h)
        SimpleText(text, "BHACC_PositionBoneModel", space, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local right = CreateDButton(IsPlayerModelp, namw - right:GetWide(), 0, namw - left:GetWide(), namh)
	right.Paint = function(me,w,h)
	    SimpleText(data.IsPlayerModel and "Yes" or "No", "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
    right.DoClick = function()
        data.IsPlayerModel = !data.IsPlayerModel

        self:ExitHoverOnItem()
        if data.model then
            self:HoverOnItem(data)
        end

        if data.IsPlayerModel then
            offsetbottom:Clear()
            offsetbottom.Paint = function(me,w,h)
                RoundedBox(space, 0, 0, w, h, colors.body)
                
                SimpleText(bh_language["DontNeedPosition"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        else
            CreateOffset()
        end
    end
    
    local lastpw, lastph = namw, ScaleY(30)
    local lastp = CreateDPanel(p, space, y - (ScaleY(30)) - space, lastpw, lastph)

    if create then
        local crt = CreateDButton(lastp, 0, 0, lastpw, lastph)
        crt.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.confirm_color)
            SimpleText(bh_language["Create"], "BHACC_PositionBoneModel", w / 2, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        crt.DoClick = function()
            if not data.name or #data.name:Trim() <= 0 then
                self.RunNotification("Notify_Editor_NoName")
                
                return
            end

            if self.GetItemDataByName(data.name) then
                self.RunNotification("Notify_Editor_AlreadyExist")

                return
            end

            if not data.model or #data.model:Trim() <= 0 then
                self.RunNotification("Notify_Editor_NoModel")

                return
            end

            self.EditorCreate(data)
        end
    else
        local del = CreateDButton(lastp, 0, 0, lastpw / 2 - space / 3, lastph)
        del.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.exit)
            SimpleText(bh_language["Delete"], "BHACC_PositionBoneModel", w / 2, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        del.DoClick = function()
            self.CL_EditorDelete(data.id)
        end

        local savew = lastpw / 2 - space / 3
        local save = CreateDButton(lastp, lastpw - savew, 0, savew, lastph)
        save.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.confirm_color)
            SimpleText(bh_language["Save"], "BHACC_PositionBoneModel", w / 2, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        save.DoClick = function()
            if not data.name or #data.name:Trim() <= 0 then
                self.RunNotification("Notify_Editor_NoName")
                
                return
            end

            if not data.model or #data.model:Trim() <= 0 then
                self.RunNotification("Notify_Editor_NoModel")

                return
            end

            self.EditorSave(olddata, data)
        end
    end

    local height = ScaleY(12)
    local width = ScaleY(85)

    local _, offy = IsPlayerModelp:GetPos()
    offy = offy + IsPlayerModelp:GetTall() + space
    offsetbottom = CreateDPanel(p, space, offy, namw, p:GetTall() - offy - lastp:GetTall() - space * 2)
    offsetbottom.Paint = function(me,w,h)
        RoundedBox(space, 0, 0, w, h, colors.body)

        SimpleText(bh_language["DontNeedPosition"], "BHACC_PositionBoneModel", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local chosenoffset = 1
    CreateOffset = function()
        offsetbottom.Paint = EmptyFunc

        for i = 1, 3 do
            local btn = CreateDButton(offsetbottom, namw / 2 + width * i - width - width * 3 / 2 + space * i - space - space * 3 / 2, 0, width, height)
            local mylerp = 0
            local mystart = CurTime()
            local mydur = 0.1
            btn.Paint = function(me,w,h)
                mylerp = Lerp((CurTime() - mystart) / mydur, 0, 1)

                RoundedBox(space, 0, 0, w, h, colors.body)

                if chosenoffset == i then
                    RoundedBox(space, 0, h / 2 - h * mylerp / 2, w, h * mylerp, colors.circle_button)
                end
            end
            btn.DoClick = function()
                if chosenoffset == i then return end

                chosenoffset = i

                mystart = CurTime()
                mylerp = 0

                CreateOffset()
            end
        end

        local offsetbg = CreateDPanel(offsetbottom, 0, height + space, namw, offsetbottom:GetTall() - height - space)
        offsetbg.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end
    
        data.offsetV = data.offsetV or Vector()
        data.offsetA = data.offsetA or Angle()
        data.scale = data.scale or Vector(1,1,1)
        
        local transw, transh = offsetbg:GetSize()
        local chosen_letters = {{"X","Y","Z"}, {"P","Y","R"}, {"X","Y","Z"}}

        local name
        local t
        local min
        local max
        if chosenoffset == 1 then
            name = bh_language.Position
            t = data.offsetV
            min = -self.EditorPos
            max = self.EditorPos
        elseif chosenoffset == 2 then
            name = bh_language.Angle
            t = data.offsetA
            min = -self.EditorAng
            max = self.EditorAng
        else
            name = bh_language.Scale
            t = data.scale
            min = -self.EditorScale
            max = self.EditorScale
        end

        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local transtext = CreateDPanel(offsetbg, space, posy - (ScaleY(30)) / 2 - ScaleY(10), transw - space * 2, ScaleY(30))
            transtext.Paint = function(me,w,h)
                DrawText(name .. " " .. chosen_letters[chosenoffset][i], "BHACC_PositionPRS", 0, space, color_white)
            end

            local transopt = Create_DNumSlider(offsetbg, space, posy, transw - space * 2, ScaleY(20))
            transopt:SetMin(min)
            transopt:SetMax(max)
            if t then
                transopt:SetValue(t[i])
            end
            transopt.OnValueChanged = function(me)             
                local val = math.Round(me:GetValue(), 2)
                if chosenoffset == 1 then
                    if i == 1 then
                        t = Vector(val, t.y, t.z)
                    elseif i == 2 then
                        t = Vector(t.x, val, t.z)
                    elseif i == 3 then
                        t = Vector(t.x, t.y, val)
                    end
                    data.offsetV = t
                elseif chosenoffset == 2 then
                    if i == 1 then
                        t = Angle(val, t.y, t.z)
                    elseif i == 2 then
                        t = Angle(t.x, val, t.z)
                    elseif i == 3 then
                        t = Angle(t.x, t.y, val)
                    end
                    data.offsetA = t
                else
                    if i == 1 then
                        t = Vector(val, t.y, t.z)
                    elseif i == 2 then
                        t = Vector(t.x, val, t.z)
                    elseif i == 3 then
                        t = Vector(t.x, t.y, val)
                    end
                    data.scale = t
                end
                
                self:HoverOnItem(data)
            end
        end
    end
    if not data.IsPlayerModel then
        CreateOffset()
    end
end