# Hide N Seek B-Hop
A jumping team based game mode for Garry's mod. I hope you guys enjoy it!

#### Installation Instructions:
To install the game mode on your server simply drag and drop all files/folders in the __HNS-master__ folder to your servers root __/garrysmod__ directory. 
Merge all pre existing files/folders when prompted. 


#### Server Config Settings:
__Round Time:__ How long the round time is in seconds.  
("*hns_roundtime_seconds*") - Default: 180 
   
__Post Round Time:__ How long the post round phase is in seconds.  
("*hns_postround_seconds*") - Default: 8
   
__Pre Round Time:__ How long the pre round phase is in seconds.  
("*hns_preround_seconds*") - Default: 16
   
__Round Limit:__ How many rounds before we switch maps.  
("*hns_round_limit*") - Default: 10
   
   
__Disable Map Vote:__ Disables the Default map voting system.   
("*hns_mapvote_disable*") - Default: 0
   
__Mapvote Length:__ How long the map vote will be displayed in seconds.   
("*hns_mapvote_length*") - Default: 15

__Map Count:__ How many maps to add to the map vote.   
("*hns_mapvote_mapcount*") - Default: 5
   
__Add Current Map:__ Add the current map the server is on.   
("*hns_mapvote_addcurrentmap*") - Default: 1
   
   
__Disable AFK Manager:__ Disable the game modes AFK manager.   
("*hns_afkcheck_disable*") - Default: 0
   
__AFK Round Limit:__ How many rounds before you get flagged as AFK.   
("*hns_afkcheck_rounds*") - Default: 3
   
   
__Power Up Length:__ How long power ups last in seconds.   
("*hns_poweruplength_seconds*") - Default: 20



### Hooks:
__Pre Round:__ Called when the round switches to pre round.   
("*PreRoundPhase*") - Realm: Shared

__Active Round:__ Called when the round switches to the active round phase.   
("*ActiveRoundPhase*") - Realm: Shared

__Post Round:__ Called when the round switches to the post round phase.   
("*PostRoundPhase*") - Realm: Shared

__Round Waiting:__ Called when the round switches to the waiting phase.   
("*WaitingPhase*") - Realm: Shared

__Hiders Win:__ Called when the hiders win the round.   
("*HidersWin*") - Realm: Shared

__Seekers Win:__ Called when the seekers win the round.   
("*SeekersWin*") - Realm: Shared

__Swap Teams:__ Called when Hiders win 3 rounds in a row.   
("*SwapTeams*") - Realm: Shared

__Create Menu Tab:__ Adds a new tab into the F1 menu.   
("*CreateNewTab*") - Realm: Client

