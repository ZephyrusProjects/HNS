
playerRowHeight = 26
white = Color(255, 255, 255, 255)
rowColor = Color(75,75,75,55)


--These are used to adjust the scoreboard. The scoreboard is actually 
--bigger then it looks. We do this so we can overhang the logo off the 
--side of the scoreboard.
panelX_adjustment = 128
panelY_adjustment = panelX_adjustment
panel_offsetPadding = 64


local PLAYER_LINE = 
{
	Init = function(self)
		self.AvatarButton = self:Add("DButton")
		self.AvatarButton:Dock(LEFT)
		self.AvatarButton:SetSize(20, 20)
		self.AvatarButton:DockPadding(3, 3, 3, 3)
		self.AvatarButton:DockMargin(16, 3, 3, 3)
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar = vgui.Create("AvatarImage", self.AvatarButton)
		self.Avatar:SetSize(20, 20)
		self.Avatar:SetMouseInputEnabled(false)		

		self.Name = self:Add("DLabel")
		self.Name:Dock(FILL)
		self.Name:SetTextColor(white)
		self.Name:SetFont("ScoreboardDefault")
		self.Name:DockMargin(8, 0, 0, 0)
		
		self.Status = self:Add("DLabel")
		self.Status:Dock(FILL)
		self.Status:SetWidth(200)
		self.Status:SetFont("ScoreboardDefault")
		self.Status:SetText("")
		self.Status:SetContentAlignment(4)
		self.Status:DockMargin(200, 0, 0, 0)
		
		self.Mute  = self:Add("DImageButton")
		self.Mute:SetSize(16, 16)
		self.Mute:Dock(RIGHT)
		self.Mute:DockPadding(6, 6, 6, 6)		
		self.Mute:DockMargin(6, 6, 6, 6)


		self.Ping = self:Add("DLabel")
		self.Ping:Dock(RIGHT)
		self.Ping:SetWidth(playerRowHeight * 2)
		self.Ping:SetFont("ScoreboardDefault")
		self.Ping:SetContentAlignment(5)
		self.Ping:DockMargin(0, 0, 8, 0)
		self.Ping.Paint = function()
			surface.SetDrawColor(rowColor)
			surface.DrawRect(0, 0, playerRowHeight * 2, playerRowHeight)
			surface.DrawOutlinedRect(0, 0, playerRowHeight * 2, playerRowHeight)
		end

		self.Deaths = self:Add("DLabel")
		self.Deaths:Dock(RIGHT)
		self.Deaths:SetWidth(playerRowHeight * 2)
		self.Deaths:SetFont("ScoreboardDefault")
		self.Deaths:SetContentAlignment(5)
		self.Deaths:DockMargin(0, 0, playerRowHeight * 2, 0)
		self.Deaths.Paint = function()
			surface.SetDrawColor(rowColor)
			surface.DrawRect(0, 0, playerRowHeight * 2, playerRowHeight)
			surface.DrawOutlinedRect(0, 0, playerRowHeight * 2, playerRowHeight)
		end

		self.Kills = self:Add("DLabel")
		self.Kills:Dock(RIGHT)
		self.Kills:SetWidth(playerRowHeight * 2)
		self.Kills:SetFont("ScoreboardDefault")
		self.Kills:SetContentAlignment(5)
		self.Kills:DockMargin(0, 0, playerRowHeight * 2	, 0)
		self.Kills.Paint = function()
			surface.SetDrawColor(rowColor)
			surface.DrawRect(0, 0, playerRowHeight * 2, playerRowHeight)
			surface.DrawOutlinedRect(0, 0, playerRowHeight * 2, playerRowHeight)
		end

		self:Dock(TOP)
		--self:DockPadding(3, 3, 3, 3)
		--self:DockPadding(3, 0, 3, 0)
		self:SetHeight(playerRowHeight)
		self:DockMargin(panel_offsetPadding + 2, 5,  panel_offsetPadding + 2, -4)
	end,

	Setup = function(self, pl)
		self.Player = pl

		self.Avatar:SetPlayer(pl)
		
		self:Think(self)
	end,

	Think = function(self)
	
		if (!IsValid(self.Player)) then
			self:Remove()
			return
		end
		
		self.TeamColor = team.GetColor(self.Player:Team())
		self.Name:SetText(self.Player:Nick())
		
		if self.Player:Alive() then
			self.Name:SetTextColor( self.TeamColor )
			self.Ping:SetTextColor( self.TeamColor )
			self.Deaths:SetTextColor( self.TeamColor )
			self.Kills:SetTextColor( self.TeamColor )
			self.Status:SetTextColor( self.TeamColor )
			self.Status:SetText("")
		else
			self.DeathTextColor = Color(128,128,128,150)
			self.Name:SetTextColor(self.DeathTextColor)
			self.Ping:SetTextColor(self.DeathTextColor)
			self.Deaths:SetTextColor(self.DeathTextColor)
			self.Kills:SetTextColor(self.DeathTextColor)
			self.Status:SetTextColor(self.DeathTextColor)
			self.Status:SetText("*DEAD*")
		end
		
		if self.Player:Team() == TEAM_SPECTATOR then
			self.Status:SetText("*Spectator*")
		elseif self.Player:Team() == TEAM_BUILDER then
			self.Status:SetText("*Builder*")
		elseif self.Player:Team() == TEAM_CONNECTING then
			self.Status:SetText("*Connecting*")
		end
		
		

		if (self.NumKills == nil || self.NumKills != self.Player:Frags()) then
			self.NumKills = self.Player:Frags()
			
			if self.Player:Team() == TEAM_SPECTATOR or self.Player:Team() ==  TEAM_BUILDER then
				self.Kills:SetText("")
				self.Kills.Paint = nil			--We don't want to paint the box on spectators/builders
			else
				self.Kills:SetText(self.NumKills)
			end
		end

		if (self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths()) then
			self.NumDeaths = self.Player:Deaths()
			
			if self.Player:Team() == TEAM_SPECTATOR  or self.Player:Team() ==  TEAM_BUILDER then
				self.Deaths:SetText("")
				self.Deaths.Paint = nil			--We don't want to paint the box on spectators/builders
			else
				self.Deaths:SetText(self.NumDeaths)
			end
		end

		if (self.NumPing == nil || self.NumPing != self.Player:Ping()) then
			self.NumPing	=	self.Player:Ping()
			self.Ping:SetText(self.NumPing)
			
			if self.Player:Team() == TEAM_SPECTATOR or self.Player:Team() ==  TEAM_BUILDER then
				self.Ping.Paint = nil
			end
			
		end

		--
		-- Change the icon of the mute button based on state
		--
		if (self.Muted == nil || self.Muted != self.Player:IsMuted()) then

			self.Muted = self.Player:IsMuted()
			if (self.Muted) then
				self.Mute:SetImage("icon16/sound_mute.png")
			else
				self.Mute:SetImage("icon16/sound.png")
			end

			self.Mute.DoClick = function() self.Player:SetMuted(!self.Muted) end

		end

		--
		-- Connecting players go at the very bottom
		--
		if (self.Player:Team() == TEAM_CONNECTING) then
			self:SetZPos(2000)
		end

		--
		-- This is what sorts the list. The panels are docked in the z order, 
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos((self.NumKills * -50) + self.NumDeaths)
	end,

	Paint = function(self, w, h)
	
		if (!IsValid(self.Player)) then
			return
		end

		if self.Player:Alive() then
			surface.SetDrawColor(Color(75, 75, 75, 55))
			surface.DrawRect(0, 0, w, h)
			surface.DrawOutlinedRect(0, 0, w, h)
		else
			surface.SetDrawColor(Color(55, 55, 55, 55))
			surface.DrawRect(0, 0, w, h)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
	end
}
PLAYER_LINE = vgui.RegisterTable(PLAYER_LINE, "DPanel")



