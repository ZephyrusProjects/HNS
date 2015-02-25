ENT.Base = "base_hns_blocks"
ENT.PrintName = "Invisibility"
ENT.Information = [[Invisibility]]
ENT.Category = "hns_powerup"
ENT.Color =  Color(73, 255, 247, 255)

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
		if table.HasValue(ent.powerUps, "Invisibility") then return end		--Gets cleared on player spawn.
		
		if ( IsValid(ent) and ent:IsPlayer() and ent:Team() != TEAM_SEEKER ) then
			table.insert(ent.powerUps, "Invisibility")
			ent:EmitSound("hns/stealth.wav", 360, 100)
			ent:SetRenderMode( RENDERMODE_TRANSALPHA )
			ent:SetColor( Color(255, 255, 255, 0) )
			ent:SendLua([[PowerUpNotify("Invisibility")]])
			
			for k,v in pairs(ent:GetWeapons()) do
				v:SetNoDraw(true)
			end
			
			timer.Simple( self.PowerUpLength, function()
				if ( IsValid(ent) and ent:IsPlayer() ) then
					ent:SetRenderMode( RENDERMODE_NORMAL )
					ent:SetColor( Color(255, 255, 255, 255) )
					
					for k,v in pairs(ent:GetWeapons()) do
						v:SetNoDraw(false)
					end
				end
			end)	
		end
		
	end
 
end

