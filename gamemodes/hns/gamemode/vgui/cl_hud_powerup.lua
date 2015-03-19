--The text that appears below your cross hair while your power up is active.


-----------------------------
-- 	   PowerUpNotify       --
-----------------------------
function PowerUpNotify(msg)
			
	local duration = CurTime() + GetGlobalVar("hns_poweruplength_seconds")
	local alpha = 150
	
	local function DisplayText()
	
		local ply = LocalPlayer()
		local txtShadow = Color(35,35,35,alpha)
		local txtColor = Color(math.Rand(1, 255), 255, 255, alpha)
		local timeLeft = math.Round(duration - CurTime())

		--Start to fade the alpha
		if timeLeft < 1 then 
			alpha = alpha - 1
		end
		
		--Remove the hook when the alpha is 0
		if alpha <= 0 or !ply:Alive() then
			hook.Remove("HUDPaint", "HNS_PowerUp_Notification")	
		end
		
		draw.SimpleText( "Power-Up: " ..msg, "MenuLargeSmall-1", ScrW() / 2 +1 , ScrH() * .75 + 1, txtShadow, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Power-Up: " ..msg, "MenuLargeSmall-1", ScrW() / 2, ScrH() * .75, txtColor, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Timeleft: " ..timeLeft, "MenuLargeSmall-1", ScrW() / 2 + 1, ScrH() * .75 + 17, txtShadow, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Timeleft: " ..timeLeft, "MenuLargeSmall-1", ScrW() / 2, ScrH() * .75 + 16, txtColor, TEXT_ALIGN_CENTER )

	end
	
	hook.Add("HUDPaint", "HNS_PowerUp_Notification", DisplayText)	
	
	
	--Removes the Power up text when a new round starts.
	hook.Add( "PreRoundPhase", "HNS_Remove_PowerupDisplayTxt", function()
		hook.Remove("HUDPaint", "HNS_PowerUp_Notification")				--Not sure if its necessary but i've been trying to manage hooks 
		hook.Remove("PreRoundPhase", "HNS_Remove_PowerupDisplayTxt")	--and removing them when I can.
	end)	
	
end

