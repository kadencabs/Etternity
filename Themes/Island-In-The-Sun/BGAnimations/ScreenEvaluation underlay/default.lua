local t = Def.ActorFrame {};

-- A very useful table...
local eval_lines = {
	"W1",
	"W2",
	"W3",
	"W4",
	"W5",
	"Miss",
	"MaxCombo"
}

local eval_radar = {
	Types = { 'Holds', 'Rolls', 'Hands', 'Mines', 'Lifts' },
}

local grade_area_offset = 16
local fade_out_speed = 0.3
local fade_out_pause = 0.08

-- And a function to make even better use out of the table.
local function GetJLineValue(line, pl)
	if line == "Held" then
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetHoldNoteScores("HoldNoteScore_Held")
	elseif line == "MaxCombo" then
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):MaxCombo()
	else
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetTapNoteScores("TapNoteScore_" .. line)
	end
	return "???"
end

-- Function to get total tap notes for percentage calculation
local function GetTotalTaps(pl)
	local total = 0
	for i, v in ipairs(eval_lines) do
		if v ~= "MaxCombo" then
			total = total + GetJLineValue(v, pl)
		end
	end
	return total
end

-- You know what, we'll deal with getting the overall scores with a function too.
local function GetPlScore(pl, scoretype)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl)
	if not pss then return "0.00%" end
	local wife = pss:GetWifeScore()
	local primary_score = string.format("%.2f%%", wife * 100)
	if wife > 0.997 then
		primary_score = string.format("%.4f%%", wife * 100)
	end
	if primary_score == "100.0000%" then primary_score = "100%" end
	
	return primary_score
end

-- Function to get the best score for a player
local function GetBestScoreForPlayer(pl)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl)
	if not pss then return nil, 0 end
	
	local song = GAMESTATE:GetCurrentSong()
	local steps = GAMESTATE:GetCurrentSteps(pl)
	if not song or not steps then return nil, 0 end
	
	-- Try to get best score from SCOREMAN
	if SCOREMAN then
		local scores = SCOREMAN:GetScoresByKey(steps:GetChartKey())
		if scores then
			local bestWife = -1
			local bestScore = nil
			for rate, scorelist in pairs(scores) do
				local list = scorelist:GetScores()
				for _, score in ipairs(list) do
					local wife = score:GetWifeScore()
					if wife == 0 and score.ConvertDpToWife then
						wife = score:ConvertDpToWife()
					end
					if wife > bestWife then
						bestWife = wife
						bestScore = score
					end
				end
			end
			if bestScore then
				return bestScore, bestWife * 100
			end
			end
	end
	
	-- Fallback to profile high scores
	local profile = PROFILEMAN:GetProfile(pl)
	if profile then
		local success, scorelist = pcall(function()
			return profile:GetHighScoreList(song, steps)
		end)
		if success and scorelist then
			local scores = scorelist:GetHighScores()
			if scores and scores[1] then
				local wife = scores[1]:GetWifeScore()
				if wife == 0 and scores[1].ConvertDpToWife then
					wife = scores[1]:ConvertDpToWife()
				end
				return scores[1], wife * 100
			end
		end
	end
	
	return nil, 0
end

-- Function to get MSD and SSR data
local function GetMSDAndSSR(pl)
	local steps = GAMESTATE:GetCurrentSteps(pl)
	if not steps then return 0, 0 end
	
	local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
	-- MSD is at index 1 (Overall)
	local msd = steps:GetMSD(rate, 1) or 0
	
	-- Get proper SSR using GetSkillsetSSR
	local ssr = 0
	if steps.GetSkillsetSSR then
		ssr = steps:GetSkillsetSSR("Overall") or 0
	end
	
	-- Fallback: calculate from performance if GetSkillsetSSR not available
	if ssr == 0 then
		local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl)
		if pss then
			local wife = pss:GetWifeScore()
			ssr = msd * math.pow(wife, 2) * 1.1
		end
	end
	
	return msd, ssr
end

