

------------------------------------
--Waiting Round Phase Notification--
------------------------------------
local function WaitingPhase()
	GAMEMODE:DrawCenterText("Waiting for more players...", 2)
end
hook.Add("WaitingPhase", "cl_WaitingPhase", WaitingPhase)



------------------------------------
--	PreRound Phase Notification	  --
------------------------------------
local function PreRoundPhase()
	surface.PlaySound("items/medshot4.wav")
	
	GAMEMODE:PreRoundBlind()
	GAMEMODE:PreRoundCountDown()		--Looks just like DrawCenterText, I just didn't want to botch that function to get this working.
end
hook.Add("PreRoundPhase", "cl_PreRoundPhase", PreRoundPhase)



-------------------------------------
-- Active Round Phase Notification --
-------------------------------------
local function ActiveRoundPhase()
	surface.PlaySound(table.Random({"hns/locknload.wav","hns/moveout.wav","hns/letsgo.wav"}))
	GAMEMODE:DrawCenterText("Ready or not here we come!")
end
hook.Add("ActiveRoundPhase", "cl_ActiveRoundPhase", ActiveRoundPhase)



------------------------------------
--  Post Round Phase Notification --
------------------------------------
local function PostRoundPhase()
--	GAMEMODE:DrawCenterText("") --Fixes the WaitingPhases text notify
end
hook.Add("PostRoundPhase", "cl_PostRoundPhase", PostRoundPhase)



------------------------------------
-- 	 Hiders win Notification	  --
------------------------------------
local function HidersWin()
	surface.PlaySound("hns/ctwin.wav")
	GAMEMODE:DrawCenterText("Hiders have won the round!")	
end
hook.Add("HidersWin", "cl_HidersWin", HidersWin)


------------------------------------
--	 Seekers win Notification	  --
------------------------------------
local function SeekersWin()
	surface.PlaySound("hns/terwin.wav")
	GAMEMODE:DrawCenterText("Seekers have won the round.")
end
hook.Add("SeekersWin", "cl_SeekersWin", SeekersWin)


------------------------------------
--	   Team swap Notification	  --	
------------------------------------
local function SwapTeams()
	GAMEMODE:DrawCenterText("Teams are being swapped")
end
hook.Add("SwapTeams","cl_SwapTeams", SwapTeams)




--Global variable that we use to hide underlying huds
isTopMost = true


------------------------------------------------
--Displays text in the center of the screen.  --
------------------------------------------------
function GM:DrawCenterText(msg, duration, color, offset)		--Last 3 arguments are optional.

	local shadowColor = Color(0,0,0,155)
	local txtColor =  color or Color(255,255,255,255)
	local offset = offset or 0		--A offset for the yPos
	local duration = duration or 5
	local startTime = CurTime() + duration

	
	local function DisplayText()
		
		if !isTopMost then return end

		local xPos = ScrW() / 2
		local yPos = ScrH() / 2 * .68
		
		if txtColor.a <= 0 then
			hook.Remove("HUDPaint", "DrawCenterText_Notification")
		end		
		
		if startTime < CurTime() then 
			txtColor.a = txtColor.a - 1
			shadowColor.a = shadowColor.a - 1 
		end
		
		draw.SimpleText( msg, "HudFont", xPos +1, yPos +1 + offset, shadowColor, TEXT_ALIGN_CENTER )
		draw.SimpleText( msg, "HudFont", xPos, yPos + offset, txtColor, TEXT_ALIGN_CENTER )
		
	end
	hook.Add("HUDPaint", "DrawCenterText_Notification", DisplayText)	
	
end


-------------------------------------
-- PreRound Center Text Countdown  --
-------------------------------------
function GM:PreRoundCountDown()

	local shadowColor = Color(0,0,0,155)
	local txtColor = Color(255,255,255,255)
	local msg = ""
	
	local function ShowTime()		
	
		--Waiting Phase
		if  GetGlobalVar( "RoundPhase" ) == 0 then return end 	--Fixes text sticking around when it shouldn't
	
		if txtColor.a <= 0 then 
			hook.Remove("HUDPaint", "PreRoundCountDown")
		end
		
		if  GetGlobalVar( "RoundPhase" ) == 2 then 	--ActiveRound	
			txtColor.a = txtColor.a - 2
			shadowColor.a = shadowColor.a - 2
		end
			
		if LocalPlayer():Team() == 3 then		--Hiding team
			 msg = "You have " .. GetGlobalVar( "hns_time_left" ) .. " seconds to hide."
		elseif LocalPlayer():Team() == 2 then	
			 msg = "Round starting in " .. GetGlobalVar( "hns_time_left" ) .. " seconds."
		end
		
		draw.SimpleText( msg, "HudFont", ScrW() / 2 +1,  ScrH() / 2 * .66 +1, shadowColor, TEXT_ALIGN_CENTER )
		draw.SimpleText( msg, "HudFont", ScrW() / 2,  ScrH() / 2 * .66, txtColor, TEXT_ALIGN_CENTER )

	 end
	 hook.Add("HUDPaint", "PreRoundCountDown", ShowTime)
	 
end


-------------------------------------
-- 		Blinds Hiders PreRound     --
-------------------------------------
function GM:PreRoundBlind()

	local preRoundAlpha  = 250
	
	local function BlindPlayer()
	
		if !LocalPlayer():Alive() then return end
		
		if LocalPlayer():Team() == 2 then	
			if GetGlobalVar( "RoundPhase" ) == 1 then  --PreRound
				surface.SetDrawColor( 0, 0, 0, preRoundAlpha )
				surface.DrawRect( -8, -8, ScrW() + 16, ScrH() +16)		--Strange as hell but the DrawRect was off by 1-2 pixels.
			else														--Added in a little extra to be safe.
				preRoundAlpha = math.max( preRoundAlpha - .4, 0 )
				surface.SetDrawColor( 0, 0, 0, preRoundAlpha )
				surface.DrawRect( -8, -8, ScrW() + 16, ScrH() + 16)
			end
		 end
		 
		 if preRoundAlpha <= 0 then
			hook.Remove("RenderScreenspaceEffects", "PreRound_BlindSeekers")
		 end
	end
	hook.Add("RenderScreenspaceEffects", "PreRound_BlindSeekers", BlindPlayer)

end
