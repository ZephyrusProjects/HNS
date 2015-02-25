

--Once teleports are removed and we starting placing more we
--will eventually start to overwrite existing ones. We use this function
--to prevent that.
function UpdateTeleportIndex(ent)
	if ent.TeleportNumber >= GAMEMODE.TeleportIndex then
		GAMEMODE.TeleportIndex = ent.TeleportNumber + 1
	end
end


--Loops through all the teleports and checks for matches. Once
--a match is found, we set which entity the teleport entrance will
--reference for a exit position.
function SyncTeleports()

	for _, teleEntrance in pairs(ents.FindByClass("bl_tele") ) do
		for _, teleExit in pairs(ents.FindByClass("bl_tele_exit") ) do
			if teleEntrance.TeleportNumber == teleExit.TeleportNumber then		--We found a match.
				UpdateTeleportIndex(teleEntrance)
				teleEntrance.TeleportPosition = teleExit
			end
		end
	end
	
end
hook.Add("InitPostEntity", "SyncTeleports", SyncTeleports)
