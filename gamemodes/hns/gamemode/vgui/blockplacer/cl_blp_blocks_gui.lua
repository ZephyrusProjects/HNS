--This is one of the first things I did for the GM, please forgive me for my sins :)


local isPanelOpen = nil 	--Lets us know if the panel is already open



-----------------------------
-- 	 Create Block Icon     --
-----------------------------
function AddBlockIcon(blockName, blockClass)		--Creates the icon for each block

	BlockIconBG:SetSize( 104, 104 )
	
	BlockIconBG.Paint = function()
		surface.SetDrawColor( 64, 64, 64, 175 )
		surface.DrawRect( 0, 0, BlockIconBG:GetWide(),  BlockIconBG:GetTall() )
		surface.SetDrawColor( 0, 0, 0, 175 )
		surface.DrawOutlinedRect( 0, 0, BlockIconBG:GetWide(),  BlockIconBG:GetTall() )
	end
	
	local BlockModelIcon = vgui.Create( "DModelPanel", BlockIconBG )
	BlockModelIcon:SetModel("models/hns/Normal.mdl")
	BlockModelIcon.Entity:SetMaterial("models/blocks/" .. blockClass )	
	BlockModelIcon:SetSize( blp_iconSize, blp_iconSize )
	BlockModelIcon:SetPos( 2,2 )
	BlockModelIcon:SetCamPos( Vector( 50, 50, 50 ) )
	BlockModelIcon:SetLookAt( Vector( 0, 0, 0 ) )

	
	--Prevents model preview from rotating 
	function BlockModelIcon:LayoutEntity(ent)
		if ( self.bAnimated ) then -- Make it animate normally
			self:RunAnimation()
		end
	end

	local IconLabel = vgui.Create ( "DLabel", BlockModelIcon )
	IconLabel:SetPos(GetTxtOffset( string.len(blockName)), 5)
	IconLabel:SetFont(blp_BlockFont)
	IconLabel:SetColor(blp_BloclFontColor)
	IconLabel:SetText(blockName)
	IconLabel:SizeToContents()
	
	BlockModelIcon.DoClick = function()
		PreviouslySelectBlockClass = blp_BlockSettings.Type		--Store this for later
	
		PrevIconLabel:SetText(CurrentIconLabel:GetText()) 
		PrevIconLabel:SizeToContents()
		PrevIconLabel:SetPos(GetTxtOffset( string.len(PrevIconLabel:GetText())) , 5) 
		PrevBlockModelIcon.Entity:SetMaterial("models/blocks/".. PreviouslySelectBlockClass)
		 
		CurrentIconLabel:SetText(blockName)
		CurrentIconLabel:SizeToContents()
		CurrentIconLabel:SetPos(GetTxtOffset( string.len(blockName)), 5)
		CurrentBlockModelIcon.Entity:SetMaterial("models/blocks/".. blockClass)
		
		blp_BlockSettings.Type = blockClass
		SendBlockSettings()
	end
		
end



