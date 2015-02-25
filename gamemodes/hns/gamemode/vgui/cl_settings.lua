
----------------------------------
--|||||    Settings Cvars    |||||
----------------------------------
CreateClientConVar("hns_settings_tips", 1, true, false)
CreateClientConVar("hns_settings_radar", 1, true, false)
CreateClientConVar("hns_settings_spectext", 1, true, false)
CreateClientConVar("hns_settings_velocity", 1, true, false)
CreateClientConVar("hns_settings_hlhud", 0, true, false)
CreateClientConVar("hns_settings_keypress", 1, true, false)
CreateClientConVar("hns_settings_fists", 0, true, false)
CreateClientConVar("hns_settings_autohop", 0, true, false)
CreateClientConVar("hns_settings_dynamicxhair", 0, true, false)
CreateClientConVar("hns_settings_hudscale", 1, true, false)
CreateClientConVar("hns_settings_radarscale", 1, true, false)

CreateClientConVar("hns_settings_hud_color", "255 153 51 255", true, false) 
CreateClientConVar("hns_settings_crosshair_color", "0 255 0 255", true, false)
CreateClientConVar("hns_settings_spectext_color", "1 255 255 150", true, false)
CreateClientConVar("hns_settings_velocitytext_color", "255 255 255 240", true, false)
CreateClientConVar("hns_settings_keypresstext_color", "255 255 255 255", true, false)



local panel_bgColor = Color(45,45,45,255)
local isPanelOpen = nil 	--Is the panel already open


----------------------------------
--|||||   Default Settings   |||||
----------------------------------
local function UseDefaultSettings()

	RunConsoleCommand("hns_settings_tips", "1")
	RunConsoleCommand("hns_settings_radar", "1")
	RunConsoleCommand("hns_settings_spectext", "1")
	RunConsoleCommand("hns_settings_velocity", "1")
	RunConsoleCommand("hns_settings_hlhud", "0")
	RunConsoleCommand("hns_settings_keypress", "1")
	RunConsoleCommand("hns_settings_fists", "0")
	RunConsoleCommand("hns_settings_autohop", "0")
	RunConsoleCommand("hns_settings_dynamicxhair", "0")
	RunConsoleCommand("hns_settings_hudscale", "1")
	RunConsoleCommand("hns_settings_radarscale", "1")
	
	RunConsoleCommand("hns_settings_hud_color", "255 153 51 255")
	RunConsoleCommand("hns_settings_crosshair_color", "0 255 0 255")
	RunConsoleCommand("hns_settings_spectext_color", "1 255 255 150")
	RunConsoleCommand("hns_settings_velocitytext_color", "255 255 255 240")
	RunConsoleCommand("hns_settings_keypresstext_color", "255 255 255 255")
	
end



