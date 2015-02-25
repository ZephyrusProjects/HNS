ENT.Base = "base_hns_blocks"
ENT.PrintName = "Honey"
ENT.Information = [[Sticky]]
ENT.Category = "hsn_movement"
ENT.Color =  Color(5, 153, 51, 255)

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

		ent:SetWalkSpeed(20)
		ent:SetRunSpeed(20)
		ent:SetJumpPower(85)

    end

	function ENT:EndTouch( ent )
		timer.Simple( .5, function()
			if ( IsValid(ent) and ent:IsPlayer() ) then
				ent:SetWalkSpeed(GM_WalkSpeed)
				ent:SetRunSpeed(GM_RunSpeed)
				ent:SetJumpPower(GM_JumpPower)
			end
		end)
	end
 
end
