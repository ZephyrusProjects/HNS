--This is how we handle walking on ice on our GM. I thought this was going
--to be a simple one liner. If you have a better way to simulate running on
--ice please let me know.


if SERVER then

	local function SimulateIce(ply, mv)

		local startSpeed = ply:GetNWFloat("Speed")
		local currentSpeed = math.Round(ply:GetVelocity():Length())

		if !ply:OnGround() then
			ply:SetNWBool("OnIce", false)
		end
		
		if ply:GetNWBool("OnIce") then
			if currentSpeed >= startSpeed then
				ply:SetVelocity(ply:GetForward() / .5)
			else
				ply:SetVelocity(ply:GetVelocity() * .1191)	--The magic number, doesn't compute like I thought it would.
			end
		end

	end
	hook.Add("SetupMove", "HNS_SimulateIce", SimulateIce)

end


if CLIENT then

	local function DisableFootSteps(ply)
		if ply:GetNWBool("OnIce") then
			return true --disable footsteps
		end
	end
	hook.Add("PlayerFootstep", "HNS_Ice_DisableFootsteps", DisableFootSteps)
	
end
