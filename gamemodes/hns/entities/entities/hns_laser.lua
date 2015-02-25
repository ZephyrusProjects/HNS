
AddCSLuaFile()

ENT.Type = "anim"
ENT.Color = Color(50, 255, 50, 100)
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:Initialize()

	self:DrawShadow(false)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	if SERVER then
		self:SetTrigger(true)
	end

end


function ENT:SetLaserVector(EndPosition)

	self:SetNWVector("endPos", EndPosition)	
	self:SetCollisionBoundsWS(self:GetPos(), EndPosition)
	
end


function ENT:GetLaserVector()

	return self:GetNWVector("endPos", Vector(0,0,0))
	
end


if SERVER then

	function ENT:Touch(ent)

		local parent = self:GetParent()
		
		if !IsValid(parent) then
			self:Remove()
		end
		
		--Prevents friendly's from setting off lasers
		if ent:IsPlayer() then
			if ent == parent:GetOwner() or ent:Team() != parent:GetOwner():Team() then
				local spos = parent:GetPos()
				local tr = util.TraceLine({start=spos, EndPosition=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})	
				parent:Explode(tr)
			end
		end
			
	end

end


if CLIENT then

	function ENT:Think()
		self:SetRenderBoundsWS(self:GetLaserVector(), self:GetPos())
	end

	function ENT:Draw()
		
		if self:GetLaserVector() == Vector(0,0,0) then return end
		
		render.SetMaterial(Material( "sprites/bluelaser1" ))
		render.DrawBeam(self:GetLaserVector(), self:GetPos(), 2, 1, 0, self:GetParent().Color)
		render.DrawBeam(self:GetLaserVector(), self:GetPos(), 5, 1, 0,  self:GetParent().Color)
		
		render.SetMaterial(Material( "effects/blueflare1" ))
		render.DrawQuadEasy(self:GetLaserVector(), self:GetPos() - self:GetLaserVector(), math.Rand(2, 5), math.Rand(2, 5), self:GetParent().Color)
		 
	end

end