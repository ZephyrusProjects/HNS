--This is one of the first things I did for the GM, please forgive me for my sins :)


blp_iconSize = 100	
	
blp_LabelColor = Color(0,255,0, 155)
blp_LabelFont = "Trebuchet18"

blp_BlockFont = "BudgetLabel"
blp_BloclFontColor = Color (255,255,255)

blp_LabelHeaderColor = Color(255,153,50, 255)
blp_LabelHeaderFont = "MenuLarge"	
	

blp_DefaultSettings = {
	blSize = "Normal",
	Type = "bl_bhop",
		
	FlipUp = "false",
	blRotate = "false",
	
	SnapXY = "true",
	SnapZ = "true",

	TrampPower = 10,
	UpdateBlock = "false",
	NoCollide = "false"
}


BlockList = {
{BlockName="Awp", BlockClass="bl_awp", BlockCategory="Weapons", BlockIsPrimary="false" },
{BlockName="Barrier", BlockClass="bl_barrier", BlockCategory="", BlockIsPrimary="true" },
{BlockName="B-Hop", BlockClass="bl_bhop", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="B-Hop Delay", BlockClass="bl_bhop_delay", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="Blind", BlockClass="bl_blind", BlockCategory="Damage", BlockIsPrimary="false" },
{BlockName="Booster", BlockClass="bl_booster", BlockCategory="Movement", BlockIsPrimary="false" },
{BlockName="Deagle", BlockClass="bl_deagle", BlockCategory="Weapons", BlockIsPrimary="false" },
{BlockName="Death", BlockClass="bl_death", BlockCategory="Damage", BlockIsPrimary="true" },
{BlockName="Fire", BlockClass="bl_fire", BlockCategory="Damage", BlockIsPrimary="false" },
{BlockName="Flash Bang", BlockClass="bl_flashbang", BlockCategory="Weapons", BlockIsPrimary="false" },
{BlockName="Freeze Gren.", BlockClass="bl_freezegrenade", BlockCategory="Weapons", BlockIsPrimary="false" },
{BlockName="God", BlockClass="bl_god", BlockCategory="PowerUps", BlockIsPrimary="false" },
{BlockName="Gravity", BlockClass="bl_gravity", BlockCategory="Movement", BlockIsPrimary="false" },
{BlockName="Grenade", BlockClass="bl_grenade", BlockCategory="Weapons", BlockIsPrimary="false" },
{BlockName="Health", BlockClass="bl_health", BlockCategory="PowerUps", BlockIsPrimary="false" },
{BlockName="Hiders", BlockClass="bl_hider", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="Honey", BlockClass="bl_honey", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="Ice", BlockClass="bl_ice", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="Invisibility", BlockClass="bl_invisibility", BlockCategory="PowerUps", BlockIsPrimary="false" },
{BlockName="No Fall", BlockClass="bl_nofall", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="Platform", BlockClass="bl_platform", BlockCategory="", BlockIsPrimary="true" },
{BlockName="Seeker", BlockClass="bl_seeker", BlockCategory="Movement", BlockIsPrimary="true" },
{BlockName="Slap", BlockClass="bl_slap", BlockCategory="Damage", BlockIsPrimary="false" },
{BlockName="Speed", BlockClass="bl_speed", BlockCategory="PowerUps", BlockIsPrimary="true" },
{BlockName="Trampoline", BlockClass="bl_trampoline", BlockCategory="Movement", BlockIsPrimary="true" }
}



--I had to do this like an asshole but it's the only way I
--could get the mouse to work 100% as intended.
function blp_ShowMouse()

	if input.IsKeyDown(KEY_LALT) then
		gui.EnableScreenClicker(true)
		BlockSpawnMenu:SetMouseInputEnabled(true) 
		BlockTabs:SetMouseInputEnabled(true) 
		BlockScrollPanel:SetMouseInputEnabled(true) 
		SelectedBlocks:SetMouseInputEnabled(true) 
		BlockOptions:SetMouseInputEnabled(true) 
		CurrentBlockIconBG:SetMouseInputEnabled(true) 
		PrevBlockIconBG:SetMouseInputEnabled(true) 
	else
		gui.EnableScreenClicker( false )
		BlockScrollPanel:SetMouseInputEnabled(false) 
		BlockTabs:SetMouseInputEnabled(false) 
		BlockSpawnMenu:SetMouseInputEnabled(false) 
		SelectedBlocks:SetMouseInputEnabled(false) 
		BlockOptions:SetMouseInputEnabled(false) 
		CurrentBlockIconBG:SetMouseInputEnabled(false) 
		PrevBlockIconBG:SetMouseInputEnabled(false) 
	end
	
end	


--Sends our table of settings to the server
--to spawn the block with the correct settings
function SendBlockSettings()
	net.Start( "SendBlocks" )
		net.WriteTable(blp_BlockSettings)
	net.SendToServer()
end

--Sad but the only way I could get a dlabel to center
function GetTxtOffset(stringLength)
	txtOffset = ((100 / 2) - (stringLength) * 3.5)
	return txtOffset
end

