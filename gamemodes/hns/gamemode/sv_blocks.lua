


-----------------------------
-- 		GM:SaveBlocks      --
-----------------------------
function GM:SaveBlocks()		--Saves blocks to a text file

	if ( !file.IsDir( "hide_n_seek", "DATA" ) ) then file.CreateDir( "hide_n_seek" ) end 

	local BlockPositions = {}
	
	for k, v in pairs( ents.FindByClass("bl_*") ) do
		if v.TeleportNumber == 0 then break end		--Prevents saving a teleport entrance that doesn't have an exit set.
		table.insert( BlockPositions, { class = v:GetClass(), owner = v:GetBlockOwner(), pos = v:GetPos(), model = v:GetModel(), angles = v:GetAngles(), tramppower = v.TrampPower, teleportid = v.TeleportNumber } )
	end

	file.Write( "hide_n_seek/" .. game.GetMap()  .. ".txt", util.TableToJSON( BlockPositions ) )
	
	return table.Count(BlockPositions)
	
end



-----------------------------
-- 		 LoadBlocks        --
-----------------------------
function LoadBlocks()			--Load blocks from a text file
									--This gets called when the GM Initializes
									
	if !file.Exists("hide_n_seek/" .. game.GetMap() .. ".txt", "DATA") then return end
	
	local filename = file.Read( "hide_n_seek/" .. game.GetMap() .. ".txt", "DATA" ) 
	local blockTable = util.JSONToTable( filename )
	
	for k, v in ipairs( blockTable ) do
		newEnt = ents.Create( v.class )
		newEnt:SetPos( v.pos )
		newEnt:SetAngles( v.angles )
		newEnt:Spawn()
		newEnt:Activate()
		newEnt:DrawShadow(false)
		newEnt:SetModel( v.model)
		newEnt.TrampPower = v.tramppower
		newEnt.TeleportNumber = v.teleportid		
		newEnt:SetBlockOwner( v.owner )
	end
end
hook.Add("Initialize", "HNS_LoadBlocks", LoadBlocks ) 



-----------------------------
-- 	   GM:RemoveBlocks     --
-----------------------------
function GM:RemoveBlocks()		--Remove all blocks from a map

	local blockCount = 0

	for k, v in pairs( ents.FindByClass("bl_*") ) do
		v:Remove()
		blockCount = blockCount + 1
	end
	
	file.Delete("hide_n_seek/" .. game.GetMap() .. ".txt")
	
	return blockCount
	
end 



-----------------------------
-- 	   GM:RemoveBlocks     --
------------------------------		-Spawns blocks from our builders block placer GUI
function GM:SpawnBlock(ply, BlockType, BlockSize, FlipUpRight, Rotate, SnapXY, SnapZ, NoCollide, TrampPower, UpdateBlock)

	local trace = ply:GetEyeTrace()
	local vector = trace.HitPos
	vector.z = vector.z + 20
	
	local newBlock = ents.Create( BlockType )
	newBlock:SetPos( vector )
	
	local eff = EffectData()
	eff:SetEntity( newBlock )
	util.Effect( "propspawn", eff)		
	
	newBlock.Spawn(newBlock)
	newBlock:Activate()
	newBlock:DrawShadow(false)
	
	newBlock:SetModel( "models/hns/".. BlockSize ..".mdl" )
	newBlock.TrampPower = TrampPower
	newBlock:SetBlockOwner( ply:Nick() )
	
	--Flip upright
	if FlipUpRight  == true then
		newBlock:SetAngles(newBlock:GetAngles() + Angle(0,0,90))
	end
	
	--Rotate
	if Rotate == true then
		newBlock:SetAngles(newBlock:GetAngles() + Angle(0,90,0))
	end
	
	undo.Create( BlockType )
	undo.AddEntity( newBlock )
	undo.SetPlayer( ply )
	undo.Finish()
	
end


--Receive block settings from the client and spawn the block. 
util.AddNetworkString( "SendBlocks" )
net.Receive( "SendBlocks", function( len, ply )
	local blSettings = net.ReadTable()
	GAMEMODE:SpawnBlock( ply, blSettings.Type, blSettings.blSize, blSettings.FlipUp, blSettings.blRotate, blSettings.SnapXY, blSettings.SnapZ, blSettings.NoCollide, blSettings.TrampPower, blSettings.UpdateBlock)
end)



-----------------------------
-- 	   GM:UpdateBlock      --
------------------------------		--Update a block from our block_updater SWEP
function GM:UpdateBlock(ply, BlockType, BlockSize, FlipUpRight, Rotate, SnapXY, SnapZ, NoCollide, TrampPower, UpdateBlock)

	local trace = ply:GetEyeTrace().Entity
	local newBlock = ents.Create( BlockType )
	
	newBlock:SetPos( trace:GetPos() )
	newBlock.Spawn(newBlock)
	newBlock:SetBlockOwner( ply:Nick() )
	newBlock:Activate()
	newBlock:DrawShadow(false)
	trace:Remove()		--Remove old block
	newBlock:SetModel( "models/hns/".. BlockSize ..".mdl" )
	newBlock.TrampPower = TrampPower
	
	--Flip upright
	if FlipUpRight  == true then
		newBlock:SetAngles(newBlock:GetAngles() + Angle(0,0,90))
	end
	
	--Rotate
	if Rotate == true then
		newBlock:SetAngles(newBlock:GetAngles() + Angle(0,90,0))
	end
	
end


--Recieve new block settings from client and update the block
util.AddNetworkString( "UpdateBlocks" )
net.Receive( "UpdateBlocks", function( len, ply )
	local blSettings = net.ReadTable()
	GAMEMODE:UpdateBlock( ply, blSettings.Type, blSettings.blSize, blSettings.FlipUp, blSettings.blRotate, blSettings.SnapXY, blSettings.SnapZ, blSettings.NoCollide, blSettings.TrampPower, blSettings.UpdateBlock)
end)



----------------------------------
-- 	 Chat commands for builders --
----------------------------------
hook.Add("PlayerSay", "HNS_BlockCommands", function(pl, msg, tchat)
	if pl:Team() != TEAM_BUILDER then return end
	
	local args = string.Explode(" ", msg)
	
	if string.lower(args[1]) == "!save_blocks" then

		local blockCount = GAMEMODE:SaveBlocks()
		GAMEMODE:SaveBlocks()
		
		local message = (tostring(blockCount) .. " - Blocks have been successfully saved!" )
		GAMEMODE:ChatMsg(pl, message)

		return ""	
		
	elseif string.lower(args[1]) == "!remove_blocks" then
	
		if pl:IsSuperAdmin() then
			local blockCount = GAMEMODE:RemoveBlocks()
			GAMEMODE:RemoveBlocks()
		
			local message = (tostring(blockCount) .. " - Blocks have been removed.")
			GAMEMODE:ChatMsg(pl, message)
			
		else
			notification.AddLegacy("You must be a Super Admin to do that!", NOTIFY_ERROR, 5)
		end

		return ""
	
	elseif  string.lower(args[1]) == "!hns_help" then
		local message = "Type '!save_blocks' in chat to save all blocks."
		GAMEMODE:ChatMsg(pl, message)
		
		local message = "Type '!remove_blocks' in chat to remove all blocks."
		GAMEMODE:ChatMsg(pl, message)
		return ""
		
	end
	
end)
