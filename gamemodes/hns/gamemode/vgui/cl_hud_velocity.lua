

local vel_textColor  = string.ToColor(GetConVarString("hns_settings_velocitytext_color"))

--This is a call back, every time the setting gets changed we update the global variable.
cvars.AddChangeCallback( "hns_settings_velocitytext_color", function( convar_name, value_old, value_new )
	vel_textColor  = string.ToColor(value_new)
end )



-----------------------------
-- 	    Velocity HUD       --
-----------------------------
local function HUD_Velocity()

	if GetConVarNumber("hns_settings_velocity") != 1 then return end
	if !LocalPlayer():Alive() then return end
	if LocalPlayer():Team() == TEAM_BUILDER then return end
	if !isTopMost then return end
	
	local txtColorBG = Color(0,0,0,100)
	
	local velocity = LocalPlayer():GetVelocity()
		  velocity.z = 0	--Ignore fall speed
	      velocity = math.Round(velocity:Length())
		  

	if velocity <= 100 then
		txtColorBG.a = velocity + 30
		vel_textColor.a = velocity + 30
	end
	
	draw.SimpleText("Velocity: " ..velocity, "MenuLargeSmall-2", ScrW()/2 + 1, ScrH() * 0.72 + 1, txtColorBG, TEXT_ALIGN_CENTER)
	draw.SimpleText("Velocity: " ..velocity, "MenuLargeSmall-2", ScrW()/2, ScrH() * 0.72, vel_textColor, TEXT_ALIGN_CENTER)
	
end
hook.Add("HUDPaint", "HNS_HUD_Velocity", HUD_Velocity)