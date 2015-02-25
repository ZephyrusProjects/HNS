--This is a hard coded gmod tool. I didn't want to make my game mode
--derive from sandbox and I also didn't want to include the dozen files
--needed for tools. 


AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon		= surface.GetTextureID( "vgui/gmod_tool" )
	SWEP.Gradient			= surface.GetTextureID( "gui/gradient" )
	SWEP.InfoIcon			= surface.GetTextureID( "gui/info" )
	SWEP.DrawCrosshair = false
	SWEP.BounceWeaponIcon = false
	SWEP.DrawWeaponInfoBox = false
	SWEP.PrintName = "Teleport Placer"
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
	SWEP.ViewbobIntensity = 1
	SWEP.ViewbobEnabled = true
	
	
surface.CreateFont( "GModToolName",
{
	font		= "Roboto Bk",
	size		= 80,
	weight		= 1000
})

surface.CreateFont( "GModToolSubtitle",
{
	font		= "Roboto Bk",
	size		= 24,
	weight		= 1000
})

surface.CreateFont( "GModToolHelp",
{
	font		= "Roboto Bk",
	size		= 17,
	weight		= 1000
})

end


SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Author			= ""
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= ""


SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"
SWEP.AnimPrefix			= "python"

SWEP.UseHands			= true
SWEP.Spawnable			= true

SWEP.HelpText			= "Left Click to place teleport entrance."
SWEP.TeleportEntrance   = 0 --Store the ent, so we can change it later on

-- Be nice, precache the models
util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

-- Todo, make/find a better sound.
SWEP.ShootSound			= Sound( "Airboat.FireGunRevDown" )

SWEP.Tool				= {}

