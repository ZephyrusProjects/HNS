

local COLOR_WHITE = Color(255,255,255,255)
local bgColor = Color(0, 0, 0, 175)

local padding = 10
local btnWidth, btnHeight = 140, 45

local desc_hider = "What ever you do make sure to get off the ground! Try to complete a jump before the Seekers come and find you! Use your grenades to makes the Seekers fall/take damage or hopefully die! Stick with your teammates to help increase your chances of surviving, nobody likes being a Seeker!"
local desc_seeker = "SEEK AND DESTROY! Better have your Air Jordan's on you will be doing a lot of jumping! You will spawn with only a knife and will try to hunt down the Hiders. Be careful the Hiders have Flash Bangs, Grenades, and Freeze Grenades try to not find yourself between one of them! What ever you do don't fall!"
local desc_builder = "This is how we place the blocks and make all of the jumps. This is reserved for Admins or trusted builders ONLY. **Server Owners** simply create group called builder and players in that group will have access to building."
local desc_spec = "Don't feel like playing? Or do you just want to be a stalker like Jake? Or even if you want to take notes on Swifty's awesome skills, this is the place for you!"



---------------------------------------
--|||||    	 Paint Buttons        |||||
---------------------------------------	
local function PaintButton(w,h)

	surface.SetDrawColor( bgColor )
	surface.DrawRect( 0, 0, btnWidth, btnHeight)
	
	surface.SetDrawColor( COLOR_WHITE )
	surface.DrawOutlinedRect( 0, 0, btnWidth, btnHeight )
	surface.DrawOutlinedRect( 1, 1, btnWidth-2, btnHeight-2 )

end


---------------------------------------
--|||||       Button Click        |||||
---------------------------------------	
local function ButtonClickStuff()
		isTopMost = true
		ts_modelPreview:SetVisible(false)
		ts_frame:Close()
		
		surface.PlaySound( "/UI/buttonclick.wav" )
		surface.PlaySound( "/UI/buttonclickrelease.wav" )
end


