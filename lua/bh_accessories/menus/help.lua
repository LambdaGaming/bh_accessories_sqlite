local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local IsValid = IsValid
local Lerp = Lerp
local CurTime = CurTime
local color_white = color_white

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local RoundedBox = draw.RoundedBox
local RoundedBoxEx = draw.RoundedBoxEx
local SimpleText = draw.SimpleText
local GetTextSize = surface.GetTextSize
local SetFont = surface.SetFont
local DrawText = draw.DrawText

local bh_language = BH_ACC.Language
local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

local LerpColor = BH_ACC.LerpColor
local LerpText = BH_ACC.LerpText
local CreateDPanel = BH_ACC.CreateDPanel
local CreateDButton = BH_ACC.CreateDButton
local CreateDModelPanel = BH_ACC.CreateDModelPanel
local RemovePanel = BH_ACC.RemovePanel
local TextWrap = BH_ACC.TextWrap

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/help", function(filename)
    if filename == "bh_acc_config" then
        bh_language = BH_ACC.Language
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors
    elseif filename == "cl_bh_acc_ui" then
        LerpColor = BH_ACC.LerpColor
        CreateDPanel = BH_ACC.CreateDPanel
        CreateDButton = BH_ACC.CreateDButton
        CreateDModelPanel = BH_ACC.CreateDModelPanel
        RemovePanel = BH_ACC.RemovePanel
    elseif filename == "cl_bh_acc_fonts" then
        LerpText = BH_ACC.LerpText
        TextWrap = BH_ACC.TextWrap
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/help", function()
    ScaleY = BH_ACC.ScaleY
end)

