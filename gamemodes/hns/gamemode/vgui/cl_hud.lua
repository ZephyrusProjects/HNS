
--Only way to reference the variable names from creating a string 
--was to put these in a table.
local numberTextures = {}
numberTextures.num_0 = surface.GetTextureID ("hns/cstrikeHUD/num_0")
numberTextures.num_1 = surface.GetTextureID ("hns/cstrikeHUD/num_1")
numberTextures.num_2 = surface.GetTextureID ("hns/cstrikeHUD/num_2")
numberTextures.num_3 = surface.GetTextureID ("hns/cstrikeHUD/num_3")
numberTextures.num_4 = surface.GetTextureID ("hns/cstrikeHUD/num_4")
numberTextures.num_5 = surface.GetTextureID ("hns/cstrikeHUD/num_5")
numberTextures.num_6 = surface.GetTextureID ("hns/cstrikeHUD/num_6")
numberTextures.num_7 = surface.GetTextureID ("hns/cstrikeHUD/num_7")
numberTextures.num_8 = surface.GetTextureID ("hns/cstrikeHUD/num_8")
numberTextures.num_9 = surface.GetTextureID ("hns/cstrikeHUD/num_9")


local symbol_plus =   surface.GetTextureID ("hns/cstrikeHUD/symbol_plus")
local symbol_minus =  surface.GetTextureID ("hns/cstrikeHUD/symbol_minus")
local symbol_money =  surface.GetTextureID ("hns/cstrikeHUD/symbol_money")
local hpcross = 	  surface.GetTextureID ("hns/cstrikeHUD/hp_cross")
local armor = 		  surface.GetTextureID ("hns/cstrikeHUD/armor")
local clock = 		  surface.GetTextureID ("hns/cstrikeHUD/clock")
local flash_on = 	  surface.GetTextureID ("hns/cstrikeHUD/flash-on")
local flash_off = 	  surface.GetTextureID ("hns/cstrikeHUD/flash-off")


local scale = GetConVarNumber("hns_settings_hudscale")
local iconSize = 30
local iconSpacing = 32

local margin = 20	--The padding from outside edges on your screen
local hudPosX =  margin
local hudPosY = (ScrH() - margin - iconSize)


local moneyDrawTime = 300		--not related to any form of time.


--Global hud color, we reference it in a few files.
HUD_Color  = string.ToColor(GetConVarString("hns_settings_hud_color"))



--This is a call back, every time the setting gets changed we update the global variable.
cvars.AddChangeCallback( "hns_settings_hud_color", function( convar_name, value_old, value_new )
	HUD_Color  = string.ToColor(value_new)
end )

cvars.AddChangeCallback( "hns_settings_hudscale", function( convar_name, value_old, value_new )
	scale  = value_new
	iconSize = 30 * scale
	iconSpacing = iconSize + 2
	hudPosY = ScrH() - (margin * scale) - iconSize
end )




--Puts time/health etc in a table so we can loop through it
--to draw our hud elements like cs.
function SplitString(String)

	String = tostring(String)
	local stringToTable = {}
	
	for i = 1, string.len(String) do
		table.insert(stringToTable, string.sub(String, i, i) )
	end
	
	return stringToTable
end


