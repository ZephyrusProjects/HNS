AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Knife"
	SWEP.BobScale = 1
	SWEP.SwayScale = 1
	SWEP.WepSelectIcon	= surface.GetTextureID( "hns/cstrikeHUD/HUD_knife_sel" )
end

SWEP.UseHands = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel		= "models/weapons/w_knife_t.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.PrimaryDamage = 20

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.SecondaryDamage	    =  55

SWEP.UsePrimaryAttack = false
SWEP.KnifeReach = 52

SWEP.HitSoundElse = "hns/knife_hitwall1.wav"

local knifeSound = {
	"hns/knife_hit1.wav",
	"hns/knife_hit2.wav",
	"hns/knife_hit3.wav",
	"hns/knife_hit4.wav"
}
local knifeSwing = {
	"hns/knife_slash1.wav",
	"hns/knife_slash2.wav"
}



function SWEP:Initialize()
	self:SetWeaponHoldType("knife")
end


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	
	self:SetNextPrimaryFire(CurTime() + 0.7)
	self:EmitSound("hns/knife_deploy1.wav", 70, 100)
	
	return true
end


function SWEP:Holster(wep)
	self:OnRemove()

	return true
end




function SWEP:PrimaryAttack()
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	if IsFirstTimePredicted() then
		self.KnifeReach = 52
		self.UsePrimaryAttack = true
		self:EmitSound(table.Random(knifeSwing), 70, 100)
	end
	
	self.Owner:LagCompensation( true )
	self:Swing()
	self.Owner:LagCompensation( false )
	
	self:SetNextPrimaryFire(CurTime() + 0.6)
	self:SetNextSecondaryFire(CurTime() + 1)

end


function SWEP:SecondaryAttack()

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(197)
	
	if IsFirstTimePredicted() then
		self.KnifeReach = 44
		self.UsePrimaryAttack = false
		self:EmitSound(table.Random(knifeSwing), 70, 100)
	end
	
	self.Owner:LagCompensation( true )
	self:Swing()
	self.Owner:LagCompensation( false )
	
	self:SetNextPrimaryFire(CurTime() + 0.6)
	self:SetNextSecondaryFire(CurTime() + 1)
end


function SWEP:DrawSparks( trace, traceData )

	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetNormal( trace.HitNormal )
	effectdata:SetMagnitude( 0.5 )
	effectdata:SetScale( 0.5 )
	effectdata:SetRadius( 8 )
	util.Effect("Sparks", effectdata)

end


function SWEP:DamagePlayer(ent)

	local usedPrimary = ( self.UsePrimaryAttack ) && true || false

	local dmg = DamageInfo()
	dmg:SetAttacker(self.Owner)
	dmg:SetInflictor(self.Weapon or self)
	dmg:SetDamageForce(self.Owner:GetAimVector() * 0)
	dmg:SetDamagePosition(self.Owner:GetPos())
	dmg:SetDamageType(DMG_SLASH)
	
	if usedPrimary then 
		dmg:SetDamage(self.PrimaryDamage)
	else
		dmg:SetDamage(self.SecondaryDamage)
	end

	--The engine is pushing players when they take damage. We handle damaging players
	--differently to avoid this.
	if ent:Team() != self.Owner:Team() then
		if !ent:IsBot() then
			ent:SetArmor( ent:Armor() - ( dmg:GetDamage() / math.random(2,3)) )
		end
		
		ent:SetHealth(ent:Health() - dmg:GetDamage())
		
		if ent:Health() <= 0 then
			ent:TakeDamageInfo( dmg )	--So it kills the player and shows the death notification 
		end
		
	--	dmg:SetDamage(0)		--We do this so it still shows the HUD you see when you take damage
	--  ent:TakeDamageInfo( dmg )		

	end

end


function SWEP:Swing()

	local traceData = {}
	local trace, ent

	traceData.start = self.Owner:GetShootPos()
	traceData.endpos = traceData.start + self.Owner:GetForward() * self.KnifeReach
	traceData.filter = self.Owner
	traceData.mins = Vector(-8, -8, -8)
	traceData.maxs = Vector(8, 8, 8)
	
	trace = util.TraceHull(traceData)
	
	if trace.Hit then
		local ent = trace.Entity
		local usedPrimary = ( self.UsePrimaryAttack ) && true || false
		local PlayerOrNPC = IsValid( ent ) && ( ent:IsPlayer( ) || ent:IsNPC( ) )
		local sound = table.Random(knifeSound)
	
		if !usedPrimary then 
			sound = "hns/knife_stab.wav"
		end
		
		if PlayerOrNPC then
			ParticleEffect("blood_impact_red_01", trace.HitPos, trace.HitNormal:Angle(), ent)	 
			self:DamagePlayer(ent)
		else
			sound = self.HitSoundElse
			self:DrawSparks( trace, traceData )
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, traceData.endpos) 
		end
	
		if SERVER then
			if !PlayerOrNPC then
				if ( IsValid( ent ) && ent:GetClass() == "func_breakable_surf" ) then
					ent:Input( "Shatter", NULL, NULL, "" )
					sound = "physics/glass/glass_impact_bullet1.wav"
				elseif IsValid( ent ) then
					sound = self.HitSoundElse
				end
			end
		end

		self:EmitSound( sound , 80, 100 )
	else
			--Biffed it, you didn't hit shit
	end
	
end


if CLIENT then
	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end


function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	local w, h = surface.GetTextureSize( self.WepSelectIcon )
	w = w * 1.5
	h = h * 1.5
	
	surface.SetDrawColor( HUD_Color )
	surface.SetTexture ( self.WepSelectIcon )
	surface.DrawTexturedRect( x + 10, y, w, h )
	
end