-- Timing statistics functions (ported from Holographic-Void)
function wifeMean(t)
	local c = #t
	local m = 0
	if c == 0 then
		return 0
	end
	local o = 0
	for i = 1, c do
		-- ignore EO misses and replay mines (values 1000 and -1100)
		if t[i] ~= 1000 and t[i] ~= -1100 then
			o = o + t[i]
		else
			m = m + 1
		end
	end
	if (c - m) <= 0 then return 0 end
	return o / (c - m)
end

function wifeSd(t)
	local u = wifeMean(t)
	local u2 = 0
	local m = 0
	for i = 1, #t do
		-- ignore EO misses and replay mines
		if t[i] ~= 1000 and t[i] ~= -1100 then
			u2 = u2 + (t[i] - u) ^ 2
		else
			m = m + 1
		end
	end
	if (#t - 1 - m) <= 0 then return 0 end
	return math.sqrt(u2 / (#t - 1 - m))
end

function wifeRange(t)
	local x, y = 10000, 0
	for i = 1, #t do
		if math.abs(t[i]) <= 180 then		-- ignore misses flagged as 1100
			if math.abs(t[i]) < math.abs(x) then
				x = t[i]
			end
			if math.abs(t[i]) > math.abs(y) then
				y = t[i]
			end
		end
	end
	return x, y
end

function wifeMax(t)
	local _, y = wifeRange(t)
	return math.abs(y)
end

-- Function to get detailed timing stats from PlayerStageStats using offset vector
local function GetDetailedTimingStats(pl)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl)
	if not pss then
		return { MA = "0:1", PA = "0:1", mean = 0, stddev = 0, maxOffset = 0 }
	end
	
	local stats = {}
	
	-- Get judgement counts for MA/PA ratio
	local w1 = pss:GetTapNoteScores("TapNoteScore_W1")
	local w2 = pss:GetTapNoteScores("TapNoteScore_W2")
	local w3 = pss:GetTapNoteScores("TapNoteScore_W3")
	
	-- MA ratio = (W1/W2):1, PA ratio = (W2/W3):1
	if w2 > 0 then
		local maRatio = w1 / w2
		stats.MA = string.format("%.2f:1", maRatio)
	else
		stats.MA = w1 > 0 and "∞:1" or "0:1"
	end
	
	if w3 > 0 then
		local paRatio = w2 / w3
		stats.PA = string.format("%.2f:1", paRatio)
	else
		stats.PA = w2 > 0 and "∞:1" or "0:1"
	end
	
	-- Get offset vector and calculate mean, stddev, max offset
	-- Values are already in milliseconds
	local offsetVector = pss:GetOffsetVector()
	if offsetVector and #offsetVector > 0 then
		stats.mean = wifeMean(offsetVector)
		stats.stddev = wifeSd(offsetVector)
		stats.maxOffset = wifeMax(offsetVector)
	else
		-- Fallback to HighScore methods if offset vector not available
		local highScore = pss:GetHighScore()
		if highScore then
			if highScore.GetStandardDeviation then
				stats.stddev = highScore:GetStandardDeviation() or 0
			end
			if highScore.GetMeanOffset then
				stats.mean = highScore:GetMeanOffset() or 0
			end
			if highScore.GetMaxOffset then
				stats.maxOffset = highScore:GetMaxOffset() or 0
			end
		else
			stats.mean = 0
			stats.stddev = 0
			stats.maxOffset = 0
		end
	end
	
	return stats
end

-- #################################################
-- That's enough functions; let's get this done.

-- Shared portion.
local mid_pane = Def.ActorFrame {
	OnCommand=function(self) self:diffusealpha(0):sleep(0.3):decelerate(0.4):diffusealpha(1) end;
	OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;
	-- Song/course banner.
	Def.Sprite {
		InitCommand=function(self)
			local target = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
			if target and target:HasBanner() then
				self:Load(target:GetBannerPath())
			else
				self:Load(THEME:GetPathG("Common fallback", "banner"))
			end
			self:scaletoclipped(468,146):x(_screen.cx):y(_screen.cy-173):zoom(0.8)
		end
	},
	-- Banner frame.
	LoadActor("_bannerframe") .. {
		InitCommand=function(self) self:x(_screen.cx):y(_screen.cy-172):zoom(0.8) end
	}
}

-- Song or Course Title
if not GAMESTATE:IsCourseMode() then
	mid_pane[#mid_pane+1] = Def.BitmapText {
		Font="Common Fallback",
		InitCommand=function(self)
			self:x(_screen.cx):y(_screen.cy+188-6):diffuse(color("#512232")):shadowlength(1):zoom(0.75):maxwidth(500)
		end;
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:settext(song:GetDisplayMainTitle());
			else
				self:settext("");
			end;
			self:diffusealpha(0):sleep(1.0):decelerate(0.4):diffusealpha(1)
		end,
		OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end
	}
	mid_pane[#mid_pane+1] = Def.BitmapText {
		Font="Common Fallback",
		InitCommand=function(self)
			self:x(_screen.cx):y(_screen.cy+188+22-6):diffuse(color("#512232")):shadowlength(1):zoom(0.6):maxwidth(500)
		end;
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:settext(song:GetDisplaySubTitle());
			else
				self:settext("");
			end;
			self:diffusealpha(0):sleep(1.1):decelerate(0.4):diffusealpha(1)
		end,
		OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end
	}
else
	mid_pane[#mid_pane+1] = Def.BitmapText {
		Font="Common Fallback",
		InitCommand=function(self)
			self:x(_screen.cx):y(_screen.cy+188-6):diffuse(color("#512232")):shadowlength(1):zoom(0.75):maxwidth(500)
		end;
		OnCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse()
			self:settext(course:GetDisplayFullTitle())
			self:diffusealpha(0):sleep(1.3):decelerate(0.4):diffusealpha(1)
		end,
		OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end
	}
end

-- Each line's text, and associated decorations.
for i, v in ipairs(eval_lines) do
	local spacing = 38*i
	local cur_line = "JudgmentLine_" .. v
	
	mid_pane[#mid_pane+1] = Def.ActorFrame{
		InitCommand=function(self) self:x(_screen.cx):y((_screen.cy/1.48)+(spacing)) end,
		Def.Quad {
			InitCommand=function(self) self:zoomto(400,36):diffuse(cur_line == "JudgmentLine_MaxCombo" and color("#FFFFFF") or GameColor.Judgment[cur_line] or color("#FFFFFF")):fadeleft(0.5):faderight(0.5) end;
			OnCommand=function(self)			
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(1)
			end;
			OffCommand=function(self)			
				self:sleep(fade_out_pause * i):decelerate(fade_out_speed):diffusealpha(0)
			end;				
		};
	
		Def.BitmapText {
			Font = "_roboto condensed Bold 48px",
			InitCommand=function(self) self:zoom(0.6):diffuse(color("#000000")):settext(string.upper(THEME:GetString("JudgmentLine", v))) end;
			OnCommand=function(self)			
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(0.8)
			end;
			OffCommand=function(self)			
				self:sleep(fade_out_pause * i):decelerate(fade_out_speed):diffusealpha(0)
			end;	
		}
	}
end

t[#t+1] = mid_pane

-- #################################################
-- Time to deal with all of the player stats. ALL OF THEM.

local eval_parts = Def.ActorFrame {}

-- Get P1 total taps for percentage calculations
local p1TotalTaps = 0
if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	p1TotalTaps = GetTotalTaps(PLAYER_1)
end

-- Always create both P1 and P2 sides
-- If P2 is not a human player, we'll use P1 data for the P2 side display
local playersToProcess = { {p = PLAYER_1, isP1 = true} }
if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	table.insert(playersToProcess, {p = PLAYER_2, isP1 = false})
else
	-- When only P1 is playing, create a "virtual" P2 side using P1 data
	-- This allows the stats display to always show both the classic view (left) and Etterna stats view (right)
	table.insert(playersToProcess, {p = PLAYER_1, isP1 = false})
end

for _, playerData in ipairs(playersToProcess) do
	local p = playerData.p
	local isP1 = playerData.isP1
	-- Some things to help positioning
	local step_count_offs = isP1 and -140 or 140
	local grade_parts_offs = isP1 and -320 or 320
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(p)
	local p_grade = "Grade_None"
	if pss then
		if GetGradeFromPercent then
			p_grade = GetGradeFromPercent(pss:GetWifeScore())
		else
			p_grade = pss:GetGrade()
		end
	end
	
	-- Step counts / Percentages
	for i, v in ipairs(eval_lines) do
		local spacing = 38*i
		eval_parts[#eval_parts+1] = Def.BitmapText {
			Font = "_overpass 36px",
			InitCommand=function(self) self:x(_screen.cx + step_count_offs):y((_screen.cy/1.48)+(spacing)):diffuse(ColorDarkTone(PlayerColor(p))):zoom(0.75):diffusealpha(1.0):shadowlength(1):maxwidth(120) end,
			OnCommand=function(self)
				if isP1 then
					-- P1: Show actual counts
					self:settext(GetJLineValue(v, p))
					self:horizalign(right)
				else
					-- P2: Show percentage of P1's judgements
					if p1TotalTaps > 0 and v ~= "MaxCombo" then
						local p1Count = GetJLineValue(v, PLAYER_1)
						local percentage = (p1Count / p1TotalTaps) * 100
						self:settext(string.format("%.1f%%", percentage))
					elseif v == "MaxCombo" then
						-- Max Combo: show ratio of max combo to total notes
						local maxCombo = GetJLineValue(v, PLAYER_1)
						local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
						local totalNotes = 0
						if steps then
							local radar = steps:GetRadarValues(PLAYER_1)
							totalNotes = radar:GetValue("RadarCategory_Notes") or 0
						end
						if totalNotes > 0 then
							local comboPercent = (maxCombo / totalNotes) * 100
							self:settext(string.format("%.1f%%", comboPercent))
						else
							self:settext("--")
						end
					else
						self:settext("--")
					end
					self:horizalign(left)
				end
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(1)
			end;
			OffCommand=function(self)			
				self:sleep(fade_out_pause * i):decelerate(fade_out_speed):diffusealpha(0)
			end;	
		}
	end

	-- Letter grade and associated parts - CONTAINER QUADS (keep for both)
	eval_parts[#eval_parts+1] = Def.ActorFrame{
		InitCommand=function(self) self:x(_screen.cx + grade_parts_offs):y(_screen.cy/1.91) end,
		
		--Containers - kept for both P1 and P2
		Def.Quad {
			InitCommand=function(self) self:zoomto(190,115):diffuse(ColorLightTone(PlayerColor(p))):diffusebottomedge(color("#FEEFCA")) end,
			OnCommand=function(self)
			    self:diffusealpha(0):decelerate(0.4):diffusealpha(0.5)
			end,
			OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end
		},
		
		Def.Quad {
			InitCommand=function(self) self:vertalign(top):y(60+grade_area_offset):zoomto(190,136):diffuse(color("#fce1a1")) end,
			OnCommand=function(self)
			    self:diffusealpha(0):decelerate(0.4):diffusealpha(0.4)
			end,
			OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end
		},
		
		-- Grade Text or SSR/MSD for P2 (SWAPPED: SSR is now main, MSD is subtext)
		Def.BitmapText {
			Font = "_roboto condensed Bold 48px",
			InitCommand=function(self) self:zoom(1):shadowlength(1) end;
			OnCommand=function(self)
				self:diffusealpha(0):zoom(1.5):sleep(0.63):decelerate(0.4):zoom(1):diffusealpha(1)
				
				if isP1 then
					-- P1: Show grade as usual
					self:settext(GetGradeString(p_grade))
					self:diffuse(GetGradeColor(p_grade))
					
					if pss.GetStageAward and pss:GetStageAward() then
					  self:sleep(0.1):decelerate(0.4):addy(-12);
					else
					  self:addy(0);
					end;
				else
					-- P2: Show SSR value (main display, no label)
					local _, ssr = GetMSDAndSSR(p)
					self:settext(string.format("%.2f", ssr))
					self:diffuse(color("#00BFFF")) -- Light blue for SSR
				end
			end;
			OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;			
		},
		
		-- Stage Award or MSD for P2 (SWAPPED: MSD is now subtext, no label)
		Def.BitmapText {
			Font = "_roboto condensed 24px",
			InitCommand=function(self) self:diffuse(Color.White):zoom(1):addy(38):maxwidth(160):uppercase(true):diffuse(ColorDarkTone(PlayerDarkColor(p))):diffusetopedge(ColorMidTone(PlayerColor(p))):shadowlength(1) end,
			OnCommand=function(self)
				if isP1 then
					-- P1: Show stage award
					if pss.GetStageAward and pss:GetStageAward() then
						self:settext(THEME:GetString( "StageAward", ToEnumShortString(pss:GetStageAward()) ))
						self:diffusealpha(0):zoomx(0.5):sleep(1):decelerate(0.4):zoomx(1):diffusealpha(1)
					end
				else
					-- P2: Show MSD (subtext, no label)
					local msd, _ = GetMSDAndSSR(p)
					self:settext(string.format("%.2f", msd))
					self:diffusealpha(0):zoomx(0.5):sleep(1):decelerate(0.4):zoomx(1):diffusealpha(1)
				end
			end;
			OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;
		}
	}
	
		
	-- Primary score - P1: current score. P2: PB score and difference.
	eval_parts[#eval_parts+1] = Def.BitmapText {
		Font = "_overpass 36px",
		InitCommand=function(self) self:horizalign(center):x(_screen.cx + (grade_parts_offs)):y((_screen.cy-59)+grade_area_offset):diffuse(ColorMidTone(PlayerColor(p))):zoom(0.85):shadowlength(1):maxwidth(200) end,
		OnCommand=function(self)
			if isP1 then
				self:settext(GetPlScore(p, "primary"))
			else
				-- P2: Show PB score and difference
				local currentScore = pss and pss:GetWifeScore() * 100 or 0
				local _, bestScore = GetBestScoreForPlayer(p)
				
				if bestScore > 0 then
					local diff = currentScore - bestScore
					local sign = diff >= 0 and "+" or ""
					self:settext(string.format("%.2f%% (%s%.2f%%)", bestScore, sign, diff))
					self:diffuse(diff >= 0 and color("#00FF00") or color("#FF0000"))
				else
					self:settext(string.format("%.2f%% (No PB)", currentScore))
					self:diffuse(ColorMidTone(PlayerColor(p)))
				end
			end
			self:diffusealpha(0):sleep(0.5):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:decelerate(0.3):diffusealpha(0)
		end;
	}

	-- Clear Type text - P1: current clear type. P2: current and PB clear type.
	eval_parts[#eval_parts+1] = Def.BitmapText {
		Font = "Common Condensed",
		InitCommand=function(self) self:horizalign(center):x(_screen.cx + (grade_parts_offs)):y((_screen.cy-34)+grade_area_offset):zoom(0.75):shadowlength(1):maxwidth(200) end,
		OnCommand=function(self)
			if isP1 then
				local score = pss and pss:GetHighScore() or nil
				if getClearTypeFromScore ~= nil then
					local clearText = getClearTypeFromScore(p, score, 0)
					local clearColor = getClearTypeFromScore(p, score, 2)
					self:settext(clearText)
					if clearColor ~= nil then
						self:diffuse(clearColor)
					end
				else
					self:settext("")
				end
			else
				-- P2: Show current clear type and PB clear type
				local currentScore = pss and pss:GetHighScore() or nil
				local bestScore, _ = GetBestScoreForPlayer(p)
				
				local currentClear = "--"
				local pbClear = "--"
				local displayColor = ColorMidTone(PlayerColor(p))
				
				if getClearTypeFromScore ~= nil then
					-- Get current clear type
					if currentScore then
						currentClear = getClearTypeFromScore(p, currentScore, 0)
						local currentColor = getClearTypeFromScore(p, currentScore, 2)
						if currentColor then
							displayColor = currentColor
						end
					end
					
					-- Get PB clear type
					if bestScore then
						pbClear = getClearTypeFromScore(p, bestScore, 0)
					end
				end
				
				self:settext(string.format("%s | PB: %s", currentClear, pbClear))
				self:diffuse(displayColor)
			end
			self:diffusealpha(0):sleep(0.5):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:decelerate(0.3):diffusealpha(0)
		end;
	}
	
	-- Personal record indicator - P1 only
	if isP1 then
		eval_parts[#eval_parts+1] = Def.BitmapText {
			Font = "Common Condensed",
			InitCommand=function(self) self:horizalign(center):x(_screen.cx + (grade_parts_offs)):y((_screen.cy-50)+56+grade_area_offset):diffuse(ColorDarkTone(PlayerColor(p))):zoom(0.75):shadowlength(1):maxwidth(180) end,
			OnCommand=function(self)
				local record = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetPersonalHighScoreIndex()
				local hasPersonalRecord = record ~= -1
				self:visible(hasPersonalRecord);
				local text = string.format(THEME:GetString("ScreenEvaluation", "PersonalRecord"), record+1)
				self:settext(text)
				self:diffusealpha(0):sleep(0.6):decelerate(0.3):diffusealpha(0.9)
			end;
			OffCommand=function(self)
				self:sleep(0.1):decelerate(0.3):diffusealpha(0)
			end;
		}
	end
	
	-- Other stats (holds, mines, etc.) - P1: normal. P2: MA/PA ratio, mean, stddev, max offset
	if isP1 then
		-- P1: Original radar display (Holds, Rolls, Hands, Mines, Lifts)
		for i, rc_type in ipairs(eval_radar.Types) do
			local performance = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetRadarActual():GetValue( "RadarCategory_"..rc_type )
			local possible = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetRadarPossible():GetValue( "RadarCategory_"..rc_type )
			local label = THEME:GetString("RadarCategory", rc_type)
		
			eval_parts[#eval_parts+1] = Def.ActorFrame {
				InitCommand=function(self)
					self:x(_screen.cx + (grade_parts_offs))
					self:y((_screen.cy + 104 - 32) + (i-1)*32)
				end;
				OnCommand=function(self)				
					self:diffusealpha(0):sleep(0.1 * i):decelerate(0.5):diffusealpha(1)
				end;
				OffCommand=function(self)				
				self:sleep(0.13 * i):decelerate(0.6):diffusealpha(0)
				end;	
					Def.Quad {
						InitCommand=function(self) self:zoomto(190,28):diffuse(color("#fce1a1")):diffusealpha(0.4) end;
					};
					Def.BitmapText {
						Font = "Common Condensed",
						InitCommand=function(self) self:zoom(0.8):x(-80):horizalign(left):diffuse(color("0,0,0,0.75")):shadowlength(1) end,
						BeginCommand=function(self)
							self:settext(label .. ":")
						end
					};
					Def.BitmapText {
						Font = "_overpass 36px",
						InitCommand=function(self) self:zoom(0.5):x(83):horizalign(right):maxwidth(200):diffuse(ColorDarkTone(PlayerColor(p))):shadowlength(1) end,
						BeginCommand=function(self)
							self:settext(performance .. "/" .. possible)
						end
					};
			};
		end
	else
		-- P2: Timing statistics (MA/PA ratio, mean, stddev, max offset)
		local timingStats = GetDetailedTimingStats(p)
		local statLabels = {
			{ label = "MA", value = timingStats.MA, order = 1 },
			{ label = "PA", value = timingStats.PA, order = 2 },
			{ label = "Mean", value = string.format("%.1fms", timingStats.mean), order = 3 },
			{ label = "StdDev", value = string.format("%.1fms", timingStats.stddev), order = 4 },
			{ label = "Max Off", value = string.format("%.1fms", timingStats.maxOffset), order = 5 },
		}
		
		for i, stat in ipairs(statLabels) do
			eval_parts[#eval_parts+1] = Def.ActorFrame {
				InitCommand=function(self)
					self:x(_screen.cx + (grade_parts_offs))
					self:y((_screen.cy + 104 - 32) + (i-1)*32)
				end;
				OnCommand=function(self)				
					self:diffusealpha(0):sleep(0.1 * i):decelerate(0.5):diffusealpha(1)
				end;
				OffCommand=function(self)				
				self:sleep(0.13 * i):decelerate(0.6):diffusealpha(0)
				end;	
					Def.Quad {
						InitCommand=function(self) self:zoomto(190,28):diffuse(color("#fce1a1")):diffusealpha(0.4) end;
					};
					Def.BitmapText {
						Font = "Common Condensed",
						InitCommand=function(self) self:zoom(0.8):x(-80):horizalign(left):diffuse(color("0,0,0,0.75")):shadowlength(1) end,
						BeginCommand=function(self)
							self:settext(stat.label .. ":")
						end
					};
					Def.BitmapText {
						Font = "_overpass 36px",
						InitCommand=function(self) self:zoom(0.5):x(83):horizalign(right):maxwidth(200):diffuse(ColorDarkTone(PlayerColor(p))):shadowlength(1) end,
						BeginCommand=function(self)
							self:settext(stat.value)
						end
					};
			};
		end
	end
	
	-- Options - P1 only
	if isP1 then
		eval_parts[#eval_parts+1] = Def.BitmapText {
			Font = "Common Condensed",
			InitCommand=function(self) self:horizalign(center):vertalign(top):x(_screen.cx + (grade_parts_offs)):y((_screen.cy+196+43)):wrapwidthpixels(240):diffuse(ColorDarkTone(PlayerColor(p))):zoom(0.75):shadowlength(1) end,
			OnCommand=function(self)
				self:settext(GAMESTATE:GetPlayerState(p):GetPlayerOptionsString(0))
				self:diffusealpha(0):sleep(0.8):decelerate(0.6):diffusealpha(1)
				end;				
			OffCommand=function(self)
				self:sleep(0.1):decelerate(0.3):diffusealpha(0)
			end;
			};
	end
end

t[#t+1] = eval_parts


-- P1 Difficulty banner only - P2 chart meter removed
if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
	if GAMESTATE:IsCourseMode() == false then
	-- Difficulty banner
	local grade_parts_offs = -320
	t[#t+1] = Def.ActorFrame {
	  InitCommand=function(self) self:horizalign(center):x(_screen.cx + grade_parts_offs):y(_screen.cy-96+grade_area_offset):visible(not GAMESTATE:IsCourseMode()) end;
	  OnCommand=function(self) self:zoomx(0.3):diffusealpha(0):sleep(0.5):decelerate(0.4):zoomx(1):diffusealpha(1) end;
	  OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end;
	  LoadFont("Common Fallback") .. {
			InitCommand=function(self) self:zoom(1):horizalign(center):shadowlength(1) end;
			OnCommand=function(self) self:playcommand("Set") end;
			CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
			ChangedLanguageDisplayMessageCommand=function(self) self:playcommand("Set") end;
			SetCommand=function(self)
			stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
			local song = GAMESTATE:GetCurrentSong();
			  if song then
				if stepsP1 ~= nil then
				  local st = stepsP1:GetStepsType();
				  local diff = stepsP1:GetDifficulty();
				  local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
				  local cdp1 = GetCustomDifficulty(st, diff, courseType);
				  self:settext(string.upper(THEME:GetString("CustomDifficulty",ToEnumShortString(diff))) .. "  " .. stepsP1:GetMeter());
				  self:diffuse(ColorDarkTone(CustomDifficultyToColor(cdp1)));				  
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
end;

-- P2 Chart meter display - REMOVED (previously here)

-- Standard decorations
t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");

if (gameplay_pause_count or 0) > 0 then
	t[#t+1]= Def.BitmapText{
		Font= "Common Italic Condensed",
		Text= THEME:GetString("PauseMenu", "pause_count") .. ": " .. gameplay_pause_count,
		InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y-130):shadowlength(1):maxwidth(140) end;
		OnCommand=function(self)
			self:diffuse(color("#FF0000")):diffusebottomedge(color("#512232")):zoom(0.8);
			self:diffusealpha(0):sleep(1.5):smooth(0.3):diffusealpha(1);
		end;
		OffCommand=function(self) self:sleep(0.2):decelerate(0.3):diffusealpha(0) end;
	}
end

return t;
