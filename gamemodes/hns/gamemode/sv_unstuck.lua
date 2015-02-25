--This is how we handle players that are stuck. Its not the 100% fool proof
--but it is a much more efficient alternative.


-----------------------------
-- 	    CheckIfStuck       --
-----------------------------
local function CheckIfStuck(ply)

	if !ply:Alive() then	--Prevent dead players from calling it
		ply:ChatPrint("You must be alive to use this command.")
		return
	end
	
	if ply:GetNWBool("isFrozen") then	--Prevent frozen players from calling it
		GAMEMODE:GlobalChatMsg(ply:Nick().." Tried to use the !unstuck command while frozen. What a jerk!")
		return
	end
	
	--Can only use it in the active round phase
	if GetGlobalVar( "RoundPhase" ) != ROUND_ACTIVE then
		ply:ChatPrint("You must wait until the round starts to use this command.")
		return 
	end
	
	local IsSuitableSpawn = GAMEMODE:IsSpawnpointSuitable(ply)

	local tracedata = {}
		tracedata.start = ply:GetPos()
		tracedata.endpos = ply:GetPos()
		tracedata.filter = ply
		tracedata.mins = ply:OBBMins()
		tracedata.maxs = ply:OBBMaxs()
		
	local trace = util.TraceHull( tracedata )
	
	
	if trace.Entity:IsValid() or trace.HitWorld then
		if IsSuitableSpawn then
			GAMEMODE:GlobalChatMsg(ply:Nick() .." has used the !unstuck command.")
			ply:ConCommand("+duck")
			
			timer.Simple(0.25, function()
				if !IsValid(ply) then return end
				ply:SetPos(ply.UnstuckPos) 
			end)
			
			timer.Simple(0.75, function() 
				if !IsValid(ply) then return end
				ply:ConCommand("-duck")
			end)
		end
		
	else
		ply:ChatPrint("You do not appear to be stuck.")
	end
	
end



-----------------------------
--  Unstuck Chat Command   --
-----------------------------
hook.Add("PlayerSay", "HNS_UnstuckChatCommand", function(ply, msg, tchat)

	local args = string.Explode(" ", msg)
	
	if string.lower(args[1]) == "!unstuck" then
		CheckIfStuck(ply)
	end
	
end)