SWEP.Primary = 
{
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.Secondary = 
{
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.ToolNameHeight		= 0
SWEP.InfoBoxHeight		= 0


--[[---------------------------------------------------------
	The shoot effect
-----------------------------------------------------------]]
function SWEP:DoShootEffect( hitpos, hitnormal, entity, physbone, bFirstTimePredicted )

	self.Weapon:EmitSound( self.ShootSound	)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 	-- View model animation
	
	-- There's a bug with the model that's causing a muzzle to 
	-- appear on everyone's screen when we fire this animation. 
	self.Owner:SetAnimation( PLAYER_ATTACK1 )			-- 3rd Person Animation
	
	if ( !bFirstTimePredicted ) then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( hitpos )
		effectdata:SetNormal( hitnormal )
		effectdata:SetEntity( entity )
		effectdata:SetAttachment( physbone )
	util.Effect( "selection_indicator", effectdata )	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( hitpos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
	
end

--[[---------------------------------------------------------
	Trace a line then send the result to a mode function
-----------------------------------------------------------]]
function SWEP:PrimaryAttack(ply, entity, physobject )

	if ( !IsFirstTimePredicted( ) ) then return; end
	if string.find(self.HelpText, "Right") == 1 then return; end 	--Prevents player from spawning multiple entrances

	local tr = util.GetPlayerTrace( self.Owner )
	tr.mask = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	
	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
	
	local Entity = trace.Entity	
	if ( Entity:IsPlayer() ) then return false end
	
	if SERVER then 
		local teleport = ents.Create( "bl_tele" )		--Spawns teleport entrance
		teleport:SetPos( trace.HitPos + Vector(0, 0, 32))

		teleport.Spawn(teleport)
		teleport:Activate()
		
		--Store the ent so we can change some variables in the SecondaryAttack
		self.TeleportEntrance = teleport:EntIndex()

	end
	
	self.HelpText = "Right Click to place teleport exit."
	
end


--[[---------------------------------------------------------
	SecondaryAttack - Reset everything to how it was
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()

	if ( !IsFirstTimePredicted( ) ) then return; end
	if string.find(self.HelpText, "Left") == 1 then return; end  --Prevents player from spawning multiple exits

	local tr = util.GetPlayerTrace( self.Owner )
	tr.mask = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
	
	local Entity = trace.Entity	
	if ( Entity:IsPlayer() ) then return false end
	
	if SERVER then 
		local teleport = ents.Create( "bl_tele_exit" )		--Spawns teleport exit
			teleport:SetPos( trace.HitPos + Vector(0, 0, 32))
			teleport.Spawn(teleport)
			teleport:Activate()
		
		--Our tele entrance we just placed.
		local teleEntrance = ents.GetByIndex(self.TeleportEntrance)
		
		--We use this to match each portal with a unique number. This is 
		--later used for syncing the portals.
		local totalTeleports = table.Count(ents.FindByClass("bl_tele")) + 1
		
		teleEntrance.TeleportNumber = GAMEMODE.TeleportIndex
		teleport.TeleportNumber =  GAMEMODE.TeleportIndex
		GAMEMODE.TeleportIndex = GAMEMODE.TeleportIndex + 1
		
		teleEntrance.TeleportPosition = teleport	--Sets the tele exit as the entity to reference for a tele position.
	end
	
	
	self.HelpText = "Left Click to place teleport entrance."
	
end


--[[---------------------------------------------------------
	Draws the help on the HUD (disabled if gmod_drawhelp is 0)
-----------------------------------------------------------]]
function SWEP:DrawHUD()
	
	local mode = "Remover"
	
	-- Don't draw help for a nonexistant tool!
--	if ( !self:GetToolObject() ) then return end
	
--	self:GetToolObject():DrawHUD()
	
	
	-- This could probably all suck less than it already does
	
	
	local x, y = 50, 25
	local w, h = 0, 0
	
	local TextTable = {}
	local QuadTable = {}
	
	QuadTable.texture 	= self.Gradient
	QuadTable.color		= Color( 10, 10, 10, 180 )
	
	QuadTable.x = 0
	QuadTable.y = y-8
	QuadTable.w = 600
	QuadTable.h = self.ToolNameHeight - (y-8)
	draw.TexturedQuad( QuadTable )
	
	TextTable.font = "GModToolName"
	TextTable.color = Color( 240, 240, 240, 255 )
	TextTable.pos = { x, y }
	TextTable.text = "Teleport Placer"
	
	w, h = draw.TextShadow( TextTable, 2 )
	y = y + h

	TextTable.font = "GModToolSubtitle"
	TextTable.pos = { x, y }
	TextTable.text = "Teleport Placement Tool"
	w, h = draw.TextShadow( TextTable, 1 )
	y = y + h + 8
	
	self.ToolNameHeight = y
	
	--y = y + 4
	
	QuadTable.x = 0
	QuadTable.y = y
	QuadTable.w = 600
	QuadTable.h = self.InfoBoxHeight
	local alpha =  math.Clamp( 0, 10, 0 )
	QuadTable.color = Color( alpha, alpha, alpha, 230 )
	draw.TexturedQuad( QuadTable )
		
	y = y + 4
	
	TextTable.font = "GModToolHelp"
	TextTable.pos = { x + self.InfoBoxHeight, y  }
	TextTable.text = self.HelpText
	w, h = draw.TextShadow( TextTable, 1 )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( self.InfoIcon )
	surface.DrawTexturedRect( x+1, y+1, h-3, h-3 )	
	
	self.InfoBoxHeight = h + 8
	
end

if CLIENT then

	local matScreen 	= Material( "models/weapons/v_toolgun/screen" )
	local txidScreen	= surface.GetTextureID( "models/weapons/v_toolgun/screen" )
	local txRotating	= surface.GetTextureID( "pp/fb" )

	local txBackground	= surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )


	-- GetRenderTarget returns the texture if it exists, or creates it if it doesn't
	local RTTexture 	= GetRenderTarget( "GModToolgunScreen", 256, 256 )

	surface.CreateFont( "GModToolScreen",
	{
		font		= "Helvetica",
		size		= 60,
		weight		= 900
	})


	local function DrawScrollingText( text, y, texwide )

		local w, h = surface.GetTextSize( text  )
		w = w + 64
		
		local x = math.fmod( CurTime() * 400, w ) * -1;
		
		while ( x < texwide ) do
		
			surface.SetTextColor( 0, 0, 0, 255 )
			surface.SetTextPos( x + 3, y + 3 )
			surface.DrawText( text )
				
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( x, y )
			surface.DrawText( text )
			
			x = x + w
			
		end

	end

	--[[---------------------------------------------------------
		We use this opportunity to draw to the toolmode 
			screen's rendertarget texture.
	-----------------------------------------------------------]]
	function SWEP:RenderScreen()
		
		local TEX_SIZE = 256
		local mode 	= "Teleport Placement Tool"
		local NewRT = RTTexture
		local oldW = ScrW()
		local oldH = ScrH()
		
		-- Set the material of the screen to our render target
		matScreen:SetTexture( "$basetexture", NewRT )
		
		local OldRT = render.GetRenderTarget();
		
		-- Set up our view for drawing to the texture
		render.SetRenderTarget( NewRT )
		render.SetViewPort( 0, 0, TEX_SIZE, TEX_SIZE )
		cam.Start2D()
		
			-- Background
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( txBackground )
		surface.DrawTexturedRect( 0, 0, TEX_SIZE, TEX_SIZE )
				
		surface.SetFont( "GModToolScreen" )
		DrawScrollingText( mode, 64, TEX_SIZE )


		cam.End2D()
		render.SetRenderTarget( OldRT )
		render.SetViewPort( 0, 0, oldW, oldH )
		
	end
	
end

