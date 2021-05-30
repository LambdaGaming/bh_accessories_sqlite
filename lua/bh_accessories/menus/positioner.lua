local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local color_white = color_white

local RoundedBox = draw.RoundedBox
local RoundedBoxEx = draw.RoundedBoxEx
local SimpleText = draw.SimpleText
local DrawText = draw.DrawText
local GetTextSize = surface.GetTextSize
local SetFont = surface.SetFont

local function EmptyFunc() end

local string_sub = string.sub
local string_find = string.find

local GetItemData = BH_ACC.GetItemData
local TextWrap = BH_ACC.TextWrap
local Create_DNumSlider = BH_ACC.Create_DNumSlider
local CreateDPanel = BH_ACC.CreateDPanel
local CreateDButton = BH_ACC.CreateDButton
local CreateDModelPanel = BH_ACC.CreateDModelPanel
local CreateTextEntry = BH_ACC.CreateTextEntry
local CreateDScrollPanel = BH_ACC.CreateDScrollPanel
local RemovePanel = BH_ACC.RemovePanel
local ClearPanel = BH_ACC.ClearPanel

local bh_language = BH_ACC.Language
local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

local Position_Options = {
    {name = bh_language["Accessory"], doclick = function(p, data)
        BH_ACC:PositionerCreateAccessoryTab(p, data)
    end, check = function(ply)
        return BH_ACC.CanAccessPositioner(ply)
    end},
    {name = bh_language["Playermodel"], doclick = function(p)
        BH_ACC:PositionerCreatePlayerModelTab(p)
    end, check = function(ply)
        return BH_ACC.CanAccessPMDLPositioner(ply)
    end}
}

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/positioner", function(filename)
    if filename == "bh_acc_config" then
        bh_language = BH_ACC.Language
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors

        Position_Options = {
            {name = bh_language["Accessory"], doclick = function(p, data)
                BH_ACC:PositionerCreateAccessoryTab(p, data)
            end, check = function(ply)
                return BH_ACC.CanAccessPositioner(ply)
            end},
            {name = bh_language["Playermodel"], doclick = function(p)
                BH_ACC:PositionerCreatePlayerModelTab(p)
            end, check = function(ply)
                return BH_ACC.CanAccessPMDLPositioner(ply)
            end}
        }
    elseif filename == "cl_bh_acc_ui" then
        Create_DNumSlider = BH_ACC.Create_DNumSlider
        CreateDPanel = BH_ACC.CreateDPanel
        CreateDButton = BH_ACC.CreateDButton
        CreateDModelPanel = BH_ACC.CreateDModelPanel
        CreateTextEntry = BH_ACC.CreateTextEntry
        CreateDScrollPanel = BH_ACC.CreateDScrollPanel
        RemovePanel = BH_ACC.RemovePanel
        ClearPanel = BH_ACC.ClearPanel
    elseif filename == "cl_bh_acc_fonts" then
        TextWrap = BH_ACC.TextWrap
    elseif filename == "sh_bh_acc" then
        GetItemData = BH_ACC.GetItemData
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/positioner", function()
    ScaleY = BH_ACC.ScaleY
end)

