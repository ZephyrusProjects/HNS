--I needed some help with the math to get this radar working properly. Acecool
--was nice enough to make this example for me. Thanks again!

--Credits: Josh 'Acecool' Moser
--https://dl.dropboxusercontent.com/u/26074909/tutoring/hud/simple_hud_radar_system.lua




-- 1 unit = 0.75 inches
-- 4 units = 3 inches
local UNITS_PER_INCH = 4 / 3

--Convert units to feet
local UNITS_PER_FEET = UNITS_PER_INCH * 12	--16 units = 1 foot
local radar = surface.GetTextureID ("hns/cstrikeHUD/radar")



-----------------------------
-- 	    Radar HUD          --
-----------------------------
local function HUD_Radar()

	if !LocalPlayer():Alive() then return end
	if ply:Team() == TEAM_BUILDER then return end
	if GetConVarNumber("hns_settings_radar") != 1 then return end
	
	local radar_scale = GetConVarNumber("hns_settings_radarscale")
	local radar_diameter = 224 * radar_scale
	local radar_pos = 5
	local radar_dotSize = 4
	local radar_center = ( (radar_diameter / 2) + (radar_pos + radar_dotSize / 2) )
	local radar_maxLength = radar_center - radar_pos - radar_dotSize 
	--print(radar_maxLength)
	
	surface.SetTexture( radar )
	surface.SetDrawColor( 255, 255, 255, 150 )
	surface.DrawTexturedRect (radar_pos, radar_pos, radar_diameter, radar_diameter)
	
	
	--Get players position
	local pl_pos = LocalPlayer():GetPos()

	
	--Get the eye angles of the player
	local pl_ang = LocalPlayer():EyeAngles( )
	      pl_ang.p = 0 pl_ang.y = pl_ang.y pl_ang.r = 0
	
	
	for k, v in pairs(team.GetPlayers(LocalPlayer():Team())) do
	
		if v == LocalPlayer() then continue end 	--skips iteration
		if !v:Alive() then continue end				
		
		local _tpos = WorldToLocal( pl_pos, pl_ang, v:GetPos(), pl_ang )
        	  _tpos.z = 0		--2d don't need this

			  
		--How far away the player is from you
		local _len = math.Clamp( _tpos:Length() / UNITS_PER_FEET, 0, radar_maxLength )	

		 _tpos = _len * _tpos:GetNormalized() * UNITS_PER_FEET

		 
		--Get the x and y of the player taking into account their body size then dividing the number by something...
		local _x = ( _tpos.x - 32 ) / UNITS_PER_FEET
		local _y = ( _tpos.y - 32 ) / UNITS_PER_FEET
		
		
		--Swap values so that the top is facing forward...
		_x, _y = _y, _x
		
		draw.RoundedBox(2, radar_center + _x - ( radar_dotSize / 2 ), radar_center + _y - ( radar_dotSize / 2 ), radar_dotSize, radar_dotSize, Color(255,255,255))
	end

end
hook.Add("HUDPaint", "HNS_HUD_Radar", HUD_Radar)



