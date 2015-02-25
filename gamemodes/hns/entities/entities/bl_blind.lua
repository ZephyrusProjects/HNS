ENT.Base = "base_hns_blocks"
ENT.PrintName = "Blind"
ENT.Information = [[Blinds a player.]]
ENT.Category = "hns_damage"
ENT.Color =  Color(112, 128, 144, 255)

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


	function ENT:Touch( ent )
		if !IsValid(ent:GetGroundEntity()) or ent:GetGroundEntity():GetClass() != self:GetClass() then return end
		
		if ( IsValid(ent) and ent:IsPlayer() ) then
			ent:SetNWFloat("flashTime", CurTime() + 8)
		end
	end
 
end
