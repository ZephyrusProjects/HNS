

local xhair_color = string.ToColor(GetConVarString("hns_settings_crosshair_color"))

cvars.AddChangeCallback( "hns_settings_crosshair_color", function( convar_name, value_old, value_new )
	xhair_color  = string.ToColor(value_new)
end )


-----------------------------
-- 	    HUD_Crosshair      --
-----------------------------
local function HUD_Crosshair()

	local ply = LocalPlayer()
	if !isTopMost then return end
	if !IsValid(ply) then return end
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "weapon_hns_awp" then return end
	if GetConVarNumber("hns_settings_hlhud") != 0 then return end
 
	local gap = 10 
	local x = ScrW() / 2
	local y = ScrH() / 2
	
	--Cross hair for players	
	if ply:Alive() then
		if(ply:KeyDown( IN_FORWARD )) or
			(ply:KeyDown( IN_BACK )) or
			(ply:KeyDown( IN_MOVELEFT )) or
			(ply:KeyDown( IN_MOVERIGHT )) or
			(ply:KeyDown( IN_JUMP )) or
			(ply:KeyDown( IN_ATTACK )) or
			(!ply:OnGround()) then
			gap = gap + 5
		elseif
			(ply:KeyDown( IN_DUCK )) then
			gap = gap - 3
		end
		
		if GetConVarNumber("hns_settings_dynamicxhair") != 0 then gap = 10 end
		
		local length = gap + 10
	   
        surface.SetDrawColor( xhair_color )
		surface.DrawLine( x - length, y, x - gap, y )		--Left
		surface.DrawLine( x + length, y, x + gap, y )		--Right
		surface.DrawLine( x, y - length, x, y - gap )		--Top
		surface.DrawLine( x, y + length, x, y + gap )		--Bottom
	end
	
	
	--Cross hair for spectators
  	if !ply:Alive() then 
		local gap = 12
		local length = gap + 1
			surface.SetDrawColor( 255, 220, 0, 255 )
			surface.DrawLine( x, y, x, y )					--Center dot
			surface.DrawLine( x - length, y, x - gap, y )	--Left		
			surface.DrawLine( x + length, y, x + gap, y )	--Right
			surface.DrawLine( x, y - length, x, y - gap )	--Top
			surface.DrawLine( x, y + length, x, y + gap )	--Bottom
	end
	
	
end
hook.Add("HUDPaint", "HNS_HUD_Crosshair", HUD_Crosshair)

