include( 'modules/killicon.lua' )

include("shared.lua")
include("cl_rounds.lua")
include("cl_hooks.lua")
include("cl_halos.lua")
include("sh_ice.lua")
include("sh_precache.lua")
include("sh_keypress.lua")
include("vgui/cl_hudpickup.lua")
include("vgui/cl_deathnotice.lua")
include("vgui/cl_targetid.lua")
include("vgui/cl_crosshair.lua")
include("vgui/cl_teamselect.lua")
include("vgui/cl_scoreboard.lua")
include("vgui/cl_voice.lua")
include("vgui/cl_mapvote.lua")
include("vgui/cl_hud.lua")
include( "vgui/cl_hud_keypress.lua" )
include( "vgui/cl_hud_powerup.lua" )
include( "vgui/cl_hud_radar.lua" )
include( "vgui/cl_hud_speclist.lua" )
include( "vgui/cl_hud_velocity.lua" )
include("vgui/cl_fonts.lua")
include("vgui/cl_tips.lua")
include("vgui/cl_settings.lua")
include("vgui/skins/hns_colored.lua")
include("vgui/skins/hns_dark.lua")
include("vgui/blockplacer/cl_blp_blocks_gui.lua")
include("vgui/blockplacer/cl_blp_methods.lua")
include("vgui/blockplacer/cl_blp_settings_gui.lua")


--Add the particle systems our game is using
game.AddParticles( "particles/weapon_fx.pcf")
game.AddParticles( "particles/teleported_fx.pcf")
game.AddParticles( "particles/hunter_projectile.pcf")
game.AddParticles( "particles/door_explosion.pcf")
game.AddParticles( "particles/aurora_sphere2.pcf")



function GM:CreateMove(cmd)

	--Sets mouse wheel down to jump for players
	if cmd:GetMouseWheel() <= -1 then 	-- Negative 1 is mouse wheel down
		if LocalPlayer():IsOnGround() then
			cmd:SetButtons(cmd:GetButtons() + IN_JUMP)
		end											
	end
	
	--Autohop
	if GetConVarNumber("hns_settings_autohop") == 1 then 
		if LocalPlayer():KeyDown(IN_JUMP) and LocalPlayer():IsOnGround() then	
			cmd:SetButtons(bit.band(cmd:GetButtons(), bit.bnot(IN_JUMP)))
		end
	end

end  



function GM:PlayerBindPress( ply, bind, pressed )

	--I need set the hull collisions server and client side. It wasn't working with
	--properly hooks or net sends on player spawn etc. I needed to actually confirm that the player 
	--was fully connected client side. I do that here by checking to see if they have used a bind. 
	--If so and the hull is not set, we will set the hull.
	if bind and !ply.hasHullSet then 
		ply.hasHullSet = true
		ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 72 ) )
		ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 36 ) )		--Fixes some bugs caused from the default hull collisions
	end

	
	--We block mouse wheel downs normal functionality
	if ( string.find( bind, "invnext" ) ) then return true end
	

end



--Death cam FOV when the player dies.
function GM:CalcView(ply, origin, angles, fov)

	--Get the players ragdoll
	local ragdoll = ply:GetRagdollEntity()
	if( !ragdoll or !IsValid(ragdoll) or ragdoll == NULL or ply:GetObserverTarget() != ply ) then return end

	--Get the ragdolls eyes
	local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) )

	--Set the view to the ragdolls eye pos
	local view = {
	origin = eyes.Pos,
	angles = eyes.Ang,
	fov = 90
	}

	return view

end
 
 
 
function GM:OnUndo( name, strCustomString )
    
    Msg( name .." undone\n" )

    if ( !strCustomString ) then
        notification.AddLegacy( "#Undone_"..name, NOTIFY_UNDO, 2 )
    else    
       notification.AddLegacy( strCustomString, NOTIFY_UNDO, 2 )
    end
    
    // Find a better sound :X
    surface.PlaySound( "buttons/button15.wav" )

end
  
  
--Hand Fix Stuff
function GM:PostDrawViewModel( vm, ply, weapon )

  if ( weapon.UseHands || !weapon:IsScripted() ) then
    local hands = LocalPlayer():GetHands()
    if ( IsValid( hands ) ) then hands:DrawModel() end

  end

end
  

