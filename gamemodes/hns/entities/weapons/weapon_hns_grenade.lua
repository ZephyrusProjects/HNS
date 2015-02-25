AddCSLuaFile()

SWEP.HoldType = "grenade"


if CLIENT then
   SWEP.WepSelectIcon		= surface.GetTextureID( "hns/cstrikeHUD/HUD_grenade" )
   SWEP.AmmoIcon		= surface.GetTextureID( "hns/cstrikeHUD/he_ammo" )   
   SWEP.PrintName = "HE-Grenade"
   SWEP.Slot = 4
   SWEP.SlotPos	= 0
   SWEP.IconLetter = "O"
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.Spawnable = true


SWEP.AutoSpawnable      = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.ClipSize		= 1
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight			= 5

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "hns_grenade_proj"
end