function BH_ACC:PositionerCreateAccessoryTab(p, data)
    p:Clear()

    local ply = LocalPlayer()
    local adjustments = ply.bh_acc_adjustments

    local x, y = p:GetSize()
    
    local CreateBelow

    local text2font = "BHACC_PositionDesc"

    local text2 = TextWrap(bh_language.Adjusting_Note, text2font, x - ScaleY(15))
    
    SetFont("BHACC_PositionTitle")
    local _, th1 = GetTextSize(bh_language.ClickToPick)
    SetFont(text2font)
    local tw2, th2 = GetTextSize(text2)

    local space = ScaleY(5)

    local text = CreateDPanel(p, space, space, x - space * 2, th1 + th2 + space * 2)
    text.Paint = function(me,w,h)
        RoundedBox(space, 0, 0, w, h, colors.body)

        DrawText(text2, text2font, space, space + th1, color_white)
    end

    local text1comboopen = CreateDButton(text, space, space / 2, x, th1)
    text1comboopen.Paint = function(me,w,h)
        if not data then
            SetFont("BHACC_PositionTitle")
            local clickw, clickh = GetTextSize(bh_language.ClickToPick)
            if me:GetWide() ~= clickw then
                text1comboopen:SetWide(clickw)
            end

            DrawText(bh_language.ClickToPick, "BHACC_PositionTitle", 0, space / 2, colors.gray_text)
        else
            SetFont("BHACC_PositionTitle")
            local clickw, clickh = GetTextSize(data.name)
            if me:GetWide() ~= clickw then
                text1comboopen:SetWide(clickw)
            end

            DrawText(data.name, "BHACC_PositionTitle", 0, space / 2, color_white)
        end
    end
    text1comboopen.OnRemove = function()
        self:ExitHoverOnItem()
    end
    text1comboopen.DoClick = function()
        local ply = LocalPlayer()

        local x, y = ScaleY(300), ScaleY(425)
        local dmenu = self:CreateDermaMenu(x, y)

        local function CreateBottom(text)
            ClearPanel(dmenu.bottom)
            
            dmenu.bottom = CreateDPanel(dmenu, space, ScaleY(48) + space, x - space * 2, y - ScaleY(48) - space * 2)
            local bottom = dmenu.bottom
            local bg = bottom:GetParent()

            local x, y = bottom:GetSize()
            if text then
                text = text:lower():Trim()
            end
            if text == "" then
                text = nil
            end

            local eq = CreateDPanel(bottom, 0, 0, x, ScaleY(35) - space * 2)
            eq.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w , h, colors.hover_light )

                SimpleText(bh_language.Equipped, "BHACC_FSmallMed", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local cop_equipped = {}
            local count = 0
            local equipped = ply.bh_acc_equipped
            for k = 1, #equipped do
                local v = equipped[k]

                local data = GetItemData(v)

                if data and not data.IsPlayerModel and ( ( text and string_find(data.name:lower():Trim(), text, 1, true) ) or not text ) then
                    count = count + 1
                    cop_equipped[count] = data
                end
            end

            local should = #cop_equipped > 4
            local minus = 0
            if should then
                minus = - 15 - space
            end

            local scrollbg = CreateDPanel(bottom, 0, eq:GetTall() + space, x, ScaleY(150))
            scrollbg.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w + minus, h, colors.hover_light )
            end

            local scroll = CreateDScrollPanel(scrollbg, 0, 0, scrollbg:GetWide(), scrollbg:GetTall())
            local function SbarPaint(me,w,h)
                RoundedBox( space, 0, 0, w, h, colors.hover_light )
            end
            local sbar = scroll:GetVBar()
            sbar.Paint = EmptyFunc
            sbar.btnUp.Paint = SbarPaint
            sbar.btnDown.Paint = SbarPaint
            sbar.btnGrip.Paint = SbarPaint

            local accw, acch = scrollbg:GetWide() + minus, scrollbg:GetTall() / 5

            for k = 1, count do
                local v = cop_equipped[k]
                local name = v.name

                local acc = CreateDButton(scrollbg, 0, acch * k - acch, accw, acch)
                local function accPaint(me,w,h)
                    if me.Hovered then
                        RoundedBox( space, 0, 0, w, h, colors.hover )
                    end

                    SimpleText(name, "BHACC_ItemFont", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                acc.Paint = accPaint
                
                local function DoClick(me)
                    data = v
                    CreateBelow()

                    self:HoverOnItem(data)

                    bg:Remove()
                end
                acc.DoClick = DoClick
            end

            local _, sc1y = scrollbg:GetPos()
            sc1y = sc1y + scrollbg:GetTall()
            
            local noneq = CreateDPanel(bottom, 0, sc1y + space, x, ScaleY(35) - space * 2)
            noneq.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w , h, colors.hover_light )

                SimpleText(bh_language.Accessories, "BHACC_FSmallMed", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local cop_items = {}
            local count = 0
            local items = self.Items
            for k = 1, self.GetItemCount() do
                local data = items[k]
                if not data.IsPlayerModel and ( (text and string_find(data.name:lower():Trim(), text, 1, true) ) or not text ) then
                    count = count + 1
                    cop_items[count] = data
                end
            end

            local should = #cop_items > 4
            local minus = 0
            if should then
                minus = - 15 - space
            end

            local scroll2bg = CreateDPanel(bottom, 0, sc1y + space + noneq:GetTall() + space, eq:GetWide(), ScaleY(150))
            scroll2bg.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w + minus, h, colors.hover_light )
            end

            local scroll2 = CreateDScrollPanel(scroll2bg, 0, 0, scroll2bg:GetWide(), scroll2bg:GetTall())
            local function SbarPaint(me,w,h)
                RoundedBox( space, 0, 0, w, h, colors.hover_light )
            end
            local sbar = scroll2:GetVBar()
            sbar.Paint = EmptyFunc
            sbar.btnUp.Paint = SbarPaint
            sbar.btnDown.Paint = SbarPaint
            sbar.btnGrip.Paint = SbarPaint

            local accw, acch = scroll2bg:GetWide() + minus, scroll2bg:GetTall() / 5
            for k = 1, #cop_items do
                local v = cop_items[k]
                local name = v.name

                local acc = CreateDButton(scroll2, 0, acch * k - acch, accw, acch)
                local function accPaint(me,w,h)
                    if me.Hovered then
                        RoundedBox( space, 0, 0, w, h, colors.hover )
                    end

                    SimpleText(name, "BHACC_ItemFont", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                acc.Paint = accPaint
                local function DoClick(me)
                    data = v
                    CreateBelow()

                    self:HoverOnItem(data)

                    bg:Remove()
                end
                acc.DoClick = DoClick
            end
        end

        local searchacc = CreateTextEntry(dmenu, 0, 0, x, ScaleY(48))
        searchacc.Paint = function(me,w,h)
            RoundedBox( ScaleY(5), 0, 0, w , h, colors.hover_light )
    
            me:DrawTextEntryText(color_white, color_white, color_white)
    
            if #me:GetText() == 0 then
                SimpleText(bh_language["Enter name"] .. "...", "BHACC_FMedium", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        searchacc.OnTextChanged = function(me)
            CreateBottom(me:GetText())
        end

        CreateBottom()
    end

    CreateBelow = function()
        RemovePanel(text1comboopen.insbg)
        
        local x, y = p:GetSize()

        local model = data and data.model
        if model and not adjustments[model] then
            adjustments[model] = {
                pos = Vector(),
                ang = Angle(),
                scale = Vector()
            }
        end
        
        text1comboopen.insbg = CreateDPanel(p, space, space + text:GetTall() + space, x - space * 2, y - text:GetTall() - space * 3)
        local insbg = text1comboopen.insbg

        x, y = insbg:GetSize()

        local save = CreateDButton(insbg, 0, y - ScaleY(35), x, ScaleY(35))
        save.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)

            SimpleText(bh_language.Save, "BHACC_PositionPRS", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        save.DoClick = function()
            if not data then return end

            local thing = adjustments[model]

            self.AdjustAccessory(data.id, thing.pos, thing.ang, thing.scale)

            self.ClearPlayerAdjustments(ply)
        end

        local bgy = 0
        local bgh = (y - save:GetTall() - space * 3) / 3

        local translate = CreateDPanel(insbg, 0, 0, x, bgh)
        translate.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end

        local transw, transh = translate:GetSize()            
        local translate_letters = {"X","Y","Z"}
        local singleadjh = ScaleY(30)
        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local transtext = CreateDPanel(translate, space, posy - singleadjh / 2 - ScaleY(15), x, singleadjh)
            transtext.Paint = function(me,w,h)
                DrawText(bh_language.Position .. " " .. translate_letters[i], "BHACC_PositionPRS", 0, space, color_white)
            end
            
            local transopt = Create_DNumSlider(translate, space, posy, transw - space * 2, ScaleY(20))
            transopt:SetMin(-self.PositionerPos)
            transopt:SetMax(self.PositionerPos)
            if adjustments[model] then
                transopt:SetValue(adjustments[model].pos[i])
            end
            transopt.OnValueChanged = function(me)
                if not data then return end

                local val = math.Round(me:GetValue(), 2)

                local old = adjustments[model].pos
                if i == 1 then
                    adjustments[model].pos = Vector(val, old.y, old.z)
                elseif i == 2 then
                    adjustments[model].pos = Vector(old.x, val, old.z)
                elseif i == 3 then
                    adjustments[model].pos = Vector(old.x, old.y, val)
                end

                self.ClearAllPlayerAdjustments()
            end
        end

        bgy = bgy + bgh + space

        local rotate = CreateDPanel(insbg, 0, bgy, x, bgh)
        rotate.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end

        local rotate_letters = {"P","Y","R"}
        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local rotatetext = CreateDPanel(rotate, space, posy - singleadjh / 2 - ScaleY(15), x, singleadjh)
            rotatetext.Paint = function(me,w,h)
                DrawText(bh_language.Angle .. " " .. rotate_letters[i], "BHACC_PositionPRS", 0, space, color_white)
            end
            
            local rotateopt = Create_DNumSlider(rotate, space, posy, transw - space * 2, ScaleY(20))
            rotateopt:SetMin(-self.PositionerAng)
            rotateopt:SetMax(self.PositionerAng)
            if adjustments[model] then
                rotateopt:SetValue(adjustments[model].ang[i])
            end
            rotateopt.OnValueChanged = function(me)
                if not data then return end

                local val = math.Round(me:GetValue(), 2)

                local old = adjustments[model].ang
                if i == 1 then
                    adjustments[model].ang = Angle(val, old.y, old.r)
                elseif i == 2 then
                    adjustments[model].ang = Angle(old.p, val, old.r)
                elseif i == 3 then
                    adjustments[model].ang = Angle(old.p, old.y, val)
                end

                self.ClearAllPlayerAdjustments()
            end
        end

        bgy = bgy + bgh + space

        local pscale = CreateDPanel(insbg, 0, bgy, x, bgh)
        pscale.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end

        local scale_letters = {"X","Y","Z"}
        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local scaletext = CreateDPanel(pscale, space, posy - singleadjh / 2 - ScaleY(15), x, singleadjh)
            scaletext.Paint = function(me,w,h)
                DrawText(bh_language.Scale .. " " .. scale_letters[i], "BHACC_PositionPRS", 0, space, color_white)
            end
            
            local scaleopt = Create_DNumSlider(pscale, space, posy, transw - space * 2, ScaleY(20))
            scaleopt:SetMin(-self.PositionerScale)
            scaleopt:SetMax(self.PositionerScale)
            if adjustments[model] then
                scaleopt:SetValue(adjustments[model].scale[i])
            end
            scaleopt.OnValueChanged = function(me)
                if not data then return end

                local val = math.Round(me:GetValue(), 2)

                local old = adjustments[model].scale
                if i == 1 then
                    adjustments[model].scale = Vector(val, old.y, old.z)
                elseif i == 2 then
                    adjustments[model].scale = Vector(old.x, val, old.z)
                elseif i == 3 then
                    adjustments[model].scale = Vector(old.x, old.y, val)
                end

                self.ClearAllPlayerAdjustments()
            end
        end
    end

    CreateBelow()
end

function BH_ACC:PositionerCreatePlayerModelTab(p)
    p:Clear()

    local x, y = p:GetSize()
    local space = ScaleY(5)
    local ply = LocalPlayer()

    local text = bh_language["PModel_PositionerText"]
    text = TextWrap(text, "BHACC_PositionDesc", x - ScaleY(20))
    SetFont("BHACC_PositionDesc")
    local textw, texth = GetTextSize(text)

    local textp = CreateDPanel(p, space, space, x - space * 2, texth + space * 2)
    textp.Paint = function(me, w, h)
        RoundedBox(space, 0, 0, w, h, colors.body)

        DrawText(text, "BHACC_PositionDesc", space, space, color_white)
    end
    textp.OnRemove = function()
        self:ExitHoverOnItem()
    end

    local allfoundbones = {}
    local foundbones = {}
    local reali = 0
    local items = self.Items
    for k = 1, self.GetItemCount() do
        local v = items[k]
        if not v.bone or foundbones[v.bone] then continue end

        reali = reali + 1

        foundbones[v.bone] = true
        allfoundbones[reali] = v.bone
    end

    local data = {
        model = ply:GetModel(),
        bone = allfoundbones[1],
        IsPlayerModel = true
    }

    local itemsize = ScaleY(128)
    local ix, iy = space, textp:GetTall() + space * 2

    local insbg
    local CreateBottom

    local rightofitem = CreateDPanel(p, ix + space + itemsize, iy, x - itemsize - space * 3, itemsize)

    local mdlp = CreateDButton(rightofitem, 0, 0, rightofitem:GetWide(), rightofitem:GetTall() / 2 - 1)
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize(bh_language["Model:"])
    mdlp.Paint = function(me,w,h)
        RoundedBox(space, 0, 0, w, h, colors.body)

        SimpleText(bh_language["Model:"], "BHACC_PositionBoneModel", space * 2, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        local model = data.model
        if model then
            if #model > 27 then
                model = string_sub(model, 0, 24) .. "..."
            end
            
            if me.Hovered then
                SimpleText(model, "BHACC_PositionPRS", tw + space * 2 + ( w - tw - space * 3) / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                SimpleText(" " .. model, "BHACC_PositionPRS", tw + space * 2 + ( w - tw - space * 3) / 2, h / 2, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        else
            if me.Hovered then
                SimpleText(" " .. bh_language["ClickToPickModel"], "BHACC_PositionPRS", tw + space * 2  + ( w - tw - space * 3) / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                SimpleText(" " .. bh_language["ClickToPickModel"], "BHACC_PositionPRS", tw + space * 2  + ( w - tw - space * 3) / 2, h / 2, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    mdlp.DoClick = function()
        local ply = LocalPlayer()

        local x, y = ScaleY(300), ScaleY(425) - space + ScaleY((50 + 35 - space * 3)) + space * 2
        local dmenu = self:CreateDermaMenu(x, y)

        local function CreateDMenuBottom(text)
            ClearPanel(dmenu.bottom)
            
            dmenu.bottom = CreateDPanel(dmenu, space, ScaleY(48) + space, x - space * 2 + 1, y - ScaleY(48) - space * 2)
            local bottom = dmenu.bottom
            local bg = bottom:GetParent()

            local x, y = bottom:GetSize()

            if text then
                text = text:lower():Trim()
            end
            
            if text == "" then
                text = nil
            end

            local eq = CreateDPanel(bottom, 0, 0, x, ScaleY(35) - space * 2)
            eq.Paint = function(me,w,h)
                RoundedBox( ScaleY(5), 0, 0, w , h, colors.hover_light )

                SimpleText(bh_language.Equipped, "BHACC_FSmallMed", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local cop_equipped = {}
            local count = 0
            local equipped = ply.bh_acc_equipped
            for k = 1, #equipped do
                local v = equipped[k]
                local data = GetItemData(v)

                if data and data.IsPlayerModel and ( ( text and string_find(data.name:lower():Trim(), text, 1, true) ) or not text ) then
                    count = count + 1
                    cop_equipped[count] = data
                end
            end

            local should = #cop_equipped > 4
            local minus = 0
            if should then
                minus = - 15 - space
            end

            local scrollbg = CreateDPanel(bottom, 0, eq:GetTall() + space, x, ScaleY(150))
            scrollbg.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w + minus, h, colors.hover_light )
            end

            local scroll = CreateDScrollPanel(scrollbg, 0, 0, scrollbg:GetWide(), scrollbg:GetTall())
            local function SbarPaint(me,w,h)
                RoundedBox( space, 0, 0, w, h, colors.hover_light )
            end
            local sbar = scroll:GetVBar()
            sbar.Paint = EmptyFunc
            sbar.btnUp.Paint = SbarPaint
            sbar.btnDown.Paint = SbarPaint
            sbar.btnGrip.Paint = SbarPaint
            
            local accw, acch = scrollbg:GetWide() + minus, scrollbg:GetTall() / 5

            for k = 1, count do
                local v = cop_equipped[k]
                local name = v.name

                local acc = CreateDButton(scrollbg, 0, acch * k - acch, accw, acch)
                local function accPaint(me,w,h)
                    if me.Hovered then
                        RoundedBox( space, 0, 0, w, h, colors.hover )
                    end

                    SimpleText(name, "BHACC_ItemFont", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                acc.Paint = accPaint
                
                local function DoClick(me)
                    data.model = v.model

                    CreateBottom()

                    self:HoverOnItem(data)

                    bg:Remove()
                end
                acc.DoClick = DoClick
            end

            local _, sc1y = scrollbg:GetPos()
            sc1y = sc1y + scrollbg:GetTall()
            
            local noneq = CreateDPanel(bottom, 0, sc1y + space, x, ScaleY(35) - space * 2)
            noneq.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w , h, colors.hover_light )

                SimpleText(bh_language.Playermodels, "BHACC_FSmallMed", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local cop_items = {}
            local count = 0
            local items = self.Items
            for k = 1, self.GetItemCount() do
                local data = items[k]
                if data.IsPlayerModel and ( (text and string_find(data.name:lower():Trim(), text, 1, true) ) or not text ) then
                    count = count + 1
                    cop_items[count] = data
                end
            end

            local should = #cop_items > 4
            local minus = 0
            if should then
                minus = - 15 - space
            end

            local scroll2bg = CreateDPanel(bottom, 0, sc1y + space + noneq:GetTall() + space, eq:GetWide(), ScaleY(150))
            scroll2bg.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w + minus, h, colors.hover_light )
            end

            local scroll2 = CreateDScrollPanel(scroll2bg, 0, 0, scroll2bg:GetWide(), scroll2bg:GetTall())
            local function SbarPaint(me,w,h)
                RoundedBox( space, 0, 0, w, h, colors.hover_light )
            end
            local sbar = scroll2:GetVBar()
            sbar.Paint = EmptyFunc
            sbar.btnUp.Paint = SbarPaint
            sbar.btnDown.Paint = SbarPaint
            sbar.btnGrip.Paint = SbarPaint

            local accw, acch = scroll2bg:GetWide() + minus, scroll2bg:GetTall() / 5
            for k = 1, #cop_items do
                local v = cop_items[k]
                local name = v.name

                local acc = CreateDButton(scroll2, 0, acch * k - acch, accw, acch)
                local function accPaint(me,w,h)
                    if me.Hovered then
                        RoundedBox( space, 0, 0, w, h, colors.hover )
                    end

                    SimpleText(name, "BHACC_ItemFont", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                acc.Paint = accPaint
                local function DoClick(me)
                    data.model = v.model
                    
                    CreateBottom()

                    self:HoverOnItem(data)

                    bg:Remove()
                end
                acc.DoClick = DoClick
            end

            local s2x, s2y = scroll2bg:GetPos()
            local OR = CreateDPanel(bottom, s2x, s2y + scroll2bg:GetTall() + space, x, ScaleY(35) - space * 2)
            OR.Paint = function(me,w,h)
                RoundedBox( space,0,0,w,h, colors.hover_light )
                
                SimpleText(bh_language["OR"], "BHACC_FSmallMed", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local enterown = CreateTextEntry(bottom, 0, s2y + scroll2bg:GetTall() + space + OR:GetTall() + space, x, ScaleY(50))
            enterown.Paint = function(me,w,h)
                RoundedBox( ScaleY(5), 0, 0, w , h, colors.hover_light )
        
                me:DrawTextEntryText(color_white, color_white, color_white)
        
                if #me:GetText() == 0 then
                    SimpleText(bh_language["EnterModel"] .. "...", "BHACC_ItemFont", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end
            enterown.OnEnter = function()
                data.model = enterown:GetText()

                CreateBottom()

                self:HoverOnItem({
                    IsPlayerModel = true,
                    model = data.model,
                })

                bg:Remove()
            end
        end

        local searchacc = CreateTextEntry(dmenu, 0, 0, x, ScaleY(48))
        searchacc.Paint = function(me,w,h)
            RoundedBox( ScaleY(5), 0, 0, w , h, colors.hover_light )
    
            me:DrawTextEntryText(color_white, color_white, color_white)
    
            if #me:GetText() == 0 then
                SimpleText(bh_language["Enter name"] .. "...", "BHACC_FMedium", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        searchacc.OnTextChanged = function(me)
            CreateDMenuBottom(me:GetText())
        end

        CreateDMenuBottom()
    end

    local bonep = CreateDButton(rightofitem, 0, rightofitem:GetTall() / 2 + 2, rightofitem:GetWide(), rightofitem:GetTall() / 2 - 1)
    SetFont("BHACC_PositionBoneModel")
    local tw, th = GetTextSize("Bone:")
    bonep.Paint = function(me,w,h)
        RoundedBox(space, 0, 0, w, h, colors.body)

        SimpleText(bh_language["Bone:"], "BHACC_PositionBoneModel", space * 2, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        local bone = data.bone or ""
        if bone and bone ~= "" then
            if #bone > 27 then
                bone = string_sub(bone, 0, 24) .. "..."
            end
            
            if me.Hovered then
                SimpleText(bone, "BHACC_PositionPRS", tw + space * 2 + ( w - tw - space * 3) / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                SimpleText(" " .. bone, "BHACC_PositionPRS", tw + space * 2 + ( w - tw - space * 3) / 2, h / 2, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        else
            if me.Hovered then
                SimpleText(" " .. bh_language["ClickToPickBone"], "BHACC_PositionPRS", tw + space * 2  + ( w - tw - space * 3) / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                SimpleText(" " .. bh_language["ClickToPickBone"], "BHACC_PositionPRS", tw + space * 2  + ( w - tw - space * 3) / 2, h / 2, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    bonep.DoClick = function()
        local ply = LocalPlayer()

        local x, y = ScaleY(300), ScaleY(425) - space + ScaleY(50 + 35 - space * 3) + space * 2
        local dmenu = self:CreateDermaMenu(x, y)

        local function CreateDMenuBottom()
            ClearPanel(dmenu.bottom)
            
            dmenu.bottom = CreateDPanel(dmenu, space, space, x - space * 2 + 1, y - ScaleY(48) - space * 2)
            local bottom = dmenu.bottom
            local bg = bottom:GetParent()
            
            local x, y = bottom:GetSize()

            local eq = CreateDPanel(bottom, 0, 0, x, ScaleY(35) - space * 2)
            eq.Paint = function(me,w,h)
                RoundedBox( ScaleY(5), 0, 0, w , h, colors.hover_light )

                SimpleText(bh_language["Bones"], "BHACC_FSmallMed", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local should = #allfoundbones > 4
            local minus = 0
            if should then
                minus = - 15 - space
            end

            local scrollbg = CreateDPanel(bottom, 0, eq:GetTall() + space, x, ScaleY(150))
            scrollbg.Paint = function(me,w,h)
                RoundedBox( space, 0, 0, w + minus, h, colors.hover_light )
            end

            local scroll = CreateDScrollPanel(scrollbg, 0, 0, scrollbg:GetWide(), scrollbg:GetTall())
            local function SbarPaint(me,w,h)
                RoundedBox( space, 0, 0, w, h, colors.hover_light )
            end
            local sbar = scroll:GetVBar()
            sbar.Paint = EmptyFunc
            sbar.btnUp.Paint = SbarPaint
            sbar.btnDown.Paint = SbarPaint
            sbar.btnGrip.Paint = SbarPaint

            local accw, acch = scrollbg:GetWide() + minus, scrollbg:GetTall() / 5

            for k = 1, #allfoundbones do
                local v = allfoundbones[k]

                local acc = CreateDButton(scrollbg, 0, acch * k - acch, accw, acch)
                local function accPaint(me,w,h)
                    if me.Hovered then
                        RoundedBox( space, 0, 0, w, h, colors.hover )
                    end

                    SimpleText(v, "BHACC_ItemFont", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                acc.Paint = accPaint
                
                local function DoClick(me)
                    data.bone = v

                    CreateBottom()

                    bg:Remove()
                end
                acc.DoClick = DoClick
            end

            dmenu:SetSize(dmenu:GetWide(), eq:GetTall() + scrollbg:GetTall() + space * 4)
        end

        CreateDMenuBottom()
    end

    local item

    CreateBottom = function()
        ClearPanel(insbg)
        RemovePanel(item)
        
        local model = data.model
        local bone = data.bone

        if model and bone then
            self.ModelOffsets[model] = self.ModelOffsets[model] or {}
            self.ModelOffsets[model][bone] = self.ModelOffsets[model][bone] or {}
        end

        local x, y = p:GetSize()

        item = CreateDButton(p, ix, iy, itemsize, itemsize)
        local trim = ScaleY(28)

        local mdl = CreateDModelPanel(item, 0, 0, itemsize, itemsize)
        mdl:SetModel(model)
        mdl.LayoutEntity = EmptyFunc
        mdl.vCamPos = Vector(59.69, 20.9, 61.2)
        mdl.fFOV = 17
        mdl.aLookAngle = Angle(-1.7, -160.1, 0)
        mdl.PostDrawModel = function(me, w, h)
            self:DrawEquipped(me.Entity, ply.bh_acc_equipped_csms)
        end
        
        item.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
            
            if me.Hovered then
                RoundedBoxEx(ScaleY(8),0,0,w,h,colors.hovercatoritem, true, true, false, false)
            end
        end

        insbg = CreateDPanel(p, space, iy + item:GetTall() + space, x - space * 2, y - textp:GetTall() - space * 3 - item:GetTall() - space)
        x, y = insbg:GetSize()

        local saveh = ScaleY(35)
        local save = CreateDButton(insbg, 0, y - saveh, x, saveh)
        save.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)

            SimpleText(bh_language.Save, "BHACC_PositionPRS", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        save.DoClick = function()
            if not model or not bone then return end

            local thing = self.ModelOffsets[model][bone]
            thing.pos = thing.pos or Vector()
            thing.ang = thing.ang or Angle()
            thing.scale = thing.scale or Vector()

            self.AdjustPModel(model, bone, thing.pos, thing.ang, thing.scale)
        end

        local bgy = 0
        local bgh = (y - saveh - space * 3) / 3

        local translate = CreateDPanel(insbg, 0, 0, x, bgh)
        translate.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end

        local transw, transh = translate:GetSize()

        local newdata = self.ModelOffsets[model] and self.ModelOffsets[model][bone]

        local translate_letters = {"X","Y","Z"}
        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local transtext = CreateDPanel(translate, space, posy - (ScaleY(30)) / 2 - ScaleY(15), x, ScaleY(30))
            transtext.Paint = function(me,w,h)
                DrawText(bh_language.Position .. " " .. translate_letters[i], "BHACC_PositionPRS", 0, space, color_white)
            end
            
            local transopt = Create_DNumSlider(translate, space, posy, transw - space * 2, ScaleY(20))
            transopt:SetMin(-self.PositionerPMDLPos)
            transopt:SetMax(self.PositionerPMDLPos)
            if newdata and newdata.pos then
                transopt:SetValue(newdata.pos[i])
            end
            transopt.OnValueChanged = function(me)
                if not model or not bone then return end
                
                local val = math.Round(me:GetValue(), 2)

                local old = self.ModelOffsets[model][bone].pos
                if not old then
                    self.ModelOffsets[model][bone].pos = Vector()
                    old = self.ModelOffsets[model][bone].pos
                end

                if i == 1 then
                    self.ModelOffsets[model][bone].pos = Vector(val, old.y, old.z)
                elseif i == 2 then
                    self.ModelOffsets[model][bone].pos = Vector(old.x, val, old.z)
                elseif i == 3 then
                    self.ModelOffsets[model][bone].pos = Vector(old.x, old.y, val)
                end
            end
        end

        bgy = bgy + bgh + space

        local rotate = CreateDPanel(insbg, 0, bgy, x, bgh)
        rotate.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end

        local rotate_letters = {"P","Y","R"}
        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local rotatetext = CreateDPanel(rotate, space, posy - (ScaleY(30)) / 2 - ScaleY(15), x, ScaleY(30))
            rotatetext.Paint = function(me,w,h)
                DrawText(bh_language.Angle .. " " .. rotate_letters[i], "BHACC_PositionPRS", 0, space, color_white)
            end
            
            local rotateopt = Create_DNumSlider(rotate, space, posy, transw - space * 2, ScaleY(20))
            rotateopt:SetMin(-self.PositionerPMDLAng)
            rotateopt:SetMax(self.PositionerPMDLAng)
            if newdata and newdata.ang then
                rotateopt:SetValue(newdata.ang[i])
            end
            rotateopt.OnValueChanged = function(me)
                if not model or not bone then return end

                local val = math.Round(me:GetValue(), 2)

                local old = self.ModelOffsets[model][bone].ang
                if not old then
                    self.ModelOffsets[model][bone].ang = Angle()
                    old = self.ModelOffsets[model][bone].ang
                end

                if i == 1 then
                    self.ModelOffsets[model][bone].ang = Angle(val, old.y, old.r)
                elseif i == 2 then
                    self.ModelOffsets[model][bone].ang = Angle(old.p, val, old.r)
                elseif i == 3 then
                    self.ModelOffsets[model][bone].ang = Angle(old.p, old.y, val)
                end
            end
        end

        bgy = bgy + bgh + space

        local pscale = CreateDPanel(insbg, 0, bgy, x, bgh)
        pscale.Paint = function(me,w,h)
            RoundedBox(space, 0, 0, w, h, colors.body)
        end

        local scale_letters = {"X","Y","Z"}
        for i = 1, 3 do
            local posy = transh / 3 * i - transh / 3 + transh / 6

            local scaletext = CreateDPanel(pscale, space, posy - (ScaleY(30)) / 2 - ScaleY(15), x, ScaleY(30))
            scaletext.Paint = function(me,w,h)
                DrawText(bh_language.Scale .. " " .. scale_letters[i], "BHACC_PositionPRS", 0, space, color_white)
            end

            local scaleopt = Create_DNumSlider(pscale, space, posy, transw - space * 2, ScaleY(20))
            scaleopt:SetMin(-self.PositionerPMDLScale)
            scaleopt:SetMax(self.PositionerPMDLScale)
            if newdata and newdata.scale then
                scaleopt:SetValue(newdata.scale[i])
            end
            scaleopt.OnValueChanged = function(me)
                if not model or not bone then return end

                local val = math.Round(me:GetValue(), 2)

                local old = self.ModelOffsets[model][bone].scale
                if not old then
                    self.ModelOffsets[model][bone].scale = Vector()
                    old = self.ModelOffsets[model][bone].scale
                end

                if i == 1 then
                    self.ModelOffsets[model][bone].scale = Angle(val, old.y, old.r)
                elseif i == 2 then
                    self.ModelOffsets[model][bone].scale = Angle(old.p, val, old.r)
                elseif i == 3 then
                    self.ModelOffsets[model][bone].scale = Angle(old.p, old.y, val)
                end

                self.ClearAllPlayerAdjustments()
            end
        end
    end
    CreateBottom()
end

function BH_ACC:OpenPositionMenu()
    RemovePanel(self.bh_acc_positionmenu)

    local ply = LocalPlayer()
    local scrh = ScrH()
    local picked = -1

    local x, y = ScaleY(500), scrh * 0.75
    self.bh_acc_positionmenu = CreateDPanel(self.bh_acc_menu, ScaleY(275) + ScaleY(5), scrh / 2 - (scrh * 0.75) / 2, x, y)
    local p = self.bh_acc_positionmenu
    local trim = ScaleY(50)

    local ptrim = CreateDPanel(p, 0, 0, x, trim)

    local pbody = CreateDPanel(p, 0, trim, x, y - trim)
    pbody.Paint = function(me,w,h)
        RoundedBoxEx(ScaleY(5), 0, 0, w, h, colors.body_transparent, false, true, true, true)
    end

    local optw, opth = ScaleY(162), trim

    local called = false

    local reali = 0
    for k = 1, #Position_Options do
        reali = reali + 1

        local v = Position_Options[k]

        if not v.check(ply) then
            reali = reali - 1
            continue
        end

        local name = v.name

        local opt = CreateDButton(ptrim, optw * reali - optw + 1 * reali - 1, 0, optw, opth)
        opt.Paint = function(me,w,h)
            if picked == k then
                RoundedBoxEx(ScaleY(8),0,0,w,h,colors.body, true, true, false, false)
                SimpleText(name, "BHACC_PositionCategory", w * 0.5, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                RoundedBoxEx(ScaleY(8),0,h * 0.25,w,h * 0.75,colors.body, true, true, false, false)
                SimpleText(name, "BHACC_PositionCategory", w * 0.5, h * 0.75 - h * 0.25 /2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        local function OptDoClick()
            if picked == k then return end
            picked = k

            v.doclick(pbody)
        end
        opt.DoClick = OptDoClick

        if not called then
            called = true

            OptDoClick()
        end
    end
end