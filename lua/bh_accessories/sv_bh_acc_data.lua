local string_format = string.format
local MsgC = MsgC
local tostring = tostring

local _P = FindMetaTable("Player")
local SteamID64 = _P.SteamID64
require("mysqloo")

local t = BH_ACC.MySQLOO
local db = mysqloo.connect(t.Host, t.Username, t.Password, t.Database, t.Port)

local GetItemData = BH_ACC.GetItemData
local GetItemIDByName = BH_ACC.GetItemIDByName

hook.Add("BH_ACC_LoadedFile", "BH_ACC_Update/sv_bh_acc_data", function(filename)
    if filename == "bh_acc_sql_config" then
        t = BH_ACC.MySQLOO

        if db:status() == mysqloo.DATABASE_CONNECTED then
            db:disconnect(true)

            db = mysqloo.connect(t.Host, t.Username, t.Password, t.Database, t.Port)
        end
    elseif filename == "sh_bh_acc" then
        GetItemData = BH_ACC.GetItemData
        GetItemIDByName = BH_ACC.GetItemIDByName
    end
end)

local function dbprint(message, color)
	MsgC( color or BH_ACC.ChatTagColors["ok"], BH_ACC.ChatTagMySQL, color_white, " " .. message .. "\n")
end

function BH_ACC.Query(query, callback, debug)
	local newQuery = db:query(query)

	if debug then
		local function onsucc(q, d)
			dbprint("Successful Query: " .. query)

			if callback then
				callback(q,d)
			end 
		end
		newQuery.onSuccess = onsucc

		local function onfail(db, error)
			dbprint("Failed Query: " .. query .. " | " .. error, BH_ACC.ChatTagColors["error"])
		end

		newQuery.onError = onfail
	else
		local function onsucc(q, d)
			if callback then
				callback(q,d)
			end 
		end
		newQuery.onSuccess = onsucc
	end

	newQuery:start()
	
	return newQuery
end
local Query = BH_ACC.Query

function BH_ACC.DBEscape(q, quotes)
    local qs = tostring(q)

	if quotes then
		return db:escape(qs)
	else
		return string_format("'%s'", db:escape(qs))
	end
end
local DBEscape = BH_ACC.DBEscape

