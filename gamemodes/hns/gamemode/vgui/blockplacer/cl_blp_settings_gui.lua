--This is one of the first things I did for the GM, please forgive me for my sins :)



--Custom DCombo Menu, to override the default one sorting alphabetically 
local function CustomDComboMenu(pControlOpener, panel)

	if ( pControlOpener ) then
		if ( pControlOpener == panel.TextEntry ) then
			return
		end
	end
	
	-- Don't do anything if there aren't any options..
	if ( #panel.Choices == 0 ) then return end
	
	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if ( IsValid( panel.Menu ) ) then
		panel.Menu:Remove()
		panel.Menu = nil
	end
	
	panel.Menu = DermaMenu()
	
	for k, v in pairs( panel.Choices ) do
		panel.Menu:AddOption( v, function() panel:ChooseOption( v, k ) end )
	end
	
	local x, y = panel:LocalToScreen( 0, panel:GetTall() )
	
	panel.Menu:SetMinimumWidth( panel:GetWide() )
	panel.Menu:Open( x, y, false, panel )
	
end

-------------------------------
-- 	  Block Options Menu     --
-------------------------------
function BlockOptionsMenu()			--The block settings GUI off to the right
		
	local BlockIconPaint = BlockIconBG.Paint	--Taken from our block GUI DPanel Paint
		
	------------------------------------------------------------
	----		Background frame for Block Options	         ---
	------------------------------------------------------------
	BlockOptionMenu = vgui.Create ( "DFrame", BlockSpawnMenu)
		BlockOptionMenu:SetSize( 243, 510 )
		BlockOptionMenu:SetPos( ScrW() - 253, ScrH() - 160 - 509 )
		BlockOptionMenu:SetVisible( true )
		BlockOptionMenu:SetDraggable(false)
		BlockOptionMenu:SetTitle( "" )
		BlockOptionMenu:ShowCloseButton( false )
		BlockOptionMenu:MakePopup()
		BlockOptionMenu:SetKeyBoardInputEnabled() 
		BlockOptionMenu:SetMouseInputEnabled(false) 
		BlockOptionMenu:SetSkin( "hns_dark" )
	
	BlockOptionMenu.OnMousePressed = function()
		BlockOptionMenu:MoveToBack()	--Prevents our mainframe from being the TopMost Panel
	end
		
	
	--Our child panels use this for proper position
	local menuPosX,menuPosY = BlockOptionMenu:GetPos()	
	
	
	------------------------------------------------------------
	----		Panel for Recentely Selected Blocks 	     ---
	------------------------------------------------------------
	SelectedBlocks = vgui.Create ( "DFrame" )
		SelectedBlocks:SetSize( 233, 155 )
		SelectedBlocks:SetPos( menuPosX + 5, menuPosY + 349 )
		SelectedBlocks:SetVisible( true )
		SelectedBlocks:SetDraggable(false)
		SelectedBlocks:SetTitle( "" )
		SelectedBlocks:ShowCloseButton( false )
		SelectedBlocks:MakePopup()
		SelectedBlocks:SetKeyBoardInputEnabled() 
		SelectedBlocks:SetMouseInputEnabled(false) 
		SelectedBlocks:SetSkin( "hns_colored" )
		
	local labelHeader = vgui.Create ( "DLabel", SelectedBlocks )
		labelHeader:SetText("Recently Selected")	
		labelHeader:SetFont(blp_LabelHeaderFont)
		labelHeader:SetPos(50,3)
		labelHeader:SetColor(blp_LabelHeaderColor)
		labelHeader:SizeToContents()	
		
		

		------------------------------------------------------------
		----				Currently Selected 	  			     ---
		------------------------------------------------------------
		CurrentBlockIconBG = vgui.Create ("DPanel", SelectedBlocks)
			CurrentBlockIconBG:SetSize( 104, 104 )
			CurrentBlockIconBG:SetPos( 10, 30 )
		CurrentBlockIconBG.Paint = function()
			BlockIconPaint(self)		--Uses our paint function from the block gui.
		end
		
		CurrentBlockModelIcon = vgui.Create( "DModelPanel", CurrentBlockIconBG )
		CurrentBlockModelIcon:SetModel("models/hns/Normal.mdl")
		CurrentBlockModelIcon.Entity:SetMaterial("models/blocks/bl_bhop")	
		CurrentBlockModelIcon:SetSize( blp_iconSize, blp_iconSize )
		CurrentBlockModelIcon:SetPos( 2,2 )
		CurrentBlockModelIcon:SetCamPos( Vector( 50, 50, 50 ) )
		CurrentBlockModelIcon:SetLookAt( Vector( 0, 0, 0 ) )

		--Prevents model preview from rotating 
		function CurrentBlockModelIcon:LayoutEntity(ent)
			if ( self.bAnimated ) then -- Make it animate normally
				self:RunAnimation()
			end
		end
		
		CurrentBlockModelIcon.DoClick = function()
			SendBlockSettings()
		end
	
			
		CurrentIconLabel = vgui.Create ( "DLabel", CurrentBlockIconBG )
			 CurrentIconLabel:SetText("B-Hop")
			 CurrentIconLabel:SetPos(GetTxtOffset( string.len(CurrentIconLabel:GetText())), 5)
			 CurrentIconLabel:SetFont(blp_BlockFont)
			 CurrentIconLabel:SetColor(blp_BloclFontColor)
			 CurrentIconLabel:SizeToContents()	
					
		local CurrentIconLabelSel = vgui.Create ( "DLabel", SelectedBlocks )
			CurrentIconLabelSel:SetPos(38, 135)
			CurrentIconLabelSel:SetColor(blp_LabelColor)
			CurrentIconLabelSel:SetFont(blp_LabelFont)
			CurrentIconLabelSel:SetText("Selected")
			CurrentIconLabelSel:SizeToContents()			
			
		------------------------------------------------------------
		----				Previously Selected 	  			 ---
		------------------------------------------------------------			
		PrevBlockIconBG = vgui.Create ("DPanel", SelectedBlocks)
			PrevBlockIconBG:SetSize( 104, 104 )
			PrevBlockIconBG:SetPos( 118, 30 )
		PrevBlockIconBG.Paint = function()
			BlockIconPaint(self)
		end	
		
				
		PrevBlockModelIcon = vgui.Create( "DModelPanel", PrevBlockIconBG )
		PrevBlockModelIcon:SetModel("models/hns/Normal.mdl")
		PrevBlockModelIcon.Entity:SetMaterial("models/blocks/bl_death")	
		PrevBlockModelIcon:SetSize( blp_iconSize, blp_iconSize )
		PrevBlockModelIcon:SetPos( 2,2 )
		PrevBlockModelIcon:SetCamPos( Vector( 50, 50, 50 ) )
		PrevBlockModelIcon:SetLookAt( Vector( 0, 0, 0 ) )

		--Prevents model preview from rotating 
		function PrevBlockModelIcon:LayoutEntity(ent)
			if ( self.bAnimated ) then -- Make it animate normally
				self:RunAnimation()
			end
		end
			
		PrevBlockModelIcon.DoClick = function()
			 local blName = PrevIconLabel:GetText()
			local CurrentlySelectedBlock = blp_BlockSettings.Type 
			  
			 PrevIconLabel:SetText(CurrentIconLabel:GetText()) 
			 PrevIconLabel:SetPos(GetTxtOffset( string.len(PrevIconLabel:GetText())), 5)
			 PrevIconLabel:SizeToContents()
			 PrevBlockModelIcon.Entity:SetMaterial("models/blocks/".. blp_BlockSettings.Type)
			 
			 
				
			 CurrentIconLabel:SetText(blName)
			 CurrentIconLabel:SizeToContents()	
			 CurrentIconLabel:SetPos(GetTxtOffset( string.len(blName)), 5)
			 CurrentBlockModelIcon.Entity:SetMaterial("models/blocks/"..  PreviouslySelectBlockClass)	
			 
			 blp_BlockSettings.Type = PreviouslySelectBlockClass
			 PreviouslySelectBlockClass = CurrentlySelectedBlock
			 

		end
			
		PrevIconLabel = vgui.Create ( "DLabel", PrevBlockIconBG )
			PrevIconLabel:SetText("Death")			
			PrevIconLabel:SetPos(GetTxtOffset( string.len(PrevIconLabel:GetText())), 5)
			PrevIconLabel:SetFont(blp_BlockFont)
			PrevIconLabel:SetColor(blp_BloclFontColor)


			
		local IconLabel = vgui.Create ( "DLabel", SelectedBlocks )
			IconLabel:SetPos(145, 135)
			IconLabel:SetColor(blp_LabelColor)
			IconLabel:SetFont(blp_LabelFont)
			IconLabel:SetText("Previous")
			IconLabel:SizeToContents()
	
	
	------------------------------------------------------------
	----		Block Options Menu 	  					     ---
	------------------------------------------------------------
	BlockOptions = vgui.Create ( "DFrame", BlockOptionMenu )
		BlockOptions:SetMouseInputEnabled(false)
		BlockOptions:SetSize( 233, 345 )
		BlockOptions:SetPos(menuPosX + 5, menuPosY +5)
		BlockOptions:SetVisible( true )
		BlockOptions:SetDraggable(false)
		BlockOptions:SetTitle( "" )
		BlockOptions:ShowCloseButton( false )
		BlockOptions:MakePopup()
		BlockOptions:SetKeyBoardInputEnabled() 
		BlockOptions:SetSkin( "hns_colored" )
		
	local labelHeader = vgui.Create ( "DLabel", BlockOptions )
		labelHeader:SetText("Block Options")	
		labelHeader:SetFont(blp_LabelHeaderFont)
		labelHeader:SetPos(65,3)
		labelHeader:SetColor(blp_LabelHeaderColor)
		labelHeader:SizeToContents()		
		
	local label = vgui.Create ( "DLabel", BlockOptions )
		label:SetText("Smart Snap:")	
		label:SetFont(blp_LabelFont)
		label:SetPos(10, 25)
		label:SetColor(blp_LabelColor)
		label:SizeToContents()
		
	SnapOnXY = vgui.Create( "DCheckBoxLabel", BlockOptions )
		SnapOnXY:SetText("Snap to grid.")
		SnapOnXY:SetPos(20,43)
		SnapOnXY:SetValue(1)
		SnapOnXY:SizeToContents()
		SnapOnXY.OnChange = function(pSelf, fValue)
			if fValue then
				RunConsoleCommand("gm_snapgrid", SnapAmount:GetValue())
			else
				RunConsoleCommand("gm_snapgrid", "0")
			end
		end
		
	local label = vgui.Create ( "DLabel", BlockOptions )
		label:SetText("Snap Amount:")	
		label:SetFont(blp_LabelFont)
		label:SetPos(20, 61)
	--	label:SetColor(blp_)
		label:SizeToContents()	
		
	SnapAmount = vgui.Create( "DComboBox", BlockOptions )
		SnapAmount:SetPos(105,61)
		SnapAmount:SetSize( 120, 20 )
		SnapAmount:AddChoice("1")
		SnapAmount:AddChoice("2")
		SnapAmount:AddChoice("4")
		SnapAmount:AddChoice("8")
		SnapAmount:AddChoice("16")
		SnapAmount:AddChoice("32")
		SnapAmount:AddChoice("64")	
		SnapAmount:AddChoice("128")		
		SnapAmount:ChooseOption("4")
		SnapAmount.OpenMenu = function() CustomDComboMenu(pControlOpener,SnapAmount) end
		SnapAmount.OnSelect = function( panel, index, value )
			RunConsoleCommand("gm_snapgrid", value)
		end
		
	local label = vgui.Create ( "DLabel", BlockOptions )
		label:SetText("Block Rotation:")	
		label:SetFont(blp_LabelFont)
		label:SetPos(10, 89)
		label:SetColor(blp_LabelColor)
		label:SizeToContents()	
		
	FlipUpRight = vgui.Create( "DCheckBoxLabel", BlockOptions )
		FlipUpRight:SetText("Flip Block Up-Right.")
		FlipUpRight:SetPos(20,104)
		FlipUpRight:SetValue(0)
		FlipUpRight:SizeToContents()
		FlipUpRight.OnChange = function(pSelf, fValue)
			blp_BlockSettings.FlipUp = fValue
		end		

	RotateBlock = vgui.Create( "DCheckBoxLabel", BlockOptions )
		RotateBlock:SetText("Rotate Block 90 Degrees.")
		RotateBlock:SetPos(20,123)
		RotateBlock:SetValue(0)
		RotateBlock:SizeToContents()					
		RotateBlock.OnChange = function(pSelf, fValue)
			blp_BlockSettings.blRotate = fValue
		end						
  
	local label = vgui.Create ( "DLabel", BlockOptions )
		label:SetText("Block Size:")	
		label:SetFont(blp_LabelFont)
		label:SetPos(10, 148)
		label:SetColor(blp_LabelColor)
		label:SizeToContents()			
		
	SelectBoxSize = vgui.Create( "DComboBox", BlockOptions )
		SelectBoxSize:SetPos(20,166)
		SelectBoxSize:SetSize( 120, 20 )
		SelectBoxSize:SetText( "Select a size" )
		SelectBoxSize:AddChoice("Micro")
		SelectBoxSize:AddChoice("Small")
		SelectBoxSize:AddChoice("Normal")
		SelectBoxSize:AddChoice("Large")
		SelectBoxSize:AddChoice("Pole")	
		SelectBoxSize:AddChoice("Small_Thin")	
		SelectBoxSize:AddChoice("Normal_Thin")	
		SelectBoxSize:AddChoice("Large_Thin")	
		SelectBoxSize:ChooseOption("Normal")
		SelectBoxSize.OpenMenu = function() CustomDComboMenu(pControlOpener,SelectBoxSize) end
		SelectBoxSize.OnSelect = function( panel, index, value )
			blp_BlockSettings.blSize = value
		end
		
	local label = vgui.Create ( "DLabel", BlockOptions )
		label:SetText("Miscellaneous:")	
		label:SetFont(blp_LabelFont)
		label:SetPos(10, 261)
		label:SetColor(blp_LabelColor)
		label:SizeToContents()		
	
	NoCollide = vgui.Create( "DCheckBoxLabel", BlockOptions )
		NoCollide:SetText("No Collide with World.")
		NoCollide:SetPos(20,279)
		NoCollide:SetValue(0)
		NoCollide:SizeToContents()
		NoCollide.OnChange = function(pSelf, fValue)
			blp_BlockSettings.NoCollide = value
			notification.AddLegacy("This currently does not work.", NOTIFY_ERROR, 3)
		end
		
	UpdateBlock = vgui.Create( "DCheckBoxLabel", BlockOptions )
		UpdateBlock:SetText("Update Block to selected Block type.")
		UpdateBlock:SetPos(20,297)
		UpdateBlock:SetValue(1)
		UpdateBlock:SizeToContents()			
		UpdateBlock.OnChange = function(pSelf, fValue)
			blp_BlockSettings.UpdateBlock = value
		end		
			
	TrampolinePower = vgui.Create ( "DNumSlider", BlockOptions  )
		TrampolinePower:SetText( "Trampoline Power" )
		TrampolinePower:SetPos( 10, 315 )
		TrampolinePower:SetSize( BlockOptions:GetWide(), 20 )
		TrampolinePower.TextArea:SetTextColor(Color(255,255,255,255))
		TrampolinePower:SetMinMax( 5, 25 )
		TrampolinePower:SetValue( 8 )
		TrampolinePower:SetDecimals( 0 )
		TrampolinePower:SizeToContents()
		TrampolinePower.OnValueChanged = function( panel, value )
			blp_BlockSettings.TrampPower = value
		end
		
end

