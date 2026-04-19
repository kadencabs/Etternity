local curStage = GAMESTATE:GetCurrentStage();
local curStageIndex = (GAMESTATE.GetCurrentStageIndex and GAMESTATE:GetCurrentStageIndex()) or 0;
local t = LoadFallbackB();

local function GetSteps( pnPlayer )
	local steps = GAMESTATE:GetCurrentSteps( pnPlayer )
	local song = GAMESTATE:GetCurrentSong()

	-- Validation: Ensure steps belong to the current song to avoid stale data during transitions
	-- Defensive check: ensure steps is userdata and has GetSong method
	if steps and song and type(steps) == "userdata" and steps.GetSong and steps:GetSong() ~= song then
		steps = nil
	end

	if not steps then
		-- Fallback to the other player if the current one isn't joined or is stale
		if pnPlayer == PLAYER_1 then
			steps = GAMESTATE:GetCurrentSteps( PLAYER_2 )
		else
			steps = GAMESTATE:GetCurrentSteps( PLAYER_1 )
		end
		if steps and song and type(steps) == "userdata" and steps.GetSong and steps:GetSong() ~= song then
			steps = nil
		end
	end

	-- Final Fallback: If still nil, try to get the first available chart for the song
	if not steps and song then
		local st = GAMESTATE:GetCurrentStyle():GetStepsType()
		local allSteps = song:GetStepsByStepsType(st)
		if allSteps and #allSteps > 0 then
			steps = allSteps[1]
		end
	end

	return steps
end

local function GetEtternaBestScore(song, steps)
	if not song or not steps then return nil end
	local topscore = nil
	local function rate_key_to_number(k)
		if k == nil then return nil end
		if type(k) == "number" then return k end
		if type(k) == "string" then
			local n = tonumber(k)
			if n then return n end
			local m = k:match("([0-9]+%.[0-9]+)") or k:match("([0-9]+)")
			return tonumber(m)
		end
		return nil
	end
	
	-- 1. Try modern ScoreManager (handles all rates and is most efficient)
	if SCOREMAN then
		local scores = SCOREMAN:GetScoresByKey(steps:GetChartKey())
		if scores then
			local bestWife = -1
			local targetRate = nil
			if GAMESTATE and GAMESTATE.GetSongOptionsObject then
				local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
				if so and so.MusicRate then
					targetRate = so:MusicRate()
				end
			end
			local bestScorelist = nil
			if targetRate then
				local bestDiff = math.huge
				for rateKey, scorelist in pairs(scores) do
					local r = rate_key_to_number(rateKey)
					if r then
						local d = math.abs(r - targetRate)
						if d < bestDiff then
							bestDiff = d
							bestScorelist = scorelist
						end
					end
				end
			end
			local function consider_scorelist(scorelist)
				if not scorelist then return end
				local list = scorelist:GetScores()
				for _, score in ipairs(list) do
					local wife = score:GetWifeScore()
					if wife == 0 and score.ConvertDpToWife then
						wife = score:ConvertDpToWife()
					end
					if wife > bestWife then
						bestWife = wife
						topscore = score
					end
				end
			end
			consider_scorelist(bestScorelist)
			if not topscore then
				for _, scorelist in pairs(scores) do
					consider_scorelist(scorelist)
				end
			end
		end
	end
	
	-- 2. Fallback to traditional profile list if nothing found yet
	if not topscore then
		local profiles = {
			PROFILEMAN:GetProfile(PLAYER_1),
			PROFILEMAN:GetMachineProfile()
		}
		
		for _, profile in ipairs(profiles) do
			if profile then
				local success, scorelist = pcall(function()
					return profile:GetHighScoreList(song, steps)
				end)
				if success and scorelist then
					local scores = scorelist:GetHighScores()
					if scores and scores[1] then
						topscore = scores[1]
						break
					end
				end
			end
		end
	end
	
	if topscore then
		local wife = topscore:GetWifeScore()
		-- Fallback to ConvertDpToWife for scores without explicit WifeScore field
		if wife == 0 and topscore.ConvertDpToWife then
			wife = topscore:ConvertDpToWife()
		end
		return topscore, wife * 100
	end
	
	return nil, 0
