DeriveGamemode( "base" )

GM.Version = " v2.0"
GM.Name = "Hide N Seek B-Hop" .. GM.Version
GM.Author = "swifty"
GM.Email = "N/A"
GM.Website = "N/A"


--Shared round variables
ROUND_WAITING 	= 0
ROUND_PRE 		= 1
ROUND_ACTIVE 	= 2
ROUND_POST 		= 3

--Shared team variables
TEAM_SEEKER = 2
TEAM_HIDER = 3
TEAM_BUILDER = 4
TEAM_SPEC = 5

--Don't change these!
GM_CrouchWalkSpeed = .35		--multiplier
GM_WalkSpeed = 250
GM_RunSpeed = 125
GM_JumpPower = 225


--Global player models we reference in multiple files
SeekerModels = {
	"models/player/leet.mdl",
	"models/player/guerilla.mdl",
	"models/player/arctic.mdl",
	"models/player/phoenix.mdl"}
 
HiderModels = {
	"models/player/urban.mdl",
	"models/player/gasmask.mdl",
	"models/player/riot.mdl",
	"models/player/swat.mdl"}
	
	
	
-----------------------------
-- 		GM:CreateTeams     --
-----------------------------
function GM:CreateTeams()

	TEAM_SEEKER = 2
	team.SetUp( TEAM_SEEKER, "Terrorists", Color( 255, 62, 50, 255), false )
	team.SetSpawnPoint( TEAM_SEEKER, "info_player_counterterrorist" )

	TEAM_HIDER = 3
	team.SetUp( TEAM_HIDER, "Counter-Terrorists", Color( 151, 201, 255, 255 ), false )
	team.SetSpawnPoint( TEAM_HIDER, "info_player_terrorist" )
	
	TEAM_BUILDER = 4
	team.SetUp( TEAM_BUILDER, "Builders", Color( 250, 255, 255, 255 ), false )
	team.SetSpawnPoint( TEAM_BUILDER, "info_player_counterterrorist" )
	
	TEAM_SPEC = 5
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 255, 255 ), true )
	
end



-----------------------------
-- 	   GM:PlayerNoClip     --
-----------------------------
function GM:PlayerNoClip( pl, on )

	-- Don't allow if player is in vehicle
	if ( pl:InVehicle() ) then return false end

	-- Always allow in single player
	if ( game.SinglePlayer() ) then return true end

	--Allow builders to noclip
	if pl:Team() == 4 then return true end

end



-----------------------------
-- 	 GM:GrabEarAnimation   --
-----------------------------
function GM:GrabEarAnimation( ply )

	ply.ChatGestureWeight = ply.ChatGestureWeight or 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply:IsTyping() or ply:IsSpeaking() ) then
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 5.0 )
	else
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime() * 5.0 )
	end
	
	if ( ply.ChatGestureWeight > 0 ) then
	
		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )
	
	end

end


--Slow players down that are moving too fast.
-----------------------------
-- 	    GM:SetupMove       --
-----------------------------
function GM:SetupMove(ply, mv)

	local velocity = ply:GetVelocity()
		  velocity.z = 0	--ignore fall speed
		 
	velocity = velocity:Length()
	
	--DO NOT CHANGE THIS
	--I want to keep somewhat of a jumping standard for this GM.
	if velocity >= 375 then
		ply:SetVelocity(ply:GetVelocity() * -.01)
		--ply:ChatPrint("STOP SPEEDING!")
	end
	
end



--Prevents builders from colliding with players.
-----------------------------
-- 	  GM:ShouldCollide     --
-----------------------------
function GM:ShouldCollide(ent1, ent2)
		
	if ent1:IsPlayer() and ent2:IsPlayer() then	
		if ent1:Team() == TEAM_BUILDER or ent2:Team() == TEAM_BUILDER then
			return false
		end
	end

	return true
	
end



/*
function GM:Move(pl, movedata)

	if !pl:Alive() or pl:WaterLevel() > 0 then return end

	--This makes us match the CSS crouch + jump height
	if pl:KeyDown( IN_DUCK ) then
		pl:SetJumpPower(275)
	else
		pl:SetJumpPower(GM_JumpPower)
	end
	
	return false		--So we don't override gmods Move function

end


function GM:PhysgunPickup(ply, ent)

	if ent:GetClass("bl_*") then
		--ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		--ent:SetSolid(SOLID_NONE)
	end
	
	return true

end

function GM:PhysgunDrop(ply, ent)

	if ent:GetClass("bl_*") then
		--ent:SetCollisionGroup(COLLISION_GROUP_NONE)
		--ent:SetSolid(SOLID_VPHYSICS)
	end
	
	return true

end

*/
