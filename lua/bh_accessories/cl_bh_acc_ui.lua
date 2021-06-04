local GetItemData = BH_ACC.GetItemData

local bh_language = BH_ACC.Language
local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/cl_bh_acc_ui", function(filename)
    if filename == "bh_acc_config" then
        bh_language = BH_ACC.Language
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors
    elseif filename == "sh_bh_acc" then
        GetItemData = BH_ACC.GetItemData
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/cl_bh_acc_ui", function()
    ScaleY = BH_ACC.ScaleY
end)

-- Vgui functions and utilities --
function BH_ACC.RemovePanel(p)
    if IsValid(p) then p:Remove() end
end

function BH_ACC.ClearPanel(p)
    if IsValid(p) then p:Clear() end
end

function BH_ACC.LerpColor(frac,from,to) 
	return Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
end
local LerpColor = BH_ACC.LerpColor

local function EmptyFunc() end

local timer_Simple = timer.Simple

local _Panel = FindMetaTable("Panel")
local Panel_Add = _Panel.Add
local Panel_SetPos = _Panel.SetPos
local Panel_SetSize = _Panel.SetSize

local RegisterDermaMenuForClose = RegisterDermaMenuForClose

local RoundedBoxEx = draw.RoundedBoxEx
local RoundedBox = draw.RoundedBox
local SimpleText = draw.SimpleText
local DrawText = draw.DrawText
local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local SetFont = surface.SetFont
local GetTextSize = surface.GetTextSize
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

local string_sub = string.sub

local boxHover = GWEN.CreateTextureBorder( 4, 4, 64 - 4 * 2, 64 - 4 * 2, 5, 5, 5, 5, Material( "gui/sm_hover.png", "nocull" ) )

local vgui_Create = vgui.Create

function BH_ACC.CreateDFrame(x, y, w, h)
    local f = vgui_Create("DFrame")
    Panel_SetPos(f, x, y)
    Panel_SetSize(f, w, h)
    f:SetTitle("")
    f:MakePopup()
    f:SetDraggable(false)
    f:ShowCloseButton(false)
    f.Paint = EmptyFunc

    return f
end
local CreateDFrame = BH_ACC.CreateDFrame

function BH_ACC.CreateDPanel(parent, x, y, w, h)
    local p = Panel_Add(parent, "DPanel")
    Panel_SetPos(p, x, y)
    Panel_SetSize(p, w, h)
    p.Paint = EmptyFunc

    return p
end

function BH_ACC.CreateDButton(parent, x, y, w, h)
    local b = Panel_Add(parent, "DButton")
    Panel_SetPos(b, x, y)
    Panel_SetSize(b, w, h)
    b:SetText("")
    b.Paint = Emptyfunc

    return b
end
local CreateDButton = BH_ACC.CreateDButton

local SetDModelPanelModel = BH_ACC.SetDModelPanelModel
function BH_ACC.CreateDModelPanel(parent, x, y, w, h, data)
    local mdl = Panel_Add(parent, "DModelPanel")
    Panel_SetPos(mdl, x, y)
    Panel_SetSize(mdl, w, h)
    mdl:SetMouseInputEnabled(false)

    if data then
        if data.model then
            SetDModelPanelModel(mdl, data.model)
        end

        mdl.LayoutEntity = EmptyFunc
        
        mdl.vCamPos = data.ui_CamPos or mdl.vCamPos
        mdl.fFOV = data.ui_FOV or mdl.fFOV
        mdl.aLookAngle = data.ui_LookAng or mdl.aLookAngle

        local ent = mdl.Entity
        if IsValid(ent) then
            if data.skin then ent:SetSkin( data.skin ) end
            if data.material then ent:SetMaterial(data.material) end
            if data.color then ent:SetColor( data.color ) end
        end
    end
    
    return mdl
end

function BH_ACC.CreateAvatarImage(parent, x, y, w, h, ply)
    local av = Panel_Add(parent, "AvatarImage")
    Panel_SetPos(av, x, y)
    Panel_SetSize(av, w, h)
    av:SetPlayer(ply, h)
    av:SetMouseInputEnabled(false)

    return av
end