end

local function GradeDisplay(pn)
	return LoadFont("Common Normal") .. {
		Name="GradeText";
		InitCommand=function(self) 
			self:visible(false):zoom(3):shadowlength(1):horizalign(center)
			self:x(0):y(0)
		end;
		BeginCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			local steps = GetSteps(pn)
			
			if song and steps then
				local topscore, _ = GetEtternaBestScore(song, steps)
				
				if topscore then
					local grade = nil
					if topscore.GetWifeGrade then
						grade = topscore:GetWifeGrade()
					else
						grade = topscore:GetGrade()
					end
					if grade and grade ~= "Grade_None" then
						self:settext(GetGradeString(grade))
						self:diffuse(GetGradeColor(grade))
						self:visible(true)
					else
						self:visible(false)
					end
				else
					self:visible(false)
				end
			else
				self:visible(false)
			end
		end;
		CurrentSongChangedMessageCommand=function(self) self:finishtweening():queuecommand("Set") end;
		CurrentStepsP1ChangedMessageCommand=function(self) self:finishtweening():queuecommand("Set") end;
		CurrentStepsP2ChangedMessageCommand=function(self) self:finishtweening():queuecommand("Set") end;
	}
end
local function PercentScore(pn)
	local lastValue = -1
	local function GetScoreDisplayValue()
		local song = GAMESTATE:GetCurrentSong();
		local steps = GetSteps(pn);
		
		if song and steps then
			local _, percent = GetEtternaBestScore(song, steps)
			return percent
		end
		return 0
	end

	return Def.ActorFrame {
		InitCommand=function(self)
			self:SetUpdateFunction(function(frame)
				local value = GetScoreDisplayValue()
				if math.abs(value - lastValue) > 0.0001 then
					lastValue = value
					local textChild = frame:GetChild("ScoreText")
					if textChild then
						local formatStr = "%.2f%%"
						-- Show 4 decimal points when above 99.7%
						if value > 99.7 then
							formatStr = "%.4f%%"
						end
						local text = string.format(formatStr, value)
						if text == "100.0000%" then text = "100%" end
						textChild:settext(text)
					end
				end
			end)
		end;
		LoadFont("_overpass Score")..{
			Name="ScoreText";
			InitCommand=function(self) 
				self:zoom(1):diffuse(Color("Black")):diffusealpha(0.75)
				if pn == PLAYER_1 then
					self:horizalign(right)
				else
					self:horizalign(left)
				end
				self:settext("0.00%")
			end;
		};
	};
end

local function OverallMSDGrade(pn)
	if pn == PLAYER_1 then return Def.Actor {} end

	local lastValue = -1
	return Def.ActorFrame {
		InitCommand=function(self)
			self:SetUpdateFunction(function(frame)
				local steps = GetSteps(PLAYER_1)
				local value = 0
				if steps then
					local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
					local msd = steps:GetMSD(rate, 1)
					value = math.floor(msd)
				end
				if value ~= lastValue then
					lastValue = value
					local textChild = frame:GetChild("MSDText")
					if textChild then
						textChild:settext(tostring(value))
					end
				end
			end)
		end;
		LoadFont("_overpass Score")..{
			Name="MSDText";
			InitCommand=function(self) 
				self:zoom(2.0):diffuse(Color("Black")):diffusealpha(0.75):horizalign(center)
				self:y(-10)
				self:settext("0")
			end;
		};
	};
end

