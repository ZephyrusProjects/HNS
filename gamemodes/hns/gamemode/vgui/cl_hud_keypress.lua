 --This is the key press GUI you see while you are spectating a player.
 
 
 
local keypress_color = string.ToColor(GetConVarString("hns_settings_keypresstext_color"))

cvars.AddChangeCallback( "hns_settings_keypresstext_color", function( convar_name, value_old, value_new )
	keypress_color  = string.ToColor(value_new)
end )
 
 
 
 --Receive the keys the player is pressing
 net.Receive( "HNS_SendKeys", function( len )
	playerKeys = net.ReadTable()
 end)



-----------------------------
-- 	   Key Press HUD       --
-----------------------------
local function HUD_KeyPress()

	local spec = LocalPlayer():GetObserverTarget() -- or LocalPlayer()

	if !IsValid(spec) then return end
	if GetConVarNumber("hns_settings_keypress") != 1 then return end
	if !isTopMost then return end

	
	local xPos = ScrW() * 0.33
	local yPos = ScrH() * 0.6
	local xPadding,yPadding = 22, 19
	local w,a,s,d,ctrl,space
	keypress_color.r = math.Rand(1, 255)
	
	
	if playerKeys then
	
		--Remove the dots for ctrl and space
		if playerKeys.ctrl == "." then
			playerKeys.ctrl = ""	
		end
		
		if playerKeys.space == "." then
			playerKeys.space = ""	
		end

	
		--Draw our key press text
		draw.SimpleText(playerKeys.W, "HudFont2", xPos +1, yPos - yPadding, keypress_color, TEXT_ALIGN_CENTER)
		draw.SimpleText(playerKeys.A, "HudFont2", xPos - xPadding, yPos, keypress_color, TEXT_ALIGN_CENTER)
		draw.SimpleText(playerKeys.S, "HudFont2", xPos + 1, yPos, keypress_color, TEXT_ALIGN_CENTER)
		draw.SimpleText(playerKeys.D, "HudFont2", xPos + xPadding + 1, yPos, keypress_color, TEXT_ALIGN_CENTER)
		draw.SimpleText(playerKeys.ctrl, "HudFont2",xPos - xPadding * 2.5, yPos + xPadding -1, keypress_color, TEXT_ALIGN_CENTER)		--We draw this one twice to make it a little more bold
		draw.SimpleText(playerKeys.ctrl, "HudFont2",xPos - xPadding * 2.5, yPos + xPadding, keypress_color, TEXT_ALIGN_CENTER)
		draw.SimpleText(playerKeys.space, "HudFont2",xPos, yPos + xPadding + 4,keypress_color, TEXT_ALIGN_CENTER)
		
		--Draw boxes around our key press text
		local _w, _h = 21,18	--GetTextSize() didn't really work well. We will have
								--to tweak these values if we switch font.
		
		
		--Only draw boxes if the key is being pressed
		surface.SetDrawColor(keypress_color)
		if playerKeys.W != "." then surface.DrawOutlinedRect( xPos + 1 - _w / 2, yPos - yPadding + 1, _w, _h) end
		if playerKeys.A != "." then surface.DrawOutlinedRect( xPos - xPadding - _w / 2 + 1, yPos + 1, _w, _h) end
		if playerKeys.S != "." then surface.DrawOutlinedRect( xPos - _w / 2 + 1, yPos + 1, _w, _h) end
		if playerKeys.D != "." then surface.DrawOutlinedRect( xPos + xPadding - _w / 2 + 1, yPos + 1, _w, _h) end
	
	end
	
end
hook.Add("HUDPaint", "HNS_HUD_KeyPress", HUD_KeyPress)


