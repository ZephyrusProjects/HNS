
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "AWP"
    SWEP.WepSelectIcon		= surface.GetTextureID( "hns/cstrikeHUD/HUD_awp_sel" )
    SWEP.AmmoIcon		= surface.GetTextureID( "hns/cstrikeHUD/338cal_ammo" )
end

SWEP.UseHands = true

SWEP.Base = "weapon_hns_base"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.HoldType = "ar2"

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		=	 "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel		= 	 "models/weapons/w_snip_awp.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.PrimaryDamage = 200
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.SecondaryDamage	    =  0
SWEP.IsScoped 				= false

SWEP.Primary.Sound			= Sound("Weapon_AWP.Single")
SWEP.Secondary.Sound 		= Sound("Default.Zoom")


function SWEP:SecondaryAttack()
	if IsFirstTimePredicted() then
		self.Weapon:EmitSound( self.Secondary.Sound )
		self.IsScoped = !self.IsScoped
		
		if self.IsScoped then
			self.Owner:SetFOV(32, .3)
		else
			self.Owner:SetFOV(0, .15)
		end
		
	end
end


function SWEP:Holster()
	self.IsScoped = false

	return true
end

if CLIENT then

   local scope_lens = surface.GetTextureID("sprites/scope")
   
   function SWEP:DrawHUD()
   
		if !self.IsScoped then return end
         
         local x = ScrW() / 2
         local y = ScrH() / 2
		 
		--Set the scope texture
         surface.SetTexture(scope_lens)
         surface.SetDrawColor(255, 255, 255, 255)
         surface.DrawTexturedRectRotated(x, y, ScrH() + 2,  ScrH() + 2 , 0)
		
		--Fills in around the sprite
		 local w = x / 2.25
		 surface.SetDrawColor( 0, 0, 0, 255 )
		 surface.DrawRect( 0,0, w, ScrH() )
		 surface.DrawRect( ScrW() - w + 2,0, w, ScrH() )	
		 
		 --Draw some lines for the crosshair
		 surface.DrawLine( x + y, y, x - y, y )
		 surface.DrawLine( x, y + y, x , y - y )
	
	end
	
end

