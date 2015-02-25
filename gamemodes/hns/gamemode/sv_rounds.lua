CreateConVar("hns_roundtime_seconds", "180", FCVAR_NOTIFY, "Round time in seconds.")
CreateConVar("hns_postround_seconds", "8", FCVAR_NOTIFY, "Post round time in seconds.")
CreateConVar("hns_preround_seconds", "16", FCVAR_NOTIFY, "Pre round time in seconds.")
CreateConVar("hns_round_limit", "10", FCVAR_NOTIFY, "How many rounds.")
CreateConVar("hns_poweruplength_seconds", "20", FCVAR_NOTIFY, "How long power ups last in seconds.")


SetGlobalVar( "hns_poweruplength_seconds", GetConVarNumber("hns_poweruplength_seconds") )
SetGlobalVar( "hns_time_left", -1)
SetGlobalVar( "hns_rounds_left", GetConVarNumber("hns_round_limit"))
SetGlobalVar( "RoundPhase", ROUND_WAITING )


Round_Phase = GetGlobalVar( "RoundPhase" )

Time = {}
Time.Remaining = 0 --This is the "time-keeper"
Time.RemainingRounds = GetGlobalVar("hns_rounds_left")
Time.Active = GetConVarNumber( "hns_roundtime_seconds" )
Time.Post = GetConVarNumber( "hns_postround_seconds" )
Time.Pre = GetConVarNumber( "hns_preround_seconds" )

winTracker = 0		--Keeps tracks of wins, we use it to swap teams if one team keeps loosing.



-----------------------------
-- 	    SpawnPlayers       --
-----------------------------
local function SpawnPlayers()		--Spawn seekers and hiders

	ServerLog("[Spawning Players] \n")
	
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_HIDER or v:Team() == TEAM_SEEKER then
			v:Spawn()
		end
	end
	
end 



-----------------------------
-- 	   RestoreMovement     --
-----------------------------
local function RestoreMovement()	--Restore movement for hiders

	for k, v in pairs(team.GetPlayers(TEAM_SEEKER)) do
		if !IsValid(v) or !v:Alive() then continue end	--Skips
		
		v:SetWalkSpeed( GM_WalkSpeed )
		v:SetRunSpeed( GM_RunSpeed )
		v:GodDisable()
		v:ChatPrint("God mode has been disabled." )
	end
	
end



-----------------------------
-- 	  	 SwapTeams         --
-----------------------------
local function SwapTeams(ply)
	
	winTracker = 0 --Reset the wins
	
	hook.Call("SwapTeams")		--Create the hook

	umsg.Start( "hns_SwapTeams")	--Send it to clients
	umsg.End()
	
	
	local players = team.GetPlayers( 1 )
	table.Empty(players)
	table.Add( players, team.GetPlayers( 2 ) )		--Seekers
	table.Add( players, team.GetPlayers( 3 ) )		--Hiders
	
	for k, v in pairs(players) do
		if v:Team() == TEAM_SEEKER then
			v:SetTeam( TEAM_HIDER )
		elseif v:Team() == TEAM_HIDER then
			v:SetTeam(TEAM_SEEKER)
		end
		GAMEMODE:ChatMsg(v, "Teams are being swapped.")
	end
	
	ServerLog("[Team Swap] - Teams are now being switched.\n")

end



-----------------------------
-- 	   AutoTeamBalance     --
-----------------------------
local function AutoTeamBalance()

	local playerVariance = #team.GetPlayers(TEAM_SEEKER) - #team.GetPlayers(TEAM_HIDER)

	while playerVariance <= -2 or playerVariance >= 2 do
		if playerVariance <= -2 then
			local randomPlayer = table.Random(team.GetPlayers(TEAM_HIDER))
			randomPlayer:SetTeam(TEAM_SEEKER)
			GAMEMODE:GlobalChatMsg("Auto-Team Balance has switched " ..randomPlayer:Nick().. " to Seekers.")
			ServerLog("[Auto-Team Balance] - Has switched " .. randomPlayer:Nick().. " to Seekers.\n")
		elseif playerVariance >= 2 then
			local randomPlayer = table.Random(team.GetPlayers(TEAM_SEEKER))
			randomPlayer:SetTeam(TEAM_HIDER)
			GAMEMODE:GlobalChatMsg("Auto-Team Balance has switched " ..randomPlayer:Nick().. " to Hiders.")
			ServerLog("[Auto-Team Balance] - Has switched " .. randomPlayer:Nick().. " to Hiders.\n")
		end
		
		playerVariance = #team.GetPlayers(TEAM_SEEKER) - #team.GetPlayers(TEAM_HIDER)
		
	end
	
