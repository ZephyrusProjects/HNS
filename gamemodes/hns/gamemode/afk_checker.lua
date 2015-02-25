-----------------------------------------------
--				  AFK Manager				 --
-----------------------------------------------
--Set hns_afkcheck_disable 1 in the server.cfg to disable the game modes 
--default AFK management system. 


CreateConVar("hns_afkcheck_disable", "0", FCVAR_NOTIFY, "To disable set to 1.")
CreateConVar("hns_afkcheck_rounds", "3", FCVAR_NOTIFY, "How many rounds until you get moved to spec.")


local function AFK_SpawnCheck(ply)

	if GetConVarNumber("hns_afkcheck_disable") > 0 then return end
	
	if ply.flaggedAsAFK == nil then
		ply.flaggedAsAFK = 0
	end
	
	--Rounded the Vector hoping it would make it less expensive 
	ply.SpawnPos = math.Round(ply:GetPos():Length())

end
hook.Add("PlayerSpawn", "HNS_AFK_GetSpawnPosition", AFK_SpawnCheck)



--Sets the players death position on death. We use it later on for a
--comparison in the PostRound hook.
local function AFK_SetDeathPos(ply)
	if GetConVarNumber("hns_afkcheck_disable") > 0 then return end
	--Rounded the Vector hoping it would make it less expensive 
	ply.deathPos = math.Round(ply:GetPos():Length())
end
hook.Add("PlayerDeath", "HNS_AFK_GetDeathPos", AFK_SetDeathPos)



local function AFK_Checker()

	if GetConVarNumber("hns_afkcheck_disable") > 0 then return end

	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_SPEC then continue end			--We don't want to keep track of spectators
		if v:IsBot() then continue end
		if v.deathPos == nil then continue end		--Skip if nil	

		local comparePositions = ( v.SpawnPos - v.deathPos )
		
		--Convert negative numbers to positive numbers
		if comparePositions <= -1 then
			comparePositions = (comparePositions * -1)
		end
		
		--Players are spawned in the air, and move slightly when landing on a slope.
		--I could have fixed this with a timer in the PlayerSpawn hook but im trying to 
		--avoid timers. More importantly players slightly move when attacked. 
		if comparePositions < 96 then
			v.flaggedAsAFK = v.flaggedAsAFK + 1
		else
			v.flaggedAsAFK = 0
		end
		
		--Set them to spectator 
		if v.flaggedAsAFK >= GetConVarNumber("hns_afkcheck_rounds") then
			v:Kill()
			v:SetTeam(TEAM_SPEC)
			v.flaggedAsAFK = 0
			v:SetPData("HNS_IsAFK", true)
			v:Spectate( OBS_MODE_ROAMING )
			GAMEMODE:GlobalChatMsg(v:Nick() .. " has been moved to Spectator for being AFK.")
			v:SendLua([[surface.PlaySound("vo/gman_misc/gman_02.wav")]])
		end
	end

end
hook.Add("PostRoundPhase", "HNS_AFK_CheckIfAFK", AFK_Checker)
