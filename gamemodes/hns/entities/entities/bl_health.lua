ENT.Base = "base_hns_blocks"
ENT.PrintName = "Health"
ENT.Information = [[Emits Health]]
ENT.Category = "hns_powerups"
ENT.Color =  Color(165, 42, 42, 255 )

if (SERVER) then

	AddCSLuaFile()

 
	local healsound = Sound("items/medshot4.wav")
	local last_sound_time = 0
	local last_heal_time = 0

	
	function ENT:Initialize()
		self:SetModel("models/hns/Normal.mdl")
		self:SetMaterial("models/blocks/" .. self:GetClass() )
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
		end
	end

	
	function Givehealth( ent )
		if ( !IsValid(ent) and !ent:IsPlayer() ) then return end
		
		local health = ent:Health()
		local maxhealth = 100
		
        if (health < maxhealth) then
            ent:SetHealth( health + 2 )
        else
            ent:SetHealth(maxhealth)
        end
		
		if (last_sound_time + 3 < CurTime() and ( health < maxhealth )) then
			ent:EmitSound(healsound)
            last_sound_time = CurTime()
        end
	end
 

	function ENT:Touch( ent )
		if !IsValid(ent:GetGroundEntity()) or ent:GetGroundEntity():GetClass() != self:GetClass() then return end
        if last_heal_time + 1 > CurTime() then return end
		
		last_heal_time = CurTime()
		Givehealth(ent)
    end
 
end