local function Connect_To_DB()
	dbprint("Attemping to connect to the database.")

    local function onConnected()
		hook.Run("BH_ACC_DBConnected")
		
		dbprint("Connected to the database successfully.")

		Query([[
			CREATE TABLE IF NOT EXISTS `bh_accessories_owned` (
				`steamid` VARCHAR(32) NOT NULL,
				`name` VARCHAR(255) NOT NULL,
				PRIMARY KEY(`steamid`, `name`)
			)
		]])

		Query([[
			CREATE TABLE IF NOT EXISTS `bh_accessories_equipped` (
				`steamid` VARCHAR(32) NOT NULL,
				`name` VARCHAR(255) NOT NULL,
				PRIMARY KEY(`steamid`, `name`)
			)
		]])

		Query([[
			CREATE TABLE IF NOT EXISTS `bh_accessories_adjusted` (
				`steamid` VARCHAR(32) NOT NULL,
				`model` VARCHAR(255) NOT NULL,
				`vx` FLOAT NOT NULL,
				`vy` FLOAT NOT NULL,
				`vz` FLOAT NOT NULL,
				`ap` FLOAT NOT NULL,
				`ay` FLOAT NOT NULL,
				`ar` FLOAT NOT NULL,
				`sx` FLOAT NOT NULL,
				`sy` FLOAT NOT NULL,
				`sz` FLOAT NOT NULL,
				PRIMARY KEY(`steamid`, `model`)
			)
		]])

		Query([[
			CREATE TABLE IF NOT EXISTS `bh_accessories_pmdl_adjusted` (
				`model` VARCHAR(255) NOT NULL,
				`bone` VARCHAR(255) NOT NULL,
				`vx` FLOAT NOT NULL,
				`vy` FLOAT NOT NULL,
				`vz` FLOAT NOT NULL,
				`ap` FLOAT NOT NULL,
				`ay` FLOAT NOT NULL,
				`ar` FLOAT NOT NULL,
				`sx` FLOAT NOT NULL,
				`sy` FLOAT NOT NULL,
				`sz` FLOAT NOT NULL,
				PRIMARY KEY(`model`, `bone`)
			)
		]])

		Query([[
			CREATE TABLE IF NOT EXISTS `bh_accessories_editor` (
				`name` VARCHAR(255) UNIQUE NOT NULL,
				`disabled` BOOL,
				`description` TEXT,
				`model` TINYTEXT NOT NULL,
				`price` INT UNSIGNED,
				`bone` TEXT,
				`material` TINYTEXT,
				`skin` TINYINT UNSIGNED,
				`r` FLOAT, `g` FLOAT, `b` FLOAT,
				`user` TEXT,
				`IsPlayerModel` BOOL,
				`vx` FLOAT, `vy` FLOAT, `vz` FLOAT,
				`ap` FLOAT, `ay` FLOAT, `ar` FLOAT,
				`sx` FLOAT, `sy` FLOAT, `sz` FLOAT,
				`uivx` FLOAT, `uivy` FLOAT, `uivz` FLOAT,
				`uiap` FLOAT, `uiay` FLOAT, `uiar` FLOAT,
				`ui_FOV` FLOAT,
				`ui_Simple` BOOL,
				`category` TINYTEXT NOT NULL,
				`mini_category` TINYTEXT,
				PRIMARY KEY(`name`)
			)
		]])

		if not BH_ACC.AddedModelOffsets then
			local function pmdlquery(q, data)
				BH_ACC.AddedModelOffsets = {}
				BH_ACC.AddedModelOffsets_IDS = {}

				local mdloffsets = BH_ACC.AddedModelOffsets
				local ids = BH_ACC.AddedModelOffsets_IDS

				for k,v in ipairs(data) do
					local model = v.model
					if ids[model] then
						local mdlt = mdloffsets[ids[model]]
						local offsets = mdlt.offsets

						local key = #offsets + 1
						offsets[key] = {
							bone = v.bone,
							pos = Vector(v.vx, v.vy, v.vz),
							ang = Angle(v.ap, v.ay, v.ar),
							scale = Vector(v.sx, v.sy, v.sz)
						}
						mdlt.offset_ids[v.bone] = key
					else
						local key = #mdloffsets + 1

						mdloffsets[#mdloffsets + 1] = {
							model = model,
							offsets = {
								{
									bone = v.bone,
									pos = Vector(v.vx, v.vy, v.vz),
									ang = Angle(v.ap, v.ay, v.ar),
									scale = Vector(v.sx, v.sy, v.sz)
								}
							},
							offset_ids = {
								[v.bone] = 1,
							}
						}
						ids[model] = key
					end
				end
			end
			Query("SELECT * FROM `bh_accessories_pmdl_adjusted`", pmdlquery)
		end

		if not BH_ACC.EditedAccessories then
			BH_ACC.EditedAccessories = {}
			local edited_acc = BH_ACC.EditedAccessories

			local tobool = tobool
			local util_JSONToTable = util.JSONToTable
			local Vector = Vector
			local Angle = Angle

			local function query(q, data)
				local reali = 0

				for i = 1, #data do
					local o = data[i] 
					
					reali = reali + 1
					if tobool(o.disabled) and not BH_ACC.GetItemIDByName(o.name) then
						reali = reali - 1
						continue
					end

					edited_acc[reali] = {
						name = o.name,
						description = o.desc,
						model = o.model,
						price = o.price,
						bone = o.bone,
						material = o.material,
						skin = o.skin,
						user = o.user and util_JSONToTable(o.user),
						IsPlayerModel = tobool(o.IsPlayerModel),
						offsetV = (o.vx and Vector(o.vx, o.vy, o.vz)),
						offsetA = (o.ap and Angle(o.ap, o.ay, o.ar)),
						scale = (o.sx and Vector(o.sx, o.sy, o.sz)),
						ui_CamPos = (o.uivx and Vector(o.uivx, o.uivy, o.uivz)),
						ui_LookAng = (o.uiap and Angle(o.uiap, o.uiay, o.uiar)),
						ui_FOV = o.ui_FOV,
						ui_Simple = tobool(o.ui_Simple),
						category = o.category,
						mini_category = o.mini_category,
						disabled = tobool(o.disabled)
					}

					local t = edited_acc[reali]

					local olddata = BH_ACC.GetItemDataByName(t.name)
		
					if olddata then
						t.id = olddata.id
			
						BH_ACC.EditorSaveUpdateItemData(olddata.id, t)
					else
						t.id = BH_ACC.GetItemCount() + 1
						
						BH_ACC.EditorCreateUpdateItemData(t)
					end
				end
			end
			local cats = BH_ACC.Categories
			local text = "`category` = " .. DBEscape(cats[1].name)
			for i = 2, #cats do
				text = text .. " OR `category` = " .. DBEscape(cats[i].name)
			end
            
            text = text .. " AND "

			local minicats = BH_ACC.MiniCategories
            text = text .. "ISNULL(`mini_category`) OR "
			text = text .. "`mini_category` = " .. DBEscape(minicats[1].name)
			for i = 2, #minicats do
				text = text .. " OR `mini_category` = " .. DBEscape(minicats[i].name)
			end

			Query("SELECT * FROM `bh_accessories_editor` WHERE " .. text, query)
		end
    end
	db.onConnected = onConnected

    local function onConnectionFailed(db, msg)
		db("Failed to connect to the database.")
		dbprint(msg)
    end
	db.onConnectionFailed = onConnectionFailed
    
	db:connect()
