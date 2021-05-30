local color_white = color_white

local SetDrawColor = surface.SetDrawColor
local RoundedBox = draw.RoundedBox
local DrawText = draw.DrawText
local SetMaterial = surface.SetMaterial
local DrawTexturedRect = surface.DrawTexturedRect

local materials = BH_ACC.Materials
local colors = BH_ACC.Colors

local CreateEditorItemPanel = BH_ACC.CreateEditorItemPanel
local CreateDButton = BH_ACC.CreateDButton
local ChangeSelected = BH_ACC.ChangeSelected
local RemovePanel = BH_ACC.RemovePanel
local GetItemData = BH_ACC.GetItemData

local coroutine_create = coroutine.create
local coroutine_yield = coroutine.yield
local coroutine_resume = coroutine.resume

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/items", function(filename)
    if filename == "bh_acc_config" then
        materials = BH_ACC.Materials
        colors = BH_ACC.Colors
    elseif filename == "cl_bh_acc_ui" then
        CreateEditorItemPanel = BH_ACC.CreateEditorItemPanel
        CreateDButton = BH_ACC.CreateDButton
        RemovePanel = BH_ACC.RemovePanel
    elseif filename == "cl_bh_acc_view" then
        ChangeSelected = BH_ACC.ChangeSelected
    elseif filename == "sh_bh_acc" then
        GetItemData = BH_ACC.GetItemData
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/items", function()
    ScaleY = BH_ACC.ScaleY
end)

-- Here's what we use to position the main category panels --
-- Why is there so much math? Because we need to reposition other categories above the others if there's more than 4 ( centered ) --
local math_floor = math.floor
local math_ceil = math.ceil
local function PositionCategories(panels, itemw, itemh)
    local amt_panels = #panels

    local space = 2 -- Space inbetween the items --
    local width_itembg = itemw * 4 + space * 4 -- The background panel widght
    local optsize = ScaleY(100) -- Main category size --

    local gridHeight = math_ceil( amt_panels / 4 ) - 1
    local row_btncount = amt_panels > 4 and 4 or amt_panels -- The amount of items in a row calculated per row --
    
    for i = 0, amt_panels - 1 do
        local y = gridHeight - math_floor( i / 4 )
        local optx = i % 4

        -- Now position all categories accordingly --
        panels[i + 1]:SetPos( optx * optsize + optx * space + ( width_itembg - optsize * row_btncount - space * ( row_btncount - 1 ) ) / 2, y * optsize + y * space)
    end
end

-- Here's where we show the items or sub-categories --
-- Sub categories if there is any, if not then show all the items for that category --
function BH_ACC:CreateBottomFirstItems(cat)
    local bottom = self.bh_acc_options_bottom

    bottom:Clear()
    self.bh_acc_loaditems_co = nil

    local ply = LocalPlayer()
    
    local x, y =  bottom:GetSize()

    local trim = ScaleY(28)
    local iconsizebig = ScaleY(100)

    local allitems = cat.allitems
    local minicats = cat.Mini_Categories

    local amount_all = 0
    if minicats then
        amount_all = amount_all + #minicats

        if #allitems > 0 then
            amount_all = amount_all + 1
        end
    else
        amount_all = #allitems
    end

    local scrollsize = 3.5 -- Why do we need scrollsize here? Because we check if all of the items together extend the menu so we decrease the size of the items to fit with the scrollbar
    local space = 2
    local maxwidth = x - 15 - space -- The max width of the menu which is ( x ( bottom:GetWide() ) - 15 ( constant value of scrollbar size from gmod ) - space ( just space ) )

    local mcw, mch = x / 4 - space, y / 5 - space + 0.5
    local itemw, itemh = x / 4 - space, y / 5 - space + 0.5
    if amount_all > 20 then
        mcw = mcw - scrollsize
        itemw = itemw - scrollsize
    end

    PositionCategories(self.bh_acc_options.panels, itemw, itemh)

    -- Here we check for any sub categories so we can then show them --
    -- If there's none then we just show all the items --
    if minicats then
        local amt_minicats = #minicats

        local x, y = 0, 0
        for i = 1, amt_minicats do
            local data = self.MiniCategories[minicats[i]]
            local mc = self:CreateSubCategoryPanel(bottom, x, y, mcw, mch, data, cat)
            local old = mc.DoClick
            local function mcDoClick()
                old()

                ChangeSelected(self, data.name)
            end
            mc.DoClick = mcDoClick

            x = x + mcw + space
            if x > maxwidth then
                x = 0
                y = y + mch + space
            end
        end

        if #allitems > 0 then
            if x >= maxwidth then
                x = 0
                y = y + mch + space
            end
            
            self:CreateSubCategoryPanel(bottom, x, y, mcw, mch, nil, cat, true)
        end
    else
        if not allitems[1] then return end

        self:CreateUnequipPanel(bottom, 0, 0, itemw, itemh, self.Categories[self.Category_IDS[GetItemData(allitems[1]).category]].name)
        
        -- Since we don't have sub categories we will do x = itemw + space because of the unequip panel we have added
        local x = itemw + space
        local y = 0

        local function LoadAllItems()
            for i = 1, #allitems do
                local data = GetItemData(allitems[i])

                if data.disabled then continue end

                self:CreateItemPanel(data, bottom, x, y, itemw, itemh)

                coroutine_yield()

                x = x + itemw + space
                if x > maxwidth then
                    x = 0
                    y = y + itemh + space
                end
            end
        end
        self.bh_acc_loaditems_co = coroutine_create(LoadAllItems)
    end