-----------------------------
-- 	  Blocks Spawn GUI     --
-----------------------------
local function BlockSpawnGUI()

	if isPanelOpen then return end		--Prevents the GUI from displaying twice.

	isPanelOpen = true
		
	------------------------------------------------------------
	----		Back ground frame for Block Spawn Menu	     ---
	------------------------------------------------------------
	BlockSpawnMenu = vgui.Create ( "DFrame" )
		BlockSpawnMenu:SetPos( 10, ScrH() - 160 )
		BlockSpawnMenu:SetSize( ScrW() - 20, 150 )
		BlockSpawnMenu:SetVisible( true )
		BlockSpawnMenu:ShowCloseButton( false )
		BlockSpawnMenu:SetDraggable(false)
		BlockSpawnMenu:MakePopup()
		BlockSpawnMenu:SetKeyBoardInputEnabled() 
		BlockSpawnMenu:SetMouseInputEnabled(true) 
		BlockSpawnMenu:SetSkin( "hns_dark" )
		BlockSpawnMenu.Paint = function()
				local w,h = BlockSpawnMenu:GetSize()
		--Main body
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.SetMaterial(Material("gui/gradient_down"))
		surface.DrawTexturedRect(0, 0, w, h )
	--	surface.DrawTexturedRect(0, 0, w, h )
		surface.DrawRect( 0, 0, w, h )
		
		--Main body outline
		surface.SetDrawColor(0, 0, 0, 175)
		surface.DrawOutlinedRect( 0, 0, w, h )

		end
		
		local BlockSpawnHeader = vgui.Create ( "DLabel", BlockSpawnMenu )
		BlockSpawnHeader:SetPos(ScrW() / 2 - 65, 3 )
		BlockSpawnHeader:SetColor(blp_LabelColor)
		BlockSpawnHeader:SetFont("MenuLarge2")
		BlockSpawnHeader:SetText("Block Placer")
		BlockSpawnHeader:SizeToContents()

		
		
	--Panel for our Tabs
	BlockTabs = vgui.Create ( "DPropertySheet", BlockSpawnMenu )
		BlockTabs:SetPos( 5, 5 )
		BlockTabs:SetSize( BlockSpawnMenu:GetWide() - 10, BlockSpawnMenu:GetTall() - 10 )
		
		BlockTabs.Paint = function()		--TODO: Add this to the skin instead
			surface.SetDrawColor( 55, 55, 55, 150 )
			surface.DrawRect( 0, 20, BlockTabs:GetWide() , BlockTabs:GetTall() - 20 )
			surface.SetDrawColor( 55, 55, 55, 225 )
			surface.DrawOutlinedRect( 0, 20, BlockTabs:GetWide() , BlockTabs:GetTall() - 20 )
		end
		
	--Scroll Panel in the tab selection
	BlockScrollPanel = vgui.Create( "DScrollPanel", BlockTabs )
		BlockScrollPanel:SetSize( BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12 )
		BlockScrollPanel:SetPos( 6, 6 )

	local AllTab   = vgui.Create( "DIconLayout", BlockScrollPanel )
		AllTab:SetSize(  BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12)
		AllTab:SetPos( 0, 0 )
		AllTab:SetSpaceY( 5 )
		AllTab:SetSpaceX( 5 )
		
	local PrimaryTab   = vgui.Create( "DIconLayout", BlockScrollPanel )
		PrimaryTab:SetSize(  BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12)
		PrimaryTab:SetPos( 0, 0 )
		PrimaryTab:SetSpaceY( 5 )
		PrimaryTab:SetSpaceX( 5 )
	
	local MovementTab   = vgui.Create( "DIconLayout", BlockScrollPanel )
		MovementTab:SetSize(  BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12)
		MovementTab:SetPos( 0, 0 )
		MovementTab:SetSpaceY( 5 )
		MovementTab:SetSpaceX( 5 )

	local DamageTab   = vgui.Create( "DIconLayout", BlockScrollPanel )
		DamageTab:SetSize(  BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12)
		DamageTab:SetPos( 0, 0 )
		DamageTab:SetSpaceY( 5 )
		DamageTab:SetSpaceX( 5 )
								
	local PowerUpTab   = vgui.Create( "DIconLayout", BlockScrollPanel )
		PowerUpTab:SetSize(  BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12)
		PowerUpTab:SetPos( 0, 0 )
		PowerUpTab:SetSpaceY( 5 )
		PowerUpTab:SetSpaceX( 5 )
																
			
	local WeaponTab   = vgui.Create( "DIconLayout", BlockScrollPanel )
		WeaponTab:SetSize(  BlockSpawnMenu:GetWide() - 12, BlockSpawnMenu:GetTall() - 12)
		WeaponTab:SetPos( 0, 0 )
		WeaponTab:SetSpaceY( 5 )
		WeaponTab:SetSpaceX( 5 )
					
		

	--Loop through each block and add it to the correct tab
	for k, v in pairs( BlockList ) do 
	
		BlockIconBG = AllTab:Add ("DPanel")
		AddBlockIcon(v.BlockName, v.BlockClass)
	
		if tostring(v.BlockIsPrimary) == "true" then
			BlockIconBG = PrimaryTab:Add ("DPanel")
			AddBlockIcon(v.BlockName, v.BlockClass)
		end	
		if tostring(v.BlockCategory) == "Movement" then
				BlockIconBG = MovementTab:Add ("DPanel") 
				AddBlockIcon(v.BlockName, v.BlockClass)
		end
		if tostring(v.BlockCategory) == "Damage" then
				BlockIconBG = DamageTab:Add ("DPanel")
				AddBlockIcon(v.BlockName, v.BlockClass)
		end	
		if tostring(v.BlockCategory) == "PowerUps" then
				BlockIconBG = PowerUpTab:Add ("DPanel")
				AddBlockIcon(v.BlockName, v.BlockClass)
		end	
		if tostring(v.BlockCategory) == "Weapons" then
				BlockIconBG = WeaponTab:Add ("DPanel")
				AddBlockIcon(v.BlockName, v.BlockClass)
		end	
	end
		
		
	--All of our different Tabs	
	BlockTabs:AddSheet( "All Blocks", BlockScrollPanel, "materials/icon16/brick_add.png", false, false, "Every HNS Block." )

	local defaultSheet = BlockTabs:AddSheet( "Primary", PrimaryTab, "materials/icon16/heart.png", false, false, "Primary building blocks." ) 
	
	BlockTabs:AddSheet( "Movement", MovementTab, "materials/icon16/arrow_refresh.png", false, false, "Blocks that change/impair a players movement." ) 
	BlockTabs:AddSheet( "Damage", DamageTab, "materials/icon16/exclamation.png", false, false, "Blocks that do damage." ) 
	BlockTabs:AddSheet( "Power Ups", PowerUpTab, "materials/icon16/star.png", false, false, "All buffs/power ups can be found here." ) 
	BlockTabs:AddSheet( "Weapons", WeaponTab, "materials/icon16/bomb.png", false, false, "All blocks that give weapons/nades" ) 

	--Sets our default Selected Tab
	BlockTabs:SetActiveTab(defaultSheet.Tab)
	
	--Changes the color of our Tabs
		for k, v in pairs(BlockTabs.Items) do
			if (!v.Tab) then continue end
			
			v.Tab.Paint = function(self,w,h)
				 draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55, 255) )
				 if v.Tab == BlockTabs:GetActiveTab() then
					draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 100 ) )
				end
			end
		end
	
	
	BlockOptionsMenu()			--Shows the side block menu panel
		
	gui.EnableScreenClicker( false )	
	hook.Add("Think","blp_ShowMouse",blp_ShowMouse)
