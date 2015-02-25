
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_icegrenade_thrown.mdl")
ENT.Color = Color(0,255,255,100)

util.PrecacheModel("models/props_debris/concrete_debris128pile001b.mdl")
util.PrecacheModel("models/props_debris/concrete_column001a_chunk02.mdl")
util.PrecacheModel("models/props_debris/concrete_spawnchunk001k.mdl")

PrecacheParticleSystem("aurora_shockwave_debris")
PrecacheParticleSystem("hunter_projectile_explosion_2k")
PrecacheParticleSystem("aurora_shockwave_ring")
PrecacheParticleSystem("teleportedin_blue")
PrecacheParticleSystem("Weapon_Combine_Ion_Cannon_d")


local freezeTime = 7


if SERVER then 
	
	local pillarPositions = {
		{pos=Vector(-8, -4, 5), angle=Angle(27, 143, 0)},
		{pos=Vector(-0, -4, 7), angle=Angle(38, 78, 0)},
		{pos=Vector(-11, 7, 7), angle=Angle(32, 86, 0)},
		{pos=Vector(4, 8, 5),   angle=Angle(36, -54, 0)},
		{pos=Vector(4, 16, 5),  angle=Angle(30, -22, 0)},
		{pos=Vector(4, 0, 9),   angle=Angle(37, -106, 0)},
		{pos=Vector(-4, -4, 5), angle=Angle(15, 157, -20)} }

	

	--Spawns the base for our player freeze effect.
	function ENT:SpawnIceBase(ply)
		for i=1, 2 do
			local IceBase=ents.Create("prop_physics")
			IceBase:SetModel("models/props_debris/concrete_debris128pile001b.mdl")
			IceBase:SetPos(ply:GetPos() + Vector(0,0, 8))
			IceBase:SetAngles(Angle( 0, math.random(-365,365), 0))
			IceBase:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

			IceBase:SetRenderMode( RENDERMODE_TRANSALPHA )
			IceBase:SetMaterial("models/player/shared/ice_player")
			IceBase:SetColor( Color(0, math.random(170,251), 251, 120) )
			IceBase:SetKeyValue("renderfx", 1)		--slow pulse
			IceBase:DrawShadow(false)
			IceBase:Spawn()

			local phys = IceBase:GetPhysicsObject()
		 
			if phys and phys:IsValid() then
				phys:EnableMotion(false) -- Freezes the object in place.
			end

			 SafeRemoveEntityDelayed(IceBase , freezeTime )
		end
	end


	--Surrounds the player in ice pillars.
	function ENT:SpawnIcePillars(ply)

		for k, v in pairs(pillarPositions) do
			local IcePillars=ents.Create("prop_physics")
			
			IcePillars:SetModel("models/props_debris/concrete_column001a_chunk02.mdl")
			IcePillars:SetPos(ply:GetPos() + v.pos)		--Used to be -48 instead of 12 when we were moving them with the timer.
			IcePillars:SetAngles(v.angle)							--Removed that for now to see if it optimizes it
			IcePillars:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

			IcePillars:SetRenderMode( RENDERMODE_TRANSALPHA )
			IcePillars:SetMaterial("models/player/shared/ice_player")
			IcePillars:SetColor( Color(0, math.random(170,251), 251, 120) )
			IcePillars:SetKeyValue("renderfx", 1)		--slow pulse
			IcePillars:DrawShadow(false)
			IcePillars:Spawn()

			local phys = IcePillars:GetPhysicsObject()
		 
			if phys and phys:IsValid() then
				phys:EnableMotion(false) -- Freezes the object in place.
			end

			SafeRemoveEntityDelayed(IcePillars , freezeTime )
		end		
		
	end
	
	
	--Adds a somewhat fitting trail for the player
	function ENT:IceTrail(ply)
		local ID = ply:LookupAttachment("chest")
		local playerTrail = util.SpriteTrail(ply, ID, Color(0,251,251, 125), false, 16, 42, 1.75, 1/(15+1)*0.5, "trails/smoke.vmt")

		timer.Simple(freezeTime * 2, function()
			if IsValid(ply) then
				SafeRemoveEntity( playerTrail )
			end
		end)
	end
	
	
	
	--This makes the player look like they are made out of ice.
	function ENT:IcePlayer(ply)
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetMaterial("models/player/shared/ice_player")
		ply:SetColor( Color(0,251, 251, 120) )
		ply:SetKeyValue("renderfx", 1)		--slow pulse
	end
	
	
	--Our function to remove all freezing effects from the player.
	local function RemoveIce(ply)
		if ply:GetNWBool("isFrozen") then
			ply:UnLock()
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor( Color(255,255,255,255) )
			ply:SetMaterial("")
			ply:SetKeyValue("renderfx", 0)
			ply:SetNWBool("isFrozen", false)
			ply:SetWalkSpeed( GM_WalkSpeed )
			ply:SetRunSpeed( GM_RunSpeed )
		end
	end


	--This makes it look like the players ice container shattered and exploded into
	--a bunch of pieces.
	local function IceExplode(ply)

		ply:EmitSound(table.Random({"physics/glass/glass_sheet_break1.wav",
									"physics/glass/glass_sheet_break2.wav",
									"physics/glass/glass_sheet_break3.wav" }),500,100)
		
		for i=1,16 do
			local IceChunks=ents.Create("prop_physics")
			IceChunks:SetModel("models/props_debris/concrete_spawnchunk001k.mdl")
			IceChunks:SetPos(ply:GetPos() + Vector(20,20, 16))
			IceChunks:SetAngles( Angle( math.random(-15,15), math.random(-15,15), math.random(-15,15)) )
			IceChunks:SetVelocity(VectorRand() * math.Rand(1000, 1500))
			IceChunks:SetCollisionGroup( COLLISION_GROUP_WEAPON )

			IceChunks:SetRenderMode( RENDERMODE_TRANSALPHA )
			IceChunks:SetMaterial("models/player/shared/ice_player")
			IceChunks:SetColor( Color(0, 251, 251, 120) )
			IceChunks:SetKeyValue("renderfx", 1)		--slow pulse
			IceChunks:DrawShadow(false)
			IceChunks:Spawn()
			
			local phys = IceChunks:GetPhysicsObject()
	 
			if phys and phys:IsValid() then
				phys:Wake()
				phys:SetMaterial("default_silent")
			end
			
			
			SafeRemoveEntityDelayed(IceChunks , freezeTime )
			
			timer.Simple(freezeTime - 1 , function()
				if IsValid(IceChunks) then
					IceChunks:SetKeyValue("renderfx", 5)	--slow fade effect
				end
			end)
			
		end
	end
	


	util.AddNetworkString( "HNS_SpawnFog" )
	
	--Once the grenade explodes we find and freeze players in a certain radius.
	function ENT:FreezePlayer(pos, freezer)
		local radius = 160
		
		--Freeze all players in a certain radius
		for k, v in pairs(ents.FindInSphere(pos, radius)) do
			if IsValid(v) and v:IsPlayer() and v:Alive() and v:Team() != TEAM_SPEC and v:GetNWBool("isFrozen") == false then
				if v == freezer or v:Team() != freezer:Team() then
					v:Lock()	--Stops player mid air
					v:SetLocalVelocity(Vector(0,0,0))
					v:ResetSequence( "idle" )
					v:SetNWBool("isFrozen", true)
					
					self:IcePlayer(v)
					self:SpawnIceBase(v)
					self:SpawnIcePillars(v)
					self:IceTrail(v)
					
					net.Start( "HNS_SpawnFog" )
						net.WriteVector(v:GetPos())
					net.Broadcast()		--Send the net msg to all players

					timer.Simple(freezeTime, function()
						if !IsValid(v) then return end
						if v:GetNWBool("isFrozen") then
							IceExplode(v) 
							v:UnLock()
							v:SetWalkSpeed( 175 )
							v:SetRunSpeed( 175 )
						end
					end)
			
					timer.Create( "de-icePlayer_" .. v:SteamID(), freezeTime * 2, 1, function()
						if !IsValid(v) then return end
						RemoveIce(v)
					end)
				end
			end
		end
	end
	
	
	--The explode function is called a few different ways. Once it is called this is the function
	--that starts our freezing effects.
	function ENT:Explode(tr)

		--Prevents bad shit from happening when frozen post round.
		if GetGlobalVar( "RoundPhase" ) != ROUND_ACTIVE then return end
			
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
		
		-- pull out of the surface
		if tr.Fraction != 1.0 then
			self:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,3))
		end
		
		local pos = self:GetPos()
		
		-- make sure we are removed, even if errors occur later
		self:Remove()
		
		self:FreezePlayer(pos, self:GetThrower())
		
		self:EmitSound( "hns/frostnova.wav", 360, 100)
		
		self:SetDetonateExact(0) 
		
		--ParticleEffect( "aurora_shockwave", pos, Angle(0,0,0) )
		ParticleEffect( "aurora_shockwave_debris", pos, Angle(0,0,0) )
		ParticleEffect( "hunter_projectile_explosion_2k", pos, Angle(0,0,0) )
		ParticleEffect( "aurora_shockwave_ring", pos, Angle(0,0,0) )
		ParticleEffect( "teleportedin_blue", pos, Angle(0,0,0) )
	
		ParticleEffect( "Weapon_Combine_Ion_Cannon_d", pos + Vector(0,0,4), Angle(0,0,0) )
		ParticleEffect( "Weapon_Combine_Ion_Cannon_d", pos + Vector(0,0,4), Angle(0,90,0) )
		ParticleEffect( "Weapon_Combine_Ion_Cannon_d", pos + Vector(0,0,4), Angle(0,45,0) )
		ParticleEffect( "Weapon_Combine_Ion_Cannon_d", pos + Vector(0,0,4), Angle(0,135,0) )
		ParticleEffect( "Weapon_Combine_Ion_Cannon_d", pos + Vector(0,0,4), Angle(0,0,90) )		
		

		local trs = util.TraceLine({start=pos + Vector(0,0,64), endpos=pos + Vector(0,0,-128), filter=self})
		util.Decal("GlassBreak", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)    
		
	end


	--Just incase we have any lingering freeze effects we will remove them when the round ends.
	hook.Add("PostRoundPhase", "RemoveFreeze_PostRound", function()
		for k, v in pairs(player.GetAll()) do
			if v:GetNWBool("isFrozen") then
				RemoveIce(v)
			end
		end
	end)

