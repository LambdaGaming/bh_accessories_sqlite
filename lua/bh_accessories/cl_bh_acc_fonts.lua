local SCF = surface.CreateFont
local function CreateFonts()
    local scale = ScrH() / 1080

    function BH_ACC.ScaleY(val)
        return scale * val
    end
    local ScaleY = BH_ACC.ScaleY

    local font = BH_ACC.Font

	SCF( "BHACC_FontLeftTitle", { font = font, size = ScaleY(30), weight = 800 } )

	SCF( "BHACC_CategoryTitle", { font = font, size = ScaleY(20), weight = 800 } )

	SCF( "BHACC_ItemFont", { font = font, size = ScaleY(20), weight = 800 } )

    SCF( "BHACC_ItemFontComboBox", { font = font, size = ScaleY(22), weight = 800 } )

    SCF( "BHACC_ItemFontToolTip", { font = font, size = ScaleY(28), weight = 800 } )

    SCF( "BHACC_ItemFontOverlay", { font = font, size = ScaleY(35), weight = 800 } )

	SCF( "BHACC_DescriptionFont", { font = font, size = ScaleY(20), weight = 800 } )

	SCF( "BHACC_PriceFont", { font = font, size = ScaleY(22), weight = 800 } )

	SCF( "BHACC_EquippableFont", { font = font, size = ScaleY(20), weight = 800 } )

	SCF( "BHACC_DropBoxNameFont", { font = font, size = ScaleY(20), weight = 700 } )

	SCF( "BHACC_HelpArrowFont", { font = font, size = ScaleY(40), weight = 700 } )

	SCF( "BHACC_PositionCategory", { font = font, size = ScaleY(25), weight = 700 } )

	SCF( "BHACC_PositionTitle", { font = font, size = ScaleY(29), weight = 900 } )

	SCF( "BHACC_PositionDesc", { font = font, size = ScaleY(22), weight = 550 } )

	SCF( "BHACC_PositionPRS", { font = font, size = ScaleY(22), weight = 550 } )

	SCF( "BHACC_PositionBoneModel", { font = font, size = ScaleY(29), weight = 550 } )

    SCF( "BHACC_VendorTextFont", { font = BH_ACC.NPC_Font, size = ScaleY(200), weight = 800 } )

    SCF( "BHACC_FSmall", { font = font, size = ScaleY(20), weight = 700 } )
    SCF( "BHACC_FSmallMed", { font = font, size = ScaleY(25), weight = 700 } )
    SCF( "BHACC_FMedium", { font = font, size = ScaleY(30), weight = 700 } )
    SCF( "BHACC_FLarge", { font = font, size = ScaleY(35), weight = 700 } )

    hook.Run("BH_ACC_FontsLoaded")
end
hook.Add("OnScreenSizeChanged", "BH_ACC_UpdateFonts", CreateFonts)
CreateFonts()
hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/cl_bh_acc_fonts", function(filename)
    if filename == "bh_acc_config" then
        CreateFonts()
    end
end)

local tostring = tostring

local GetTextSize = surface.GetTextSize
local SetFont = surface.SetFont

local string_sub = string.sub
local string_gsub = string.gsub
local string_find = string.find

local math_Round = math.Round
local math_abs = math.abs

function BH_ACC.FormatMoney(n)
    local negative = n < 0

    n = tostring(math_abs(n))
    local dp = string_find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = string_sub(n, 1, i) .. "," .. string_sub(n, i + 1)
    end

    -- Make sure the amount is padded with zeroes
    if n[#n - 1] == "." then
        n = n .. "0"
    end

    return (negative and "-" or "") .. n
end

function BH_ACC.LerpText(mul, text)
    return string_sub(text, 1, math_Round(#text * mul))
end

local function charWrap(text, pxWidth)
	local total = 0

    local function gsubFunc(char)
		total = total + GetTextSize(char)
		if total >= pxWidth then
			total = 0
			return "\n" .. char
		end

		return char
    end
	text = string_gsub(text, ".", gsubFunc)

	return text, total
end

function BH_ACC.TextWrap(text, font, pxWidth)
	local total = 0

	SetFont(font)

	local spaceSize = GetTextSize(' ')
    local function gsubFunc(word)
		local char = string_sub(word, 1, 1)
		if char == "\n" or char == "\t" then
			total = 0
		end

		local wordlen = GetTextSize(word)
		total = total + wordlen
		if wordlen >= pxWidth then
			local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
			total = splitPoint
			return splitWord
		elseif total < pxWidth then
			return word
		end
		if char == ' ' then
			total = wordlen - spaceSize
			return '\n' .. string_sub(word, 2)
		end

		total = wordlen
		return '\n' .. word
    end
	text = string_gsub(text, "(%s?[%S]+)", gsubFunc)

	return text
end

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "cl_bh_acc_fonts")
end