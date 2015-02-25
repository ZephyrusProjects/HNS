

--We keep track of the SpawnIndexPos so we prevent players
--from spawning on top of each other.
local seeker_SpawnIndexPos = 0
local hider_SpawnIndexPos = 0


function GM:PlayerSelectSpawn( ply )

	 if ply:Team() == TEAM_SEEKER then
		local spawns = ents.FindByClass( "info_player_counterterrorist" )
		seeker_SpawnIndexPos = seeker_SpawnIndexPos + 1
		if seeker_SpawnIndexPos > #spawns then seeker_SpawnIndexPos = 1 end
		return spawns[seeker_SpawnIndexPos]
	 elseif ply:Team() == TEAM_HIDER then
		local spawns = ents.FindByClass( "info_player_terrorist" )
		hider_SpawnIndexPos = hider_SpawnIndexPos + 1
		if hider_SpawnIndexPos > #spawns then hider_SpawnIndexPos = 1 end
		return spawns[hider_SpawnIndexPos]
	else
		local spawns = ents.FindByClass( "info_player_counterterrorist" )
		if seeker_SpawnIndexPos > #spawns then seeker_SpawnIndexPos = 1 end
		return spawns[hider_SpawnIndexPos]
	end
	
end



------------------------------------------------------------------
-- We actually use this function for our !unstuck command.	    --
-- It checks the area around the player before we move them to  --
-- make sure there is nothing blocking the area.				--
------------------------------------------------------------------
function GM:IsSpawnpointSuitable( ply )

	local Pos = ply.UnstuckPos
	local Ents = ents.FindInBox( Pos + Vector( -20, -20, 0 ), Pos + Vector( 20, 20, 76 ) )		--Slightly larger than the players hull. Just incase
																								--a player is moving extremely fast or there is a delay.

	if ( ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_BUILDER or ply:Team() == TEAM_SPEC)  then return true end

	local Blockers = 0

	for k, v in pairs( Ents ) do
		if ( IsValid(v) && v:IsPlayer() && v:Alive() && v:Team() != ply:Team()) then
			Blockers = Blockers + 1
		end
	end

	if ( Blockers > 0 ) then
		return false
	elseif ( Blockers <= 0 ) then
		return true
	end

end



------------------------------
--		PlayerLoadout		--
------------------------------
function GM:PlayerLoadout(ply)
	
	ply:StripWeapons()
	ply:StripAmmo()
	ply:Give("weapon_crowbar")		--We give then remove a crowbar to fix an
									--issue with the hands caused by the timer below.
	ply:StripWeapon( "weapon_crowbar" )
	
	--Using a timer so HUDWeaponPickedUp will
	--show up for players
	timer.Simple(1.5, function()	
		if !IsValid(ply) then return end
		
		if ply:Team() == TEAM_SEEKER then
			ply:Give( "weapon_hns_knife" )
		elseif ply:Team() == TEAM_HIDER then
			ply:Give( "weapon_hns_freezegrenade" )
			ply:Give( "weapon_hns_flashbang" )
			ply:Give( "weapon_hns_grenade" )
			if GetConVarNumber("hns_settings_fists") != 1 then
				ply:Give( "weapon_hns_fists" )
			end 
		end 	
	end)
	
	--I don't really want HUDWeaponPickedUp for builders so
	--no need for a timer.
	if ply:Team() == TEAM_BUILDER then
		ply:Give( "weapon_physgun" )
		ply:Give( "stool_block_updater" )
		ply:Give( "stool_teleport" )
	end
	
	return true
	
end


------------------------------
-- 	 OnDamagedByExplosion   --
------------------------------
function GM:OnDamagedByExplosion( ply, dmginfo )

	ply:SetDSP( 0, false )	--removes ear ringing from explosions

end  


------------------------------
--	  ScalePlayerDamage     --
------------------------------
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	-- More damage if we're shot in the head
	 if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 4 )
	 end

end




------------------------------
--	 Prevent Team Damage    --
------------------------------
function GM:PlayerShouldTakeDamage( victim, ply )

	if ply:IsPlayer() then
		if( ply:Team() == victim:Team() and GetConVarNumber( "mp_friendlyfire" ) == 0 ) then
			return false -- do not damage the player
		end
	end
	 
	return true -- damage the player
	
end
 

 
------------------------------
--	  OnPlayerHitGround     --
------------------------------
function GM:OnPlayerHitGround( ply, bInWater, bOnFloater, flFallSpeed )

	ply:SetGravity(1)  	--We return the players gravity back to normal,
						--it gets adjusted in the bl_gravity ent
						
	ply.UnstuckPos = ply:GetPos()	--We use this to store a safe position for the player to 
									--goto if they get stuck.
									
	if ply:GetGroundEntity():GetClass() == "bl_honey" then
		ply:EmitSound( table.Random({"Mud.StepLeft", "Mud.StepRight"}) )
	end

end



--We use this to store when the command was last called.
--This prevents players from spamming the global chat msg.
local lastCalled = CurTime()

------------------------------
-- 	   CanPlayerSuicide		--
------------------------------
function GM:CanPlayerSuicide(ply)

	if  ply:Team() == TEAM_SEEKER and lastCalled >= CurTime() then 
		lastCalled = CurTime() + 5
		return false 
	end

	if ply:Team() == TEAM_SEEKER then
		GAMEMODE:GlobalChatMsg(ply:Nick() .." tried to bitch out and commit suicide.")
		lastCalled = CurTime() + 5
		return false
	end
	
	return true

end

