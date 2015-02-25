
AddCSLuaFile()

ENT.Type = "anim"

ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")
ENT.Color = Color(50, 255, 50, 100)


function ENT:Explode(tr)

	--Prevents flash bangs from exploding post round
	if GetGlobalVar( "RoundPhase" ) != ROUND_ACTIVE then return end
	
	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
		
		-- pull out of the surface
		if tr.Fraction != 1.0 then
			self:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,6))
		end
		
		local pos = self:GetPos()
		
		local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)
		
		util.Effect("HelicopterMegaBomb", effect, true, true)
		util.Effect("cball_explode", effect, true, true)

		self:EmitSound(Sound("hns/flashbang-1.wav"))	
		
		for k, v in pairs(player.GetAll()) do
		
			local tracedata = {}
			tracedata.start = self:GetPos() + Vector(0,0,8)		--Make sure the grenade is not in the ground
			tracedata.endpos = v:GetPos() + Vector(0,0,64)		--I think 64 is eye level
			tracedata.filter = {self, v}
			local trace = util.TraceLine(tracedata)
			
			
			local maxDistance = 1536
			local distance = math.Clamp(trace.StartPos:Distance(trace.HitPos), 312, maxDistance)

			if distance >= maxDistance then return end
	
			local flashTime = (maxDistance / distance) + CurTime() - 1

			if !trace.Hit then
				if v == self:GetOwner() or v:Team() != self:GetOwner():Team() then
					v:SetNWFloat("flashTime", flashTime)
					if distance < 1200 then
						v:SendLua([[surface.PlaySound("hns/flashbang-ring.wav")]])
					end
				end	
			end

		end
		self:Remove()
	end
	
	if CLIENT then
		self:SetDetonateExact(0)

		local spos = self:GetPos()
		local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
		util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      
	end
	
end



if CLIENT then

	local alpha = 0
	
	local function FlashPlayer()
		local flashTime = LocalPlayer():GetNWFloat("flashTime")

			if flashTime > CurTime() then
				alpha = 235
				draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255,255,255,255) )
			else
				alpha = alpha - .5
				draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255,255,255, alpha))
			end
			
			if alpha >= -1 then
				DrawMotionBlur( 0.1, 0.9, 0.05)
			else
				DrawMotionBlur(0, 0, 0)
			end
	end
	hook.Add("RenderScreenspaceEffects", "HNS_FlashPlayer", FlashPlayer)
	
end


if SERVER then
	hook.Add("PreRoundPhase", "RemoveFlash_PreRoundPhase", function()
		for k, v in pairs(player.GetAll()) do
			v:SetNWFloat("flashTime", CurTime() - 1 )
		end
	end)
end

