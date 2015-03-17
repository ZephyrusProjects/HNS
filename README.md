# Hide N Seek B-Hop
A team based jumping game mode for Garry's mod. I hope you guys enjoy it!

#### Installation Instructions:
To install the game mode on your server simply drag and drop all files/folders in the __HNS-master__ folder to your servers root __/garrysmod__ directory. 
Merge all pre existing files/folders when prompted.  

#### Server Owners 
  * Make sure your servers tick rate is __at least 66__. Tick rates below 66 cause bhops to be unresponsive.
  * Do not worry about gravity, air acceleration, friction etc. The game mode takes care of it.
  * Super-Admin's have access to the building team. Create a new group called 'builders' for group that can  
    build with no administrative privileges.

	
---------------------
---------------------   
#### Server Config Settings:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Round Time:__ How long the round is in seconds.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_roundtime_seconds*") - Default: 180 
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Post Round Time:__ How long the post round phase is in seconds.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_postround_seconds*") - Default: 8
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Pre Round Time:__ How long the pre round phase is in seconds.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_preround_seconds*") - Default: 16
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Round Limit:__ How many rounds before a map change.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_round_limit*") - Default: 10
   
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Disable Map Vote:__ Disables the default map voting system.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_mapvote_disable*") - Default: 0
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Mapvote Length:__ How long the map vote will be displayed in seconds.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_mapvote_length*") - Default: 15

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Map Count:__ How many maps to add to the map vote.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_mapvote_mapcount*") - Default: 5
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Add Current Map:__ Add the current map the server is on.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_mapvote_addcurrentmap*") - Default: 1
   
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Disable AFK Manager:__ Disable the game modes AFK manager.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_afkcheck_disable*") - Default: 0
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__AFK Round Limit:__ How many rounds before you get flagged as AFK.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_afkcheck_rounds*") - Default: 3
   
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Power Up Length:__ How long power ups last in seconds.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*hns_poweruplength_seconds*") - Default: 20   
   
   
---------------------
---------------------   
#### Hooks:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Pre Round:__ Called when the round switches to the pre round phase.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*PreRoundPhase*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Active Round:__ Called when the round switches to the active round phase.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*ActiveRoundPhase*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Post Round:__ Called when the round switches to the post round phase.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*PostRoundPhase*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Round Waiting:__ Called when the round switches to the waiting phase.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*WaitingPhase*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Hiders Win:__ Called when the Hiders win the round.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*HidersWin*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Seekers Win:__ Called when the Seekers win the round.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*SeekersWin*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Swap Teams:__ Called when Hiders win 3 rounds in a row.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*SwapTeams*") - Realm: Shared

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__Create Menu Tab:__ Adds a new tab into the F1 menu.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("*CreateNewTab*") - Realm: Client   
   

   
---------------------
---------------------   
#### Hook Examples:
Most of our hooks can be used client or server side. In this example will be doing a client side
chat print. The majority of the hooks can be used just like this: 
```lua
local function PreRound_HookExample()
	LocalPlayer():ChatPrint("The pre round phase has just started!")
end
hook.Add("PreRoundPhase", "PreRound_HookExample", PreRound_HookExample)
```


###### In this example we will be adding a new tab to the F1 menu:
```lua
local function AddTab_Example()

	local example_Panel = vgui.Create("DPanel")
	example_Panel:SetPos(5,5)
	example_Panel:SetBackgroundColor(panel_bgColor)
	
	local chckbox_showFPS = vgui.Create("DCheckBoxLabel", example_Panel)
	chckbox_showFPS:Dock(TOP)
	chckbox_showFPS:DockMargin(10,10,0,0)
	chckbox_showFPS:SetValue(0)
	chckbox_showFPS:SetText("Show FPS")
	chckbox_showFPS:SetConVar("cl_showfps")
	chckbox_showFPS:SizeToContents()

	settings_Tabs:AddSheet( "Example", example_Panel, "materials/icon16/heart.png", false, false, "Example" )

end
hook.Add("CreateNewTab", "AddTab_Example", AddTab_Example)
```


---------------------
---------------------   