end



-----------------------------
-- 	     WaitingPhase      --
-----------------------------
local function WaitingPhase()

	--Not using currently
	hook.Call("WaitingPhase")		--Create the hook
	
	umsg.Start( "hns_RoundWaiting")	--Send the hook to the client, so we can use it clientside
	umsg.End()
	
end



-----------------------------
-- 	     PreRoundPhase     --
-----------------------------
local function PreRoundPhase()

	local blockEnts = {}	--filter ents for game.CleanUpMap

	--Todo: prevent this from getting called every time. 
	if table.Count(blockEnts) == 0 then
		for k, v in pairs(ents.FindByClass("bl_*")) do
			table.insert(blockEnts, v:GetClass())
		end
	end
	
	game.CleanUpMap(false, blockEnts)
	
	hook.Call("PreRoundPhase")		--Create the hook
	umsg.Start( "hns_PreRound")		--Send the hook to the client, so we can use it clientside
	umsg.End()
	
	GAMEMODE:RemoveMapProps()
	SpawnPlayers()
	
end



-----------------------------
-- 	   ActiveRoundPhase    --
-----------------------------
local function ActiveRoundPhase()
	
	--Respawn Hiders that died in the PreRound phase.
	 for k, v in pairs(team.GetPlayers( 3 )) do			--Hiders
		 if !v:Alive() then
			v:Spawn()
		 else
			v:SetHealth(100)		--Reset health when the round starts.
		 end
	 end
	 
	RestoreMovement()
	 
	hook.Call("ActiveRoundPhase")		--Create the hook
	
	umsg.Start( "hns_ActiveRound")		--Send the hook to the client, so we can use it clientside
	umsg.End()
	 
end



-----------------------------
-- 	    PostRoundPhase     --
-----------------------------
local function PostRoundPhase()


	-- If there are no rounds left...
	if Time.RemainingRounds <= 1 then
		timer.Simple(3, function() StartMapVote() end)
		return 
	end	

	AutoTeamBalance()
	GAMEMODE:GetAndNotifyWin()
	
	hook.Call("PostRoundPhase")		--Create the hook
	
	umsg.Start( "hns_PostRound")	--Send the hook to the client, so we can use it clientside
	umsg.End()
	
end



-----------------------------
-- 	     RoundTimer        --
-----------------------------
function RoundTimer()

	GAMEMODE:CheckRound()

	Round_Phase = GetGlobalVar( "RoundPhase" )

	if Round_Phase ~= ROUND_WAITING then
		
		--Take one second off the round phase...
		Time.Remaining = Time.Remaining - 1
	
		SetGlobalVar( "hns_time_left", Time.Remaining)
		SetGlobalVar( "hns_rounds_left", Time.RemainingRounds)
	
		-- If there is no time left in the current phase...
		if Time.Remaining <= 0 then
			ServerLog("Switching phase...\n")

			-- If the round was PRE round...
			if Round_Phase == ROUND_PRE then
				Round_Phase = ROUND_ACTIVE
				Time.Remaining = Time.Active 
				SetGlobalVar("RoundPhase", Round_Phase)
				ActiveRoundPhase()				
				ServerLog("[Round] - Switching to Active round phase.\n")
				
			-- If the round was ACTIVE round...
			elseif Round_Phase == ROUND_ACTIVE then
				Round_Phase = ROUND_POST 
				Time.Remaining = Time.Post
				SetGlobalVar("RoundPhase", Round_Phase)
				PostRoundPhase()
				ServerLog("[Round] - Switching to Post round phase.\n")
				
			-- If the round was POST round...
			elseif Round_Phase == ROUND_POST then
				Round_Phase = ROUND_PRE 
				Time.Remaining = Time.Pre
				Time.RemainingRounds = Time.RemainingRounds - 1
				SetGlobalVar("RoundPhase", Round_Phase)
				PreRoundPhase()			
				ServerLog("[Round] - Switching to Pre round phase.\n")
			end
		end
		
	end
	