function BH_ACC:OpenHelpMenu()
    RemovePanel(self.bh_acc_helpmenu)

    local scrh = ScrH()

    local x, y = ScaleY(500), scrh * 0.75
    self.bh_acc_helpmenu = CreateDPanel(self.bh_acc_menu, ScaleY(275) + ScaleY(5), scrh / 2 - (scrh * 0.75) / 2, x, y)
    local p = self.bh_acc_helpmenu

    local lerp = 0
    local lerpstart = CurTime()
    local dur = 0.75
    local start = CurTime()
    
    local trim = ScaleY(40)
    local title = CreateDPanel(p, 0, 0, x, trim)
    title.Paint = function(me,w,h)
        RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.body, true, true, false, false)

        SimpleText(LerpText((CurTime() - start) / 0.5, bh_language.StepOne), "BHACC_FMedium", ScaleY(10), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local title_text = TextWrap(bh_language.StepOneText, "BHACC_FSmallMed", x - ScaleY(10))

    SetFont("BHACC_FSmallMed")
    local tw, th = GetTextSize(title_text)
    
    local whentostart = 0.6
    local textstart = CurTime()
    local text_drawstart = CurTime() + 0.6

    local text = CreateDPanel(p, 0, trim, x, th + ScaleY(15))
    text.Paint = function(me,w,h)
        RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.help_body, false, false, true, true)

        if textstart + whentostart < CurTime() then
            DrawText(LerpText((CurTime() - text_drawstart) / 1.5, title_text), "BHACC_FSmallMed", ScaleY(5), ScaleY(5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    local tx, ty = p:GetPos()
    tx = tx + x
    ty = ty + th + trim

    local btnw, btnh = ScaleY(50), ScaleY(50)
    local button = CreateDButton(self.bh_acc_menu, tx - btnw / 2, ty - btnh / 2 + ScaleY(15), btnw, btnh)
    button.Paint = function(me,w,h)
        RoundedBox(h / 2, 0, 0, w, h, colors.circle_button)

        SimpleText(">", "BHACC_HelpArrowFont", w / 2, h / 2 - 2, colors.help_next, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local function Button2()
        title:Remove()
        text:Remove()
        button:Remove()

        local start = CurTime()
    
        local trim = ScaleY(40)
        local title = CreateDPanel(p, 0, 0, x, trim)
        title.Paint = function(me,w,h)
            RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.body, true, true, false, false)
    
            SimpleText(LerpText((CurTime() - start) / 0.5, bh_language.StepTwo), "BHACC_FMedium", ScaleY(10), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    
        local title_text = TextWrap(bh_language.StepTwoText, "BHACC_FSmallMed", x - ScaleY(10))
        
        SetFont("BHACC_FSmallMed")
        local tw, th = GetTextSize(title_text)
        
        local whentostart = 0.6
        local textstart = CurTime()
        local text_drawstart = CurTime() + 0.6
    
        local text = CreateDPanel(p, 0, trim, x, th + ScaleY(15))
        text.Paint = function(me,w,h)
            SetDrawColor(colors.help_body)
            DrawRect(0,0,w,h)
    
            if textstart + whentostart < CurTime() then
                DrawText(LerpText((CurTime() - text_drawstart) / 1.5, title_text), "BHACC_FSmallMed", ScaleY(5), ScaleY(5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end
        
        local tx, ty = p:GetPos()
        tx = tx + x
        ty = ty + th + trim

        local data = {
            name = "Hat",
            model = "models/food/hotdog.mdl",
            price = 100,
            ui_CamPos = Vector(-60.3, -45.25, 38.16),
            ui_FOV = 7.51,
            ui_LookAng = Angle(17.73, 37.04, 0),      
            id = -1
        }

        local item = CreateDButton(p, 0, trim + th + ScaleY(15) + 2, ScaleY(128), ScaleY(128))
        item.bh_acc_itemid = data.id

        local item_trim = ScaleY(28)

        CreateDModelPanel(item, 0, 0, item:GetWide(), item:GetTall() - item_trim, data)

        item.DoClick = function()
            local drop = self:MakeDropBoxForItem(data)
            if not IsValid(drop) then return end
            local kids = drop:GetChildren()
            for k = 1, #kids do
                kids[k].DoClick = function()
                    drop:Remove()
                end
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
    
            RoundedBoxEx(ScaleY(8),0,0,w,h - item_trim,hoverlerp, true, true, false, false)

            if me.Hovered then
                self:MakeToolTipForItem(data)
            end

            RoundedBoxEx(ScaleY(8), 0, 0, w, h - item_trim, colors.itembg, true, true, false, false)

            SetDrawColor(colors.body_transparent)
            DrawRect(0,h - item_trim,w,item_trim)

            SimpleText(data.name, "BHACC_ItemFont", w * 0.5, h - item_trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        local function ChangeHoverLerp()
            starthoverlerp = CurTime()
        end
        item.OnCursorEntered = ChangeHoverLerp
        item.OnCursorExited = ChangeHoverLerp

        local btnw, btnh = ScaleY(50), ScaleY(50)
        local button = CreateDButton(self.bh_acc_menu, tx - btnw / 2, ty - btnh / 2 + ScaleY(15), btnw, btnh)
        button.Paint = function(me,w,h)
            RoundedBox(h / 2, 0, 0, w, h, colors.circle_button)
    
            SimpleText(">", "BHACC_HelpArrowFont", w / 2, h / 2 - 2, colors.help_next, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        local function Button3()
            item:Remove()
            title:Remove()
            text:Remove()
            button:Remove()
    
            local start = CurTime()
        
            local trim = ScaleY(40)
            local title =  CreateDPanel(p, 0, 0, x, trim)
            title.Paint = function(me,w,h)
                RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.body, true, true, false, false)
        
                SimpleText(LerpText((CurTime() - start) / 0.5, bh_language.StepThree), "BHACC_FMedium", ScaleY(10), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        
            local title_text = TextWrap(bh_language.StepThreeText, "BHACC_FSmallMed", x - ScaleY(10))
            
            SetFont("BHACC_FSmallMed")
            local tw, th = GetTextSize(title_text)
            
            local whentostart = 0.6
            local textstart = CurTime()
            local text_drawstart = CurTime() + 0.6
        
            local text = CreateDPanel(p, 0, trim, x, th + ScaleY(15))
            text.Paint = function(me,w,h)
                RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.help_body, false, false, true, true)
        
                if textstart + whentostart < CurTime() then
                    DrawText(LerpText((CurTime() - text_drawstart) / 1.5, title_text), "BHACC_FSmallMed", ScaleY(5), ScaleY(5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        
            local tx, ty = p:GetPos()
            tx = tx + x
            ty = ty + th + trim
            
            local btnw, btnh = ScaleY(50), ScaleY(50)
            local button = CreateDButton(self.bh_acc_menu, tx - btnw / 2, ty - btnh / 2 + ScaleY(10) + ScaleY(55), btnw, btnh)
            button.Paint = function(me,w,h)
                RoundedBox(h / 2, 0, 0, w, h, colors.circle_button)
        
                SimpleText(">", "BHACC_HelpArrowFont", w / 2, h / 2 - 2, colors.help_next, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local whentostart = 0.6 + 1.5
            local linkstart = CurTime()
            local text_drawstart = CurTime() + whentostart
            
            local clickhere = CreateDButton(p, 0, trim + th + ScaleY(15) + 2, x, ScaleY(50))
            clickhere.Paint = function(me,w,h)
                RoundedBox(ScaleY(5), 0, 0, w, h, colors.help_body)
                
                if linkstart + whentostart < CurTime() then
                    SimpleText(LerpText((CurTime() - text_drawstart) / 1, bh_language["ClickToPreview"]), "BHACC_FSmallMed", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end
            clickhere.DoClick = function()
                self:CreateGiftMenu({
                    name = "Hat",
                    model = "models/food/hotdog.mdl",
                    price = 100,
                    ui_CamPos = Vector(-60.3, -45.25, 38.16),
                    ui_FOV = 7.51,
                    ui_LookAng = Angle(17.73, 37.04, 0),
                    id = -1
                }, true)
            end

            local function Button4()
                if self.Help_Credit then
                    clickhere:Remove()
                    title:Remove()
                    text:Remove()
                    button:Remove()
            
                    local start = CurTime()
                
                    local trim = ScaleY(40)
                    local title = CreateDPanel(p, 0, 0, x, trim)
                    title.Paint = function(me,w,h)
                        RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.body, true, true, false, false)
                
                        SimpleText(LerpText((CurTime() - start) / 0.5, bh_language.LastStep), "BHACC_FMedium", ScaleY(10), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                
                    local title_text = TextWrap(bh_language.LastStepText, "BHACC_FSmallMed", x - ScaleY(10))
                    
                    SetFont("BHACC_FSmallMed")
                    local tw, th = GetTextSize(title_text)
                    
                    local whentostart = 0.6
                    local textstart = CurTime()
                    local text_drawstart = CurTime() + 0.6
                
                    local text = CreateDPanel(p, 0, trim, x, th + ScaleY(15))
                    text.Paint = function(me,w,h)
                        RoundedBoxEx(ScaleY(5), 0,0,w,h,colors.help_body, false, false, true, true)
                
                        if textstart + whentostart < CurTime() then
                            DrawText(LerpText((CurTime() - text_drawstart) / 1.5, title_text), "BHACC_FSmallMed", ScaleY(5), ScaleY(5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        end
                    end
                
                    local tx, ty = p:GetPos()
                    tx = tx + x
                    ty = ty + th + trim

                    local whentostart = 0.6 + 1.5
                    local linkstart = CurTime()
                    local text_drawstart = CurTime() + whentostart

                    local clickhere = CreateDButton(p, 0, trim + th + ScaleY(15) + 2, x, ScaleY(40))
                    local link_text = "https://www.gmodstore.com/users/Bhoon/addons"
                    clickhere.Paint = function(me,w,h)
                        RoundedBox(ScaleY(5), 0, 0, w, h, colors.help_body)

                        if linkstart + whentostart < CurTime() then
                            SimpleText(LerpText((CurTime() - text_drawstart) / 1, link_text), "BHACC_FSmallMed", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end
                    end
                    clickhere.DoClick = function()
                        gui.OpenURL(link_text)
                    end
                    
                    local btnw, btnh = ScaleY(50), ScaleY(50)
                    local button = CreateDButton(self.bh_acc_menu, tx - btnw / 2, ty - btnh / 2 + clickhere:GetTall() + ScaleY(15), btnw, btnh)
                    button.Paint = function(me,w,h)
                        RoundedBox(h / 2, 0, 0, w, h, colors.circle_button)
                
                        SimpleText(">", "BHACC_HelpArrowFont", w / 2, h / 2 - 2, colors.help_next, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end

                    button.DoClick = function()
                        button:Remove()
                        p:Remove()
                    end

                    text.OnRemove = function()
                        button:Remove()
                    end
                else
                    p:Remove()
                    button:Remove()
                end
            end
            button.DoClick = Button4
        end
        button.DoClick = Button3

        text.OnRemove = function()
            button:Remove()
        end
    end
    button.DoClick = Button2
    
    text.OnRemove = function()
        button:Remove()
    end
end