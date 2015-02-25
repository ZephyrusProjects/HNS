ENT.Base = "base_hns_blocks"
ENT.PrintName = "Invincibility"
ENT.Information = [[Enables GodMode.]]
ENT.Category = "hns_powerup"
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


	function ENT:StartTouch( ent )
		if !IsValid(ent:GetGroundEntity()) or ent:GetGroundEntity():GetClass() != self:GetClass() then return end
		if GetGlobalVar( "RoundPhase" ) != ROUND_ACTIVE then return end
		if table.HasValue(ent.powerUps, "Invincibility") then return end	--Gets cleared on player spawn.
		
		if ( IsValid(ent) and ent:IsPlayer() and ent:Team() != TEAM_SEEKER ) then
			table.insert(ply.powerUps, Invincibility)
			ent:EmitSound("hns/divineshield.wav", 360, 100)
			ent:GodEnable()
			ent:SetMaterial("Models/props_combine/portalball001_sheet")	
			ent:SendLua([[PowerUpNotify("God Mode")]])
				
			timer.Simple( self.PowerUpLength, function()
				if IsValid(ent) and ent:IsPlayer() then
					ent:GodDisable()
					ent:SetMaterial("")	
				end
			end)
		end
	end
 
end