end



util.AddNetworkString( "MoneyNotification" )

-----------------------------
-- 	     GM:GiveMoney      --
-----------------------------
function GM:GiveMoney( Team, Ammount )

	for k, v in pairs(team.GetPlayers(Team)) do
		local money = v:GetNetworkedFloat("money")
		money = money + Ammount
		if money >= 16000 then
			money = 16000
		end
		v:SetNetworkedFloat("money", money)
		
		net.Start( "MoneyNotification" )
			net.WriteFloat(Ammount)
			net.WriteBit(true)
		net.Broadcast()
	end

end



-----------------------------
-- 	 PlayersAliveOnTeam    --
-----------------------------
local function PlayersAliveOnTeam(t)

	local count = 0
	
	for _ , _pl in pairs(team.GetPlayers(t)) do
		if _pl:Alive() then count = count + 1 end
	end

	return count
	
end
 
 

-----------------------------
-- 	 GM:GetAndNotifyWin    --
-----------------------------
function GM:GetAndNotifyWin()
	
	--If any Hiders are alive at the end of the round they will automatically be the winner.
	if PlayersAliveOnTeam(TEAM_HIDER) >= 1 then
		hook.Call("HidersWin")
			umsg.Start( "hns_HidersWin")
		umsg.End()
		
		winTracker = winTracker + 1
		GAMEMODE:GiveMoney(3, 2000)		--Hiders
		ServerLog("[GetWinner] - Hiders win.\n")
		
		--If Hiders have won more then X in a row, we will swap teams to keep things fun.
		if winTracker >= 3 then
			timer.Simple(4, function() SwapTeams() end)
		end	
		
	--If Hiders have no alive players.	
	else
		hook.Call("SeekersWin")
			umsg.Start( "hns_SeekersWin")
		umsg.End()
		
		GAMEMODE:GiveMoney(2, 2000)		--Seekers
		timer.Simple(4, function() SwapTeams() end)
		ServerLog("[GetWinner] - Seekers win.\n")
	end

end



-----------------------------
-- 	   GM:CheckRound       --
-----------------------------
function GM:CheckRound()

	Round_Phase = GetGlobalVar("RoundPhase") --Just double check to make sure we have the right phase.

	-- If there aren't enough players, set the phase to WAITING
	if #team.GetPlayers(TEAM_SEEKER) < 1 or #team.GetPlayers(TEAM_HIDER) < 1 then
		--FIX ENDLESS LOOP OF SETTING THIS ROUND PHASE
		--FIX ENDLESS LOOP OF SETTING THIS ROUND PHASE
		--FIX ENDLESS LOOP OF SETTING THIS ROUND PHASE
		
		WaitingPhase()
		
		SetGlobalVar("RoundPhase", ROUND_WAITING)
		SetGlobalVar( "hns_time_left", -1)

		--ServerLog("[RoundChecker] - Not enough players.\n")
		--ServerLog("[RoundChecker] - Setting round phase to WAITING.\n")
		
	elseif #team.GetPlayers(TEAM_SEEKER) >= 1 and #team.GetPlayers(TEAM_HIDER) >= 1 and Round_Phase == ROUND_WAITING then
		--If player count reaches a playable level and we are in the desired round
		--phase, we will switch set it to pre round.
		Round_Phase = ROUND_PRE
		SetGlobalVar("RoundPhase", Round_Phase)
		Time.Remaining = Time.Pre 
		PreRoundPhase()
		
		ServerLog("[RoundChecker] - We now have enough players.\n")
		ServerLog("[RoundChecker] - Setting round phase to Pre.\n")
	end

	if (Round_Phase == ROUND_ACTIVE) and (PlayersAliveOnTeam(TEAM_HIDER) == 0 or PlayersAliveOnTeam(TEAM_SEEKER) == 0) then
		Round_Phase = ROUND_POST
		SetGlobalVar("RoundPhase", Round_Phase)
		Time.Remaining = Time.Post 
		PostRoundPhase()
		ServerLog("[RoundChecker] - Not enough alive please on a team.\n")
		ServerLog("[RoundChecker] - Calculating winner and setting round phase to POST.\n")
	end

end