local TEAM_GROUP =
{
	Init = function(self)
		self:SetDrawBackground(false)
		
		self.TeamName = self:Add("DLabel")
		
		self.TeamName:SetFont("ScoreboardDefault")
		self.TeamName:Dock(TOP)
		self.TeamName:DockMargin(panel_offsetPadding + 16, 4, 0, 0)
		
		self.Scores = self:Add("DListLayout")
		self.Scores:Dock(FILL)
	end,
	
	
	SetTeam = function(self, teams)
	
		if type(teams) == "table" then
			self.targetTeams = teams
		else
			self.targetTeams = {teams}
		end
		
		self.TeamColor = team.GetColor(self.targetTeams[1])
		self.TeamName:SetTextColor(self.TeamColor)
		
	end,

	Think = function(self)	
	
		self.TeamCount = #team.GetPlayers(self.targetTeams[1])
		
		local playerCount = 0
		
		for k, v in ipairs(self.targetTeams) do
			playerCount = playerCount + team.NumPlayers(v)
		end
		
		if table.HasValue(self.targetTeams, TEAM_SPEC) then
			self.TeamName:SetText("Spectators"  .. " - "  .. playerCount .. " players")
		else
			self.TeamName:SetText(team.GetName(self.targetTeams[1]) .. " - "  .. playerCount .. " players")
		end
		
		local toRemove = {}
		
		for i, playerLine in ipairs(self.Scores:GetChildren()) do
			if not IsValid(playerLine.Player) or not table.HasValue(self.targetTeams, playerLine.Player:Team()) then
				table.insert(toRemove, playerLine)

				if IsValid(playerLine.Player) then
					playerLine.Player.ScoreEntry = nil
				end
			end
		end
		
		for i, playerLine in ipairs(toRemove) do
			playerLine:Remove()
			self:GetParent():InvalidateLayout()
		end
		
		local players = {}
		for k, teamId in ipairs(self.targetTeams) do
			local teamPlayers = team.GetPlayers(teamId)
			table.Merge(players, teamPlayers)
		end
		
		for id, player in pairs(players) do
			if (IsValid(player.ScoreEntry)) then continue end
			local playerLine = vgui.CreateFromTable(PLAYER_LINE, self.Scores)
			playerLine:Setup(player)
			player.ScoreEntry = playerLine		
			self:GetParent():InvalidateLayout()
		end
		
	end,
	
	Paint = function(self, w, h)
		w = w - panelX_adjustment
		surface.SetDrawColor(self.TeamColor)
		surface.DrawRect(panel_offsetPadding + 2, 26, w - 4, 1)		--26 is the player row height		or 28? 
	end
	
}
TEAM_GROUP = vgui.RegisterTable(TEAM_GROUP, "DPanel")



