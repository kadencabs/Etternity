local t = Def.ActorFrame {};

-- A very useful table...
local eval_lines = {
	"W1",
	"W2",
	"W3",
	"W4",
	"W5",
	"Miss",
	"Held",
	"MaxCombo"
}

local grade_area_offset = 16

local fade_out_speed = 0.3
local fade_out_pause = 0.08

-- And a function to make even better use out of the table.
local function GetJLineValue(line, pl)
	if line == "Held" then
		return STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pl):GetHoldNoteScores("HoldNoteScore_Held")
	elseif line == "MaxCombo" then
		return STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pl):MaxCombo()
	else
		return STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pl):GetTapNoteScores("TapNoteScore_" .. line)
	end
	return "???"
end

-- You know what, we'll deal with getting the overall scores with a function too.
local function GetPlScore(pl, scoretype)
	local pss = STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pl)
	if not pss then return "0.00%" end
	local wife = pss:GetWifeScore()
	local primary_score = string.format("%.2f%%", wife * 100)
	if wife > 0.997 then
		primary_score = string.format("%.4f%%", wife * 100)
	end
	if primary_score == "100.0000%" then primary_score = "100%" end
	
	return primary_score
end


-- Each line's text, and associated decorations.
for i, v in ipairs(eval_lines) do
	local spacing = 38*i
	local cur_line = "JudgmentLine_" .. v
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self) self:x(_screen.cx):y((_screen.cy/1.6)+(spacing)) end,
		Def.Quad {
			InitCommand=function(self) self:zoomto(400,36):diffuse(cur_line == "JudgmentLine_MaxCombo" and color("#FFFFFF") or GameColor.Judgment[cur_line] or color("#FFFFFF")):fadeleft(0.5):faderight(0.5) end;
			OnCommand=function(self)			
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(0.8)
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

-- #################################################
-- Time to deal with all of the player stats. ALL OF THEM.

local eval_parts = Def.ActorFrame {}

for ip, p in ipairs(GAMESTATE:GetHumanPlayers()) do
	-- Some things to help positioning
	local step_count_offs = string.find(p, "P1") and -140 or 140
	local grade_parts_offs = string.find(p, "P1") and -320 or 320
	local pss = STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(p)
	local p_grade = pss and pss:GetGrade() or "Grade_None"
	
	-- Step counts.
	for i, v in ipairs(eval_lines) do
		local spacing = 38*i
		eval_parts[#eval_parts+1] = Def.BitmapText {
			Font = "_overpass 36px",
			InitCommand=function(self) self:x(_screen.cx + step_count_offs):y((_screen.cy/1.6)+(spacing)):diffuse(ColorDarkTone(PlayerColor(p))):zoom(0.75):diffusealpha(1.0):shadowlength(1) end,
			OnCommand=function(self)
				self:settext(GetJLineValue(v, p))
				if string.find(p, "P1") then
					self:horizalign(right)
				else
					self:horizalign(left)
				end
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(1)
			end;
			OffCommand=function(self)			
				self:sleep(fade_out_pause * i):decelerate(fade_out_speed):diffusealpha(0)
			end;	
		}
	end
	
	-- Letter grade and associated parts.
	eval_parts[#eval_parts+1] = Def.ActorFrame{
		InitCommand=function(self) self:x(_screen.cx + grade_parts_offs):y(_screen.cy/1.91) end,
		
		--Containers.
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
		
		Def.BitmapText {
			Font = "_roboto condensed Bold 48px",
			InitCommand=function(self) self:zoom(1):shadowlength(1) end;
			OnCommand=function(self)
			    self:diffusealpha(0):zoom(1.5):sleep(0.63):decelerate(0.4):zoom(1):diffusealpha(1)
				self:settext(GetGradeString(p_grade))
				self:diffuse(GetGradeColor(p_grade))
			end;
			OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;			
		},
	}
	
	-- Primary score.
	eval_parts[#eval_parts+1] = Def.BitmapText {
		Font = "_overpass 36px",
		InitCommand=function(self) self:horizalign(center):x(_screen.cx + (grade_parts_offs)):y((_screen.cy-65)+grade_area_offset):diffuse(ColorMidTone(PlayerColor(p))):zoom(1):shadowlength(1):maxwidth(180) end,
		OnCommand=function(self)
			self:settext(GetPlScore(p, "primary")):diffusealpha(0):sleep(0.5):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:decelerate(0.3):diffusealpha(0)
		end;
	}
end

t[#t+1] = eval_parts

return t;

