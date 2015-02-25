ENT.Base = "base_hns_blocks"
ENT.PrintName = "Window"
ENT.Information = [[A transparent barrier.]]
ENT.Category = "hns_blocks"
ENT.Color = Color(255, 255, 255, 100)

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

end
