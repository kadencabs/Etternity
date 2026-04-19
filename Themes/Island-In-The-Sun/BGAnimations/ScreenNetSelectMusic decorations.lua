local curStage = GAMESTATE:GetCurrentStage();
local curStageIndex = GAMESTATE:GetCurrentStageIndex();
local t = LoadFallbackB();

local function PercentScore(pn)
	local t = LoadFont("_overpass Score")..{
		InitCommand=function(self) self:zoom(1):diffuse(Color("Black")):diffusealpha(0.75) end;
		BeginCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			local SongOrCourse = GAMESTATE:GetCurrentSong();
			local StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);

			local profile, scorelist;
			local text = "";
			if SongOrCourse and StepsOrTrail then
				profile = PROFILEMAN:GetProfile(pn) or PROFILEMAN:GetMachineProfile();
				
				local success, scorelist = pcall(function() 
					return profile:GetHighScoreList(SongOrCourse, StepsOrTrail) 
				end)
				
				local topscore = nil
				if success and scorelist then
					local scores = scorelist:GetHighScores()
					topscore = scores[1]
				end
				
				if topscore then
					local wife = topscore:GetWifeScore()
					text = string.format("%.2f%%", wife * 100);
					if text == "100.00%" then text = "100%" end
				else
					text = "0.00%"
				end
			else
				text = ""
			end
			self:settext(text);
		end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
	};

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		t.CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		t.CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
	end

	return t;
end

-- Genre/Artist data
t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic", "info pane")) .. {
		InitCommand=function(self) self:horizalign(center):x(SCREEN_CENTER_X-228):y(SCREEN_CENTER_Y-75):zoom(1) end;
		OnCommand=function(self)
			self:diffuse(ColorMidTone(StageToColor(curStage)));
			self:zoomx(0):diffusealpha(0):decelerate(0.3):zoomx(1):diffusealpha(1);
		end;
		OffCommand=function(self)
			self:sleep(0.3):decelerate(0.15):zoomx(0):diffusealpha(0);
		end;
		};

t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:x(SCREEN_CENTER_X-330+6-138):draworder(126) end;
    OnCommand=function(self) self:diffusealpha(0):smooth(0.3):diffusealpha(1) end;
    OffCommand=function(self) self:smooth(0.3):diffusealpha(0) end;
    -- Length
	StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	SetCommand=function(self)
		local curSelection = GAMESTATE:GetCurrentSong();
		local length = (curSelection and curSelection:MusicLengthSeconds()) or 0.0;
		if curSelection then
			if curSelection:IsLong() then self:queuecommand("Long")
			elseif curSelection:IsMarathon() then self:queuecommand("Marathon")
			else self:queuecommand("Reset") end
		else
			self:queuecommand("Reset")
		end
		self:settext( SecondsToMSS(length) );
	end;
    	CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end;
    };
};

-- Course count and type
-- Course count and type section removed as courses are not in Etterna


if not GAMESTATE:IsCourseMode() then

-- P1 Difficulty Pane
t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1)):horizalign(center):x(SCREEN_CENTER_X-210-32):y(SCREEN_CENTER_Y+230+8) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):smooth(0.4):diffusealpha(1):zoomy(1) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == PLAYER_1 then
				(function(self) self:visible(true):diffusealpha(0):linear(0.3):diffusealpha(1) end)(self);
			end;
		end;
		OffCommand=function(self) self:decelerate(0.3):zoomy(0.8):diffusealpha(0) end;
		LoadActor(THEME:GetPathG("ScreenSelectMusic", "pane background")) .. {
			CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):decelerate(0.3):diffusealpha(1) end;
			ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			SetCommand=function(self)
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					local song = GAMESTATE:GetCurrentSong();
					if song then 
						if stepsP1 ~= nil then
							local st = stepsP1:GetStepsType();
							local diff = stepsP1:GetDifficulty();
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
							local cd = GetCustomDifficulty(st, diff, courseType);
							self:finishtweening():linear(0.2):diffuse(ColorLightTone(CustomDifficultyToColor(cd)));
						else
							self:diffuse(color("#666666"));
						end
					else
							self:diffuse(color("#666666"));
					end
				  end
		};
		LoadFont("StepsDisplay meter") .. { 
			  InitCommand=function(self) self:zoom(1.25):diffuse(color("#000000")):addx(-143):addy(13) end;
			  OnCommand=function(self) self:diffusealpha(0):smooth(0.2):diffusealpha(0.75) end;
			  OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
			  CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75) end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					if stepsP1 ~= nil then
						local st = stepsP1:GetStepsType();
						local diff = stepsP1:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(stepsP1:GetMeter())
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
		LoadFont("Common Italic Condensed") .. { 
			  InitCommand=function(self) self:uppercase(true):zoom(1):addy(-40):addx(-143):diffuse(color("#000000")):maxwidth(115) end;
			  OnCommand=function(self) self:diffusealpha(0):smooth(0.2):diffusealpha(0.75) end;
			  OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
			  CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75) end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					if stepsP1 ~= nil then
						local st = stepsP1:GetStepsType();
						local diff = stepsP1:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)));
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
		LoadFont("Common Normal") .. { 
			  InitCommand=function(self) self:uppercase(true):zoom(0.75):addy(-20):addx(-143):diffuse(color("#000000")):maxwidth(130) end;
			  OnCommand=function(self) self:diffusealpha(0):smooth(0.2):diffusealpha(0.75) end;
			  OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
			  CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75) end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					if stepsP1 ~= nil then
						local st = stepsP1:GetStepsType();
						local diff = stepsP1:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(THEME:GetString("StepsType",ToEnumShortString(st)));
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
	};
	
