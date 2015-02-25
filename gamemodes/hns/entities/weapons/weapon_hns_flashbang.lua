AddCSLuaFile()
 
SWEP.HoldType = "grenade"


if CLIENT then
    SWEP.WepSelectIcon		= surface.GetTextureID( "hns/cstrikeHUD/HUD_flashbang" )
    SWEP.AmmoIcon		= surface.GetTextureID( "hns/cstrikeHUD/fb_ammo" )	
	SWEP.PrintName    = "FlashBang"
    SWEP.Slot         = 3
	SWEP.SlotPos	  = 1
    SWEP.IconLetter = "P"
  
   SWEP.ViewModelFlip = true
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.UseHands			= true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.ClipSize		= 1
SWEP.LimitedStock = true
SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight			= 5

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )


function SWEP:GetGrenadeName()
   return "hns_flashgrenade_proj"
end

