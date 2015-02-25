ENT.Base = "base_hns_blocks"
ENT.PrintName = "Hiders"
ENT.Information = [[Only Hiders may pass.]]
ENT.Category = "hns_blocks"
ENT.Color =  Color(17, 45, 157, 255)


	
if (SERVER) then

	AddCSLuaFile()

	function ENT:Initialize()
		self.stuckCheck = false
		self:SetModel("models/hns/Normal.mdl")
		self:SetMaterial("models/blocks/" .. self:GetClass() )
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then 
			phys:Wake() 
		end
	end
	
	
	function ENT:EnableTransparency()
        self:SetNotSolid( true )
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(Color(255, 255, 255, 80))
        timer.Simple(1, function()
			self:DisableTransparency()
		end)
	end

	
	function ENT:DisableTransparency()
		self:SetNotSolid( false )
		self:SetRenderMode(RENDERMODE_NORMAL)
	end


	function ENT:StartTouch( ent )
        if ( IsValid(ent) and ent:IsPlayer() ) then
			timer.Simple(.25, function()
				if ( IsValid(ent) and ent:IsPlayer() and ent:Team() == 3 ) then		--Hiders
					self:EnableTransparency()
				end
			end)
        end
	end

	
	function ENT:EndTouch(ent)
		if ( IsValid(ent) and ent:IsPlayer() and ent:Team() == 3 ) then			--Hiders
			self.stuckCheck = true
		end
	end
	
	
	function ENT:Think()
		if self.stuckCheck then 
			local pos = self:GetPos()
			local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos
				tracedata.filter = ents.FindByClass("bl_*")
				tracedata.mins = self:OBBMins()
				tracedata.maxs = self:OBBMaxs()
				
			local trace = util.TraceHull( tracedata )
			if trace.Entity and !trace.Entity:IsValid() then
				self.stuckCheck = false
				return
			end
			
			if trace.Entity and (trace.Entity:IsValid() and trace.Entity:IsPlayer()) then					
				self:EnableTransparency()
			end

		end
		
		self:NextThink(CurTime() + 4)
		return true	
		
	end
	
end