end
Connect_To_DB()

local function CheckConnection()
	if db:status() ~= mysqloo.DATABASE_CONNECTED then
		dbprint("Database connection invalid reconnecting.")
		Connect_To_DB()
	end
end
timer.Create("BH_ACC_Check_Connection", 5, 0, CheckConnection)

local _P = FindMetaTable("Player")
local SteamID64 = _P.SteamID64

local ipairs = ipairs

local function LoadPlayerAccessories(ply)
	ply.BH_ACC_delay = CurTime()
	
	ply.bh_acc_owned = {}
	ply.bh_acc_owned_lookup = {}
	ply.bh_acc_equipped = {}
	ply.bh_acc_equipped_lookup = {}
	ply.bh_acc_adjustments = {}
	ply.bh_acc_adjustments_lookup = {}
	
	local owned = ply.bh_acc_owned
	local owned_lookup = ply.bh_acc_owned_lookup
	
	local equipped = ply.bh_acc_equipped
	local equipped_lookup = ply.bh_acc_equipped_lookup

	local adjustments = ply.bh_acc_adjustments
	local adjustments_lookup = ply.bh_acc_adjustments_lookup

	local esc_sid = DBEscape(SteamID64(ply))

	local function query1(q, data)
		local reali = 0
		for _, v in ipairs(data) do
			reali = reali + 1
			
			local id = GetItemIDByName(v.name)
			
			if not id then
				reali = reali - 1
				continue
			end

			owned[reali] = id
			owned_lookup[id] = reali
		end
	end
	Query("SELECT `name` FROM `bh_accessories_owned` WHERE `steamid` = " .. esc_sid, query1)

	local function query2(q, data)
		local reali = 0
		for _, v in ipairs(data) do
			reali = reali + 1
			
			local id = GetItemIDByName(v.name)
			
			if not id then
				reali = reali - 1

				continue
			end

			equipped[reali] = id
			equipped_lookup[id] = reali
		end
	end
	Query("SELECT `name` FROM `bh_accessories_equipped` WHERE `steamid` = " .. esc_sid, query2)
	
	if BH_ACC.PositionerSaveToDB then
		local function query3(q, data)
			for k,v in ipairs(data) do
				adjustments[v.model] = {
					pos = {v.vx, v.vy, v.vz},
					ang = {v.ap, v.ay, v.ar},
					scale = {v.sx, v.sy, v.sz}
				}

				adjustments_lookup[k] = v.model
			end
		end
		Query("SELECT `model`, `vx`, `vy`, `vz`, `ap`, `ay`, `ar`, `sx`, `sy`, `sz` FROM `bh_accessories_adjusted` WHERE `steamid` = " .. esc_sid, query3)
	end
end
hook.Add("PlayerAuthed", "BH_ACC_LoadAccessories", LoadPlayerAccessories)

function BH_ACC.SavePlayerAccessory(ply, id)
	Query("INSERT INTO `bh_accessories_owned` (`steamid`, `name`) VALUES (" .. DBEscape(SteamID64(ply)) .. ", " .. DBEscape(GetItemData(id).name) .. ")" )
end

function BH_ACC.DeletePlayerAccessory(ply, id)
	Query("DELETE FROM `bh_accessories_owned` WHERE `steamid` = " .. DBEscape(SteamID64(ply)) .. " AND `name` = " .. DBEscape(GetItemData(id).name))
end

function BH_ACC.SaveEquippedAccessory(ply, id)
	Query("INSERT INTO `bh_accessories_equipped` (`steamid`, `name`) VALUES (" .. DBEscape(SteamID64(ply)) .. ", " .. DBEscape(GetItemData(id).name) .. ")" )
end

function BH_ACC.DeleteEquippedAccessory(ply, id)
	Query("DELETE FROM `bh_accessories_equipped` WHERE `steamid` = " .. DBEscape(SteamID64(ply)) .. " AND `name` = " .. DBEscape(GetItemData(id).name))
end

local IsValid = IsValid
local ipairs = ipairs
local SetModel = FindMetaTable("Entity").SetModel
local timer_Simple = timer.Simple

local function BH_ACC_PlayerSetModel(ply)
	local function dothing()
		if not IsValid(ply) or not ply.bh_acc_equipped then return end

		for k,v in ipairs(ply.bh_acc_equipped) do
			local data = GetItemData(v)
            
            if not data then continue end
            
			if data.IsPlayerModel then
				SetModel(ply, data.model)
	
				break
			end
		end
	end
	timer_Simple(0.1, dothing)
end
hook.Add("PlayerInitialSpawn", "BH_ACC_SetPlayerModelPIS", BH_ACC_PlayerSetModel)
hook.Add("PlayerSpawn", "BH_ACC_SetPlayerModelPS", BH_ACC_PlayerSetModel)

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "sv_bh_acc_data")
end