----------------------------------
--|||||    	Credits Tab 	 |||||
----------------------------------	
local function CreditsTab(panel)

	local credits_DPanel = vgui.Create("DScrollPanel", panel)
	credits_DPanel:SetPos(5,5)
	credits_DPanel.Paint = function()
		local w,h = credits_DPanel:GetSize()
		surface.SetDrawColor(panel_bgColor)
		surface.DrawRect(0,0,w,h)
		
	end
	--credits_DPanel:SetBackgroundColor(panel_bgColor)
	
	
	local lbl_header = vgui.Create("DLabel", credits_DPanel)
	lbl_header:Dock(TOP)
	lbl_header:DockMargin(10,10,10,0)
	lbl_header:SetFont("UiBold")
	lbl_header:SetText("Special Thanks:")
	lbl_header:SizeToContents()
	
	
	local lbl_credits = vgui.Create("DLabel", credits_DPanel)
	lbl_credits:Dock(TOP)
	lbl_credits:SetSize(panel:GetSize())
	lbl_credits:SetContentAlignment(7)
	lbl_credits:DockMargin(25,5,25,0)
	lbl_credits:SetText("I just wanted to take some time and give credit to the people that actually made this game mode possible.\nThank you so much everyone, I honestly wouldn't have been able to complete it without you!")
	lbl_credits:SizeToContents()
	
	
	local lbl_header = vgui.Create("DLabel", credits_DPanel)
	lbl_header:Dock(TOP)
	lbl_header:DockMargin(10,10,10,0)
	lbl_header:SetFont("UiBold")
	lbl_header:SetText("Programming Mentors:")
	lbl_header:SizeToContents()
	
	local lbl_mentors = vgui.Create("DLabel", credits_DPanel)
	lbl_mentors:Dock(TOP)
	lbl_mentors:DockMargin(25,5,25,0)
	lbl_mentors:SetText("Zachcheatham - My go to buddy; he has taught me a lot about programming! <3 \n" .. 
						"Acecool - Great programmer and an awesome teacher. Thank you so much Ace! \n" ..
						"Mdew - Got me started as a programmer and held my hand in those early stages. \n"..
						"Z-Machine - Another great teacher when I was learning how to program.")
	lbl_mentors:SizeToContents()

	
	local lbl_header = vgui.Create("DLabel", credits_DPanel)
	lbl_header:Dock(TOP)
	lbl_header:DockMargin(10,10,10,0)
	lbl_header:SetFont("UiBold")
	lbl_header:SetText("Testers:")
	lbl_header:SizeToContents()
	
	local lbl_testers = vgui.Create("DLabel", credits_DPanel)
	lbl_testers:Dock(TOP)
	lbl_testers:DockMargin(25,5,25,0)
	lbl_testers:SetText("Yeezus Christ \n" ..
						"MasterBruce \n" ..
						"Destroyer \n" ..
						"Darth Meth")
	lbl_testers:SizeToContents()
	
	local lbl_header = vgui.Create("DLabel", credits_DPanel)
	lbl_header:Dock(TOP)
	lbl_header:DockMargin(10,10,10,0)
	lbl_header:SetFont("UiBold")
	lbl_header:SetText("Others:")
	lbl_header:SizeToContents()
	
	local lbl_others = vgui.Create("DLabel", credits_DPanel)
	lbl_others:Dock(TOP)
	lbl_others:DockMargin(25,5,25,0)
	lbl_others:SetText("The One Free-Man - Created the block models. \n"..
						"Koala - The game would have never been completed if Koala hadn't ask me to finish it. \n" ..
						"Exolent - Originally created this game mode for counter-strike 1.6. \n" ..
						"Anonymous - If I used your models, graphics, sound effects, thank you very much! \n"..
						"And to anyone else that I may have forgotten, thank you!")
	lbl_others:SizeToContents()
	
	return credits_DPanel

end



