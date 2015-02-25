--This is used for the key press GUI. We keep track of what keys a player is
--hitting and send them to all players spectating them.


if SERVER then
	util.AddNetworkString( "HNS_SendKeys" )
end


--Table of key enums we care about
local key_Enums = {
	IN_FORWARD, IN_MOVELEFT,
	IN_BACK, IN_MOVERIGHT,
	IN_DUCK, IN_JUMP
}


--If a key is down we will return the correct string.
--If the key is not down, we will return the default string
local function GetKeys(ply, key, str)
	
	if ply:KeyDown(key) then
		return str
	end
	
	return "."
	
end


-----------------------------
--		 GM:KeyPress	   --
-----------------------------
function GM:KeyPress(ply, key)

	--Only continue if one of the movement keys we care about
	--was pressed. 
	if !table.HasValue(key_Enums, key) then return end

	local keys = {}
	
	keys.W =  GetKeys(ply, IN_FORWARD, "W")
	keys.A = GetKeys(ply, IN_MOVELEFT, "A")
	keys.S = GetKeys(ply, IN_BACK, "S")
	keys.D = GetKeys(ply, IN_MOVERIGHT, "D")
	keys.ctrl = GetKeys(ply, IN_DUCK, "_")
	keys.space = GetKeys(ply, IN_JUMP, "==")
	
	
	--List of spectators 
	local specs = {}
	
	--Get a list of players that are specing the player
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then continue end		--Skips if player is alive.
		
		if v:GetObserverTarget() == ply then
			table.insert(specs, v)		--Add player to the specs table
		end
	
	end
	
	--Send the players keys to all players specing him
	if SERVER then
		net.Start( "HNS_SendKeys" )
			net.WriteTable( keys )
		net.Send(specs)		
	end	


end



-----------------------------
--		GM:KeyRelease	   --
-----------------------------
function GM:KeyRelease(ply, key)

	--Only continue if one of the movement keys we care about
	--was pressed. 
	if !table.HasValue(key_Enums, key) then return end

	local keys = {}

	keys.W =  GetKeys(ply, IN_FORWARD, "W")
	keys.A = GetKeys(ply, IN_MOVELEFT, "A")
	keys.S = GetKeys(ply, IN_BACK, "S")
	keys.D = GetKeys(ply, IN_MOVERIGHT, "D")
	keys.ctrl = GetKeys(ply, IN_DUCK, "_")
	keys.space = GetKeys(ply, IN_JUMP, "==")

	--List of spectators 
	local specs = {}
	
	--Get a list of players that are specing the player
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then continue end		--Skips if player is alive.
		
		if v:GetObserverTarget() == ply then
			table.insert(specs, v)		--Add player to the specs table
		end
	
	end
	
	--Send the players keys to all players specing him
	if SERVER then
		net.Start( "HNS_SendKeys" )
			net.WriteTable( keys )
		net.Send(specs)		
	end	

end

