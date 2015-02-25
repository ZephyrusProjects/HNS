--Receive hooks so we can use them client side later on.


-------------------------------------
-- 	   All round related hooks.	   --
-------------------------------------
usermessage.Hook("hns_RoundWaiting", function()
	hook.Call("WaitingPhase")
end)

usermessage.Hook("hns_PreRound", function()
	hook.Call("PreRoundPhase")
end)

usermessage.Hook("hns_ActiveRound", function()
	hook.Call("ActiveRoundPhase")
end)

usermessage.Hook("hns_PostRound", function()
	hook.Call("PostRoundPhase")
end)




-------------------------------------
-- 		 Miscellaneous Hooks	   --
-------------------------------------

--Hiders win hook
usermessage.Hook("hns_HidersWin", function()
	hook.Call("HidersWin")
end)

--Seekers win hook
usermessage.Hook("hns_SeekersWin", function()
	hook.Call("SeekersWin")
end)

--Team swap hook
usermessage.Hook("hns_SwapTeams", function()
	hook.Call("SwapTeams")
end)

--I didn't really need to make hooks for these. Maybe me or somebody else will
--find a use for them.


