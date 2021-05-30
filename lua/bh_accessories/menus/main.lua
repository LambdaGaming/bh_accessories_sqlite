local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local IsValid = IsValid
local Lerp = Lerp
local CurTime = CurTime

local color_white = color_white

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local RoundedBox = draw.RoundedBox
local SimpleText = draw.SimpleText
local DrawText = draw.DrawText
local SetMaterial = surface.SetMaterial
local DrawTexturedRect = surface.DrawTexturedRect

local bh_language = BH_ACC.Language
local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

local LerpColor = BH_ACC.LerpColor
local CreateDPanel = BH_ACC.CreateDPanel
local CreateDButton = BH_ACC.CreateDButton
local CreateDFrame = BH_ACC.CreateDFrame
local RemovePanel = BH_ACC.RemovePanel
local ChangeSelected = BH_ACC.ChangeSelected

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/main", function(filename)
    if filename == "bh_acc_config" then
        bh_language = BH_ACC.Language
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors
    elseif filename == "cl_bh_acc_ui" then
        LerpColor = BH_ACC.LerpColor
        CreateDPanel = BH_ACC.CreateDPanel
        CreateDButton = BH_ACC.CreateDButton
        CreateDFrame = BH_ACC.CreateDFrame
        RemovePanel = BH_ACC.RemovePanel
    elseif filename == "cl_bh_acc_view" then
        ChangeSelected = BH_ACC.ChangeSelected
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/main", function()
    ScaleY = BH_ACC.ScaleY
end)

-- Here are all of the left options and the functionality --
-- title = Name, icon = Material, col = Color, doclick = function when clicked, check = function to check if the player can access it --
local LeftOptions = {
    {title = bh_language.APPEARANCE, icon = materials.user, col = colors.Bar_One, doclick = function()
        RemovePanel(BH_ACC.bh_acc_eoptions)
        RemovePanel(BH_ACC.bh_acc_eoptions_bottom)
        RemovePanel(BH_ACC.bh_acc_helpmenu)
        RemovePanel(BH_ACC.bh_acc_positionmenu)
        RemovePanel(BH_ACC.bh_acc_editormenu)

        ChangeSelected(BH_ACC, BH_ACC.Categories[1].name)

        BH_ACC:OpenOptions()
    end, check = function()
        return BH_ACC.LeftCategories["APPEARANCE"]
    end},
    {title = bh_language.HELP, icon = materials.help, col = colors.Bar_Two, doclick = function()        
        RemovePanel(BH_ACC.bh_acc_options_bottom)
        RemovePanel(BH_ACC.bh_acc_options)
        RemovePanel(BH_ACC.bh_acc_eoptions)
        RemovePanel(BH_ACC.bh_acc_eoptions_bottom)
        RemovePanel(BH_ACC.bh_acc_positionmenu)
        RemovePanel(BH_ACC.bh_acc_editormenu)

        ChangeSelected(BH_ACC, BH_ACC.Categories[1].name)

        BH_ACC:OpenHelpMenu()
    end, check = function()
        return BH_ACC.LeftCategories["HELP"]
    end},
    {title = bh_language.POSITION_OPTION, icon = materials.wrench, col = colors.Bar_Three, doclick = function()
        RemovePanel(BH_ACC.bh_acc_helpmenu)
        RemovePanel(BH_ACC.bh_acc_options)
        RemovePanel(BH_ACC.bh_acc_options_bottom)
        RemovePanel(BH_ACC.bh_acc_eoptions)
        RemovePanel(BH_ACC.bh_acc_eoptions_bottom)
        RemovePanel(BH_ACC.bh_acc_editormenu)

        ChangeSelected(BH_ACC, BH_ACC.Categories[1].name)

        BH_ACC:OpenPositionMenu()
    end, check = function(ply)
        if not BH_ACC.CanAccessPositioner(ply) and not BH_ACC.CanAccessPMDLPositioner(ply) then
            return false
        end

        return BH_ACC.LeftCategories["POSITIONER"]
    end},
    {title = bh_language.EDITOR, icon = materials.editor, col = colors.Bar_Four, doclick = function()
        RemovePanel(BH_ACC.bh_acc_options)
        RemovePanel(BH_ACC.bh_acc_helpmenu)
        RemovePanel(BH_ACC.bh_acc_options_bottom)
        RemovePanel(BH_ACC.bh_acc_positionmenu)
        RemovePanel(BH_ACC.bh_acc_editormenu)

        ChangeSelected(BH_ACC, BH_ACC.Categories[1].name)
        
        BH_ACC:EditorOptions()
    end, check = function(ply)
        if not BH_ACC.CanAccessEditor(ply) then
            return false
        end

        return BH_ACC.LeftCategories["EDITOR"]
    end}
}

