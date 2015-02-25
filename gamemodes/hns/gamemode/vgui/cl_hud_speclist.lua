--This is the list of other spectators your see while spectating a player. 

local spectext_color = string.ToColor(GetConVarString("hns_settings_spectext_color"))

cvars.AddChangeCallback( "hns_settings_spectext_color", function( convar_name, value_old, value_new )
	spectext_color  = string.ToColor(value_new)
end )



-----------------------------
-- 	   Spec List HUD       --
-----------------------------
local function HUD_SpecList()

	if GetConVarNumber("hns_settings_spectext") != 1 then return end
	local ply = LocalPlayer()
	local spec = ply:GetObserverTarget() or LocalPlayer()
	
	if !IsValid(ply) or !IsValid(spec) or !spec:IsPlayer() then return end
	
	local total = 0
	local specText = "Spectating "..spec:Nick()..":"
	spectext_color.r = math.Rand(1, 255)

	for k, v in pairs( player.GetAll() ) do
		if v:GetObserverTarget() == spec then 
			if total < 16 then
				draw.SimpleText( specText, "MenuLargeSmall-2", ScrW() * .7, ScrH() * .15, spectext_color, TEXT_ALIGN_LEFT )
			--	draw.SimpleText( specText, "MenuLargeSmall-2", ScrW() * .7 + 1, ScrH() * .15, Color(0,0,0,75), TEXT_ALIGN_CENTER )
				draw.SimpleText( v:Nick(), "MenuLargeSmall-2", ScrW() * .73, ScrH() * .165 + 16 * total, spectext_color, TEXT_ALIGN_LEFT)
			--	draw.SimpleText( v:Nick(), "MenuLargeSmall-2", ScrW() * .73 + 1, ScrH() * .165 + 16 * total, Color(0,0,0,75), TEXT_ALIGN_CENTER )
				total = total + 1
			end
		end
	end

end
hook.Add("HUDPaint", "HNS_HUD_SpecList", HUD_SpecList)