--------------------------------------
--|||||   Settings Color Mixer   |||||
--------------------------------------
local function SettingsTab_ColorMixer(panel)

	
	local settings_DPanel_Right = vgui.Create("DPanel", panel)
	settings_DPanel_Right:Dock(RIGHT)
	settings_DPanel_Right:SetWide(266)
	settings_DPanel_Right:SetPos(panel:GetWide() - settings_DPanel_Right:GetWide() - 10,5)
	settings_DPanel_Right:SetBackgroundColor(panel_bgColor)
	

	local color_mixer = vgui.Create("DColorMixer", settings_DPanel_Right)
	color_mixer:Dock(BOTTOM)
	color_mixer:DockMargin(5,10,5,5)
	color_mixer:SetSize(266,200)
	color_mixer:SetPalette(true)
	color_mixer:SetAlphaBar(true)
	color_mixer:SetWangs(true)
	color_mixer:SetColor(string.ToColor(GetConVarString("hns_settings_hud_color")))
	
	
	local combobox_index = 1	--default it to 1
	local combobox_colorOptions = vgui.Create("DComboBox", settings_DPanel_Right)
	combobox_colorOptions:Dock(TOP)
	combobox_colorOptions:DockMargin(5,5,5,0)
	combobox_colorOptions:SetToolTip("Click Me!")
	combobox_colorOptions:SetValue("HUD Color")
	combobox_colorOptions:AddChoice("HUD Color")		--DO NOT CHANGE THE ORDER OF THESE
	combobox_colorOptions:AddChoice("Crosshair Color")	
	combobox_colorOptions:AddChoice("Spectator Text Color")
	combobox_colorOptions:AddChoice("Velocity Text Color")
	combobox_colorOptions:AddChoice("Key press GUI Color")
	combobox_colorOptions.OnSelect = function(index, value, data)
		combobox_index = value		--To keep track of what choice is selected
		
		if combobox_index == 1 then
			color_mixer:SetColor(string.ToColor(GetConVarString("hns_settings_hud_color")))
		elseif combobox_index == 2 then
			color_mixer:SetColor(string.ToColor(GetConVarString("hns_settings_crosshair_color")))
		elseif combobox_index == 3 then
			color_mixer:SetColor(string.ToColor(GetConVarString("hns_settings_spectext_color")))
		elseif combobox_index == 4 then
			color_mixer:SetColor(string.ToColor(GetConVarString("hns_settings_velocitytext_color")))
		elseif combobox_index == 5 then
			color_mixer:SetColor(string.ToColor(GetConVarString("hns_settings_keypresstext_color")))
		end
	end
	
	
	local button_setColor = vgui.Create("DButton", combobox_colorOptions)
	button_setColor:Dock(RIGHT)
	button_setColor:SetText("Set Color")
	button_setColor:SetToolTip("Click to set the current element to the selected color.")
	button_setColor.DoClick = function()
		local color = color_mixer:GetColor()
		local colorToString = color.r.." "..color.g.." "..color.b.." "..color.a
		
		if combobox_index == 1 then
			RunConsoleCommand("hns_settings_hud_color", colorToString)
		elseif combobox_index == 2 then
			RunConsoleCommand("hns_settings_crosshair_color", colorToString)
		elseif combobox_index == 3 then
			RunConsoleCommand("hns_settings_spectext_color", colorToString)	
		elseif combobox_index == 4 then
			RunConsoleCommand("hns_settings_velocitytext_color", colorToString)
		elseif combobox_index == 5 then
			RunConsoleCommand("hns_settings_keypresstext_color", colorToString)
		end
	end
	
	
	local button_colorPreview = vgui.Create("DButton", combobox_colorOptions)
	button_colorPreview:Dock(RIGHT)
	button_colorPreview:SetText("Preview")
	button_colorPreview:SetToolTip("Preview color.")
	button_colorPreview.Paint = function()
		local w, h = button_colorPreview:GetSize()
		surface.SetDrawColor(color_mixer:GetColor())
		surface.DrawRect( 0, 0, w, h)
	end
	

end