local SCORE_BOARD = 
{
	Init = function(self)
		self.Header = self:Add("Panel")
		self.Header:Dock(TOP)
		self.Header:SetHeight(176)
		self.Header:DockMargin(0,22, 0,0)
		
		self.logo = self.Header:Add("DImage")
		self.logo:Dock(LEFT)
		self.logo:SetSize(176,176)
		self.logo:SetImage("vgui/hns/hns_logo")
		self.logo:SetContentAlignment(7)
		self.logo:DockMargin(0,0,0,10)

		self.Name = self.Header:Add("DLabel")
		self.Name:SetFont("ScoreboardDefaultTitle")
		self.Name:SetTextColor(white)
		self.Name:Dock(TOP)
		self.Name:SetHeight(75)
		self.Name:SetContentAlignment(7)
		self.Name:SizeToContents()
		self.Name:DockMargin(18,panel_offsetPadding + 2, panel_offsetPadding + 30,0)
		self.Name:SetExpensiveShadow(2, Color(0, 0, 0, 200))
		
		self.Credits = self.Header:Add("DLabel")
		self.Credits:Dock(LEFT)
		self.Credits:SetWidth(128)
		self.Credits:SetFont("Scoreboard_coolvetica")
		self.Credits:SetTextColor(white)
		self.Credits:SetContentAlignment(7)
		self.Credits:DockMargin(-18,25,0,0)
		self.Credits:SetText(" Created by: Swifty")
		
		self.Rounds = self.Header:Add("DLabel")
		self.Rounds:Dock(TOP)
		self.Rounds:SetWidth(128)
		self.Rounds:SetFont("Scoreboard_coolvetica")
		self.Rounds:SetTextColor(white)
		self.Rounds:SetContentAlignment(6)
		self.Rounds:DockMargin(0,24,panel_offsetPadding + 10,0)
		self.Rounds:SetText("gets updated in the think hook")
		
		self.Ping = self.Header:Add("DLabel")
		self.Ping:Dock(RIGHT)
		self.Ping:SetWidth(100)
		self.Ping:SetFont("ScoreboardDefault2")
		self.Ping:SetTextColor(white)
		self.Ping:SetContentAlignment(2)
		self.Ping:DockMargin(0,0,panel_offsetPadding + 18,0)
		self.Ping:SetText("Ping")
		
		self.Deaths = self.Header:Add("DLabel")
		self.Deaths:Dock(RIGHT)
		self.Deaths:SetWidth(100)
		self.Deaths:SetFont("ScoreboardDefault2")
		self.Deaths:SetTextColor(white)
		self.Deaths:SetContentAlignment(2)
		self.Deaths:DockMargin(0,0,4,0)
		self.Deaths:SetText("Deaths")
		
		self.Kills = self.Header:Add("DLabel")
		self.Kills:Dock(RIGHT)
		self.Kills:SetWidth(100)
		self.Kills:SetFont("ScoreboardDefault2")
		self.Kills:SetTextColor(white)
		self.Kills:SetContentAlignment(2)
		self.Kills:DockMargin(0,0,3,0)
		self.Kills:SetText("Kills")
		
		-- ADD TEAMS HERE
		self.TeamGroups = {}
		self.Teams = {TEAM_SEEKER, TEAM_HIDER, {TEAM_BUILDER, TEAM_SPEC, TEAM_CONNECTING}}
		
		for id, v in pairs(self.Teams) do
			self.TeamGroups[v] = vgui.CreateFromTable(TEAM_GROUP, self)
			self.TeamGroups[v]:SetTeam(v)
		end
		
	end,

	PerformLayout = function(self)
		local offsetX = (ScrW() * .52  + panelX_adjustment) / 2
		local offsetY = (ScrH() * .75 + panelY_adjustment) / 2
		
		self:SetSize(ScrW() * .52 + panelX_adjustment, ScrH() * .75 + panelY_adjustment)
		self:SetPos(ScrW() / 2 - offsetX, ScrH() /2 - offsetY)

		local gy = 110 + panel_offsetPadding
		for id, group in pairs(self.TeamGroups) do
			group:StretchToParent(5, gy, 5, 5)
			
			local playerCount = 0
			
				for _, teamId in ipairs(group.targetTeams) do
					playerCount = playerCount + team.NumPlayers(teamId)
				end

			if playerCount > 0 then
			
				local plyRowHeight = 28
				local labelHeight = group.TeamName:GetTall()
				
				local groupHeight = (plyRowHeight * playerCount) + labelHeight + 10		--the +10 fixes the first player row getting cut off
				if groupHeight <= 72 then	--Gives us a little extra space between teams when the player count is low
					groupHeight = 72
				end
				group:SetTall(groupHeight)
				gy = gy + groupHeight
			else
				group:SetTall(0)
			end
		end
	end,
	
	Paint = function(self, w, h)
		w = w - panelX_adjustment
		h = h - panelY_adjustment
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(panel_offsetPadding, panel_offsetPadding, w, h)	--Scoreboard body
		
		surface.SetDrawColor(Color(32, 32, 32, 175))
		surface.DrawOutlinedRect(panel_offsetPadding, panel_offsetPadding, w, h)	--Scoreboard outline
		
		surface.SetDrawColor(Color(102,204,0,255))
		surface.DrawRect( panel_offsetPadding + 4, panel_offsetPadding + 72, w -4, 22)	--Scoreboard green header
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( panel_offsetPadding + 4, panel_offsetPadding + 72, w -4, 22)		--Outline for green header
		
	end,

	Think = function(self, w, h)
		local hostName = GetHostName()
		self.Name:SetText(hostName)
		
		local roundsLeft = GetGlobalVar("hns_rounds_left") or 1
		self.Rounds:SetText("Rounds:  " .. roundsLeft .. " ")
	end,
}
SCORE_BOARD = vgui.RegisterTable(SCORE_BOARD, "EditablePanel")



function GM:ScoreboardShow()

	if (!IsValid(g_Scoreboard)) then
		g_Scoreboard = vgui.CreateFromTable(SCORE_BOARD)
	end

	if (IsValid(g_Scoreboard)) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled(false)
		isTopMost = false 	--Used when we want to hide a GUI that is not the top most
	end
	
end



function GM:ScoreboardHide()

	if (IsValid(g_Scoreboard)) then
		g_Scoreboard:Hide()
		isTopMost = true 	--Used when we want to hide a GUI that is not the top most
	end
	
end