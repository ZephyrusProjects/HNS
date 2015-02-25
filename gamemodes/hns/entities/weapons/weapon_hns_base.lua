
AddCSLuaFile()


if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.BobScale = 1
	SWEP.SwayScale = 1
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
end


SWEP.UseHands = true

SWEP.Base 				= "weapon_base"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false

SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.Cone			= 0.1
SWEP.Primary.Delay			= 0.5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )


function SWEP:Deploy()

	self:SendWeaponAnim(ACT_VM_DRAW)
	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	return true
end

function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	
	if IsFirstTimePredicted() then
		self.Weapon:EmitSound( self.Primary.Sound )
	end

	
	self.Owner:LagCompensation( true )
	self:ShootBullet( self.Primary.Damage, 1, self.Primary.Cone )
	self.Owner:LagCompensation( false )
	
	
	self:TakePrimaryAmmo( 1 )

	
	self.Owner:ViewPunch( Angle( -5, math.random(-.25, .25), math.random(-.25, .25) ) )

end



function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	--draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 125 ), TEXT_ALIGN_CENTER )	
	local w, h = surface.GetTextureSize( self.WepSelectIcon )
		w = w * 1.5
		h = h * 1.5
	surface.SetDrawColor( HUD_Color )
	surface.SetTexture ( self.WepSelectIcon )
	surface.DrawTexturedRect( x + 10, y, w, h )
end


