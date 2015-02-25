

/*
local speaker = Material("hns/cstrikeHUD/voiceicon")

--Draws the speaker above players head while talking.
function GM:PostDrawTranslucentRenderables()

	render.SetMaterial(speaker)

	for k, v in pairs(player.GetAll()) do
		if !v:Alive() then return end
		if v:IsSpeaking() then
			local pos = v:GetPos()
			pos.z = pos.z + 80
			render.DrawQuadEasy(pos, LocalPlayer():GetForward() * -1, 10, 10, Color(255,255,255), 180)
		end
	end

end
*/


-------------------------------------------------
--Shows the players name/health on mouse hover.--
-------------------------------------------------
function GM:HUDDrawTargetID()
	
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	local text = "ERROR"
	local font = "MenuLargeSmall-1"

	if (trace.Entity:IsPlayer()) then
		if LocalPlayer():Team() == trace.Entity:Team() then
			text = ("Friend: " .. trace.Entity:Nick())
		else
			text = ("Enemy: " .. trace.Entity:Nick())
		end
	else
		return
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX = ScrW() / 2
	local MouseY = ScrH() / 2
	
	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,100) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

	y = y + h + 5
	
	if LocalPlayer():Team() != trace.Entity:Team() then return end
	
	local text = ("Health: " .. trace.Entity:Health() .. "%")
	local font = "MenuLargeSmall-2"

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX  - w / 2

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,100) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
	
end



local counter = 0
------------------------------------------
--Shows block information on mouse hover--
------------------------------------------
local function BlockTargetID()

	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then  counter = 0 return end
	if (!trace.HitNonWorld) then counter = 0 return end
	if !string.find(trace.Entity:GetClass(),"bl_") then return end
	
	local text = ""
	local text2 = ""
	local font = "MenuLargeSmall-2"
	
	counter = counter + 1
	if string.find(trace.Entity:GetClass(),"bl_") then
		if counter > 225 then
			text = "Block: " .. trace.Entity.PrintName
			text2 = "Spawned By: " .. trace.Entity:GetBlockOwner()
		end
	end
	
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )


	local MouseX = ScrW() / 2
	local MouseY = ScrH() / 2
	
	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	local glow = math.abs(math.sin(CurTime() * 1.25) * 150)
	local txtColor = Color(math.Rand(1, 255), 255, 255, glow)
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,glow) )
	draw.SimpleText( text, font, x, y, txtColor )

	
	x = x - w / 2 + 16
	y = y + h + 5
	draw.SimpleText( text2, font, x+1, y+1, Color(0,0,0,glow) )
	draw.SimpleText( text2, font, x, y, txtColor )
	

end
hook.Add("HUDDrawTargetID", "HNS_BlockTargetID", BlockTargetID)