end



-------------------------------
-- 	 Block Spawn Menu Open   --
-------------------------------
function BlockSpawnMenu_Open(ply)

	if ply:IsSuperAdmin() or ply:IsUserGroup("builder") then
		PreviouslySelectBlockClass = "bl_death"		--Almost forget to reset this
		blp_BlockSettings = table.Copy(blp_DefaultSettings)

		notification.AddLegacy("Hold Left Alt to enable mouse input.", NOTIFY_HINT, 3)
		
		--Put a delay so they would have time to read the notification msg.
		timer.Simple(3, function()
			if !IsValid(ply) then return end
			RunConsoleCommand("gm_snapgrid", "4")
			BlockSpawnGUI()
		end)
	end

end
concommand.Add( "+BlockSpawnerGUI", BlockSpawnMenu_Open )
 
 
 
-------------------------------
-- 	 Block Spawn Menu Close  --
-------------------------------
function BlockSpawnMenu_Close(ply)

	if isPanelOpen then
		hook.Remove("Think", "blp_ShowMouse")
		gui.EnableScreenClicker( false )
		
		SelectedBlocks:Close()
		BlockSpawnMenu:Close()
		isPanelOpen = nil
	end
	
end
concommand.Add( "-BlockSpawnerGUI", BlockSpawnMenu_Close )