end

-- Here's where we show the items when clicking on a sub-category --
function BH_ACC:CreateBottomMiniCatItems(items, cat)
    items = items or {}

    local bottom = self.bh_acc_options_bottom

    bottom:Clear()
    self.bh_acc_loaditems_co = nil
    
    local ply = LocalPlayer()
    local x, y =  bottom:GetSize()
    local category = cat.name

    local bottomx, bottomy = bottom:GetPos()

    local gobackw, gobackh = ScaleY(44), ScaleY(44)
    self.bh_acc_minigoback = CreateDButton(self.bh_acc_menu, bottomx + x - gobackw / 2, bottomy - gobackh / 2, gobackw, gobackh)
    local p = self.bh_acc_minigoback
    local iconsize = ScaleY(32)
    p.Paint = function(me,w,h)
        RoundedBox(h / 2,0,0,w,h,colors.circle_button)

        if materials.back then
            SetDrawColor(color_white)
            SetMaterial(materials.back)
            DrawTexturedRect(w / 2 - iconsize / 2 - 2, h / 2 - iconsize / 2 - 2, iconsize, iconsize)
        end
    end
    p.DoClick = function()
        p:Remove()
        
        self:CreateBottomFirstItems(cat)
        
        ChangeSelected(self, cat.name)
    end

    bottom.OnRemove = function()
        RemovePanel(p)
    end

    local amt_items = #items

    if amt_items <= 0 then return end

    local scrollsize = 3.5 -- Why do we need scrollsize here? Because we check if all of the items together extend the menu so we decrease the size of the items to fit with the scrollbar
    local space = 2
    local maxwidth = x - 15 - space -- The max width of the menu which is ( x ( bottom:GetWide() ) - 15 ( constant value of scrollbar size from gmod ) - space ( just space ) )

    local itemw, itemh = x / 4 - space, y / 5 - space + 0.5
    if amt_items + 1 > 20 then
        itemw = itemw - scrollsize
    end

    PositionCategories(self.bh_acc_options.panels, itemw, itemh)
    
    self:CreateUnequipPanel(bottom, 0, 0, itemw, itemh, category)

    local reali = 0

    local x = itemw + space
    local y = 0

    local function LoadAllItems()
        for i = 1, amt_items do
            local data = GetItemData(items[i])
            
            if data.disabled then continue end

            self:CreateItemPanel(data, bottom, x, y, itemw, itemh)
            
            coroutine_yield()

            x = x + itemw + space
            if x > maxwidth then
                x = 0
                y = y + itemh + space
            end
        end
    end
    self.bh_acc_loaditems_co = coroutine_create(LoadAllItems)
end

