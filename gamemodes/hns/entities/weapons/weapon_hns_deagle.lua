
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Deagle"
    SWEP.WepSelectIcon		= surface.GetTextureID( "hns/cstrikeHUD/HUD_deagle_sel" )
	SWEP.AmmoIcon		    = surface.GetTextureID( "hns/cstrikeHUD//50cal_ammo" )
end

SWEP.UseHands = true

SWEP.Base = "weapon_hns_base"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.HoldType = "pistol"

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.PrimaryDamage = 50
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.SecondaryDamage	    =  0

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

function SWEP:SecondaryAttack()
	return
end