local function MSDDecimalP2(pn)
	if pn == PLAYER_1 then return Def.Actor {} end

	local lastValue = -1
	return Def.ActorFrame {
		InitCommand=function(self)
			self:SetUpdateFunction(function(frame)
				local steps = GetSteps(PLAYER_1)
				local decimal = 0
				if steps then
					local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
					local msd = steps:GetMSD(rate, 1)
					_, decimal = math.modf(msd)
				end
				if math.abs(decimal - lastValue) > 0.01 then
					lastValue = decimal
					local textChild = frame:GetChild("DecimalText")
					if textChild then
						textChild:settextf(".%02d", math.floor(decimal * 100))
					end
				end
			end)
		end;
		LoadFont("_overpass Score")..{
			Name="DecimalText";
			InitCommand=function(self) 
				self:zoom(1):diffuse(Color("Black")):diffusealpha(0.75):horizalign(center)
				self:y(15)
				self:settext(".00")
			end;
		};
	};
end

-- Banner underlay
-- t[#t+1] = Def.ActorFrame {
    -- InitCommand=function(self) self:x(SCREEN_CENTER_X-230):draworder(125) end;
    -- OffCommand=function(self) self:smooth(0.2):diffusealpha(0) end;
    -- Def.Quad {
        -- InitCommand=function(self) self:zoomto(468,196):diffuse(color("#fce1a1")):diffusealpha(0.4):vertalign(top):y(SCREEN_CENTER_Y-230) end;
      -- };
-- };

-- Banner 

t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic", "banner overlay")) .. {
		InitCommand=function(self) self:zoom(1):x(SCREEN_CENTER_X-228):y(SCREEN_CENTER_Y-165-20):draworder(47) end;
		OnCommand=function(self)
			self:diffuse(StageToColor(curStage));
			self:zoomy(0):decelerate(0.3):zoomy(1);
		end;
		OffCommand=function(self) self:decelerate(0.15):zoomx(0) end;
	};

-- Custom Banner with fallback to jacket/background
if not GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.Sprite {
		Name="SongBanner";
		InitCommand=function(self) 
			self:draworder(45):x(SCREEN_CENTER_X-228):y(SCREEN_CENTER_Y-165-20)
		end;
		OnCommand=function(self)
			self:zoomy(0):decelerate(0.3):zoomy(1)
		end;
		OffCommand=function(self) self:decelerate(0.2):zoomx(0) end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				if song:HasBanner() then
					self:LoadBanner(song:GetBannerPath())
					self:scaletoclipped(468,146)
					self:visible(true)
				elseif song:HasJacket() then
					self:LoadBanner(song:GetJacketPath())
					self:scaletoclipped(468,146)
					self:visible(true)
				elseif song:HasBackground() then
					self:LoadBanner(song:GetBackgroundPath())
					self:scaletoclipped(468,146)
					self:visible(true)
				else
					self:Load(THEME:GetPathG("Common fallback", "banner"))
					self:scaletoclipped(468,146)
					self:visible(true)
				end
			else
				self:Load(THEME:GetPathG("Common fallback", "banner"))
				self:scaletoclipped(468,146)
				self:visible(true)
			end
		end;
	};
end;


-- Genre/Artist data
t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic", "info pane")) .. {
		InitCommand=function(self) self:horizalign(center):x(SCREEN_CENTER_X-228):y(SCREEN_CENTER_Y-75-6):zoom(1) end;
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
    	CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end;
    	CurrentTrailP1ChangedMessageCommand=function(self) self:queuecommand("Set") end;
    	CurrentTrailP2ChangedMessageCommand=function(self) self:queuecommand("Set") end;
    };
};

