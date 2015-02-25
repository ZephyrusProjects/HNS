ENT.Base = "base_hns_blocks"
ENT.PrintName = "Slap"
ENT.Information = [[You got knocked the fuck out!]]
ENT.Category = "hns_damage"
ENT.Color =  Color(53, 50, 204, 255)


local slapSounds = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav",
}


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
			
		if ent:Health() <= 0 then
			ent:Kill()
			return
		end
		
		local slapSound =  "physics/body/body_medium_impact_hard" ..math.random(1,7).. ".wav"
		ent:EmitSound( slapSound, 100, 100 )
		ent:SetHealth(ent:Health() - 10)
		
		ent:SetVelocity( Vector(math.random( -100, 100 ),math.random( -100, 100 ), 0) + Vector (0,0,256) )
		ent:ViewPunch( Angle( math.random( -170, 170 ), math.random( -170, 170 ), 0 ) )
    end
	
end