----------------------------------
--|||||     Settings Tab     |||||
----------------------------------
local function SettingsTab(panel)
	
	--Since property sheets only let us add one container, we will make an 
	--invisible DPanel and parent both of our settings DPanels to it.
	local settingsTab = vgui.Create("DPanel", panel)
	settingsTab:SetPos(5,5)
	settingsTab.Paint = function() return end

	local settings_DPanel_Left = vgui.Create("DPanel", settingsTab)
	settings_DPanel_Left:Dock(LEFT)
	settings_DPanel_Left:SetWide(300)
	settings_DPanel_Left:SetPos(5,5)
	settings_DPanel_Left:SetBackgroundColor(panel_bgColor)

	
	local chckbox_autohop = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_autohop:Dock(TOP)
	chckbox_autohop:DockMargin(10,7,0,0)
	chckbox_autohop:SetValue(GetConVarNumber("hns_settings_autohop"))
	chckbox_autohop:SetText("Auto jump")
	chckbox_autohop:SetToolTip("When enabled you will automatically jump if you are holding the space bar down.")
	chckbox_autohop:SetConVar("hns_settings_autohop")
	chckbox_autohop:SizeToContents()
	
	
	local button_setDefaults = vgui.Create("DButton", chckbox_autohop)
	button_setDefaults:Dock(RIGHT)
	button_setDefaults:DockMargin(0,0,5,0)
	button_setDefaults:SetSize(110,44)
	button_setDefaults:SetText("Use Default Settings")
	button_setDefaults:SetToolTip("Reset all settings back to default.")
	button_setDefaults.DoClick = function()
		UseDefaultSettings()
	end
	
	
	local chckbox_Tips = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_Tips:Dock(TOP)
	chckbox_Tips:DockMargin(10,7,0,0)
	chckbox_Tips:SetValue(GetConVarNumber("hns_settings_tips"))
	chckbox_Tips:SetText("Show Tips")
	chckbox_Tips:SetToolTip("This is the Tips dialog box at the bottom left side of your screen while dead.")
	chckbox_Tips:SetConVar("hns_settings_tips")
	chckbox_Tips:SizeToContents()

	
	local chckbox_Radar = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_Radar:Dock(TOP)
	chckbox_Radar:DockMargin(10,7,0,0)
	chckbox_Radar:SetValue(GetConVarNumber("hns_settings_radar"))
	chckbox_Radar:SetText("Enable Radar")
	chckbox_Radar:SetToolTip("Enable or disable the radar at the top left of your screen.")
	chckbox_Radar:SetConVar("hns_settings_radar")
	chckbox_Radar:SizeToContents()
	
	
	local chckbox_SpecText = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_SpecText:Dock(TOP)
	chckbox_SpecText:DockMargin(10,7,0,0)
	chckbox_SpecText:SetValue(GetConVarNumber("hns_settings_spectext"))
	chckbox_SpecText:SetText("Show Spectator text")
	chckbox_SpecText:SetToolTip("This is the text that you see while dead that tells you who's spectating somebody.")
	chckbox_SpecText:SetConVar("hns_settings_spectext")
	chckbox_SpecText:SizeToContents()
	
	
	local chckbox_velocity = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_velocity:Dock(TOP)
	chckbox_velocity:DockMargin(10,7,0,0)
	chckbox_velocity:SetValue(GetConVarNumber("hns_settings_velocity"))
	chckbox_velocity:SetText("Show velocity text")
	chckbox_velocity:SetToolTip("The velocity text lets you know how fast you are moving.")
	chckbox_velocity:SetConVar("hns_settings_velocity")
	chckbox_velocity:SizeToContents()
	
	
	local chckbox_hl2Hud = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_hl2Hud:Dock(TOP)
	chckbox_hl2Hud:DockMargin(10,7,0,0)
	chckbox_hl2Hud:SetValue(GetConVarNumber("hns_settings_hlhud"))
	chckbox_hl2Hud:SetText("Use default Half-Life 2 hud")
	chckbox_hl2Hud:SetToolTip("Disable the game modes HUD and use the default HL2 hud.")
	chckbox_hl2Hud:SetConVar("hns_settings_hlhud")
	chckbox_hl2Hud:SizeToContents()
	
	
	local chckbox_keyPress = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_keyPress:Dock(TOP)
	chckbox_keyPress:DockMargin(10,7,0,0)
	chckbox_keyPress:SetValue(GetConVarNumber("hns_settings_keypress"))
	chckbox_keyPress:SetText("Show key press GUI")
	chckbox_keyPress:SetToolTip("This GUI lets you know what keys a playing is pressing.")
	chckbox_keyPress:SetConVar("hns_settings_keypress")
	chckbox_keyPress:SizeToContents()
	
	
	local chckbox_hands = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_hands:Dock(TOP)
	chckbox_hands:DockMargin(10,7,0,0)
	chckbox_hands:SetValue(GetConVarNumber("hns_settings_fists"))
	chckbox_hands:SetText("Remove fists from loadout")
	chckbox_hands:SetToolTip("Hiders by default have hands in their loadout.")
	chckbox_hands:SetConVar("hns_settings_fists")
	chckbox_hands:SizeToContents()
	
	
	local chckbox_dynamicCrosshair = vgui.Create( "DCheckBoxLabel", settings_DPanel_Left )
	chckbox_dynamicCrosshair:Dock(TOP)
	chckbox_dynamicCrosshair:DockMargin(10,7,0,0)
	chckbox_dynamicCrosshair:SetTall(16)
	chckbox_dynamicCrosshair:SetValue(GetConVarNumber("hns_settings_dynamicxhair"))
	chckbox_dynamicCrosshair:SetText("Disable crosshair movement")
	chckbox_dynamicCrosshair:SetToolTip("While moving your crosshair changes size. Enabling this will make your crosshair static.")
	chckbox_dynamicCrosshair:SetConVar("hns_settings_dynamicxhair")
	chckbox_dynamicCrosshair:SizeToContents()
	
		
	local slider_hudScale = vgui.Create("DNumSlider", settings_DPanel_Left)
	slider_hudScale:Dock(BOTTOM)
	slider_hudScale:DockMargin(15,0,0,5)
	slider_hudScale:SetTall(16)
	slider_hudScale:SetMin(0.6)
	slider_hudScale:SetMax(1.5)
	slider_hudScale:SetValue(GetConVarNumber("hns_settings_hudscale"))
	slider_hudScale:SetText("HUD Scale:")
	slider_hudScale:SetToolTip("Changes the size of your health, armor, ammo etc.")
	slider_hudScale.TextArea:SetTextColor(Color(255,255,255,255))
	slider_hudScale:SetConVar("hns_settings_hudscale")
	slider_hudScale:SetDecimals(1)
	
	
	local slider_radarScale = vgui.Create("DNumSlider", settings_DPanel_Left)
	slider_radarScale:Dock(BOTTOM)
	slider_radarScale:DockMargin(15,0,0,0)
	slider_radarScale:SetMin(0.4)
	slider_radarScale:SetMax(1.5)
	slider_radarScale:SetValue(GetConVarNumber("hns_settings_radarscale"))
	slider_radarScale:SetText("Radar Scale:")
	slider_radarScale:SetToolTip("Changes the size of your radar.")
	slider_radarScale.TextArea:SetTextColor(Color(255,255,255,255))
	slider_radarScale:SetConVar("hns_settings_radarscale")
	slider_radarScale:SetDecimals(1)
	
	
	SettingsTab_ColorMixer(settingsTab)		--Add our color mixer
	return settingsTab

