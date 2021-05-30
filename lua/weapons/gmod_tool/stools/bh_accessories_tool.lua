TOOL.Category = "BH Accessories"
TOOL.Name = "NPC Spawner"
TOOL.Command = nil
TOOL.ConfigName =""
TOOL.LastFire = 0

if not CLIENT then return end

local CurTime = CurTime

TOOL.Information = {
    { name = "left" },
    { name = "right" },
    { name = "reload" },
}

language.Add("tool.bh_accessories_tool.name", BH_ACC.Language["Tool_Title"])
language.Add("tool.bh_accessories_tool.desc", BH_ACC.Language["Tool_Description"])
language.Add("tool.bh_accessories_tool.left", BH_ACC.Language["AddSpawn"])
language.Add("tool.bh_accessories_tool.right", BH_ACC.Language["DeleteSpawn"])
language.Add("tool.bh_accessories_tool.reload", BH_ACC.Language["DeleteAll"])

local minusang = Angle(0, 180, 0)
function TOOL:LeftClick(tr)
    if (CurTime() > self.LastFire) then
        local ply = LocalPlayer()

        if not BH_ACC.NPCToolUsergroups[BH_ACC.GetRank(ply)] then 
            chat.AddText(BH_ACC.ChatTagColors["error"], BH_ACC.ChatTag, color_white, " " .. BH_ACC.Language["NoAccessTool"])

            return false
        end
        
        BH_ACC:AddSpawn(tr.HitPos, ply:GetRenderAngles() - minusang)

        self.LastFire = CurTime() + 0.2
        return true
    end

    return false
end

local vec2 = Vector(18, 17, 15)
local vec3 = Vector(17, 18, 25)

function TOOL:RightClick(tr)
    if (CurTime() > self.LastFire) then
        local ply = LocalPlayer()

        if not BH_ACC.NPCToolUsergroups[BH_ACC.GetRank(ply)] then 
            chat.AddText(BH_ACC.ChatTagColors["error"], BH_ACC.ChatTag, color_white, " " .. BH_ACC.Language["NoAccessTool"])

            return false
        end
    
        local pos = tr.HitPos

        for i, v in ipairs(BH_ACC:GetSpawns()) do
            if not pos:WithinAABox(v.pos - vec2, v.pos + vec3) then continue end

            BH_ACC:DeleteSpawn(i)

            break
        end

        self.LastFire = CurTime() + 0.2

        return true
    end

    return false
end

function TOOL:Reload()
    if (CurTime() > self.LastFire) then
        local ply = LocalPlayer()

        if not BH_ACC.NPCToolUsergroups[BH_ACC.GetRank(ply)] then 
            chat.AddText(BH_ACC.ChatTagColors["error"], BH_ACC.ChatTag, color_white, " " .. BH_ACC.Language["NoAccessTool"])

            return false
        end

    
        if (#BH_ACC.Spawns > 0) then
            chat.AddText(BH_ACC.ChatTagColors["ok"], BH_ACC.ChatTag, color_white, " " .. string.format(BH_ACC.Language["DeleteAllTool"], #BH_ACC.Spawns))
            BH_ACC:DeleteAllSpawns()
        end

        self.LastFire = CurTime() + 0.2

        return true
    end

    return false
end

local RenderSpawns = false
local vec1, vec2, col1 = Vector(-18, -17, 0), Vector(17, 18, 20), Color(255, 0, 0, 200)
local SetColorMaterial = render.SetColorMaterial
local DrawBox = render.DrawBox
local function DrawSpawns()
    if not RenderSpawns then return end

    local t = BH_ACC:GetSpawns()
    for k = 1, #t do
        local v = t[k]
        
        SetColorMaterial()
        DrawBox(v.pos, v.ang or angle_zero, vec1, vec2, col1)
    end
end
hook.Add("PostDrawTranslucentRenderables", "BH_ACC_SpawnPoints", DrawSpawns)

function TOOL:Think()
    if not self.Requested then
        self.Requested = true

        net.Start("BH_ACC_SP_Req")
        net.SendToServer()
    end

    RenderSpawns = true
end

function TOOL:Holster()
    RenderSpawns = false
end