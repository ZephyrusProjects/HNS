

--Pre-cache our custom models
local function PrecacheModels()

	local files, folders = file.Find( "gamemodes/hns/content/models/*", "MOD" )
	
	for k, folder in pairs (folders) do
		local models = file.Find( "gamemodes/hns/content/models/" .. folder .."/*.mdl" , "MOD" )
		for k2, mdlName in pairs(models) do
			--print("models/".. folder .."/".. mdlName)
			util.PrecacheModel("models/".. folder .."/".. mdlName)
		end
	end
end 
PrecacheModels()


--Pre-cache our custom sound files
local function PrecacheSounds()

	local files, folders = file.Find( "gamemodes/hns/content/sound/*", "MOD" )
	
	for k, folder in pairs (folders) do
		local models = file.Find( "gamemodes/hns/content/sound/" .. folder .."/*.wav" , "MOD" )
		for k2, soundFile in pairs(models) do
			--print("sound/".. folder .."/".. soundFile)
			util.PrecacheSound("sound/".. folder .."/".. soundFile)
		end
	end
end 
PrecacheSounds()


--Pre-cache the player models
local function PrecachePlayerModels()

	for k, v in pairs(HiderModels) do
		util.PrecacheModel(v)
	end
	
	for k, v in pairs(SeekerModels) do
		util.PrecacheModel(v)
	end

end

--We call it in the PostGamemodeLoaded to make sure the tables are created
--before we pre-cache the models.
hook.Add("PostGamemodeLoaded" , "HNS_PrecachePlayerModels", PrecachePlayerModels)
