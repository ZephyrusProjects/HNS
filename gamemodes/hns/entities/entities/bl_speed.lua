ENT.Base = "base_hns_blocks"
ENT.PrintName = "Sonic Boots"
ENT.Information = [[Run like Sonic!]]
ENT.Category = "hns_powerups"
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
		if table.HasValue(ent.powerUps, "SpeedBoost") then return end
		
		if ( IsValid(ent) and ent:IsPlayer() and ent:Team() != TEAM_SEEKER ) then
			table.insert(ent.powerUps, "SpeedBoost")
			ent:SetWalkSpeed(345)
			ent:EmitSound("hns/bootsofspeed.wav", 360, 100)
			ent:SendLua([[PowerUpNotify("Speed Boost")]])
			
			timer.Simple( self.PowerUpLength, function()
				if ( IsValid(ent) and ent:IsPlayer() ) then
					ent:SetWalkSpeed(GM_WalkSpeed)
				end
			end)	
		end
		
	end
	
end