end




---------------------------------------------
--|||||     Our F1 Menu's main frame    |||||
---------------------------------------------
local function HNS_ShowSettings()
	
	if isPanelOpen then return end

	gui.EnableScreenClicker( true )
	isTopMost = false 	--Used when we want to hide a GUI that is not the top most

	local settings_Form = vgui.Create("DFrame")	
	isPanelOpen = true
	settings_Form:SetSize( 600, 325 )
	settings_Form:SetPos(ScrW() / 2 - settings_Form:GetWide() / 2, ScrH() / 2 - settings_Form:GetTall() / 2)
	settings_Form:SetTitle("")
	settings_Form:SetVisible(true)
	settings_Form:SetDraggable(false)
	settings_Form:SetMouseInputEnabled(true)
	settings_Form:ShowCloseButton(false)
	settings_Form.Paint = function()
		local w,h = settings_Form:GetSize()
		--Main body
		surface.SetDrawColor( 32, 32, 32, 175 )
		surface.SetMaterial(Material("gui/gradient_down"))
		surface.DrawTexturedRect(0, 0, w, 25 )
		surface.DrawTexturedRect(0, 0, w, 25 )
		surface.DrawRect( 0, 0, w, h )
		
		--Header
		surface.SetMaterial(Material("gui/gradient"))
		surface.DrawTexturedRect(0, 25, w, h )
		surface.DrawTexturedRect(0, 25, w, h )
		
		--Main body outline
		surface.SetDrawColor( 128, 128, 128, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		--Header outline
		surface.DrawLine( 0, 25, w, 25 )
	end 

	
	--Header for GUI
	local lbl_header = vgui.Create( "DLabel", settings_Form )
	lbl_header:Dock(TOP)
	lbl_header:SetContentAlignment(8)
	lbl_header:DockMargin(5,-23,0,0)
	lbl_header:SetFont("Trebuchet18-2")
	lbl_header:SetText("HNS Settings")
	lbl_header:SetTextColor(Color(128,255,0))
	lbl_header:SizeToContents()
	
	
	--Custom close button
	local btn_close = vgui.Create( "DButton", settings_Form )
	btn_close:Dock(RIGHT)
	btn_close:SetContentAlignment(9)
	btn_close:DockMargin(0,-19,3,0)
	btn_close:SetFont("Trebuchet18")
	btn_close:SetTextColor(Color(255,255,255))
	btn_close:SetText("X")
	btn_close.Paint = function() return end
	btn_close.OnCursorEntered = function()
		btn_close:SetFont("Trebuchet19")
		surface.PlaySound( "/UI/buttonrollover.wav" )
	end
	btn_close.OnCursorExited = function()
		btn_close:SetFont("Trebuchet18")
	end
	btn_close.DoClick = function()
		settings_Form:Close()
		isTopMost = true 	--Used when we want to hide a GUI that is not the top most
		isPanelOpen = nil
		gui.EnableScreenClicker( false )
		surface.PlaySound( "/UI/buttonclick.wav" )
	end
	
	
	--Tabs to add to the GUI
	local settingsTab = SettingsTab(settings_Form)	
	local creditsTab = CreditsTab(settings_Form)
	
	
	----------------------------------
	--|||||    	 Adds Tabs 	     |||||
	----------------------------------
	settings_Tabs = vgui.Create("DPropertySheet", settings_Form)
	settings_Tabs:SetSize(settings_Form:GetWide() - 10, settings_Form:GetTall() - 35 )
	settings_Tabs:SetPos(5,30)
	settings_Tabs:AddSheet( "Settings", settingsTab, "materials/icon16/user.png", false, false, "Hide n Seek Settings" )
	settings_Tabs:AddSheet( "Credits", creditsTab, "materials/icon16/heart.png", false, false, "Just wanted to thank a few people" )
	settings_Tabs.Paint = function()
		surface.SetDrawColor( 55, 55, 55, 150 )
		surface.DrawRect( 0, 20, settings_Tabs:GetWide() , settings_Tabs:GetTall() - 20 )
		surface.SetDrawColor( 55, 55, 55, 225 )
		surface.DrawOutlinedRect( 0, 20, settings_Tabs:GetWide() , settings_Tabs:GetTall() - 20 )
	end
	
	hook.Call("CreateNewTab")		--So developers can add new tabs w/o editing core code.
	
	--Changes the color of our tabs
	for k, v in pairs(settings_Tabs.Items) do
		if (!v.Tab) then continue end
		
		v.Tab.Paint = function(self,w,h)
			 draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55, 255) )
			 if v.Tab == settings_Tabs:GetActiveTab() then
				draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 100 ) )
			end
		end
	end
	
	
end
concommand.Add("hns_showsettings", HNS_ShowSettings)


/*
local function AddTab_Example()

	local example_Panel = vgui.Create("DPanel")
	example_Panel:SetPos(5,5)
	example_Panel:SetBackgroundColor(panel_bgColor)
	
	local chckbox_showFPS = vgui.Create("DCheckBoxLabel", example_Panel)
	chckbox_showFPS:Dock(TOP)
	chckbox_showFPS:DockMargin(10,10,0,0)
	chckbox_showFPS:SetValue(0)
	chckbox_showFPS:SetText("Show FPS")
	chckbox_showFPS:SetConVar("cl_showfps")
	chckbox_showFPS:SizeToContents()

	settings_Tabs:AddSheet( "Example", example_Panel, "materials/icon16/heart.png", false, false, "Example" )

end
hook.Add("CreateNewTab", "AddTab_Example", AddTab_Example)
*/

