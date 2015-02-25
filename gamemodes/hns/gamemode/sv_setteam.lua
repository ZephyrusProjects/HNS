--Our team selection GUI calls these functions. This is where we
--set our team and notify.


-----------------------------
-- 	    CheckIfBuilder     --
-----------------------------
local function CheckIfBuilder(ply)

	if ply:Team() == TEAM_BUILDER then		--Builder team
		ply:ConCommand("-BlockSpawnerGUI")
		ply:StripWeapons()
		ply:SetRenderMode( RENDERMODE_NORMAL )
		ply:SetColor( Color(255, 255, 255, 255) )
	end
	
end



-----------------------------
-- 	    Set Team Hider     --
-----------------------------
local function SetTeam_Hider(ply)
	
	if ply:Team() == TEAM_HIDER then return end
	if team.NumPlayers( TEAM_HIDER ) ~= 0 and team.NumPlayers( TEAM_HIDER ) > team.NumPlayers( TEAM_SEEKER ) then

		ply:SendLua( [[ notification.AddLegacy("Too many players on that team!", NOTIFY_ERROR, 5) ]] )
		ply:SendLua( [[ surface.PlaySound( "common/bugreporter_failed.wav" )  ]] )
	else
		if ply:Alive() then ply:Kill() end
		
		CheckIfBuilder(ply)
		
		ply:SetTeam( TEAM_HIDER )
		ply:StripWeapons()
		ply:SetPData("IsAFK", false)
		ply:ChatPrint("You have been set team Hiders!" )

	end

end
concommand.Add( "hns_setteam_hider", SetTeam_Hider )	



-----------------------------
-- 	    Set Team Seeker    --
-----------------------------
local function SetTeam_Seeker(ply)

	if ply:Team() == TEAM_SEEKER then return end
	if team.NumPlayers( TEAM_SEEKER ) ~= 0 and team.NumPlayers( TEAM_SEEKER ) > team.NumPlayers( TEAM_HIDER ) then 
		ply:SendLua( [[ notification.AddLegacy("Too many players on that team!", NOTIFY_ERROR, 5) ]] )
		ply:SendLua( [[ surface.PlaySound( "common/bugreporter_failed.wav" )  ]] )
	else
		if ply:Alive() then ply:Kill() end
		
		CheckIfBuilder(ply)	
		
		ply:SetTeam( TEAM_SEEKER )
		ply:StripWeapons()
		ply:SetPData("IsAFK", false)
		ply:ChatPrint ("You have been set team Seekers!" )

	end
	
end
concommand.Add( "hns_setteam_seeker", SetTeam_Seeker )	



-----------------------------
-- 	   Set Team Builder    --
-----------------------------
local function SetTeam_Builder(ply)

	if  ply:IsSuperAdmin() or ply:IsUserGroup("builder") then
		if ply:Alive() then ply:Kill() end
		
		CheckIfBuilder(ply)	
		
		ply:SetTeam( TEAM_BUILDER )
		ply:StripWeapons()
		ply:SetPData("IsAFK", false)
		ply:Spawn()
		ply:ChatPrint ("You have been set team Builder!" )
		ply:ConCommand("+BlockSpawnerGUI")
		local message = "Type '!hns_help' in chat for a list of commands."
		GAMEMODE:ChatMsg(ply, message)
	else
		ply:SendLua( [[ notification.AddLegacy("You must be an Admin or Builder to do that!", NOTIFY_ERROR, 5) ]] )
		ply:SendLua( [[ surface.PlaySound( "common/bugreporter_failed.wav" )  ]] )
	end
	
end
concommand.Add( "hns_setteam_builder", SetTeam_Builder )	



-----------------------------
-- 	    Set Team Spec      --
-----------------------------
local function SetTeam_Spec(ply)

	if ply:Alive() then ply:Kill() end

	CheckIfBuilder(ply)

	ply:SetTeam( TEAM_SPEC )
	ply:StripWeapons()
	ply:ChatPrint ("You have been set to spectator!" )
	ply:Spectate( OBS_MODE_ROAMING )

end
concommand.Add( "hns_setteam_spec", SetTeam_Spec )