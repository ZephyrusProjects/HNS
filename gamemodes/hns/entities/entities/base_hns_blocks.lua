ENT.Type = "anim"
ENT.PrintName = "blocks"
ENT.Author = "Swifty"
ENT.Information = [[Put shit here]]
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.Category = "hns_blocks"
ENT.Color =  Color( 255, 0, 0, 255)
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PowerUpLength = GetConVarNumber("hns_poweruplength_seconds")
ENT.BlockOwner = "base"


if (SERVER) then

	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube1x1x025.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionBounds( self:OBBMins(),self:OBBMaxs() )
		
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then 
			phys:Wake() 
		end
		
	end
	
	
	function ENT:SpawnFunction( ply, tr ) 
		if ( !tr.Hit ) then return end 

		local SpawnPos = tr.HitPos + tr.HitNormal * 16 
	
		local ent = ents.Create( self.Classname ) 
		ent:SetPos( SpawnPos ) 
		ent:Spawn() 
		ent:Activate() 

		return ent 
	 end 

end

function ENT:SetupDataTables()
	self:NetworkVar( "String", "0", "BlockOwner" )
end


if ( CLIENT ) then

	function ENT:Initialize()	
		local owner = self:GetBlockOwner()
		self.BlockOwner = owner
	end
	
	
	function ENT:Draw()
		self:DrawModel()
	end

end