--To match the counter-strike HUD I had to draw numbers with
--textures instead of a font :(
function DrawHUDNumbers(Table, posX, PosY)

	local spacing = iconSpacing
	--We loop through backwards and draw them right to left so
	--we don't have to do a bunch shit to fix the placement later on.
	for i = #Table, 1, -1 do
		for j = 0, 9 do
			if Table[i] == tostring(j) then
				texture = j
				spacing = spacing - iconSpacing
			end				
		end				
		surface.SetTexture( numberTextures["num_" .. texture] )
		surface.DrawTexturedRect (posX + spacing ,PosY + 2,iconSize ,iconSize - 2)	-- -2 because the numbers are slighly bigger then the icons		
	end
	
end



-----------------------------
-- 	     Health HUD        --
-----------------------------
local function HUD_Health()

	local ply = LocalPlayer()
	if !IsValid(ply) or !ply:Alive() then return end	
	if ply:Team() == 4 then return end		--Builder team
	if GetConVarNumber("hns_settings_hlhud") != 0 then return end
	
	local healthTable = SplitString(ply:Health())		
	if ply:Health() <= 25 then
		surface.SetTexture( hpcross )
		surface.SetDrawColor( Color(255, 0, 0, 255) )
		surface.DrawTexturedRect (hudPosX,hudPosY,iconSize,iconSize)
		DrawHUDNumbers(healthTable, hudPosX + iconSpacing * 3, hudPosY)
	else
		surface.SetTexture( hpcross )
		surface.SetDrawColor( HUD_Color )
		surface.DrawTexturedRect (hudPosX,hudPosY,iconSize,iconSize)
		DrawHUDNumbers(healthTable, hudPosX + iconSpacing * 3 , hudPosY)
	end

end
hook.Add("HUDPaint", "HNS_HUD_Health", HUD_Health)


-----------------------------
-- 	     Armor HUD         --
-----------------------------
local function HUD_Armor()

	local ply = LocalPlayer()
	if !IsValid(ply) or !ply:Alive() then return end	
	if ply:Team() == 4 then return end		--Builder team
	if GetConVarNumber("hns_settings_hlhud") != 0 then return end
	
	local armorPOS = ScrW() * 0.25 - 75
	local armorTable =  SplitString(math.Clamp(ply:Armor(), 0, 100))		
		surface.SetTexture( armor )
		surface.SetDrawColor( HUD_Color )
		surface.DrawTexturedRect (armorPOS,hudPosY,iconSize,iconSize)
		DrawHUDNumbers(armorTable,armorPOS + iconSpacing * 3, hudPosY)

end
hook.Add("HUDPaint", "HNS_HUD_Armor", HUD_Armor)



-----------------------------
-- 	     Ammo HUD          --
-----------------------------
local function HUD_Ammo()

	local ply = LocalPlayer()
	if !IsValid(ply) or !ply:Alive() then return end	
	if(ply:GetActiveWeapon() == NULL or ply:GetActiveWeapon() == "Camera") then return end
	if (ply:GetActiveWeapon():Clip1()) <= -1 then return end
	
	
	local ammoPos = (ScrW() - margin - iconSpacing)
	
	surface.SetTexture( ply:GetActiveWeapon().AmmoIcon )
	surface.SetDrawColor( HUD_Color )
	surface.DrawTexturedRect ( ammoPos ,hudPosY, iconSize, iconSize )
	
	local ammoTable = SplitString(ply:GetActiveWeapon():Clip1())
	DrawHUDNumbers(ammoTable, ammoPos - iconSpacing - 5, hudPosY)
end
hook.Add("HUDPaint", "HNS_HUD_Ammo", HUD_Ammo)



-----------------------------
-- 	   FlashLight HUD      --
-----------------------------
local function HUD_FlashLight()

	local ply = LocalPlayer()
	if !IsValid(ply) or !ply:Alive() then return end	
	if ply:Team() == 4 then return end		--Builder team
	
	local iconWidth = 52 * scale
	local iconHeight = 38 * scale

	if ( !ply:FlashlightIsOn() ) then
		surface.SetTexture( flash_off )
		surface.SetDrawColor( HUD_Color )
		surface.DrawTexturedRect ( ScrW() -  iconWidth - margin, ScrH()*0.03, iconWidth, iconHeight )
	else 
		surface.SetTexture( flash_on )
		surface.SetDrawColor( HUD_Color )
		surface.DrawTexturedRect ( ScrW() -  iconWidth - margin, ScrH()*0.03, iconWidth, iconHeight )
		surface.DrawTexturedRect ( ScrW() -  iconWidth - margin, ScrH()*0.03, iconWidth, iconHeight )
	end
	
end
hook.Add("HUDPaint", "HNS_HUD_FlashLight", HUD_FlashLight)



-----------------------------
-- 	     Clock HUD         --
-----------------------------
local function HUD_Clock()

	local ply = LocalPlayer()
	if !IsValid(ply) then return end	
	if ply:Team() == 4 then return end		--Builder team
	
	local timeleft = GetGlobalVar( "hns_time_left" )  or 0
	local formatTime = string.FormattedTime(timeleft)
	
	--Correct the seconds
	if formatTime.s < 10 then  
		seconds = ("0" .. formatTime.s)
	elseif formatTime.s <= 0 then
		seconds = "00"
	else
		seconds = formatTime.s
	end
	
	--Time
	local glow = math.abs(math.sin(CurTime() * 2) * 255)
    local flashingRed = Color(255, 0, 0, glow)
	local hudColor = string.ToColor(GetConVarString("hns_settings_hud_color"))
	hudColor.a = glow * -1
	local minutesTable = SplitString(formatTime.m)
	local secondsTable = SplitString(seconds)


	--We draw time twice. It fades between red and the hud color. When one is fading out
	--the other is fading in.
	if timeleft < 30 then  
		surface.SetTexture( clock )
		surface.SetDrawColor( hudColor )
		surface.DrawTexturedRect (ScrW()/2-95 * scale,hudPosY,iconSize,iconSize)
		draw.SimpleText(":", "Trebuchet27", ScrW()/2, hudPosY, Color( 255, 153, 51, 125), TEXT_ALIGN_CENTER)	--Couldn't use hudColor something strange is happening
		DrawHUDNumbers(minutesTable, ScrW() / 2 - iconSpacing - 2, hudPosY)
		DrawHUDNumbers(secondsTable, ScrW() / 2 + iconSpacing + 2, hudPosY)
	
		surface.SetTexture( clock )
		surface.SetDrawColor( flashingRed )
		surface.DrawTexturedRect (ScrW()/2-95 * scale,hudPosY,iconSize,iconSize)
		draw.SimpleText(":", "Trebuchet28", ScrW()/2, hudPosY, flashingRed, TEXT_ALIGN_CENTER)
		DrawHUDNumbers(minutesTable, ScrW() / 2 - iconSpacing - 2, hudPosY)
		DrawHUDNumbers(secondsTable, ScrW() / 2 + iconSpacing + 2, hudPosY)
	else
		surface.SetTexture( clock )
		surface.SetDrawColor( HUD_Color )
		surface.DrawTexturedRect (ScrW()/2-95 * scale,hudPosY,iconSize,iconSize)
		draw.SimpleText(":", "Trebuchet27", ScrW()/2, hudPosY, Color( 255, 153, 51, 100), TEXT_ALIGN_CENTER)
		DrawHUDNumbers(minutesTable, ScrW() / 2 - iconSpacing - 2, hudPosY)
		DrawHUDNumbers(secondsTable, ScrW() / 2 + iconSpacing + 2, hudPosY)
	end

end
hook.Add("HUDPaint", "HNS_HUD_RoundTimer", HUD_Clock)



-----------------------------
-- 	     Dead HUD          --
-----------------------------
local function HUD_Dead()

	local ply = LocalPlayer()
	if !IsValid(ply) or ply:Alive() then return end	
	
	--WideScreen Look
	local margin = .095
	local variance = ScrH() * margin
	
	surface.SetDrawColor( 0, 0, 0, 210 )
	surface.DrawRect( 0, 0, ScrW(), ScrH() * margin )
	surface.DrawRect( 0, ScrH() - variance +1, ScrW(), ScrH() * margin )	
	
	--Help/Hints
	draw.SimpleText("Left Mouse to change players.", "HudFont", 15, 25, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
	draw.SimpleText("Right Mouse to change camera view.", "HudFont", 15, 50, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)	
	
end
hook.Add("HUDPaint", "HNS_HUD_Dead", HUD_Dead)



-----------------------------
-- 	     Money HUD         --
-----------------------------
local function HUD_Money()

	local ply = LocalPlayer()
	if !IsValid(ply) then return end	
	if ply:Team() == 4 then return end		--Builder team

	local money = ply:GetNetworkedFloat("money")
	local moneyTable = SplitString(money)
	local moneyPos = (ScrW() - margin - iconSpacing)
		surface.SetTexture(	symbol_money )
		surface.SetDrawColor( HUD_Color )
		surface.DrawTexturedRect (moneyPos - iconSpacing * string.len(tostring(money)),hudPosY - 45,iconSize,iconSize)
		DrawHUDNumbers(moneyTable, moneyPos, hudPosY - 45)
	
	
	if drawMoney == 1 then		--true
		local moneyTable = SplitString(addMoney)
		
		moneyDrawTime = moneyDrawTime - .20
		
		if moneyDrawTime > 0 then
			surface.SetTexture(	symbol_plus )
			surface.SetDrawColor( Color(0,255,0, moneyDrawTime) )
			surface.DrawTexturedRect (moneyPos - iconSpacing * string.len(tostring(addMoney)),hudPosY - 45 * 2,iconSize,iconSize)
			DrawHUDNumbers(moneyTable, moneyPos, hudPosY - 90)	
		else 
			drawMoney = 0		--false
			moneyDrawTime = 300 --mirror with origional value 
		end
	end

end
hook.Add("HUDPaint", "HNS_HUD_Money", HUD_Money)


--Tells us how much money to give the player
net.Receive( "MoneyNotification", function( len )
	 addMoney = net.ReadFloat()
	 drawMoney = net.ReadBit()
end) 



-----------------------------
-- 	  Hide default HUDs    --
-----------------------------
local function HideDefaultHud(hudType)
	if GetConVarNumber("hns_settings_hlhud") != 0 then return end
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudCrosshair", "CHudAmmo"})do
		if hudType == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HNS_HideDefaultHud", HideDefaultHud)



