AddCSLuaFile( "modules/killicon.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hooks.lua" )
AddCSLuaFile( "cl_rounds.lua" )
AddCSLuaFile( "cl_halos.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_ice.lua" )
AddCSLuaFile( "sh_precache.lua" )
AddCSLuaFile( "sh_keypress.lua" )
AddCSLuaFile( "vgui/blockplacer/cl_blp_blocks_gui.lua")
AddCSLuaFile( "vgui/blockplacer/cl_blp_methods.lua")
AddCSLuaFile( "vgui/blockplacer/cl_blp_settings_gui.lua")
AddCSLuaFile( "vgui/cl_hudpickup.lua" )
AddCSLuaFile( "vgui/cl_deathnotice.lua" )
AddCSLuaFile( "vgui/cl_targetid.lua" )
AddCSLuaFile( "vgui/cl_mapvote.lua" )
AddCSLuaFile( "vgui/cl_crosshair.lua" )
AddCSLuaFile( "vgui/cl_teamselect.lua" )
AddCSLuaFile( "vgui/cl_scoreboard.lua" )
AddCSLuaFile( "vgui/skins/hns_colored.lua" )
AddCSLuaFile( "vgui/skins/hns_dark.lua" )
AddCSLuaFile( "vgui/cl_voice.lua" )
AddCSLuaFile( "vgui/cl_hud.lua" )
AddCSLuaFile( "vgui/cl_hud_keypress.lua" )
AddCSLuaFile( "vgui/cl_hud_powerup.lua" )
AddCSLuaFile( "vgui/cl_hud_radar.lua" )
AddCSLuaFile( "vgui/cl_hud_speclist.lua" )
AddCSLuaFile( "vgui/cl_hud_velocity.lua" )
AddCSLuaFile( "vgui/cl_fonts.lua" )
AddCSLuaFile( "vgui/cl_tips.lua" )
AddCSLuaFile( "vgui/cl_settings.lua" )


include( "shared.lua" )
include( "sh_ice.lua" )
include( "sh_precache.lua" )
include( "sh_keypress.lua" )
include( "sv_blocks.lua" )
include( "sv_setteam.lua" )
include( "sv_teleport.lua" )
include( "sv_unstuck.lua" )
include( "sv_mapvote.lua" )
include( "player.lua" )
include( "player_spawn.lua" )
include( "player_death.lua" )
include( "afk_checker.lua" )
include( "sv_rounds.lua" )
include( "sv_resources.lua" )




---------------------------------------------
-- Global chat message sent to all players --
---------------------------------------------
function GM:GlobalChatMsg(msg)
	for k, v in pairs(player.GetAll()) do
		v:SendLua("chat.AddText( Color(255,0,0), [[  []], Color(0,255,0), [[ HNS ]], Color(255,0,0), [[] ]], Color(255,255,255), [[".. msg .."]] )")
	end
end


---------------------------------------------
-- Chat message sent to a specific player  --
---------------------------------------------
function GM:ChatMsg(ply, msg)
	ply:SendLua("chat.AddText( Color(255,0,0), [[  []], Color(0,255,0), [[ HNS ]], Color(255,0,0), [[] ]], Color(255,255,255), [[".. msg .."]] )")
end


-----------------------------
-- 	    GM Initialize      --
-----------------------------
function GM:Initialize()

	timer.Create( "HNS_RoundTimer", 1, 0, RoundTimer )		--Keeps track of round time.
	
	GAMEMODE.TeleportIndex = 1 		--Prevents us from overriding teleports
	
	--DO NOT EDIT THESE
	--I want jumping to be the same in every server hosting this GM
	RunConsoleCommand("sv_airaccelerate", "150" )
	RunConsoleCommand("sv_sticktoground", "0" )
	RunConsoleCommand("sv_stopspeed", "75" )
	
end


--------------------------------
--    Remove all map props    --
--------------------------------
function GM:RemoveMapProps()

	--Remove props
	for k, v in ipairs( ents.FindByClass( "prop_physics*" ) ) do
		if IsValid(v) then
			v:Remove()
		end
	end
	
	--Remove weapons
	for k, v in ipairs( ents.FindByClass( "weapon_*" ) ) do
		if IsValid(v) then
			v:Remove()
		end
	end
	
	--Remove Items
	for k, v in ipairs( ents.FindByClass( "item_*" ) ) do
		if IsValid(v) then
			v:Remove()
		end
	end
end


--------------------------------
--     GM InitPostEntity      --
--------------------------------
function GM:InitPostEntity()

	--After all ents are created, we will remove them from the map.
	GAMEMODE:RemoveMapProps()
	
	
	/*
	if #ents.FindByClass( "info_player_counterterrorist" ) > 0 then return end
	
	seekerSpawns = ents.FindByClass( "info_player_counterterrorist" )			--Our teams already use the CSS spawns by default.
	hiderSpawns = ents.FindByClass( "info_player_terrorist" )
	
	local gmodSpawns = ents.FindByClass( "info_player_start" )		--Player spawns from gmod maps
	local hl2Spawns  = ents.FindByClass( "info_player_deathmatch" )	--Player spawns from HL2DM Maps
	local combineSpawns = ents.FindByClass( "info_player_combine" )	--Player spawns from HL2 team DM
	local rebelSpawns = ents.FindByClass( "info_player_rebel" )	--Player spawns from HL2 team DM
	
	
	--If we have no spawn points and we have HL2 ones, lets use them.
	if #seekerSpawns == 0 && #combineSpawns > 0 then 
		table.Add(seekerSpawns, combineSpawns)
		table.Add(hiderSpawns, rebelSpawns)
	end
	
	--Some maps only have 1 type of player spawn. For those maps we will
	--have to divvy them up between each team.
	for k, v in pairs(gmodSpawns) do
		print("GMOD SPAWNS")
		if math.mod(k, 2) == 0 then
			table.insert(seekerSpawns, v)
		else
			table.insert(hiderSpawns, v)
		end
	end
	
	--Same as above just a different player spawn entity.
	for k, v in pairs(hl2Spawns) do
		print("HL2 SPAWNS")
		if math.mod(k, 2) == 0 then
			table.insert(seekerSpawns, v)
		else
			table.insert(hiderSpawns, v)
		end
	end
	*/
end

 
--------------------------------
--       GM Fall Damage       --
--------------------------------
function GM:GetFallDamage( ply, flFallSpeed )

	--Negates fall damage for the nofall block
	if ply:GetGroundEntity():GetClass() == "bl_nofall" then return end 
	
	if GetConVarNumber("mp_falldamage") == 1 then
		return ( flFallSpeed - 500 ) * (100 / 396)		--Default SDK ( flFallSpeed - 526.5 ) * (100 / 396)
	else
		return 10
	end
	
end


--------------------------------
--     F1 Settings Menu       --
--------------------------------
function GM:ShowHelp(ply) 
	if not IsValid(ply) then return end
	ply:ConCommand("hns_showsettings")
end


--------------------------------
--   F2 Team Selection GUI    --
--------------------------------
function GM:ShowTeam(ply)
	if not IsValid(ply) then return end
	ply:ConCommand("+hns_teamselection")
end



---------------------------------
-- Player Connect Notification --
---------------------------------
function GM:PlayerConnect( name, ip )
	PrintMessage( HUD_PRINTTALK, name.. " has joined the server." )
end


------------------------------------
-- Player Disconnect Notification --
------------------------------------
function GM:PlayerDisconnected( ply )
	PrintMessage( HUD_PRINTTALK, ply:Name().. " has left the server." )
end