function BH_ACC.Create_DNumSlider(parent, x, y, w, h)
	local slider = Panel_Add(parent, "DNumSlider" )
	Panel_SetPos( slider, x, y )
	Panel_SetSize( slider, w, h )
	slider:SetMin( -1 )
	slider:SetMax( 1 )
	slider:SetDecimals( 2 )
	slider:SetValue( 0 )
	slider.TextArea:SetTextColor(color_white)
	slider.TextArea:SetFont("BHACC_FSmall")
	slider.TextArea:SetDrawLanguageID(false)
	slider.TextArea:SetCursorColor(color_black)
	slider.Label:SetVisible(false)
	slider.Slider.Paint = function(me, w, h)
		SetDrawColor(255,255,255,20)
		DrawRect(0, h * 0.5, w, 2)
	end
    local knobsize = ScrH() / 1080 * 20
	slider.Slider.Knob.Paint = function(me, w, h)
		RoundedBox(ScrH() / 1080 * 5, w / 2 - knobsize / 2, h / 2 - knobsize / 2, knobsize, knobsize, color_white)

		return true
	end

	return slider
end

function BH_ACC.CreateDScrollPanel(parent, x, y, w, h)
    local s = Panel_Add(parent, "DScrollPanel")
    Panel_SetPos(s, x, y)
    Panel_SetSize(s, w, h)

	local sbar = s:GetVBar()
	sbar.Paint = EmptyFunc
	sbar.btnUp.Paint = EmptyFunc
	sbar.btnDown.Paint = EmptyFunc
    sbar.btnGrip.Paint = EmptyFunc

    s.bh_acc_itemid = nil
    sbar.bh_acc_itemid = nil
    
    return s
end

function BH_ACC.ScrollPaint(s)
    local function Paint(me, w, h)
		RoundedBox( 5,0,0,w,h, colors.body_transparent )
    end
	s:GetVBar().btnGrip.Paint = Paint
end

function BH_ACC:CreateDermaMenu(w, h)
    if IsValid(self.bh_acc_pickaccessory) then
        self.bh_acc_pickaccessory:Remove()
    end

    local bg = CreateDFrame(0, 0, ScrW(), ScrH())
    self.bh_acc_pickaccessory = bg

    local pposx, pposy = gui.MouseX(), gui.MouseY()
    local p = self.CreateDPanel(bg, pposx, pposy, w, h)
    local function DMenuPaint(me, w, h)
        RoundedBox(ScrH() / 1080 * 5, 0, 0, w, h, colors.body)
    end
    p.Paint = DMenuPaint
    local function GetDeleteSelf(me)
        local pposx, pposy = me:GetPos()
        local mx, my = gui.MouseX(), gui.MouseY()

        local bool = ((mx >= pposx and mx <= pposx + me:GetWide()) and (my >= pposy and my <= pposy + me:GetTall()))
        me:SetVisible(bool)
        bg:SetVisible(bool)
        
        if bool then
            local function TimerFunc()
                if not IsValid(me) then return end

                RegisterDermaMenuForClose( me )
            end
            timer_Simple(0, TimerFunc)
        end

        return not bool
    end
    p.GetDeleteSelf = GetDeleteSelf
    
    RegisterDermaMenuForClose( p )

    local function OnRemove()
        if IsValid(bg) then
            bg:Remove()
        end
    end
    p.OnRemove = OnRemove

    return p
end

