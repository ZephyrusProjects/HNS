CreateConVar("hns_mapvote_disable", "0", FCVAR_NOTIFY, "To disable set to 1.")
CreateConVar("hns_mapvote_length", "15", FCVAR_NOTIFY, "Value is relative to seconds.")
CreateConVar("hns_mapvote_mapcount", "5", FCVAR_NOTIFY, "How many maps will be added to the mapvote.")
CreateConVar("hns_mapvote_addcurrentmap", "1", FCVAR_NOTIFY, "Adds the servers current map to the map list.")

SetGlobalVar("hns_mapvote_mapcount", GetConVarNumber("hns_mapvote_mapcount"))



local votes = {}		--Used to keep track of the players votes.
 

--Typically you would be searching the maps folder,
--but we only want to play maps that have been built for our GM.
local maps = file.Find("data/hide_n_seek/*", "GAME")
local mapList = {}



--Randomize map list and remove the .txt
for k, v in RandomPairs(maps) do

	v = string.Replace(v, ".txt", "")
	table.remove(maps, k)
	--A check to see if we want to add the current map to the maplist.
	if GetConVarNumber("hns_mapvote_addcurrentmap") < 1 && v == game.GetMap() then continue end
	table.ForceInsert(mapList, v)
end



local function GetWinningMap()
	timer.Simple(GetConVarNumber("hns_mapvote_length") + 1, function()
		local winningMap = table.GetWinningKey(votes) or 1
		GAMEMODE:GlobalChatMsg("Changing level to " .. mapList[winningMap] .. ".")
		
		timer.Simple(3, function()
			RunConsoleCommand("changelevel", mapList[winningMap] )
		end)
	end)
end



util.AddNetworkString( "StartMapVote" )
function StartMapVote()	 

	if GetConVarNumber("hns_mapvote_disable") > 0 then return end
	GAMEMODE:GlobalChatMsg("A mapvote has begun, please select a map.")

	net.Start( "StartMapVote" )
		net.WriteTable( mapList )
		net.WriteInt(GetConVarNumber("hns_mapvote_length"), 8)
	net.Broadcast()
	
	GetWinningMap()
end



util.AddNetworkString( "SendVoteToServer" )
--Get the players vote and add to the vote count.
net.Receive( "SendVoteToServer", function( len, ply )
	local keyvalue = net.ReadInt(4)
	local voteCount = votes[keyvalue]
	
	if voteCount == nil then
		voteCount = 0
	end
	
	voteCount = voteCount + 1
	
	table.remove(votes, keyvalue)
	table.insert(votes, keyvalue, voteCount)
end)



--RTV stuff

local rtvVotes = 0			--How many players have rtv
local percentage = 0.50 	--50 percent

--Check to see if its time to start a map vote
local function CheckForMapVote()
	local remainingVotes = math.Round(#player.GetAll() * percentage - rtvVotes)
	
	if remainingVotes <= 0 then
		GAMEMODE:GlobalChatMsg("Enough players have rocked the vote. A map vote will start at the end of the round.")
		hook.Add("PostRoundPhase", "HNS_RockTheVote", function()
			StartMapVote()
		end)
	end
end


--Check to see if the player can rtv
local function RockTheVote(ply)

	--Disable rtv for the first round
	if GetGlobalVar("hns_rounds_left") >= GetConVarNumber("hns_round_limit") then
		GAMEMODE:ChatMsg(ply, "You must wait before you can do that!")
		return
	end
	
	if ply.hasRocked then
		GAMEMODE:ChatMsg(ply, "You have already rocked the vote!")
	else
		rtvVotes = rtvVotes + 1
		ply.hasRocked = true
		local remainingVotes = math.Round(#player.GetAll() * percentage - rtvVotes)
		GAMEMODE:GlobalChatMsg(ply:Nick().. " has rocked the vote! "..remainingVotes.." more players must rtv!")
		CheckForMapVote()
	end
	
end


--Our chat command for rtv
hook.Add("PlayerSay", "HNS_RTVChatCommand", function(ply, msg, tchat)
	local args = string.Explode(" ", msg)
	local rtv = { "!rtv", "!rockthevote", "/rtv", "/rockthevote" }
	
	if table.HasValue(rtv, string.lower(args[1])) then
		RockTheVote(ply)
	end
end)


--Remove the players vote on DC
hook.Add("PlayerDisconnected", "HNS_RemoveRtvVote", function(ply)
	if ply.hasRocked then
		rtvVotes = rtvVotes - 1
	end
end)
