local RoundedBox = draw.RoundedBox
local RoundedBoxEx = draw.RoundedBoxEx
local DrawText = draw.DrawText

local CreateDPanel = BH_ACC.CreateDPanel
local CreateDButton = BH_ACC.CreateDButton
local CreateDScrollPanel = BH_ACC.CreateDScrollPanel
local ScrollPaint = BH_ACC.ScrollPaint
local CreateMainCategoryPanel = BH_ACC.CreateMainCategoryPanel
local RemovePanel = BH_ACC.RemovePanel

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/menus/main_categories", function(filename)
    if filename == "cl_bh_acc_ui" then
        CreateDPanel = BH_ACC.CreateDPanel
        CreateDButton = BH_ACC.CreateDButton
        CreateDScrollPanel = BH_ACC.CreateDScrollPanel
        ScrollPaint = BH_ACC.ScrollPaint
        CreateMainCategoryPanel = BH_ACC.CreateMainCategoryPanel
        RemovePanel = BH_ACC.RemovePanel
    end
end)

local ScaleY = BH_ACC.ScaleY
hook.Add("BH_ACC_FontsLoaded", "BH_ACC_ChangeScaleY/menu/main_categories", function()
    ScaleY = BH_ACC.ScaleY
end)

local math_max = math.max
local math_ceil = math.ceil

function BH_ACC:OpenOptions()
    RemovePanel(self.bh_acc_options)

    local ply = LocalPlayer()
    local scrh = ScrH()

    local cats = self.Categories
    local amt_cats = #cats

    local optw, opth = ScaleY(100), ScaleY(100)
    local space = 2
    
    local ymath = math_max(math_ceil(amt_cats / 4), 1)
    local x, y = optw * 5 + space * 5, ymath * opth + ymath * space -- Here we define the size of the background of the categories
    local lefth = scrh * 0.75 -- This is the size of the left panel which has the accessory, help, positioner and editor tabs
    local mx, my = ScaleY(280), scrh / 2 - lefth / 2 -- This is going to be the position of the options bg ( space + ScaleY(25 -- x of left panel ) + ScaleY(250 - leftw), center )
    self.bh_acc_options = CreateDPanel(self.bh_acc_menu, mx, my - ymath * opth + opth, x, y)
    local m = self.bh_acc_options
    m.panels = {}
    
    local panels = m.panels
    for i = 1, amt_cats do
        -- We don't need to set the position of the panels here ( see items.lua for positioning them ) --
        -- Because we are going to make sure it's all perfectly aligned when items have different width and height while showing or not showing the scrollbar --
        panels[i] = CreateMainCategoryPanel(self, m, 0, 0, optw, opth, cats[i])
    end

    self.bh_acc_options_bottom = CreateDScrollPanel(self.bh_acc_menu, mx, my + opth + space, x - space, lefth - opth - space)
	ScrollPaint(self.bh_acc_options_bottom)
    
    self:CreateBottomFirstItems(cats[1])
end

function BH_ACC:EditorOptions()
    RemovePanel(self.bh_acc_eoptions)

    local ply = LocalPlayer()
    local scrh = ScrH()

    local cats = self.Categories
    local amt_cats = #cats

    local optw, opth = ScaleY(100), ScaleY(100)
    local space = 2

    local ymath = math_max(math_ceil(amt_cats / 4), 1)
    local x, y = optw * 5 + space * 5, ymath * opth + ymath * space -- Here we define the size of the background of the categories
    local lefth = scrh * 0.75 -- This is the size of the left panel which has the accessory, help, positioner and editor tabs
    local mx, my = ScaleY(280), scrh / 2 - lefth / 2 -- This is going to be the position of the options bg ( space + ScaleY(25 -- space for leftw ) + ScaleY(250 - leftw), center )
    self.bh_acc_eoptions = CreateDPanel(self.bh_acc_menu, mx, my - ymath * opth + opth, x, y)
    local m = self.bh_acc_eoptions
    m.panels = {}

    local panels = m.panels
    for i = 1, amt_cats do
        -- We don't need to set the position of the panels here ( see items.lua for positioning them ) --
        -- Because we are going to make sure it's all perfectly aligned when items have different width and height while showing or not showing the scrollbar --
        panels[i] = CreateMainCategoryPanel(self, m, 0, 0, optw, opth, cats[i], true)
    end

    self.bh_acc_eoptions_bottom = CreateDScrollPanel(self.bh_acc_menu, mx, my + opth + space, x - space, lefth - opth - space)
    ScrollPaint(self.bh_acc_eoptions_bottom)

    self:CreateBottomEditorFirstItems(cats[1])
end