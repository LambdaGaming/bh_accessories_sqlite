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
local DrawText = draw.DrawText
local GetTextSize = surface.GetTextSize
local SetFont = surface.SetFont

local table_remove = table.remove
local string_find = string.find

local bh_language = BH_ACC.Language
local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

local LerpColor = BH_ACC.LerpColor
local CreateDPanel = BH_ACC.CreateDPanel
local CreateDButton = BH_ACC.CreateDButton
local CreateDModelPanel = BH_ACC.CreateDModelPanel
local CreateBetterTextEntry = BH_ACC.CreateBetterTextEntry
local CreateTextEntry = BH_ACC.CreateTextEntry
local CreateDScrollPanel = BH_ACC.CreateDScrollPanel
local CreateAvatarImage = BH_ACC.CreateAvatarImage
local ScrollPaint = BH_ACC.ScrollPaint
local CreateDFrame = BH_ACC.CreateDFrame
local RemovePanel = BH_ACC.RemovePanel

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/gift", function(filename)
    if filename == "bh_acc_config" then
        bh_language = BH_ACC.Language
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors
    elseif filename == "cl_bh_acc_ui" then
        LerpColor = BH_ACC.LerpColor
        CreateDPanel = BH_ACC.CreateDPanel
        CreateDButton = BH_ACC.CreateDButton
        CreateDModelPanel = BH_ACC.CreateDModelPanel
        CreateBetterTextEntry = BH_ACC.CreateBetterTextEntry
        CreateTextEntry = BH_ACC.CreateTextEntry
        CreateDScrollPanel = BH_ACC.CreateDScrollPanel
        CreateAvatarImage = BH_ACC.CreateAvatarImage
        ScrollPaint = BH_ACC.ScrollPaint
        CreateDFrame = BH_ACC.CreateDFrame
        RemovePanel = BH_ACC.RemovePanel
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/gift", function()
    ScaleY = BH_ACC.ScaleY
end)