-- Course count and type
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:x(SCREEN_CENTER_X-200):draworder(126) end;
    OnCommand=function(self) self:diffusealpha(0):smooth(0.3):diffusealpha(1) end;
    OffCommand=function(self) self:smooth(0.2):diffusealpha(0) end;
	LoadFont("Common Condensed") .. { 
          InitCommand=function(self) self:horizalign(right):zoom(1.0):y(SCREEN_CENTER_Y-78+2-6):maxwidth(180):diffuse(color("#DFE2E9")):visible(GAMESTATE:IsCourseMode()) end;
          CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end; 
          ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end; 
          SetCommand=function(self) 
               local course = GAMESTATE:GetCurrentCourse(); 
               if course then
                    self:settext(course:GetEstimatedNumStages() .. " songs"); 
                    self:queuecommand("Refresh");
				else
					self:settext("");
					self:queuecommand("Refresh"); 	
               end 
          end; 
		};
};
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:x(SCREEN_CENTER_X+5):draworder(126) end;
    OnCommand=function(self) self:diffusealpha(0):smooth(0.3):diffusealpha(1) end;
    OffCommand=function(self) self:smooth(0.2):diffusealpha(0) end;
	LoadFont("Common Condensed") .. { 
          InitCommand=function(self) self:horizalign(right):zoom(1.0):y(SCREEN_CENTER_Y-76-6):maxwidth(180):diffuse(color("#DFE2E9")):visible(GAMESTATE:IsCourseMode()) end;
          CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end; 
          ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end; 
          SetCommand=function(self) 
               local course = GAMESTATE:GetCurrentCourse(); 
               if course then
                    self:settext(CourseTypeToLocalizedString(course:GetCourseType())); 
                    self:queuecommand("Refresh");
				else
					self:settext("");
					self:queuecommand("Refresh"); 	
               end 
          end; 
		};
};
-- CourseContentsList removed as it crashes in Etterna
-- t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList");


if not GAMESTATE:IsCourseMode() then

-- P1 Difficulty Pane
t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1)):horizalign(center):x(SCREEN_CENTER_X-210-32):y(SCREEN_CENTER_Y+230+10) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):smooth(0.4):diffusealpha(1):zoomy(1) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == PLAYER_1 then
				(function(self) self:visible(true):diffusealpha(0):linear(0.3):diffusealpha(1) end)(self);
			end;
		end;
		OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;
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
		InitCommand=function(self) self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2)):horizalign(center):x(SCREEN_CENTER_X+210+32):y(SCREEN_CENTER_Y+230+10) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):smooth(0.4):diffusealpha(1):zoomy(1) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == PLAYER_2 then
				(function(self) self:visible(true):diffusealpha(0):linear(0.3):diffusealpha(1) end)(self);
			end;
		end;
		OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;
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

-- Custom PaneDisplay with direct polling for P1 note counts and P2 MSD skillsets
local lastStepsP1Meter = nil
local lastStepsP1Diff = nil

local function GetChartHash()
	local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
	if not steps then return "nil" end
	return tostring(steps:GetMeter()) .. "_" .. tostring(steps:GetDifficulty())
end

local radarCategories = {
	'TapsAndHolds', 'Jumps', 'Holds', 'Mines', 'Hands', 'Rolls', 'Lifts', 'Fakes'
}

local radarLabels = {
	"Taps", "Jumps", "Holds", "Mines", "Hands", "Rolls", "Lifts", "Fakes"
}

local skillsets = {
	"Stream", "Jumpstream", "Handstream", "Stamina", 
	"Jackspeed", "Chordjack", "Technical"
}

-- MSD indices: 2-8 are skillsets
local msdIndices = {2, 3, 4, 5, 6, 7, 8}

-- Create P1 Note Count Display
for i = 1, 8 do
	local xPos = (i <= 4) and (-128+16+8) or 36
	local yPos = (i <= 4) and (-14 + (i-1)*24) or (-14 + (i-5)*24)
	
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) 
			self:x(SCREEN_CENTER_X-200+24-32 + xPos):y(SCREEN_CENTER_Y+207+10 + yPos)
			self.lastValue = -1
			self:SetUpdateFunction(function(frame)
				local steps = GetSteps(PLAYER_1)
				local value = 0
				if steps then
					local rv = steps:GetRadarValues(PLAYER_1)
					local cat = "RadarCategory_" .. radarCategories[i]
					value = rv:GetValue(cat) or 0
				end
				if value ~= frame.lastValue then
					frame.lastValue = value
					local textChild = frame:GetChild("ValueText")
					if textChild then
						textChild:settextf("%04d", math.floor(value))
					end
				end
			end)
		end;
		-- Label
		LoadFont("Common Italic Condensed")..{
			InitCommand=function(self) 
				self:horizalign(left):zoom(0.8):diffuse(color("0.9,0.9,0.9")):shadowlength(1)
				self:settext(string.upper(THEME:GetString("PaneDisplay", radarLabels[i])))
			end;
		};
		-- Value
		LoadFont("Common Condensed")..{
			Name="ValueText";
			InitCommand=function(self) 
				self:x(122):horizalign(right):zoom(0.8):shadowlength(1)
				self:settext("0000")
			end;
		};
	}
