ENT.Base = "base_hns_blocks"
ENT.PrintName = "Grenade"
ENT.Information = [[Drops Grenade.]]
ENT.Category = "hns_weapons"
ENT.Color =  Color( 0, 51, 0, 255)

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
		if ent:HasWeapon( "weapon_hns_grenade" ) then return end		--We dont want them stocking up on grenades.	
		if table.HasValue(ent.powerUps, "Grenade") then return end	--Gets cleared on player spawn.
		
		
		if ( IsValid(ent) and ent:IsPlayer() and ent:Team() != TEAM_SEEKER ) then
			table.insert(ent.powerUps, "Grenade")
			ent:Give( "weapon_hns_grenade" )
		end
	end

end
