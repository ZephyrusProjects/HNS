
AddCSLuaFile()

if CLIENT then
    SWEP.WepSelectIcon	=	surface.GetTextureID( "hns/cstrikeHUD/HUD_fists" )
end

SWEP.PrintName	= "Hands"

SWEP.Spawnable	= false
SWEP.DrawAmmo	= false

SWEP.ViewModel	= "models/weapons/c_arms_cstrike.mdl"
SWEP.WorldModel	= ""		--We just need to see the players hands, so we can leave this blank. 

util.PrecacheModel( SWEP.ViewModel )

SWEP.ViewModelFOV	= 55
SWEP.Slot			= 2
SWEP.SlotPos		= 0

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.UseHands	= true


function SWEP:Initialize()
	self:SetWeaponHoldType( "normal")
end


--Fixes multiple hands showing up.
function SWEP:PreDrawViewModel( vm, wep, ply )
	vm:SetMaterial( "" )
end


--Our hands are just for looks, so we do not want anything to happen in
--the attack function
function SWEP:PrimaryAttack()
	return false
end


function SWEP:SecondaryAttack()
	return false
end


function SWEP:Deploy()
	local viewModel = self.Owner:GetViewModel()
	viewModel:SendViewModelMatchingSequence( viewModel:LookupSequence( "fists_draw" ) )

	return true
end


--Removes our hands on Holster
function SWEP:Holster( wep )
	self:OnRemove()

	return true
end


function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	local w, h = surface.GetTextureSize( self.WepSelectIcon )
		w = w * 1.5
		h = h * 1.5
	surface.SetDrawColor( HUD_Color )
	surface.SetTexture ( self.WepSelectIcon )
	surface.DrawTexturedRect( x + 10, y, w, h )
end