function BH_ACC:CreateGiftMenu(data, test)
    RemovePanel(self.bh_acc_giftmenu_bg)
    
    local scrw, scrh = ScrW(), ScrH()
    local ply = LocalPlayer()
    local trim = ScaleY(48)
    local space = ScaleY(5)
    
    local name = data.name
    local price = self.FormatMoney(data.price)

    self.bh_acc_giftmenu_bg = CreateDFrame(0, 0, scrw, scrh)
    local bg = self.bh_acc_giftmenu_bg
    bg.Time = SysTime()
    bg.Paint = function(me, w, h)
        Derma_DrawBackgroundBlur(me, me.Time - 0.6)
    end

    local x, y = ScaleY(800), ScaleY(600) -- You should be able to change these numbers to change the width and height of the whole menu it actually works pretty well
    local p = CreateDPanel(bg, scrw / 2 - x / 2, scrh / 2 - y / 2, x, y)
    p.Paint = function(me,w,h)
        RoundedBoxEx(space, 0, 0, w, trim, colors.body, true, true, false, false)
        RoundedBoxEx(space, 0, trim, w, h - trim, colors.gift_body, false, false, true, true)

        SimpleText(bh_language["Gifting menu"], "BHACC_FLarge", ScaleY(7), trim / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
 
    local rem = CreateDButton(p, x - trim, 0, trim, trim)
    rem.Paint = function(me,w,h)
        SimpleText("X", "BHACC_FLarge", w / 2, h / 2, colors.x, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    rem.DoClick = function()
        bg:Remove()
    end

    local left = CreateDPanel(p, 2, trim + 2, x / 2 - 3, y - trim - 6)

    local lefttext = CreateDPanel(left, 0, 0, left:GetWide(), ScaleY(48))
    lefttext.Paint = function(me,w,h)
        RoundedBox( space, 0, 0, w , h, colors.body )

        SimpleText(bh_language["Accessory details"], "BHACC_FMedium", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local item = CreateDButton(left, 0, lefttext:GetTall() + 2, ScaleY(128), ScaleY(128))
    item.bh_acc_itemid = data.id
    local hoverlerp = color_transparent
    local starthoverlerp = CurTime()
    local dur = 0.75
    local item_trim = ScaleY(28)
    item.Paint = function(me,w,h)
        RoundedBoxEx(ScaleY(8), 0, 0, w, h - item_trim, colors.itembg, true, true, false, false)

        SetDrawColor(colors.body_transparent)
        DrawRect(0,h - item_trim,w,item_trim)

        if me.Hovered and hoverlerp ~= colors.hovercatoritem then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, colors.hovercatoritem)
        elseif not me.Hovered and hoverlerp ~= color_transparent then
            hoverlerp = LerpColor((CurTime() - starthoverlerp) / dur, hoverlerp, color_transparent)
        end

        RoundedBoxEx(ScaleY(8),0,0,w,h - item_trim,hoverlerp, true, true, false, false)

        SimpleText(data.name, "BHACC_ItemFont", w * 0.5, h - item_trim / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local function ChangeEnterLerp()
        starthoverlerp = CurTime()
    end
    item.OnCursorEntered = ChangeEnterLerp
    item.OnCursorExited = ChangeEnterLerp

    local stats = {
        {color_white, bh_language["Name:"] .. " " .. data.name},
        {color_white, bh_language["Price:"] .. " " .. self.FormatMoney(data.price), colors.currency_color, bh_language.Currency},
        {color_white, bh_language["Playermodel:"] .. " " .. tostring(data.IsPlayerModel and bh_language["Yes"] or bh_language["No"])}
    }

    local bg_for_stats = CreateDPanel(left, item:GetWide() + 2, lefttext:GetTall() + 2, left:GetWide() - item:GetWide() - 2, ScaleY(128))

    local statspace = 1
    local size = bg_for_stats:GetTall() / #stats - statspace / 2
    for k = 1, #stats do
        local v = stats[k]
        
        local p = CreateDPanel(bg_for_stats, 0, size * k - size + statspace * k - statspace, bg_for_stats:GetWide(), size)
        p.Paint = function(me,w,h)
            RoundedBox( space, 0, 0, w , h, colors.body )

            local plus = 0

            SetFont("BHACC_FSmall")
            
            local amt = #v
            for i = 1, amt do
                local o = v[i]
                
                if IsColor(o) then continue end

                local tw, th = GetTextSize(o)

                plus = plus + tw

                surface.SetTextColor(v[i-1])
                surface.SetTextPos(space + plus - tw, h / 2 - th / 2)
                surface.DrawText(o)
            end
        end
    end

    local modelpanel = CreateDModelPanel(item, 0, 0, item:GetWide(), item:GetTall() - item_trim, data)
    modelpanel:SetDrawOnTop(true)
    
    local itemx, itemy = item:GetPos()
    local leftmessage_title = CreateDPanel(left, itemx, itemy + item:GetTall() + 1, lefttext:GetWide(), lefttext:GetTall())
    leftmessage_title.Paint = function(me,w,h)
        RoundedBox( space, 0, 0, w , h, colors.body )

        SimpleText(bh_language["Message"], "BHACC_FMedium", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local enter_message = CreateBetterTextEntry(left, itemx, itemy + item:GetTall() + 1 + leftmessage_title:GetTall() + 1, lefttext:GetWide(), y - trim - 2 * 3 - item:GetTall() - leftmessage_title:GetTall() - lefttext:GetTall())
    local alltext = ""
    enter_message.BH_ACC_OnChangedText = function(newtext)
        alltext = newtext
    end
    local oldPaint = enter_message.Paint
    enter_message.Paint = function(me,w,h)
        oldPaint(me,w,h)

        if #alltext == 0 then
	        SimpleText(bh_language["Enter message"] .. "...", "BHACC_FMedium", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local amtleft = self.GiftMessageMaxLength - #alltext
        local col = colors.gray_text
        if amtleft < 0 then
            col = colors.exit
        end

        SimpleText(string.format(bh_language["Max_Text_GiftingMSG"], self.GiftMessageMaxLength - #alltext), "BHACC_FSmall", space, h - space * 3, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    local rightwide, righttall = x / 2 - 3, y - trim - 6
    local right = CreateDPanel(p, x - rightwide - 2, trim + 2, rightwide, righttall)
    right.Paint = function(me,w,h)
        RoundedBox(space, 0, ScaleY(50), w, h - ScaleY(100), colors.body)
    end

    local confirm = CreateDButton(right, 0, righttall - ScaleY(48), rightwide, ScaleY(48))
    confirm.Paint = function(me,w,h)
        RoundedBox( space, 0, 0, w , h, colors.confirm_color )
        
        if me.Hovered then
            RoundedBox( space, 0, 0, w , h, colors.hover)
        end

        SimpleText(bh_language["Confirm"],"BHACC_FMedium",w * 0.5,h * 0.5,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    confirm.DoClick = function(me,w,h)
        if test or data.id == -1 then bg:Remove() return end
        
        if not picked_player or not IsValid(player.GetBySteamID64(picked_player)) then
            self.RunNotification("Notify_Gift_NoPlayer")
            return
        end
        
        if #alltext > self.GiftMessageMaxLength then
            self.RunNotification("Notify_Gift_MsgTooBig")
            return
        end

        self.GiftItem(picked_player, data.id, alltext)
        
        bg:Remove()
    end

    local search_player = CreateTextEntry(right, 0, 0, rightwide, ScaleY(48))
	
    local function NewPaint(me,w,h)
        RoundedBox( space, 0, 0, w , h, colors.body )

        me:DrawTextEntryText(color_white, color_white, color_white)

        if #me:GetText() == 0 then
	        SimpleText(bh_language["Enter player name"] .. "...", "BHACC_FMedium", w * 0.5, h * 0.5, colors.gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    search_player.Paint = NewPaint
    
    local sw, sh = rightwide, righttall - search_player:GetTall() - space - ScaleY(48) - space
    local scroll = CreateDScrollPanel(right, 0, search_player:GetTall() + space, sw, sh)
    ScrollPaint(scroll)

    local picked_player = nil
    local function CreatePlayers(text)
        scroll:Clear()

        local plys = player.GetAll()
        local amt = #plys

        if text then
            text = text:lower():Trim()
            
            local reali = 0
            for _ = 1, amt do
                reali = reali + 1
                
                local v = plys[reali]

                if v == ply or v:IsBot() or not string_find(v:Nick():lower():Trim(), text)  then
                    table_remove(plys, reali)
                    
                    reali = reali - 1

                    amt = amt - 1
                end
            end
        else
            local reali = 0
            for _ = 1, amt do
                reali = reali + 1
                
                local v = plys[reali]

                if v == ply or v:IsBot() then
                    table_remove(plys, reali)
                    
                    reali = reali - 1

                    amt = amt - 1
                    
                    break
                end
            end
        end
    
        local ppw, pph = sw, sh / 10
        local avsize = pph - ScaleY(10)
        local avy = pph / 2 - avsize / 2
        local buttonspace = 2

        for k = 1, amt do
            local v = plys[k]

            local pp = CreateDButton(scroll, 0, pph * k - pph + buttonspace * k - buttonspace, ppw, pph)
            local name = v:Nick()
            local steamid64 = v:SteamID64()
            local function PlayerPanelPaint(me,w,h)
                RoundedBox( space, 0, 0, w , h, colors.body )
                
                if picked_player == steamid64 then
                    RoundedBox( space, 0, 0, w , h, colors.hovered_onplayer)
                end

                SimpleText(name, "BHACC_FMedium", ScaleY(7) + avsize, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            pp.Paint = PlayerPanelPaint
            pp.DoClick = function(me,w,h)
                if picked_player == steamid64 then
                    picked_player = nil
    
                    return
                end
    
                picked_player = steamid64
            end
    
            CreateAvatarImage(pp, space, avy, avsize, avsize, v)
        end
    end
    CreatePlayers()

    search_player.OnTextChanged = function()
        CreatePlayers(search_player:GetText() == "" and nil or search_player:GetText())
    end
end