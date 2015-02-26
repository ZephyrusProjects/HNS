
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade_thrown.mdl")
ENT.Color = Color(255,0,0,255)

PrecacheParticleSystem("door_pound_core")



function ENT:DamagePlayers()

		local dmg = DamageInfo()
			  dmg:SetAttacker(self.Owner)
			  dmg:SetInflictor(self.Weapon or self)
			  dmg:SetDamageForce(self.Owner:GetAimVector() * 0)
			  dmg:SetDamagePosition(self.Owner:GetPos())
			  dmg:SetDamageType(DMG_BLAST)
		
		
		for k, v in pairs(player.GetAll()) do
			if !v:Alive() then continue end			--Skip iteration if player is dead.
			
			local tracedata = {}
			tracedata.start = self:GetPos() + Vector(0,0,8)		--Make sure the grenade is not in the ground
			tracedata.endpos = v:GetPos() + Vector(0,0,36)		--waist level is somewhere around here. 
			tracedata.filter = {self}
			local trace = util.TraceLine(tracedata)
			
			
			local maxDistance = 256
			local minDistance = 75
			local distance = math.Clamp(trace.StartPos:Distance(trace.HitPos), minDistance, maxDistance)
			
			if distance >= maxDistance then return end
	
			local damage  = (distance / minDistance)
				  damage = math.random(45, 55) / damage
				
				
			if SERVER then	  
				if trace.Hit and trace.Entity:IsPlayer() then
					if v == self:GetOwner() or v:Team() != self:GetOwner():Team() then
						v:SetArmor( v:Armor() - ( damage / math.random(2,3)) )
						v:SetHealth(v:Health() - damage)
							
						dmg:SetDamage(1)			--Can't use 0 as a value or it won't call the HUD
						v:TakeDamageInfo( dmg )		--We do this so it still shows the default HL2 take damage HUD
					end
				end
			end
			
		end
		
end


function ENT:Explode(tr)

	--Prevents grenades from exploding post round
	if GetGlobalVar( "RoundPhase" ) != ROUND_ACTIVE then return end
	
	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
		
		-- pull out of the surface
		if tr.Fraction != 1.0 then
			self:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,6))
		end
		
		local pos = self:GetPos()
		
		-- make sure we are removed, even if errors occur later
		self:Remove()

		
		local effect = EffectData()
			effect:SetStart(pos)
			effect:SetOrigin(pos)
			effect:SetScale(10)
		
		if tr.Fraction != 1.0 then
			effect:SetNormal(tr.HitNormal)
		end
		
		util.Effect("Explosion", effect, true, true)
		ParticleEffect( "door_pound_core", pos + Vector(0,0,4), Angle(0,0,0) )
	
		sound.Play(table.Random({"hns/explode3.wav","hns/explode4.wav","hns/explode5.wav" }), pos, 100, 100)
	end
	
	self:DamagePlayers()
	
	if CLIENT then
		self:SetDetonateExact(0)
	  
		local spos = self:GetPos()
		local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
		util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)    	 
	end
   
end