function BH_ACC:OpenMenu()
    RemovePanel(self.bh_acc_menu)

    --self.OldSelected = self.Categories[1].name
    ChangeSelected(self, self.Categories[1].name)

    local scrh = ScrH()

    self.bh_acc_menu = CreateDFrame(0, 0, ScrW(), scrh)
    local m = self.bh_acc_menu
    
    RemovePanel(self.bh_acc_model) -- It's not a panel but why not --
    
    local ply = LocalPlayer()
    
    -- Here we create the illusion clientsidemodel of the players model --
    -- Then we make the player invisible --
    self.bh_acc_model = self.CreateClientSideModel(nil, ply:GetModel())
    self.SetDModelPanelEntitySequence(self.bh_acc_model)
    ply:SetNoDraw(true)
    m.OnRemove = function()
        ply:SetNoDraw(false)

        if IsValid(self.bh_acc_model) then
            self.bh_acc_model:Remove()
        end
    end

    local lw, lh = ScaleY(250), (scrh * 0.75)
    self.bh_acc_left = CreateDPanel(m, ScaleY(25), scrh / 2 - lh / 2, lw, lh)
    local left = self.bh_acc_left
    local function leftPaint(me, w, h)
        SetDrawColor(colors.body)
        RoundedBox(ScaleY(5), 0, 0, w, h, colors.body)
    end
    left.Paint = leftPaint

    local remh = ScaleY(72)
    local rem = CreateDButton(left, 0, lh - remh, lw, remh)
    local remmarg = ScaleY(5)
    rem.Paint = function(me,w,h)
        RoundedBox(ScaleY(5), remmarg, remmarg, w - remmarg * 2, h - remmarg * 2, colors.exit)

        if me.Hovered then
            RoundedBox(ScaleY(5), remmarg, remmarg, w - remmarg * 2, h - remmarg * 2, colors.hover)
        end

        SimpleText(bh_language.EXIT, "BHACC_FontLeftTitle", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    rem.DoClick = function()
        m:Remove()
    end

    local leftpw, leftph = lw, lh / 16

    local bari = 1
    local start_bar = CurTime()
    local oldsize = leftph * bari - leftph

    local clickedrect = colors.left_cat_clicked
    local unclicked = colors.unclicked_icon_left
    local unclicked_text = colors.unclicked_text_left
    local clicked = colors.clicked_icon_left
    local clicked_text = colors.clicked_text_left

    local iconsize = ScaleY(32)

    local opened = 0
    local called = false
    local reali = 0
    -- Let's create all of the left options ( only those that we can access ) --
    for k = 1, #LeftOptions do
        local v = LeftOptions[k]

        if not v.check(ply) then continue end

        reali = reali + 1

        local reali = reali

        local title = v.title
        local icon = v.icon
        
        local p = CreateDButton(left, 0, leftph * reali - leftph, leftpw, leftph)
        local hoverlerp = color_transparent
        local starthoverlerp = CurTime()
        local dur = 0.75
        local function LeftPaint(me,w,h)
            if bari == reali then
                SetDrawColor(clickedrect)
                DrawRect(4,0,w,h)

                if icon then
                    SetDrawColor( clicked )
                    SetMaterial( icon )
                    DrawTexturedRect(4 + ScaleY(8), h / 2 - iconsize / 2, iconsize, iconsize)
                end

                SimpleText(v.title, "BHACC_FontLeftTitle", ScaleY(22) + iconsize, h / 2, clicked_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                if me.Hovered then
                    hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hover)
                else
                    hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
                end

                SetDrawColor(hoverlerp)
                DrawRect(0,0,w,h)
                
                if icon then
                    SetDrawColor( unclicked )
                    SetMaterial( icon )
                    DrawTexturedRect(4 + ScaleY(8), h / 2 - iconsize / 2, iconsize, iconsize)
                end

                SimpleText(v.title, "BHACC_FontLeftTitle", ScaleY(22) + iconsize, h / 2, unclicked_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end
        p.Paint = LeftPaint

        local function StartHoverTime()
            starthoverlerp = CurTime()
        end

        p.OnCursorEntered = StartHoverTime
        p.OnCursorExited = StartHoverTime
        local function DoClick()
            if opened == k then return end
            opened = k
            
            oldsize = leftph * bari - leftph
            bari = reali
            start_bar = CurTime()

            v.doclick()
        end
        p.DoClick = DoClick

        if not called then
            called = true

            DoClick()
        end
    end

    local amt = 0
    for i = 1, #LeftOptions do
        -- Let's check and only show the ones the player can access --
        if not LeftOptions[i].check(ply) then continue end
        
        amt = amt + 1
    end

    -- Here we handle that little bar that moves when clicking on the left options --
    local lerp_bar = leftph * bari - leftph
    local leftposx, leftposy = left:GetPos()
    local bar = CreateDPanel(m, leftposx, leftposy, 4, leftph * amt)
    local function BarPaint(me,w,h)
        lerp_bar = Lerp((CurTime() - start_bar) / 0.08, oldsize, leftph * bari - leftph)

        SetDrawColor(LeftOptions[bari].col)
        DrawRect(0, lerp_bar, w, leftph)
    end
    bar.Paint = BarPaint
end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "cl_bh_acc")
end