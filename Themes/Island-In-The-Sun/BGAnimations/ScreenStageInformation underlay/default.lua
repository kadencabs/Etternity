local playMode = GAMESTATE:GetPlayMode()
local slideTime = 1.1;
local slideWait = 1.25;
local bottomSlide = 0.5;
local easeTime = 0.10;

local sStage = ""
sStage = GAMESTATE:GetCurrentStage()

if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
  sStage = playMode;
end;

local t = Def.ActorFrame {};
t[#t+1] = Def.Quad {
	InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(Color("Black")) end;
};

t[#t+1] = Def.Sprite {
	InitCommand=function(self) self:Center():diffusealpha(0.26) end;
	BeginCommand=function(self) self:LoadFromCurrentSongBackground() end;
	OnCommand=function(self)
		self:scale_or_crop_background()
		self:addy(SCREEN_HEIGHT):sleep(slideWait):smooth(slideTime):addy(-SCREEN_HEIGHT):diffusealpha(1);
	end;
};


-- BG for credits
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self) self:addy(SCREEN_HEIGHT):sleep(slideWait):smooth(slideTime+easeTime):addy(-SCREEN_HEIGHT):sleep(2-easeTime):smooth(bottomSlide):addy(240) end;
	-- Behind stage graphic
	Def.Quad {
		InitCommand=function(self) self:vertalign(bottom):x(SCREEN_CENTER_X):y(SCREEN_BOTTOM-110):zoomto(SCREEN_WIDTH,120) end;
		OnCommand=function(self)
			self:diffuse(color("#000000")):diffusealpha(0.8);
		end
	};
	-- Behind song
	Def.Quad {
		InitCommand=function(self) self:vertalign(bottom):x(SCREEN_CENTER_X):y(SCREEN_BOTTOM):zoomto(SCREEN_WIDTH,110) end;
		OnCommand=function(self)
			self:diffuse(color("#000000")):diffusealpha(0.9);
		end
	};
};


local stage_num_actor= THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage), true)
if stage_num_actor ~= "" and FILEMAN:DoesFileExist(stage_num_actor) then
	stage_num_actor= LoadActor(stage_num_actor)
else
	-- Midiman:  We need a "Stage Next" actor or something for stages after
	-- the 6th. -Kyz
	local curStage = GAMESTATE:GetCurrentStage();
	stage_num_actor= Def.BitmapText{
		Font= "Common Normal",  Text= thified_curstage_index(false) .. " Stage",
		InitCommand= function(self)
			self:zoom(1.5)
			self:strokecolor(Color.Black)
			self:diffuse(StageToColor(curStage));
			self:diffusetopedge(ColorLightTone(StageToColor(curStage)));
		end
	}
end

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+190) end;
	OnCommand=function(self) self:addy(SCREEN_HEIGHT):sleep(slideWait):smooth(slideTime+easeTime):addy(-SCREEN_HEIGHT):sleep(2-easeTime):smooth(bottomSlide):addy(240) end;

	stage_num_actor .. {
		OnCommand=function(self) self:zoom(1):diffusealpha(1) end;
	};
};

-- Step author credits
	if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
	t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:y(SCREEN_BOTTOM-80):x(SCREEN_LEFT+40) end;
	OnCommand=function(self) self:addy(SCREEN_HEIGHT):sleep(slideWait):smooth(slideTime+easeTime):addy(-SCREEN_HEIGHT):sleep(2-easeTime):smooth(bottomSlide):addy(240) end;
		LoadFont("Common Italic Condensed") .. {
		  OnCommand=function(self) self:playcommand("Set"):horizalign(left):diffuse(color("#FFFFFF")) end;
          SetCommand=function(self)
			stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if stepsP1:GetAuthorCredit() ~= "" then
					self:settext(string.upper(THEME:GetString("OptionTitles","Step Author")) .. ":");
				else
					self:settext("")
				end
			else
				self:settext("")
			end
         end
		};
		LoadFont("Common Fallback Font") .. {
		  InitCommand=function(self) self:addy(22) end;
		  OnCommand=function(self) self:playcommand("Set"):horizalign(left):zoom(0.75):diffuse(color("#FFFFFF")) end;
          SetCommand=function(self)
			stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if stepsP1 ~= nil then
					self:settext(stepsP1:GetAuthorCredit())
				else
					self:settext("")
				end
			else
				self:settext("")
			end
         end
		};
	};
	end
	
	if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
	t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:y(SCREEN_BOTTOM-80):x(SCREEN_RIGHT-40) end;
	OnCommand=function(self) self:addy(SCREEN_HEIGHT):sleep(slideWait):smooth(slideTime+easeTime):addy(-SCREEN_HEIGHT):sleep(2-easeTime):smooth(bottomSlide):addy(240) end;
	LoadFont("Common Italic Condensed") .. {
		  OnCommand=function(self) self:playcommand("Set"):horizalign(right):diffuse(color("#FFFFFF")) end;
          SetCommand=function(self)
			stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local diff = stepsP2:GetDifficulty();
				if stepsP2:GetAuthorCredit() ~= "" then
					self:settext(string.upper(THEME:GetString("OptionTitles","Step Author")) .. ":");
				else
					self:settext("")
				end
			else
				self:settext("")
			end
         end
		};

	LoadFont("Common Fallback Font") .. {
		  InitCommand=function(self) self:addy(22) end;
		  OnCommand=function(self) self:playcommand("Set"):horizalign(right):zoom(0.75):diffuse(color("#FFFFFF")) end;
          SetCommand=function(self)
			stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if stepsP2 ~= nil then
					self:settext(stepsP2:GetAuthorCredit())
				else
					self:settext("")
				end
			else
				self:settext("")
			end
          end
	};
	};
	end

-- Song title and artist
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_BOTTOM-80) end;
	OnCommand=function(self) self:addy(SCREEN_HEIGHT):sleep(slideWait):smooth(slideTime+easeTime):addy(-SCREEN_HEIGHT):sleep(2-easeTime):smooth(bottomSlide):addy(240) end;
	LoadFont("Common Fallback Font") .. {
		Text=GAMESTATE:GetCurrentSong():GetDisplayFullTitle();
		InitCommand=function(self) self:diffuse(color("#FFFFFF")):maxwidth(SCREEN_WIDTH*0.6) end;
		OnCommand=function(self) self:zoom(1) end;
	};
	LoadFont("Common Fallback Font") .. {
		Text=GAMESTATE:GetCurrentSong():GetDisplayArtist();
		InitCommand=function(self) self:diffuse(color("#FFFFFF")):maxwidth(SCREEN_WIDTH*0.6) end;
		OnCommand=function(self) self:zoom(0.75):addy(24) end;
	};
};

-- Stunt BG in case the BG accidentally overhangs
t[#t+1] = Def.Quad {
	InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(Color("Black")) end;
	OnCommand=function(self) self:sleep(slideWait):smooth(slideTime):addy(-SCREEN_HEIGHT):sleep(0.2):diffusealpha(0) end;
};

t[#t+1] = Def.ActorFrame {
	LoadActor("_arrow") .. {
		InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):diffuse(color("#DAD6CC")) end;
		OnCommand=function(self) self:diffusealpha(0):sleep(0.5):diffusealpha(0.6):decelerate(0.4):zoom(1.2):diffusealpha(0) end;
	};
	LoadActor("_arrow") .. {
		InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):diffuse(color("#DAD6CC")) end;
		OnCommand=function(self) self:zoom(0):bounceend(0.5):zoom(1):sleep(0.75):smooth(slideTime):addy(-SCREEN_HEIGHT) end;
	};
};

return t