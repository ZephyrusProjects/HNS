ENT.Base = "base_hns_blocks"
ENT.PrintName = "Ice"
ENT.Information = [[Slippery]]
ENT.Category = "hns_movement"
ENT.Color =  Color(175, 238, 238, 255)

--We handle the rest in the sh_ice.lua

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
		if ent:GetNWBool("OnIce") then return end
		
		local playerSpeed = ent:GetVelocity()
		playerSpeed.z = 0		--we do this to ignore fallspeed
		playerSpeed = math.Round(playerSpeed:Length())
		ent:SetNWBool("OnIce", true)
		ent:SetNWFloat("Speed", playerSpeed )
		ent:SetWalkSpeed(55)
		ent:SetRunSpeed(55)
	end

	
	function ENT:EndTouch( ent )
		if IsValid(ent:GetGroundEntity()) and ent:GetGroundEntity():GetClass() == self:GetClass() then
			ent:SetNWBool("OnIce", true)
		else
			ent:SetNWBool("OnIce", false)
			ent:SetWalkSpeed(GM_WalkSpeed)
			ent:SetRunSpeed(GM_RunSpeed)
		end
	end
	
end
