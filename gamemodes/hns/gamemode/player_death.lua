
util.AddNetworkString("PlayerKilledSelf")
util.AddNetworkString("PlayerKilledByPlayer")
util.AddNetworkString("PlayerKilled")
util.AddNetworkString( "PlayerDeath" )



------------------------------
--		 PlayerDeath	    --
------------------------------
function GM:PlayerDeath(ply, inflictor, attacker)

	net.Start("PlayerDeath")
	net.Send(ply)
	
	--Spectator Shit
	ply.SpecID = 1
	ply.SpecType = 5
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity( attacker )
	
	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end
	
	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a 
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then
		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( inflictor ) ) then inflictor = attacker end
	end

	if ( attacker == ply ) then
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( ply )
		net.Broadcast()
		
		MsgAll( attacker:Nick() .. " suicided!\n" )
		return 
	end

	if ( attacker:IsPlayer() ) then
		net.Start( "PlayerKilledByPlayer" )
			local headshot = ply:LastHitGroup()
			net.WriteEntity( ply )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )
			net.WriteString( headshot )
		net.Broadcast()
		
		MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )
		return 
	end
	
	
	net.Start( "PlayerKilled" )
		net.WriteEntity( ply )
		net.WriteString( inflictor:GetClass() )
		net.WriteString( attacker:GetClass() )
	net.Broadcast()
	
	MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )

end


------------------------------
--		DoPlayerDeath	    --
------------------------------
function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
 	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
			
			local plyMoney = attacker:GetNetworkedFloat("money")
			plyMoney = plyMoney + 300
			attacker:SetNetworkedFloat("money", plyMoney)
		end
	end
	
end


------------------------------
--	   PlayerDeathThink	    --
------------------------------
function GM:PlayerDeathThink( ply )

	local Round_Phase = GetGlobalVar( "RoundPhase" )
	local players = team.GetPlayers( 1 )
	
	table.Add(players, team.GetPlayers(2))
	table.Add(players, team.GetPlayers(3))
	
	--Makes the spectator spectate a new player
	if ply:KeyPressed( IN_ATTACK ) then
		if #players == 0 then return end
		if !ply.SpecID then ply.SpecID = 1 end
		ply.SpecID = ply.SpecID + 1
		if ply.SpecID > #players then ply.SpecID = 1 end
		if !players[ ply.SpecID ]:Alive() then		--prevents us from specing spectators
			ply.SpecID = ply.SpecID + 1
		end
		ply:SpectateEntity( players[ ply.SpecID ] )
		ply:SetupHands( players[ ply.SpecID ] )
	end
	
	--Changes the spectators camera type
	if ply:KeyPressed( IN_ATTACK2 ) then
		ply.SpecType = ply.SpecType + 1
		if ply.SpecType > 6 then ply.SpecType = 4 end
		ply:Spectate( ply.SpecType )
	end
	
	--Respawn players if they die while in the round waiting phase
	 if Round_Phase == ROUND_WAITING and ply:Team() != TEAM_SPEC then
		ply:Spawn()
	 end
	
end


------------------------------
--	  PlayerDeathSound		--
------------------------------
function GM:PlayerDeathSound(ply)
	ply:EmitSound( "hns/die".. math.random(1,4) .. ".wav", 360, 100)
	return true  --Disables default death sound.
end


--This gets called when we call ply:KillSilent()
function GM:PlayerSilentDeath(ply)
	ply.SpecID = 1
	ply.SpecType = 5
	ply:Spectate( OBS_MODE_ROAMING )
end
