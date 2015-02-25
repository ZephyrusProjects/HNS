ENT.Base = "base_hns_blocks"
ENT.PrintName = "Deagle"
ENT.Information = [[Gives a player a deagle.]]
ENT.Category = "hns_weapons"
ENT.Color =  Color(0, 51, 0, 255)

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

	
	 function ENT:StartTouch( ent )
		if !IsValid(ent:GetGroundEntity()) or ent:GetGroundEntity():GetClass() != self:GetClass() then return end
		if GetGlobalVar( "RoundPhase" ) != ROUND_ACTIVE then return end
		 
		 if ( IsValid(ent) and ent:IsPlayer() and ent:Team() != TEAM_SEEKER ) then
			ent:Give( "weapon_hns_deagle" )
		end
	end

end
