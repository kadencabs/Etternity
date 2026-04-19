local t = Def.ActorFrame {
	FOV=90;
	InitCommand=function(self) self:runcommandsonleaves(function(self) self:ztest(true) end) end;
};

t[#t+1] = LoadActor("frame") .. {
	InitCommand=function(self) self:diffusealpha(0.8) end;
};


t[#t+1] = Def.TextBanner {
	InitCommand=function(self) self:x(-230):Load("TextBannerHighScores") end;
	SetCommand=function(self, params)
		if params.Song then
			self:SetFromSong( params.Song );
			self:diffuse( SONGMAN:GetSongColor(params.Song) );
		else
			self:settext(""); -- Courses removed
		end
	end;
};

local NumColumns = THEME:GetMetric(Var "LoadingScreen", "NumColumns");

local c;
local Scores = Def.ActorFrame {
	InitCommand = function(self)
		c = self:GetChildren();
	end;
};
t[#t+1] = Scores;

for idx=1,NumColumns do
	local x_pos = 35 + 83 * (idx-1);
	Scores[#Scores+1] = LoadFont(Var "LoadingScreen","Name") .. {
		Name = idx .. "Name";
		InitCommand=function(self) self:x(x_pos):y(8):shadowlength(1):maxwidth(68) end;
		OnCommand=function(self) self:zoom(0.75) end;
	};
	Scores[#Scores+1] = LoadFont(Var "LoadingScreen","Score") .. {
		Name = idx .. "Score";
		InitCommand=function(self) self:x(x_pos):y(-9):shadowlength(1):maxwidth(68) end;
		OnCommand=function(self) self:zoom(0.75) end;
	};
	Scores[#Scores+1] = LoadActor("empty") .. {
		Name = idx .. "Empty";
		InitCommand=function(self) self:x(x_pos) end;
		OnCommand=function(self) self:zoom(0.75) end;
	};
	
end

local sNoScoreName = THEME:GetMetric("Common", "NoScoreName");

Scores.SetCommand=function(self, params)
	local pProfile = PROFILEMAN:GetMachineProfile();

	for name, child in pairs(c) do
		child:visible(false);
	end
	for idx=1,NumColumns do
		c[idx .. "Empty"]:visible(true);
	end

	local Current = params.Song; -- Ignore params.Course
	if Current then
		for idx, CurrentItem in pairs(params.Entries) do
			if CurrentItem then
				local success, hsl = pcall(function() return pProfile:GetHighScoreList(Current, CurrentItem) end)
				local hs = success and hsl and hsl:GetHighScores();

				local name = c[idx .. "Name"];
				local score = c[idx .. "Score"];
				local empty = c[idx .. "Empty"];
				
				name:visible( true );
				score:visible( true );
				empty:visible( false );
				
				if hs and #hs > 0 then
					name:settext( hs[1]:GetName() );
					local wife = hs[1]:GetWifeScore()
					local text = string.format("%.2f%%", wife * 100)
					if wife > 0.997 then text = string.format("%.4f%%", wife * 100) end
					score:settext( text );
				else
					name:settext( sNoScoreName );
					score:settext( "0.00%" );
				end
			end
		end;
	end
end;

return t;