---------------------------------------
--|||||     Team Selection GUI    |||||
---------------------------------------	
local function HNS_TeamSelection()

	--Dummy panel that takes up the entire screen. We do this to draw
	--our buttons off from the main panel and to give it a widescreen look.
	ts_frame = vgui.Create( "DFrame" )
	ts_frame:SetSize( ScrW(), ScrH() )
	ts_frame:SetTitle( "" )
	ts_frame:SetDraggable(false)
	ts_frame:ShowCloseButton(false)
	ts_frame:SetVisible(true)
	ts_frame:MakePopup()
	ts_frame:SetMouseInputEnabled( true )
	ts_frame.Paint = function() 	
		local margin = .095
		local variance = ScrH() * margin
	
		--Widescreen look
		if !LocalPlayer():Alive() then return end			--Prevents double drawing while dead
		surface.SetDrawColor( 0, 0, 0, 225 );
		surface.DrawRect( 0, 0, ScrW(), ScrH() * margin )
		surface.DrawRect( 0, ScrH() - variance +1, ScrW(), ScrH() * margin )	
	end
	
		
	--Team model preview
	ts_modelPreview = vgui.Create( "DModelPanel", ts_frame )
    ts_modelPreview:SetModel( "models/player/gman_high.mdl" )
	ts_modelPreview:SetAnimated(true)
    ts_modelPreview:SetSize( 175, 800)
    ts_modelPreview:SetFOV( 36)
    ts_modelPreview:SetPos (ScrW() / 2 -  ts_modelPreview:GetWide() / 2, 30)
    ts_modelPreview:SetCamPos( Vector(70, 0, 40 ) )
    ts_modelPreview:SetVisible(true)

	--Prevents model preview from rotating 
	function ts_modelPreview:LayoutEntity(ent)
		if ( self.bAnimated ) then -- Make it animate normally
			self:RunAnimation()
		end
	end
		
		
	--Our team selections main panel
	local ts_panel = vgui.Create( "DPanel", ts_frame)
	ts_panel:SetSize(640,512)
	ts_panel:SetPos(ScrW() / 2 - (ts_panel:GetWide() / 2), ScrH() / 2 - (ts_panel:GetTall() / 2))
	ts_panel.Paint = function()
		local w,h = ts_panel:GetSize()
		surface.SetDrawColor( bgColor )
		surface.DrawRect( 0, 0, w, h ) 		--Body

		surface.SetDrawColor( COLOR_WHITE )
		surface.DrawOutlinedRect( 0, 0, w, h )		--Outline
		surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )		--Outline
	end
	
	
	--Objective panel
	local pnl_objective = vgui.Create( "DPanel", ts_panel)
	pnl_objective:SetSize(ts_panel:GetWide(), 128)
	pnl_objective:Dock(BOTTOM)
	pnl_objective:DockMargin(8,0,8,8)
	pnl_objective.Paint = function()
		local w,h = pnl_objective:GetSize()
		surface.SetDrawColor( bgColor )
		surface.DrawRect( 0, 0, w, h ) 		--Body

		surface.SetDrawColor( COLOR_WHITE )
		surface.DrawOutlinedRect( 0, 0, w, h )		--Outline
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		
		surface.DrawOutlinedRect( 0, 0, w, 24 )		--Header line
		surface.DrawOutlinedRect( 0, 0, w, 25 )
	end
	
	--Objective header text
	local lbl_objectiveHeader = vgui.Create( "DLabel", pnl_objective)
	lbl_objectiveHeader:Dock(TOP)
	lbl_objectiveHeader:SetContentAlignment(8)
	lbl_objectiveHeader:SetTextColor(COLOR_WHITE)
	lbl_objectiveHeader:SetFont("Trebuchet24")
	lbl_objectiveHeader:SetText("Objective")
	
	
	--Team description
	local lbl_objective = vgui.Create("DLabel", pnl_objective)
	lbl_objective:SetPos( 5, 30 )
	lbl_objective:Dock(TOP)
	lbl_objective:DockMargin(10,10,10,10)
	lbl_objective:SetColor(COLOR_WHITE)
	lbl_objective:SetFont( "HudFont" )
	lbl_objective:SetText( "Select a Team!" )
	lbl_objective:SetWrap(true)
	lbl_objective:SizeToContents()		
	
	
	
	local btn_Xpos, y = ts_panel:GetPos()
		  btn_Xpos =  btn_Xpos - btnWidth - padding
		  
		  
	----------------------------------
	----       Hider Button       ----
	----------------------------------
	local btn_hiders = vgui.Create( "DButton", ts_frame )
	local x, y = ts_panel:GetPos()
	btn_hiders:SetPos( btn_Xpos, y)
	btn_hiders:SetSize(btnWidth, btnHeight)
	btn_hiders:SetFont("Trebuchet24")
    btn_hiders:SetTextColor(COLOR_WHITE)
    btn_hiders:SetText( "HIDERS" )
	btn_hiders.Paint = function() PaintButton() end
	
		function btn_hiders:OnCursorEntered()	
			ts_modelPreview:SetModel(table.Random(HiderModels))
			ts_modelPreview.Entity:ResetSequence( "idle_all_scared" )
			lbl_objective:SetText( desc_hider )
			lbl_objective:SizeToContents()		
			
			btn_hiders:SetFont( "Trebuchet27" )
			ts_modelPreview:SetVisible(true)
			surface.PlaySound( "/UI/buttonrollover.wav" )	
		end
		
		function btn_hiders:OnCursorExited(m)
			btn_hiders:SetFont( "Trebuchet24" )
		--	ts_modelPreview:SetVisible(false)
			lbl_objective:SetText("Select a Team!")
		end
		
		function btn_hiders:DoClick()
			ButtonClickStuff()
			RunConsoleCommand("hns_setteam_hider")
		end
	

	
	----------------------------------
	----       Seeker Button      ----
	----------------------------------
	local btn_seekers = vgui.Create( "DButton", ts_frame )
	local x, y = btn_hiders:GetPos()
    btn_seekers:SetPos(btn_Xpos, y + btnHeight + padding )
	btn_seekers:SetSize(btnWidth, btnHeight)
	btn_seekers:SetFont("Trebuchet24")
    btn_seekers:SetTextColor(COLOR_WHITE)
    btn_seekers:SetText( "SEEKERS" )
	btn_seekers.Paint = function() PaintButton() end
	
		function btn_seekers:OnCursorEntered()
			ts_modelPreview:SetModel(table.Random(SeekerModels))
			ts_modelPreview.Entity:ResetSequence( "idle_fist" )
			lbl_objective:SetText( desc_seeker )
			lbl_objective:SizeToContents()			

			btn_seekers:SetFont( "Trebuchet27" )
			ts_modelPreview:SetVisible(true)
			surface.PlaySound( "/UI/buttonrollover.wav" )		
		end
		
		function btn_seekers:OnCursorExited(m)
			btn_seekers:SetFont( "Trebuchet24" )
		--	ts_modelPreview:SetVisible(false)
			lbl_objective:SetText("Select a Team!")
		end
	   
		function btn_seekers.DoClick()
			ButtonClickStuff()
			RunConsoleCommand("hns_setteam_seeker")
		end
	
	
	
	----------------------------------
	----      Spectate Button     ----
	----------------------------------
	local btn_spec = vgui.Create( "DButton", ts_frame )
	local x, y = ts_panel:GetPos()
    btn_spec:SetPos(  btn_Xpos, y + ts_panel:GetTall() - btnHeight )
	btn_spec:SetSize(btnWidth, btnHeight)
	btn_spec:SetFont("Trebuchet24")
    btn_spec:SetTextColor(COLOR_WHITE)
    btn_spec:SetText( "SPECTATE" )
	btn_spec.Paint = function() PaintButton() end
	
		function btn_spec:OnCursorEntered()
			ts_modelPreview:SetModel("models/player/gman_high.mdl")
			ts_modelPreview.Entity:ResetSequence( "pose_standing_02" )
			lbl_objective:SetText( desc_spec )
			lbl_objective:SizeToContents()	
			
			btn_spec:SetFont( "Trebuchet27" )
			ts_modelPreview:SetVisible(true)
			surface.PlaySound( "/UI/buttonrollover.wav" )
		end
		
		function btn_spec:OnCursorExited(m)
			btn_spec:SetFont( "Trebuchet24" )
		--	ts_modelPreview:SetVisible(false)
			lbl_objective:SetText("Select a Team!")
		end
			 
		function btn_spec:DoClick()
			ButtonClickStuff()
			RunConsoleCommand("hns_setteam_spec")
		end
	
	
	----------------------------------
	----      Builder Button      ----
	----------------------------------
	local btn_builder = vgui.Create( "DButton", ts_frame )
	local x, y = ts_panel:GetPos()
	      x = x + ts_panel:GetWide() - btnWidth
	      y = y + ts_panel:GetTall() + padding
    btn_builder:SetPos( x, y )
	btn_builder:SetSize(btnWidth, btnHeight)
	btn_builder:SetFont("Trebuchet24")
    btn_builder:SetTextColor(COLOR_WHITE)
    btn_builder:SetText( "BUILDER" )
	btn_builder.Paint = function() PaintButton() end
	
		function btn_builder:OnCursorEntered()
			ts_modelPreview:SetModel("models/player/gman_high.mdl")
			ts_modelPreview.Entity:ResetSequence( "pose_standing_02" )
			lbl_objective:SetText( desc_builder )
			lbl_objective:SizeToContents()			

			btn_builder:SetFont( "Trebuchet27" )
			ts_modelPreview:SetVisible(true)
			surface.PlaySound( "/UI/buttonrollover.wav" )		
		end
		
		function btn_builder:OnCursorExited(m)
			btn_builder:SetFont( "Trebuchet24" )
		--	ts_modelPreview:SetVisible(false)
			lbl_objective:SetText("Select a Team!")
		end
						
		function btn_builder:DoClick()
			ButtonClickStuff()
			if LocalPlayer():IsSuperAdmin() or LocalPlayer():IsUserGroup( "builder" ) then
				RunConsoleCommand("hns_setteam_builder")
			else 
				notification.AddLegacy("You must be an Admin/Builder!", NOTIFY_ERROR, 5)
			end					
		end


end



---------------------------------------
--|||||    Team Selection Open    |||||
---------------------------------------	
function TeamSelect_Open()
	HNS_TeamSelection()
	isTopMost = false 	--Used when we want to hide a GUI that is not the top most
end
concommand.Add( "+hns_teamselection", TeamSelect_Open )



---------------------------------------
--|||||   Team Selection Close    |||||
---------------------------------------	
--Close team selection window
function TeamSelect_Close()
	ts_frame:Close()
end
concommand.Add( "-hns_teamselection", TeamSelect_Close )