end

-- Create P2 MSD Skillset Display
for i = 1, 7 do
	local xPos = (i <= 4) and (-128+16+8) or 36
	local yPos = (i <= 4) and (-14 + (i-1)*24) or (-14 + (i-5)*24)
	
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) 
			self:x(SCREEN_CENTER_X+200-72-4+32 + xPos):y(SCREEN_CENTER_Y+207+10 + yPos)
			self.lastValue = -1
			self:SetUpdateFunction(function(frame)
				local steps = GetSteps(PLAYER_1)  -- P2 shows P1's selected chart
				local value = 0
				if steps then
					local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
					value = steps:GetMSD(rate, msdIndices[i]) or 0
				end
				if math.abs(value - frame.lastValue) > 0.01 then
					frame.lastValue = value
					local textChild = frame:GetChild("ValueText")
					if textChild then
						textChild:settextf("%05.2f", value)
					end
				end
			end)
		end;
		-- Label
		LoadFont("Common Italic Condensed")..{
			InitCommand=function(self) 
				self:horizalign(left):zoom(0.8):diffuse(color("0.9,0.9,0.9")):shadowlength(1)
				self:settext(string.upper(THEME:GetString("PaneDisplay", "Skillset" .. skillsets[i])))
			end;
		};
		-- Value
		LoadFont("Common Condensed")..{
			Name="ValueText";
			InitCommand=function(self) 
				self:x(122):horizalign(right):zoom(0.8):shadowlength(1)
				self:settext("00.00")
			end;
		};
	}
end	

-- New standalone Best Score function for P1
local function BestScore(pn)
	if pn ~= PLAYER_1 then return Def.Actor {} end

	local lastValue = -1
	local lastSong = nil
	local lastSteps = nil
	
	local t = Def.ActorFrame {
		InitCommand=function(self)
			self:x(THEME:GetMetric("ScreenSelectMusic", "BestScoreP1X")-45)
			self:y(THEME:GetMetric("ScreenSelectMusic", "BestScoreP1Y"))
			self:SetUpdateFunction(function(frame)
				local song = GAMESTATE:GetCurrentSong()
				local steps = GetSteps(PLAYER_1)
				
				-- Only update when the song or chart actually changes
				if song ~= lastSong or steps ~= lastSteps then
					lastSong = song
					lastSteps = steps
					
					local value = 0
					if song and steps then
						local topscore, percent = GetEtternaBestScore(song, steps)
						if topscore then
							value = percent
						end
						
						-- Force update the grade display child
						local gradeChild = frame:GetChild("GradeDisplayChild")
						if gradeChild then
							gradeChild:playcommand("Set")
						end
					end
					
					if math.abs(value - lastValue) > 0.0001 then
						lastValue = value
						local textChild = frame:GetChild("ScoreText")
						if textChild then
							local formatStr = "%.2f%%"
							if value > 99.7 then
								formatStr = "%.4f%%"
							end
							local text = string.format(formatStr, value)
							if text == "100.0000%" then text = "100%" end
							textChild:settext(text)
						end
					end
				end
			end)
		end;
		
		-- Percentage Score
		LoadFont("_overpass Score")..{
			Name="ScoreText";
			InitCommand=function(self) 
				self:horizalign(left):zoom(0.35):diffuse(Color("Black")):diffusealpha(0.75)
				self:settext("0.00%")
			end;
		};
	}

	-- Add Grade Sprite above the score
	t[#t+1] = GradeDisplay(pn) .. {
		Name="GradeDisplayChild";
		InitCommand=function(self) 
			-- Center it better within the P1 pane and make it larger
			self:x(40):y(-55):zoom(2.25) 
		end;
	}

	return t
