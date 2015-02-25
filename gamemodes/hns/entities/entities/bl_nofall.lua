ENT.Base = "base_hns_blocks"
ENT.PrintName = "NoFall"
ENT.Information = [[No Fall DMG.]]
ENT.Category = "hns_blocks"
ENT.Color =  Color(215, 153, 151, 255)

--We take care of the fall damange mechanics in the GM.
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