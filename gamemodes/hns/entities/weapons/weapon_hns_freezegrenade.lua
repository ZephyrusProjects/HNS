AddCSLuaFile()
   
SWEP.HoldType = "grenade"

if CLIENT then
   SWEP.WepSelectIcon		= surface.GetTextureID( "hns/cstrikeHUD/HUD_freezegren" )
   SWEP.AmmoIcon		= surface.GetTextureID( "hns/cstrikeHUD/fg_ammo" )
   SWEP.PrintName = "Freeze Grenade"
   SWEP.Slot         = 3
   SWEP.SlotPos	  = 2
   SWEP.IconLetter = "P"
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.detonate_timer = 2

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.AutoSpawnable      = false
SWEP.UseHands			= true
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.ClipSize		= 1
SWEP.ViewModel			= "models/weapons/v_icegrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_icegrenade.mdl"
SWEP.Weight			= 5

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )


function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")
end


function SWEP:GetGrenadeName()
   return "hns_freezegrenade_proj"
end

