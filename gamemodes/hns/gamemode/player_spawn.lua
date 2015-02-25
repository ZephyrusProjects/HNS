

------------------------------
--  	Reset Power-ups 	--
------------------------------
function GM:ResetPowerUps(ply)

	--Clear the powerUps table so players can use power ups again
	ply.powerUps = {}

	--Remove any possible remaining power up effects.
	ply:SetMaterial("")
	ply:SetRenderMode( RENDERMODE_NORMAL )
	ply:SetColor( Color(255, 255, 255, 255) )
	
end 


-----------------------------
-- Do team related stuff   --
-----------------------------
local function DoTeamStuff(ply)

	if ply:Team() == TEAM_HIDER then
		ply:SetModel( table.Random (HiderModels) )
	elseif ply:Team() == TEAM_SEEKER then
		ply:SetModel( table.Random (SeekerModels) )
		if GetGlobalVar("RoundPhase") == ROUND_PRE then	
			ply:SetWalkSpeed( 1 )
			ply:SetRunSpeed( 1 )
			ply:GodEnable()
		end
	elseif ply:Team() == TEAM_SPEC then
		ply:GodEnable()
		ply:KillSilent()
	elseif ply:Team() == TEAM_BUILDER then
		ply:SetModel( "models/player/gman_high.mdl" )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetColor( Color(255, 255, 255, 125) )    --We will make him look like a ghost =D
		ply:GodEnable()
	end
	
end


-----------------------------
--   PlayerInitialSpawn    --
-----------------------------
function GM:PlayerInitialSpawn(ply)

	local seekers = team.NumPlayers(TEAM_SEEKER)
	local hiders = team.NumPlayers(TEAM_HIDER)
	
	if seekers == hiders then
		ply:SetTeam(table.Random({TEAM_SEEKER, TEAM_HIDER}))
	elseif seekers > hiders then
		ply:SetTeam(TEAM_HIDER)
	elseif seekers < hiders then
		ply:SetTeam(TEAM_SEEKER)
	end
	
	ply:SetCustomCollisionCheck(true)
	ply:SetNetworkedFloat("money", 800 )
	ply.recentlyConnect = true			--We use this to prevent players from joining mid round.
	ply.SpecID = 1
	ply.SpecType = 5
	
	--Also set in the GM:PlayerBindPress. Make sure to keep the values synced
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 72 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 36 ) )		--Fixes some bugs caused from the default hull collisions 
	
	--So AFK's persist through map changes etc.
	if ply:GetPData("HNS_IsAFK") == true then
		ply:SetTeam(TEAM_SPEC)
	end
	
end


util.AddNetworkString( "PlayerSpawn" )

-----------------------------
--     	 PlayerSpawn       --
-----------------------------
function GM:PlayerSpawn( ply )

	self.BaseClass:PlayerSpawn( ply )
	
	net.Start("PlayerSpawn")		--Used for keeping track of PlayerSpawn client side
	net.Send(ply)
	
	GAMEMODE:ResetPowerUps(ply)
	
	ply:GodDisable()
	ply:SetHealth(ply:GetMaxHealth())
	ply:SetWalkSpeed(GM_WalkSpeed)
	ply:SetCrouchedWalkSpeed(GM_CrouchWalkSpeed)
	ply:SetRunSpeed (GM_RunSpeed)
	ply:SetJumpPower(GM_JumpPower)
	ply:SetDuckSpeed(0.3)		--Dont change these!
	ply:SetUnDuckSpeed(0.0)		--It somewhat fixes the crouch + jump glitch 
	ply:SetArmor(100)
	ply:AllowFlashlight(true)
	ply:SetNoCollideWithTeammates(true)
	
	
	DoTeamStuff(ply)	--Do some team related shit
	ply:SetupHands()	--Calls PlayerSetHandsModel which sets our new hands
	
	
	--Prevents recently connect players from joining mid round.
	if ply.recentlyConnect and GetGlobalVar("RoundPhase") == ROUND_ACTIVE then	--Active Round
		ply:KillSilent()
		ply.recentlyConnect = false
	end
	
	ply.recentlyConnect = false		--Set it to false now because the player didnt spawn mid round.
	
end


--Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end
