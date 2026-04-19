local curScreen = Var "LoadingScreen";
local curStageIndex = GAMESTATE:GetCurrentStageIndex() + 1;
local playMode = GAMESTATE:GetPlayMode();

local t = Def.ActorFrame {
	LoadActor(		THEME:GetPathG("ScreenGameplay", "progress"))  .. {
		OnCommand=function(self) self:playcommand("Set") end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentTraiP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentTraiP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
		local curStage = GAMESTATE:GetCurrentStage();
			self:diffuse(ColorMidTone(StageToColor(curStage)))
		end
	};
	LoadFont("Common Italic Condensed") .. {
		InitCommand=function(self) self:y(-1):x(-143):uppercase(true):horizalign(center):maxwidth(170):playcommand("Set") end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentTraiP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentTraiP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			local curStage = GAMESTATE:GetCurrentStage();
			if GAMESTATE:IsEventMode() then
				self:settextf("Stage %s", curStageIndex);
			else
				if GAMESTATE:IsEventMode() then
					self:settextf("Stage %s", curStageIndex);
				else
					local thed_stage= thified_curstage_index(false)
					if THEME:GetMetric(curScreen,"StageDisplayUseShortString") then
						self:settextf(thed_stage)
					else
						self:settextf("%s Stage", thed_stage)
					end
				end
			end;
			self:zoom(1);
			self:diffuse(StageToColor(curStage));
			self:diffusetopedge(ColorLightTone(StageToColor(curStage)));
		end;
	};
};
return t