-- P2 Difficulty Pane	
t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2)):horizalign(center):x(SCREEN_CENTER_X+210+32):y(SCREEN_CENTER_Y+230+8) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):smooth(0.4):diffusealpha(1):zoomy(1) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == PLAYER_2 then
				(function(self) self:visible(true):diffusealpha(0):linear(0.3):diffusealpha(1) end)(self);
			end;
		end;
		OffCommand=function(self) self:decelerate(0.3):zoomy(0.8):diffusealpha(0) end;
		LoadActor(THEME:GetPathG("ScreenSelectMusic", "pane background")) .. {
			InitCommand=function(self) self:zoomx(-1) end;
			CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):decelerate(0.3):diffusealpha(1) end;
			ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			SetCommand=function(self)
					stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
					local song = GAMESTATE:GetCurrentSong();
					if song then 
						if stepsP2 ~= nil then
							local st = stepsP2:GetStepsType();
							local diff = stepsP2:GetDifficulty();
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
							local cd = GetCustomDifficulty(st, diff, courseType);
							self:finishtweening():linear(0.2):diffuse(ColorLightTone(CustomDifficultyToColor(cd)));
						else
							self:diffuse(color("#666666"));
						end
					else
						self:diffuse(color("#666666"));
					end
				  end
		};
		LoadFont("StepsDisplay meter") .. { 
			  InitCommand=function(self) self:zoom(1.25):diffuse(color("#000000")):addx(143):addy(13) end;
			  OnCommand=function(self) self:diffusealpha(0):smooth(0.2):diffusealpha(0.75) end;
			  OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
			  CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75) end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					if stepsP2 ~= nil then
						local st = stepsP2:GetStepsType();
						local diff = stepsP2:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(stepsP2:GetMeter())
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
		LoadFont("Common Italic Condensed") .. { 
			  InitCommand=function(self) self:uppercase(true):zoom(1):addy(-40):addx(143):diffuse(color("#000000")):maxwidth(115) end;
			  OnCommand=function(self) self:diffusealpha(0):smooth(0.2):diffusealpha(0.75) end;
			  OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
			  CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75) end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					if stepsP2 ~= nil then
						local st = stepsP2:GetStepsType();
						local diff = stepsP2:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)));
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
		LoadFont("Common Normal") .. { 
			  InitCommand=function(self) self:uppercase(true):zoom(0.75):addy(-20):addx(143):diffuse(color("#000000")):maxwidth(130) end;
			  OnCommand=function(self) self:diffusealpha(0):smooth(0.2):diffusealpha(0.75) end;
			  OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
			  CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self) self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75) end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					if stepsP2 ~= nil then
						local st = stepsP2:GetStepsType();
						local diff = stepsP2:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(THEME:GetString("StepsType",ToEnumShortString(st)));
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
	};

t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1");
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2");	

t[#t+1] = StandardDecorationFromTable("PercentScore"..ToEnumShortString(PLAYER_1), PercentScore(PLAYER_1));
t[#t+1] = StandardDecorationFromTable("PercentScore"..ToEnumShortString(PLAYER_2), PercentScore(PLAYER_2));


end;

-- BPMDisplay
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:draworder(126):visible(not GAMESTATE:IsCourseMode()) end;
    OnCommand=function(self) self:diffusealpha(0):smooth(0.3):diffusealpha(1) end;
    OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
    LoadFont("Common Condensed") .. {
          InitCommand=function(self) self:horizalign(right):x(SCREEN_CENTER_X-198+69-66):y(SCREEN_CENTER_Y-78+2):diffuse(color("#512232")):horizalign(right):visible(not GAMESTATE:IsCourseMode()) end;
          OnCommand=function(self) self:queuecommand("Set") end;
          ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
          SetCommand=function(self)
              self:settext("BPM"):diffuse(ColorLightTone(StageToColor(curStage)));
              end;
    };
    StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
};


return t;