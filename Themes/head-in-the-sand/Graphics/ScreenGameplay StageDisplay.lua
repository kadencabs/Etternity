local curScreen = Var "LoadingScreen";
local curStageIndex = GAMESTATE:GetCurrentStageIndex() + 1;
local playMode = 'PlayMode_Regular';

local t = Def.ActorFrame {
	LoadActor(THEME:GetPathB("_frame","3x3"),"rounded black",64,16);
	LoadFont("Common Normal") .. {
		InitCommand=function(self)
			self:y(-1):shadowlength(1):playcommand("Set")
		end;
		CurrentSongChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		CurrentCourseChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		CurrentStepsChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		CurrentStepsP2ChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		CurrentTraiP1ChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		CurrentTraiP2ChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		SetCommand=function(self)
			local curStage = "1st";
			self:settextf("1st Stage", thed_stage)
			self:zoom(0.675);
			self:diffuse(StageToColor(curStage));
			self:diffusetopedge(ColorLightTone(StageToColor(curStage)));
		end;
	};
};
return t