function BH_ACC:CreateItemPanel(data, parent, x, y, w, h)
    local ply = LocalPlayer()
    local equipped_lookup = ply.bh_acc_equipped_lookup
    local owned_lookup = ply.bh_acc_owned_lookup
    local trim = ScaleY(28)
    local id = data.id
    local name = data.name

    local item = CreateDButton(parent, x, y, w, h)
    item.bh_acc_itemid = id
    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    local dur = 0.75
    local ownedcol = colors.itembg
    local nonownedcol = colors.itembg_unowned
    local roundness = ScaleY(8)
    local function itempaint(me, w, h)
        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)

            self:MakeToolTipForItem(data)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        local trimmaff = h - trim

        RoundedBoxEx(roundness, 0, 0, w, trimmaff, hoverlerp, true, true, false, false)
        
        if equipped_lookup[id] then
            SetDrawColor(colors.picked_dark)
            DrawRect(0, 0, w, trimmaff)

            boxHover( 0, 0, w,  trimmaff, colors.picked )
        else
            if owned_lookup[id] then
                RoundedBoxEx(roundness, 0, 0, w, trimmaff, ownedcol, true, true, false, false)
            else
                RoundedBoxEx(roundness, 0, 0, w, trimmaff, nonownedcol, true, true, false, false)
            end
        end

        SetDrawColor(colors.body_transparent)
        DrawRect(0,trimmaff,w,trim)

        SimpleText(name, "BHACC_ItemFont", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    item.Paint = itempaint
    
    local function OnCursorEntered()
        starthoverlerp = CurTime()

        self:HoverOnItem(data)
    end
    item.OnCursorEntered = OnCursorEntered
    local function ItemOnCursorExited()
        starthoverlerp = CurTime()
    
        BH_ACC:ExitHoverOnItem()
    end
    item.OnCursorExited = ItemOnCursorExited
    
    local function OpenDropBox()
        self:MakeDropBoxForItem(data)
    end
    item.DoClick = OpenDropBox
    item.DoRightClick = OpenDropBox

    local function DoRightClick()
        self:MakeDropBoxForItem(data)
    end
    item.DoRightClick = DoRightClick

    BH_ACC.CreateDModelPanel(item, 0, 0, w, h - trim, data)
end

function BH_ACC:MakeToolTipForItem(data)
    if IsValid(self.bh_acc_tooltip) then
        if self.bh_acc_tooltip.bh_acc_itemid ~= data.id then
            self.bh_acc_tooltip:Remove()
        end

        return
    end

    local name = data.name
    local price = self.FormatMoney(data.price)

    SetFont("BHACC_DescriptionFont")
    local textw, texth = 0, 0
    local desc = data.description and data.description:Trim() ~= "" and self.TextWrap(data.description, "BHACC_DescriptionFont", ScaleY(185) + ScaleY(80))
    if desc then
        textw, texth = GetTextSize(desc)
    end
    
    SetFont("BHACC_PriceFont")
    local pricew, priceh = GetTextSize(price .. bh_language.Currency)

    SetFont("BHACC_ItemFont")
    local dolw, dolh = GetTextSize(bh_language.Currency)

    SetFont("BHACC_ItemFontToolTip")
    local namew, nameh = GetTextSize(name)

    SetFont("BHACC_EquippableFont")
    local eqw, eqh = GetTextSize(bh_language["Equippable"])
    eqw = eqw + ScaleY(2)
    eqh = eqh + ScaleY(2)

    local toolw, toolh = ScaleY(200), ScaleY(20) + nameh + priceh + texth
    if desc then
        toolw = toolw + ScaleY(80)
    end
    self.bh_acc_tooltip = self.CreateDPanel(self.bh_acc_menu, gui.MouseX() + ScaleY(20), gui.MouseY() - toolh / 2, toolw, toolh)
    local p = self.bh_acc_tooltip
    p.bh_acc_itemid = data.id
    local scale5 = ScaleY(5)
    local function ToolTipPaint(me, w, h)
        local mx, my = gui.MouseX(), gui.MouseY()
        Panel_SetPos(p, mx + ScaleY(20), my - h / 2)

        SetDrawColor(colors.body_transparent)
        DrawRect(0,0,w,h)

        SimpleText(name, "BHACC_ItemFontToolTip", scale5, scale5, color_white)

        local recth = ScaleY(25)

        SetDrawColor(colors.body)
        DrawRect(scale5, h - recth - scale5, pricew + scale5 * 2, recth)

        SimpleText(bh_language.Currency, "BHACC_PriceFont", scale5 + 2, h - priceh / 2 - scale5 * 1.5, colors.currency_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        SimpleText(price, "BHACC_PriceFont", scale5 * 3 + pricew / 2, h - priceh / 2 - scale5 * 1.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        SetDrawColor(colors.body)
        DrawRect(scale5 + 2 + pricew + scale5 * 2, h - recth - scale5, eqw + scale5, recth)

        SimpleText(bh_language["Equippable"], "BHACC_EquippableFont", scale5 + 2 + pricew + scale5 * 2 + eqw / 2, h - recth - scale5 + recth / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if desc then
            --RoundedBox(scale5,scale5, scale5 + nameh / 2 + scale5 * 2,textw, texth,colors.body)

            DrawText(desc, "BHACC_DescriptionFont", scale5, scale5 + nameh, color_white)
        end
        
        local hov_p = vgui.GetHoveredPanel()
        if not IsValid(hov_p) or not hov_p.bh_acc_itemid or hov_p:GetClassName() == "DScrollPanel" then
            me:Remove()
        end
    end
    p.Paint = ToolTipPaint

    return p
end

function BH_ACC:CreateEditorItemPanel(data, parent, x, y, w, h)
    local ply = LocalPlayer()
    local equipped_lookup = ply.bh_acc_equipped_lookup
    local owned_lookup = ply.bh_acc_owned_lookup
    local trim = ScaleY(28)
    local id = data.id
    local name = data.name

    local item = CreateDButton(parent, x, y, w, h)
    item.bh_acc_itemid = id
    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    local dur = 0.75
    local roundness = ScaleY(8)
    local function itempaint(me, w, h)
        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)

            self:MakeToolTipForItem(data)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        local trimmaff = h - trim

        RoundedBoxEx(roundness, 0, 0, w, trimmaff, hoverlerp, true, true, false, false)

        RoundedBoxEx(roundness, 0, 0, w, trimmaff, colors.itembg, true, true, false, false)

        SetDrawColor(colors.body_transparent)
        DrawRect(0,trimmaff,w,trim)

        SimpleText(name, "BHACC_ItemFont", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    item.Paint = itempaint

    local function DoAClick()
        if IsValid(self.bh_acc_eoptions) then
            self.bh_acc_eoptions:Remove()
        end
        parent:Remove()
        self:CreateEditorMenu(data, false, data.category)
    end
    item.DoClick = DoAClick

    local function OnCursorEntered()
        starthoverlerp = CurTime()

        self:HoverOnItem(data)
    end
    item.OnCursorEntered = OnCursorEntered

    local function OnCursorExited()
        starthoverlerp = CurTime()
        
        self:ExitHoverOnItem()
    end
    item.OnCursorExited = OnCursorExited
    
    local mdl = BH_ACC.CreateDModelPanel(item, 0, 0, w, h - trim, data)
    local function MdlPaintOver(me,w,h)
        if item.Hovered then
            SimpleText(bh_language["EDIT"], "BHACC_ItemFontOverlay", w * 0.5, h / 2, colors.editcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    mdl.PaintOver = MdlPaintOver
end

function BH_ACC.CreateTextEntry(parent, x, y, w, h)
    local p = Panel_Add(parent, "DTextEntry")
    Panel_SetPos(p, x, y)
    Panel_SetSize(p, w, h)
	p:SetTextColor(color_white)
	p:SetText("")
	p:SetFont("BHACC_FMedium")
    local function Paint(me, w, h)
        RoundedBox( ScrH() / 1080 * 5, 0, 0, w , h, colors.body )

        me:DrawTextEntryText(color_white, color_white, color_white)
    end
    p.Paint = Paint

    return p
end

-- What keys to ignore --
local ignore = {
    ["CTRL"] = true,["ALT"] = true,["TAB"] = true,["`"] = true,["CAPSLOCK"] = true,["CAPSLOCKTOGGLE"] = true,["LWIN"] = true,["RWIN"] = true,["ENTER"] = true,["F1"] = true,["F2"] = true,["F3"] = true,["F4"] = true,["F5"] = true,["F6"] = true,["F7"] = true,["F8"] = true,["F9"] = true,["F10"] = true,["F11"] = true,["F12"] = true,["SCROLLLOCK"] = true,["SCROLLLOCKTOGGLE"] = true,["PAUSE"] = true,["NUMLOCK"] = true,["NUMLOCKTOGGLE"] = true,["APP"] = true
}

-- What keys to change when typing --
local change = {
    ["SEMICOLON"] = ";",["KP_SLASH"] = "/",["KP_MULTIPLY"] = "*",["KP_MINUS"] = "-",["KP_PLUS"] = "+",["KP_PLUS"] = "+",["END"] = "1",["DOWNARROW"] = "2",["PGDN"] = "3",["LEFTARROW"] = "4",["KP_5"] = "5",["RIGHTARROW"] = "6",["HOME"] = "7",["UPARROW"] = "8",["PGUP"] = "9",["INS"] = "0",["DEL"] = "."
}

-- Changing keys to their shifting value --
local shifts = {
    ["`"] = "~",["1"] = "!",["2"] = "@",["3"] = "#",["4"] = "$",["5"] = "%",["6"] = "^",["7"] = "&",["8"] = "*",["9"] = "(",["0"] = ")",["-"] = "_",["="] = "+",["["] = "{",["]"] = "}",[";"] = ":",["'"] = "\"",["\\"] = "|",[","] = "<",["."] = ">",["/"] = "?",
}

-- This text entry supports newlines --
-- It doesn't use dtextentry but rather RichText with raw lua intergration --
-- Some things won't work like caps lock due to gmod not having a way of detecting if the player has caps lock enabled --
function BH_ACC.CreateBetterTextEntry(parent, x, y, w, h, newtext)
    local p = Panel_Add(parent, "RichText")
    Panel_SetPos(p, x, y)
    Panel_SetSize(p, w, h)
    p:SetText(newtext or "")
    function p:PerformLayout()
        self:SetFontInternal("BHACC_FSmall")
        self:SetFGColor(color_white)
    end
    p.BH_ACC_OnChangedText = EmptyFunc

    local alltext = newtext or ""
    
    local function SetToText()
        local function TimerFunc()
            p:SetText(alltext)

            p.BH_ACC_OnChangedText(alltext)
        end
        timer_Simple(0, TimerFunc)
    end

    local function RemoveOneFromText()
        alltext = string_sub(alltext, 1, #alltext - 1)
    end

    local function ReplaceText(start, stop, replacement)
        alltext = string_sub(alltext, 1, start - 1) .. replacement .. string_sub(alltext, stop, #alltext)
    end

    local lastkey = nil
    local startkey = nil
    local upper = false
	function p:OnKeyCodePressed( key )
        if not key then return end

        local keyname = input.GetKeyName( key )

        if not keyname then return end

        if ignore[keyname] then return end
        
        local startselected, endselected = self:GetSelectedTextRange()
        local isselectednaything = startselected > 0 or endselected > 0

        keyname = change[keyname] or keyname

        if keyname == "BACKSPACE" then
            if isselectednaything then
                ReplaceText(startselected + 1, endselected + 1, "")

                SetToText()

                lastkey = keyname

                startkey = CurTime() + 0.3

                return
            else
                RemoveOneFromText()

                SetToText()

                lastkey = keyname
                
                startkey = CurTime() + 0.3
                return
            end
        elseif keyname == "SPACE" then
            keyname = " "
        elseif keyname == "SHIFT" then
            upper = true

            return
        end

        if upper then
            keyname = shifts[keyname] or keyname:upper()
        end

        if isselectednaything then
            ReplaceText(startselected + 1, endselected + 1, keyname)
        else
            alltext = alltext .. keyname
        end
        
        SetToText()

        lastkey = keyname

        startkey = CurTime() + 0.3
	end

    function p:OnKeyCodeReleased( key )
        if not key then return end
        
        local keyname = input.GetKeyName( key )

        if keyname == "SHIFT" then
            upper = false
        end

        keyname = (upper and string.upper(keyname) or keyname)

        if lastkey ~= keyname then return end
        
        lastkey = nil

        startkey = nil
    end

    p.Paint = function(me, w, h)
        RoundedBoxEx(ScaleY(5), 0, 0, w, h, colors.body, false, false, true, true)

        if lastkey and input.IsKeyDown(input.GetKeyCode(lastkey)) and startkey and startkey <= CurTime() then
            if lastkey == "BACKSPACE" then
                startkey = CurTime() + 0.045

                RemoveOneFromText()
                SetToText()
            else
                startkey = CurTime() + 0.045
                alltext = alltext .. (upper and string.upper(lastkey) or lastkey)

                SetToText()
            end
        end
    end

    return p
end

local dropboxoptions = {
    {
        name = bh_language["Buy"],
        check = function(ply, data)
            if ply.bh_acc_owned_lookup[data.id] then
                return false
            end

            return BH_ACC.GetPlayerBalance(ply) >= data.price
        end,
        doclick = function(ply, data)
            if BH_ACC.GetPlayerBalance(ply) < data.price then
                BH_ACC.RunNotification("Notify_No_Money")

                return
            end

            if not BH_ACC.CanBuyAccessory(ply, data.id) then
                BH_ACC.RunNotification("Notify_Cant_Buy")

                return
            end

            if not BH_ACC.IsNearVendor(ply) then
                BH_ACC.RunNotification("Notify_NotNear_Vendor")

                return
            end
            
            BH_ACC.BuyAccessory(data.id)
        end
    },

    {
        name = bh_language["Equip"],
        check = function(ply, data)
            if ply.bh_acc_equipped_lookup[data.id] then
                return false
            end
            
            return ply.bh_acc_owned_lookup[data.id]
        end,
        doclick = function(ply, data)
            BH_ACC.EquipAccessory(data.id)
        end
    },

    {
        name = bh_language["Unequip"],
        check = function(ply, data)
            return ply.bh_acc_equipped_lookup[data.id]
        end,
        doclick = function(ply, data)
            BH_ACC.UnEquipAccessory(data.id)
        end
    },

    {
        name = bh_language["Sell"],
        check = function(ply, data)
            return ply.bh_acc_owned_lookup[data.id]
        end,
        doclick = function(ply, data)
            BH_ACC.SellAccessory(data.id)
        end
    },

    {
        name = bh_language["Gift"],
        check = function(ply, data)
            return (BH_ACC.GetPlayerBalance(ply) >= data.price)
        end,
        doclick = function(ply, data)
            if BH_ACC.GetPlayerBalance(ply) < data.price then
                BH_ACC.RunNotification("Notify_Gift_No_Money")

                return
            end
            
            BH_ACC:CreateGiftMenu(data)
        end
    }
}

function BH_ACC.GrabValidDropBoxOptions(ply, data)
    local valid_ones = {}

    local amt = 0
    for k = 1, #dropboxoptions do
        if not dropboxoptions[k].check(ply, data) then continue end

        amt = amt + 1
        valid_ones[amt] = k
    end

    return amt, valid_ones
end

function BH_ACC:MakeDropBoxForItem(data)
    local ply = LocalPlayer()

    local amt, valid_boxoptions = self.GrabValidDropBoxOptions(ply, data)

    if amt <= 0 then return end

    local price = self.FormatMoney(data.price)
    SetFont("BHACC_PriceFont")
    local pricew, priceh = GetTextSize(price)

    local optw, opth = ScaleY(200), ScaleY(40)
    local p = BH_ACC:CreateDermaMenu(optw, opth * amt + opth)
    local function Paint(me,w,h)
        RoundedBoxEx(ScaleY(5),0,0,w,opth,colors.body,true,true,false,false)

        SimpleText(data.name, "BHACC_ItemFontComboBox", ScaleY(5), opth / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    
        SimpleText(bh_language.Currency, "BHACC_PriceFont", w - ScaleY(8) - pricew, opth / 2, colors.currency_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        SimpleText(price, "BHACC_PriceFont", w - ScaleY(5), opth / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
    p.Paint = Paint
    
    for k = 1, amt do
        local v = dropboxoptions[valid_boxoptions[k]]

        local name = v.name

        local opt = CreateDButton(p, 0, opth * k, optw, opth)
        local function OptPaint(me,w,h)
            if k == amt then
                RoundedBoxEx(ScaleY(5),0,0,w,opth,colors.dropbox_color,false,false,true,true)
            else
                SetDrawColor(colors.dropbox_color)
                DrawRect(0,0,w,h)
            end

            if me.Hovered then
                SetDrawColor(colors.hover)
                DrawRect(0,0,w,opth)
            end

            SimpleText(name, "BHACC_DropBoxNameFont", ScaleY(5), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)   
        end
        opt.Paint = OptPaint

        local function doclick()
            v.doclick(ply, data)

            p:Remove()
        end
        opt.DoClick = doclick
    end

    return p
end

function BH_ACC:CreateUnequipPanel(parent, x, y, w, h, category)
    local ply = LocalPlayer()

    local trim = ScaleY(28)
    local iconsizebig = ScaleY(100)

    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    local dur = 0.75
    local equipped = ply.bh_acc_equipped

    local uneq = CreateDButton(parent, x, y, w, h)
    local function uneqpaint(me, w, h)
        local found = false
        for k = 1, #equipped do
            local data = GetItemData(equipped[k])
            if data and GetItemData(equipped[k]).category == category then
                found = true
                break
            end
        end

        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        RoundedBoxEx(ScaleY(8),0,0,w,h - trim, hoverlerp, true, true, false, false)

        if not found then
            SetDrawColor(colors.picked_dark)
            DrawRect(0,0,w,h-trim)

            boxHover( 0, 0, w, h - trim, colors.picked )
        else
            RoundedBoxEx(ScaleY(8), 0, 0, w, h - trim, colors.itembg, true, true, false, false)
        end

        SetDrawColor(colors.body_transparent)
        DrawRect(0,h - trim,w,trim)

        if materials.x then
            SetDrawColor(colors.exit)
            surface_SetMaterial(materials.x)
            surface_DrawTexturedRect(w / 2 - iconsizebig / 2, h / 2 - iconsizebig / 2 - trim / 2, iconsizebig, iconsizebig)
        end

        SimpleText(bh_language["None"], "BHACC_ItemFont", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    uneq.Paint = uneqpaint

    local function OnCursor()
        starthoverlerp = CurTime()
    end
    uneq.OnCursorEntered = OnCursor
    uneq.OnCursorExited = OnCursor

    local function uneq_DoClick()
        for k,v in ipairs(ply.bh_acc_equipped) do
            local data = GetItemData(v)
            if data and data.category == category then
                self.UnEquipAccessory(data.id)
                break
            end
        end
    end
    uneq.DoClick = uneq_DoClick

    return uneq
end

function BH_ACC:CreateMakeNewPanel(parent, x, y, w, h, category, mini_category)
    local iconsizebig = ScaleY(100)
    local space = 2

    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    local dur = 0.75
    
    local editcreate = CreateDButton(parent, x, y, w, h)
    local function editcreatepaint(me, w, h)
        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        RoundedBoxEx(ScaleY(8), 0, 0, w, h, hoverlerp, true, true, false, false)

        RoundedBoxEx(ScaleY(8), 0, 0, w, h, colors.itembg, true, true, false, false)

        local t1 = bh_language["CREATE"]
        local t1w, t1h = GetTextSize(t1)

        local t2 = bh_language["NEW"]
        local t2w, t2h = GetTextSize(t2)

        SimpleText(t1, "BHACC_FLarge", w * 0.5, h / 2 - t1h / 2 - space, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        SimpleText(t2, "BHACC_FLarge", w * 0.5, h / 2 + t2h / 2 + space, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    editcreate.Paint = editcreatepaint

    local function OnCursor()
        starthoverlerp = CurTime()
    end
    editcreate.OnCursorEntered = OnCursor
    editcreate.OnCursorExited = OnCursor

    local function editcreate_DoClick()
        if IsValid(self.bh_acc_eoptions) then
            self.bh_acc_eoptions:Remove()
        end
        parent:Remove()
        self:CreateEditorMenu(nil, true, category, mini_category)
    end
    editcreate.DoClick = editcreate_DoClick

    return editcreate
end

function BH_ACC:CreateSubCategoryPanel(parent, x, y, w, h, data, category, other, editor)
    local trim = ScaleY(28)
    local iconsizebig = ScaleY(100)
    
    local mc = Panel_Add(parent, "DButton")
    Panel_SetPos(mc, x, y)
    Panel_SetSize(mc, w, h)
    mc:SetText("")
    mc.Paint = Emptyfunc

    local hoverlerp = color_transparent
    local dur = 0.75
    local starthoverlerp = CurTime()
    local function mcpaint(me, w, h)
        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        RoundedBoxEx(ScaleY(8),0,0,w,h - trim, hoverlerp, true, true, false, false)

        RoundedBoxEx(ScaleY(8), 0, 0, w, h - trim, colors.itembg, true, true, false, false)
        
        SetDrawColor(colors.body_transparent)
        DrawRect(0,h - trim,w,trim)

        if other then
            SimpleText(bh_language["Other"], "BHACC_ItemFont", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if materials.closet then
                SetDrawColor(color_white)
                surface_SetMaterial(materials.closet)
                surface_DrawTexturedRect(w / 2 - iconsizebig / 2, h / 2 - iconsizebig / 2 - trim / 2, iconsizebig, iconsizebig)
            end
        else
            SimpleText(data.name, "BHACC_ItemFont", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            if data.icon then
                SetDrawColor(color_white)
                surface_SetMaterial(data.icon)
                surface_DrawTexturedRect(w / 2 - iconsizebig / 2, h / 2 - iconsizebig / 2 - trim / 2, iconsizebig, iconsizebig)
            end
        end
    end
    mc.Paint = mcpaint

    local function OnCursor()
        starthoverlerp = CurTime()
    end
    mc.OnCursorEntered = OnCursor
    mc.OnCursorExited = OnCursor

    local function DoClick()
        if editor then
            if other then
                self:CreateBottomEditorMiniCatItems(category.allitems, category)
            else
                self:CreateBottomEditorMiniCatItems(data.items, category)
            end
        else
            if other then
                self:CreateBottomMiniCatItems(category.allitems, category)
            else
                self:CreateBottomMiniCatItems(data.items, category)
            end
        end
    end
    mc.DoClick = DoClick

    return mc
end

function BH_ACC:CreateMainCategoryPanel(parent, x, y, w, h, data, editor)
    local trim = ScaleY(28)
    local iconsize = ScaleY(64)

    local name = data.name
    local icon = data.icon

    local opt = CreateDButton(parent, x, y, w, h)
    local startlerp = CurTime()
    local colstart = colors.itembg
    local iconcolstart = colors.unclicked_icon
    local dur = 0.75
    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    if BH_ACC.Selected == name then
        colstart = colors.selected_color
        iconcolstart = colors.clicked_icon
    end
    local function optPaint(me,w,h)
        local CT = CurTime()

        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CT - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CT - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        RoundedBoxEx(ScaleY(8),0,0,w,h - trim, hoverlerp, true, true, false, false)

        if BH_ACC.Selected == name then
            if colstart ~= colors.selected_color and iconcolstart ~= colors.clicked_icon then
                local frac = (CT - startlerp) / dur

                colstart = LerpColor(frac, colstart, colors.selected_color)
                iconcolstart = LerpColor(frac, iconcolstart, colors.clicked_icon)
            end

            RoundedBoxEx(ScaleY(8),0,0,w,h - trim,colstart, true, true, false, false)

            SetDrawColor(colors.body_transparent)
            DrawRect(0,h - trim,w,trim)

            if icon then
                SetDrawColor(iconcolstart)
                surface_SetMaterial(icon)
                surface_DrawTexturedRect(w / 2 - iconsize / 2, h / 2 - iconsize / 2 - trim / 2, iconsize, iconsize)
            end

            --RoundedBoxEx(ScaleY(8),0,h - trim,w,trim,colors.body_transparent, false, false, true, true)
            SimpleText(name, "BHACC_CategoryTitle", w * 0.5, h - trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            if colstart ~= colors.itembg and iconcolstart ~= colors.unclicked_icon then
                local frac = (CT - startlerp) / dur
    
                colstart = LerpColor(frac, colstart, colors.itembg)
                iconcolstart = LerpColor(frac, iconcolstart, colors.unclicked_icon)
            end

            RoundedBoxEx(ScaleY(8), 0, 0,w, h - trim, colstart, true, true, false, false)

            if icon then
                SetDrawColor(iconcolstart)
                surface_SetMaterial(icon)
                surface_DrawTexturedRect(w / 2 - iconsize / 2, h / 2 - iconsize / 2 - trim / 2, iconsize, iconsize)
            end

            SetDrawColor(colors.body_transparent)
            DrawRect(0,h - trim,w,trim)

            --RoundedBoxEx(ScaleY(8),0,h - trim,w,trim,colors.body_transparent, false, false, true, true)
            SimpleText(name, "BHACC_CategoryTitle", w * 0.5, h - trim / 2, colors.unclicked_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    opt.Paint = optPaint

    local function HoverTime()
        starthoverlerp = CurTime()
    end
    opt.OnCursorEntered = HoverTime
    opt.OnCursorExited = HoverTime
    
    local function optDoClick()
        if self.Selected == name then return end

        startlerp = CurTime()

        self:ChangeSelected(name)

        self.RemovePanel(self.bh_acc_minigoback)

        if editor then
            self:CreateBottomEditorFirstItems(data)
        else
            self:CreateBottomFirstItems(data)
        end
    end
    opt.DoClick = optDoClick

    return opt
end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "cl_bh_acc_ui")
end