end



if CLIENT then

	--Spawns blue fog around the frozen player.
	local function SpawnIceFog(pos)

		local particleEmitter = ParticleEmitter(pos)

		for i=1, 2 do
			local particle = particleEmitter:Add(Model("particle/particle_smokegrenade"), pos + Vector(0,0,32))
			
			if particle then
				local blue = math.random(240, 255)
				particle:SetColor(0, blue, blue)
				particle:SetStartAlpha(125)
				particle:SetEndAlpha(100)
				particle:SetStartSize(70)
				particle:SetEndSize(70)
				
				particle:SetLifeTime(0)
				particle:SetDieTime(freezeTime)

				particle:SetVelocity(Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1)):GetNormal() * 10)
				particle:SetRoll(math.random(-180, 180))
				particle:SetRollDelta(math.Rand(-0.1, 0.1))
				particle:SetAirResistance(600)
				particle:SetCollide(true)
				particle:SetBounce(0.4)
				particle:SetLighting(false)
			end
		end

		particleEmitter:Finish()
	end
	
	--Net msg to tell our clients its time to draw some fog.
	 net.Receive( "HNS_SpawnFog", function( len )	 
		local pos = net:ReadVector()
		SpawnIceFog(pos) 
	 end ) 
	
	
	
	--Gives the players screen an icy frozen look.
	local alpha = 60
	hook.Add("HUDPaint", "HNS_FreezeGren_ScreenFreeze", function()
		if LocalPlayer():GetNWBool("isFrozen") then
			alpha = alpha - .022
			surface.SetTexture(surface.GetTextureID("hns/ttt_ice"))			--reused material from my TTT server :)
			surface.SetDrawColor(0,251,251,alpha)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
		else
			hook.Remove("HNS_FreezeGren_ScreenFreeze")
			alpha  = 60
		end
	end)
	
end