end

t[#t+1] = BestScore(PLAYER_1)
t[#t+1] = StandardDecorationFromTable("MSDDecimal"..ToEnumShortString(PLAYER_2), MSDDecimalP2(PLAYER_2));
-- Standalone GradeDisplay for P1 removed as it is now integrated into BestScore
t[#t+1] = StandardDecorationFromTable("OverallMSDGrade"..ToEnumShortString(PLAYER_2), OverallMSDGrade(PLAYER_2));

end;


if not GAMESTATE:IsCourseMode() then
-- CD title
	local function CDTitleUpdate(self)
		local song = GAMESTATE:GetCurrentSong();
		local cdtitle = self:GetChild("CDTitle");
		
		if song then
			if song:HasCDTitle() then
				cdtitle:Load(song:GetCDTitlePath());
				cdtitle:scaletoclipped(100,100);
				cdtitle:visible(true);
			else
				cdtitle:visible(false);
			end;
		else
			cdtitle:visible(false);
		end;
	end;
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) self:draworder(200):x(SCREEN_CENTER_X-420):y(SCREEN_CENTER_Y-147):zoom(0):sleep(0.5):decelerate(0.25):zoom(1):SetUpdateFunction(CDTitleUpdate) end;
		OffCommand=function(self) self:decelerate(0.3):zoomy(0) end;
		Def.Sprite {
			Name="CDTitle";
			InitCommand=function(self) self:draworder(200):visible(false) end;
			OnCommand=function(self) self:diffusealpha(1):zoom(0):bounceend(0.35):zoom(1) end;
			BackCullCommand=function(self) self:diffuse(color("0.5,0.5,0.5,1")) end;
			OffCommand=function(self) self:decelerate(0.3):zoomy(0) end;
		};	
	};
end;

-- BPMDisplay
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:draworder(126):visible(not GAMESTATE:IsCourseMode()) end;
    OnCommand=function(self) self:diffusealpha(0):smooth(0.3):diffusealpha(1) end;
    OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
    LoadFont("Common Condensed") .. {
          InitCommand=function(self) self:horizalign(right):x(SCREEN_CENTER_X-198+69-66):y(SCREEN_CENTER_Y-76-6):diffuse(color("#512232")):horizalign(right):visible(not GAMESTATE:IsCourseMode()) end;
          OnCommand=function(self) self:queuecommand("Set") end;
          ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
          SetCommand=function(self)
              self:settext("BPM"):diffuse(ColorLightTone(StageToColor(curStage)));
              end;
    };
    StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
};

t[#t+1] = StandardDecorationFromFileOptional("DifficultyList","DifficultyList");
t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptionsText") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsHideCommand");
};

t[#t+1] = Def.ActorFrame{
	Def.Quad{
		InitCommand=function(self) self:draworder(160):FullScreen():diffuse(color("0,0,0,1")):diffusealpha(0) end;
		ShowPressStartForOptionsCommand=function(self) self:sleep(0.2):decelerate(0.5):diffusealpha(1) end;
	};
};

t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay");


t[#t+1] = Def.ActorFrame {
    OffCommand=function(self) self:sleep(0.1):linear(0.2):diffusealpha(0) end;
    InitCommand=function(self) self:x(SCREEN_CENTER_X-84):visible(not GAMESTATE:IsCourseMode()) end;

	StandardDecorationFromFileOptional("StageDisplay","StageDisplay") .. {
		InitCommand=function(self) self:zoom(1) end;
	};
};

return t;