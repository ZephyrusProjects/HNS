ENT.Base = "base_hns_blocks"
ENT.PrintName = "Fire"
ENT.Information = [[Flames]]
ENT.Category = "hns_damage"
ENT.Color =  Color(255, 153, 51, 255)

if (SERVER) then

	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/hns/Normal.mdl")
		self:SetMaterial("models/blocks/" .. self:GetClass() )
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake() 
		end
	end

	
	function ENT:Touch(ent)
		if !IsValid(ent:GetGroundEntity()) or ent:GetGroundEntity():GetClass() != self:GetClass() then return end
		
		if ( IsValid(ent) and ent:IsPlayer() ) then
			ent:Ignite(5,0)      --Lights Player on fire
			self:Ignite(5,0)	 --Lights the Block on fire
			timer.Simple( 1, function() self:Extinguish() end)
		end
	end
 
end