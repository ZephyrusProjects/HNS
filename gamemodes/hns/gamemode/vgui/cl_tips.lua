

local isPanelOpen = nil 	--Is the panel already open
local tips = {}				--Used for the randomized tip list		


local oldtips = {
	"Press F1 to show the settings interface.",
	"To select a different team press F2.",
	"Right click with any grenade to change it's detonation type.",
	"To make bhopping easier try using your mouse wheel down to jump instead!",
	"If a player is frozen from a freeze grenade you will not be able to damage them until they regain movement.",
	"Hover your mouse over any block to see more information about it.",
	"You can only use each Power-up type once per round.",
	"Seekers, work together to try and trap the enemy.",
	"Use your grenades carefully. You can use them to slow down, evade, or even kill your enemies.",
	"Hiders, use your grenade in conjunction with your teammates. Multiple grenades will bring down an enemy faster.",
	"If you see your teammate in a pinch, try and help them out. Remember this is a team based game.",
	"If you happen to get stuck type !unstuck in chat",
	"To rock the vote type !rockthevote or /rockthevote"
}



----------------------------------
--|||||    Randomize Tips    |||||
----------------------------------	
local function RandomizeTips()

	table.Empty(tips)
	
	for k, v in RandomPairs(oldtips) do
		table.insert(tips, v) 
	end
	
end



----------------------------------
--|||||    Show Tips GUI     |||||
----------------------------------	
local function HNS_ShowTips()
	
	local ply = LocalPlayer()
	
	if isPanelOpen then return end
	if GetConVarNumber("hns_settings_tips") != 1 then return end
	if  !IsValid(ply) or ply:Alive() or ply:Team() == TEAM_BUILDER then return end	
	
	local ct = CurTime()	
	local index = 1		--We use this to keep track of where we are in the tip table.
	
	RandomizeTips()

	
	tips_Form = vgui.Create( "DFrame" )	
	isPanelOpen = true
	tips_Form:SetSize( 325, 75 )	
	--tips_Form:SetSize( 325, ScrH() * 0.095  - 24)	
	tips_Form:SetPos( 12, ScrH() - tips_Form:GetTall() - 12)
	tips_Form:SetTitle( "" )
	tips_Form:SetVisible( true )
	tips_Form:SetDraggable( true )
	tips_Form:SetMouseInputEnabled(true)
	tips_Form:ShowCloseButton( false )
	tips_Form.Paint = function()
		local w,h = tips_Form:GetSize()
		surface.SetDrawColor( 32, 32, 32, 175 )
		surface.DrawRect( 0, 0, w, h ) 		--Body

		surface.SetDrawColor( 128, 128, 128, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h )		--Outline
	end 
	
	tips_Form.Think = function()
		if CurTime() > ct + 20 then
			lbl_tip:SetText(tips[index])
			ct = CurTime()
		end
	end
	
	local lbl_header = vgui.Create( "DLabel", tips_Form )
	lbl_header:Dock(TOP)
	lbl_header:SetContentAlignment(7)
	lbl_header:DockMargin(5,-23,0,0)
	lbl_header:SetFont("Trebuchet16")
	lbl_header:SetText("TIPS")
	lbl_header:SizeToContents()
	
	local btn_close = vgui.Create( "DButton", tips_Form )
	btn_close:Dock(RIGHT)
	btn_close:SetSize(20,20)
	btn_close:SetContentAlignment(9)
	btn_close:DockMargin(0,-17,3,0)
	btn_close:SetTextColor(Color(255,255,255))
	btn_close:SetText("X")
	btn_close.Paint = function() return end
	btn_close.DoClick = function()
		isPanelOpen = nil
		tips_Form:Close()
	end
	
	lbl_tip = vgui.Create( "DLabel", tips_Form )
	lbl_tip:Dock(TOP)
	lbl_tip:SetSize(tips_Form:GetSize())
	lbl_tip:SetWrap(true)
	lbl_tip:SetContentAlignment(7)
	lbl_tip:DockMargin(10,-2,0,0)
	lbl_tip:SetFont("Trebuchet16")
	lbl_tip:SetText(tips[index])
	lbl_tip:SizeToContents()

end


----------------------------------
--|||||     Close Tips       |||||
----------------------------------	
local function HNS_CloseTips()
	if isPanelOpen then
		isPanelOpen = nil
		tips_Form:Close()
	end
end


---------------------------------------
--|||||   Net Receive Show Tips   |||||
---------------------------------------
net.Receive("PlayerDeath", function(len)
	if GetGlobalVar( "RoundPhase" ) == ROUND_WAITING then return end
	timer.Simple( .15, HNS_ShowTips )	--Timer fixes GUI occasionaly not popping up.
end)



----------------------------------------
--|||||   Net Receive Close Tips   |||||
----------------------------------------
net.Receive("PlayerSpawn", function(len)
	HNS_CloseTips()
end)