-- Here's where we show the items or sub-categories for the editor --
-- Sub categories if there is any, if not then show all the items for that category --
function BH_ACC:CreateBottomEditorFirstItems(cat)
    local bottom = self.bh_acc_eoptions_bottom

    bottom:Clear()
    self.bh_acc_loaditems_co = nil

    local ply = LocalPlayer()
    
    local x, y =  bottom:GetSize()

    local trim = ScaleY(28)
    local iconsizebig = ScaleY(100)

    local allitems = cat.allitems
    local minicats = cat.Mini_Categories

    local amount_all = 0
    if minicats then
        amount_all = amount_all + #minicats

        if #allitems > 0 then
            amount_all = amount_all + 1
        end
    else
        amount_all = #allitems
    end

    local scrollsize = 3.5 -- Why do we need scrollsize here? Because we check if all of the items together extend the menu so we decrease the size of the items to fit with the scrollbar
    local space = 2
    local maxwidth = x - 15 - space -- The max width of the menu which is ( x ( bottom:GetWide() ) - 15 ( constant value of scrollbar size from gmod ) - space ( just space ) )

    local mcw, mch = x / 4 - space, y / 5 - space + 0.5
    local itemw, itemh = x / 4 - space, y / 5 - space + 0.5
    if amount_all > 20 then -- Let's check if the items exceed 20 ( We do this because if there's a scrollbar we want to decrease the width of items to fit the UI better )
        mcw = mcw - scrollsize
        itemw = itemw - scrollsize
    end
    
    PositionCategories(self.bh_acc_eoptions.panels, itemw, itemh)
    
    -- Here we check for any sub categories so we can then show them --
    -- If there's none then we just show all the items --
    if minicats then
        local x, y = 0, 0
    
        for i = 1, #minicats do
            local data = self.MiniCategories[minicats[i]]
            local mc = self:CreateSubCategoryPanel(bottom, x, y, mcw, mch, data, cat, false, true)
            local old = mc.DoClick
            local function mcDoClick()
                old()

                ChangeSelected(self, data.name)
            end
            mc.DoClick = mcDoClick

            x = x + mcw + space
            if x > maxwidth then
                x = 0
                y = y + mch + space
            end
        end

        if #allitems > 0 then
            if x > maxwidth then
                x = 0
                y = y + mch + space
            end

            self:CreateSubCategoryPanel(bottom, x, y, mcw, mch, data, cat, true, true)
        end
    else
        local x, y = 0, 0
        x = x + itemw + space
        if x > maxwidth then
            x = 0
            y = y + itemh + space
        end

        self:CreateMakeNewPanel(bottom, 0, 0, itemw, itemh, cat.name)
        
        if not allitems[1] then return end

        local category = self.Categories[self.Category_IDS[GetItemData(allitems[1]).category]]

        local function LoadAllItems()
            for i = 1, #allitems do
                local data = GetItemData(allitems[i])

                if data.disabled then continue end

                CreateEditorItemPanel(self, data, bottom, x, y, itemw, itemh)

                coroutine_yield()

                x = x + itemw + space
                if x > maxwidth then
                    x = 0
                    y = y + itemh + space
                end
            end
        end
        self.bh_acc_loaditems_co = coroutine_create(LoadAllItems)
    end
end

-- Here's where we show the items when clicking on a sub-category for the editor --
function BH_ACC:CreateBottomEditorMiniCatItems(items, cat)
    items = items or {}

    local bottom = self.bh_acc_eoptions_bottom

    bottom:Clear()
    self.bh_acc_loaditems_co = nil
    
    local ply = LocalPlayer()
    local x, y =  bottom:GetSize()

    local bottomx, bottomy = bottom:GetPos()

    local gobackw, gobackh = ScaleY(44), ScaleY(44)
    local iconsize = ScaleY(32)

    self.bh_acc_minigoback = CreateDButton(self.bh_acc_menu, bottomx + x - gobackw / 2, bottomy, gobackw, gobackh)
    local p = self.bh_acc_minigoback
    local function GoBackPaint(me,w,h)
        RoundedBox(h / 2,0,0,w,h,colors.circle_button)

        if materials.back then
            SetDrawColor(color_white)
            SetMaterial(materials.back)
            DrawTexturedRect(w / 2 - iconsize / 2 - 2, h / 2 - iconsize / 2 - 2, iconsize, iconsize)
        end
    end
    p.Paint = GoBackPaint

    local function GoBackDoClick()
        p:Remove()
        
        self:CreateBottomEditorFirstItems(cat)

        ChangeSelected(self, cat.name)
    end
    p.DoClick = GoBackDoClick

    local function RemoveGoBack()
        RemovePanel(p)
    end
    bottom.OnRemove = RemoveGoBack

    local amt_items = #items

    if amt_items <= 0 then return end

    local scrollsize = 3.5 -- Why do we need scrollsize here? Because we check if all of the items together extend the menu so we decrease the size of the items to fit with the scrollbar
    local space = 2
    local maxwidth = x - 15 - space -- The max width of the menu which is ( x ( bottom:GetWide() ) - 15 ( constant value of scrollbar size from gmod ) - space ( just space ) )

    local itemw, itemh = x / 4 - space, y / 5 - space + 0.5
    if amt_items + 1 > 20 then
        itemw = itemw - scrollsize
    end
    
    PositionCategories(self.bh_acc_eoptions.panels, itemw, itemh)

    local x, y = 0, 0
    x = x + itemw + space
    if x > maxwidth then
        x = 0
        y = y + itemh + space
    end

    self:CreateMakeNewPanel(bottom, 0, 0, itemw, itemh, cat.name, GetItemData(items[1]).mini_category)

    local function LoadAllItems()
        for i = 1, amt_items do
            local data = GetItemData(items[i])
            
            if data.disabled then continue end

            CreateEditorItemPanel(self, data, bottom, x, y, itemw, itemh)

            coroutine_yield()

            x = x + itemw + space
            if x > maxwidth then
                x = 0
                y = y + itemh + space
            end
        end
    end
    self.bh_acc_loaditems_co = coroutine_create(LoadAllItems)
end

-- Here's our coroutine working every tick for loading dmodelpanels without any freezing at all --
local function ThinkRemoveCoroutine()
    local co = BH_ACC.bh_acc_loaditems_co
    if not co then return end
    coroutine_resume(co)
end
hook.Add("Think", "BH_ACC_Coroutine_Think", ThinkRemoveCoroutine)