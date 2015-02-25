--The GUI for our map voting system.



-----------------------------
-- 	    Map Vote GUI       --
-----------------------------
net.Receive( "StartMapVote", function( len )

	--How many maps to add into the list
	local mapCount =  math.Clamp( GetGlobalVar("hns_mapvote_mapcount"), 2, 9 )
	local hasVoted = false
	local maps = net.ReadTable()
	local voteTime = CurTime() + net.ReadInt(8)
	
	surface.PlaySound("vo/Citadel/gman_exit02.wav")
	
	--Main Body
	mv_Form = vgui.Create( "DFrame" )	
	mv_Form:SetSize( 200, 16 * mapCount + 40 )	
	mv_Form:SetPos( 15, ScrH() / 2 - mv_Form:GetTall())
	mv_Form:SetTitle( "" )
	mv_Form:SetVisible( true )
	mv_Form:SetDraggable( false )
	mv_Form:SetMouseInputEnabled(false)
	mv_Form:ShowCloseButton( false )
	mv_Form.Paint = function()
		local w,h = mv_Form:GetSize()
		surface.SetDrawColor( 32, 32, 32, 175 )
		surface.DrawRect( 0, 0, w, h ) 		--Body

		surface.SetDrawColor( 32, 32, 32, 175 )
		surface.DrawRect( 0, 0, w, 24 )		--Darken the header
		surface.SetDrawColor( 128, 128, 128, 255 )
		surface.DrawOutlinedRect( 0, 0, w, 24 )		--Outline for header
		surface.DrawOutlinedRect( 0, 0, w, h )
	end 
	
	--Header
	local lbl_vote = vgui.Create( "DLabel", mv_Form )
	lbl_vote:Dock(TOP)
	lbl_vote:SetContentAlignment(8)
	lbl_vote:DockMargin(0,-28,0,6)
	lbl_vote:SetFont("Trebuchet22")
	lbl_vote:SetText("MAPVOTE")
	lbl_vote:SizeToContents()
	
	--Time remaining
	local lbl_time = vgui.Create( "DLabel", lbl_vote )
	lbl_time:Dock(RIGHT)
	lbl_time:SetContentAlignment(9)
	lbl_time:DockMargin(0,0,0,0)
	lbl_time:SetFont("Trebuchet22")
	lbl_time:SetText(voteTime)
	lbl_time:SizeToContents()
	lbl_time.Think = function()
		local timeLeft = voteTime - CurTime()
		lbl_time:SetText(math.Round(timeLeft))
		
		if timeLeft <= 0 then
			mv_Form:Close()
			surface.PlaySound( "hl1/fvox/blip.wav" )
			timer.Simple(0.3, function() surface.PlaySound( "hl1/fvox/blip.wav" ) end)
			timer.Simple(0.7, function() surface.PlaySound( "hl1/fvox/blip.wav" ) end)
		end
	end

	
	--Create a label for each map
	for i=1, mapCount do			--Only add X maps to the vote. 
		local mapName = maps[i]
		local lbl_map = vgui.Create( "DLabel", mv_Form )
		lbl_map:Dock(TOP)
		lbl_map:SetContentAlignment(7)
		lbl_map:DockMargin(15,0,0,0)
		lbl_map:SetFont("Trebuchet16")
		lbl_map:SetText(i.. ".  " .. mapName)
		lbl_map:SizeToContents()
		lbl_map.Think = function()
			if hasVoted then return end			--Prevents the player from voting multiple times.
			if input.IsKeyDown( i + 1 ) then	--the Key enums start at 0 so we need to add 1
				hasVoted = true
				lbl_map:SetTextColor(Color(0,255,0))
				net.Start( "SendVoteToServer" )
					net.WriteInt(i, 4)		--4 bits should be enough
				net.SendToServer()
				surface.PlaySound("UI/buttonclick.wav")
			end
		end
	end

end)

