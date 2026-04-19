local curScreen = Var "LoadingScreen";
local curStageIndex = 1
local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
	LoadFont("Common Normal") .. {
		InitCommand=function(self)
			self:y(-1):shadowlength(1)
		end;
		BeginCommand=function(self)
			local top = SCREENMAN:GetTopScreen()
			if top then
				if not string.find(top:GetName(),"ScreenEvaluation") then
					curStageIndex = curStageIndex + 1
				end
			end
			self:playcommand("Set")
		end;
		CurrentSongChangedMessageCommand= function(self)
			self:playcommand("Set")
		end,
		SetCommand=function(self)
			self:settextf("%s Stage", "1st");
			self:zoom(1);
			-- StepMania is being stupid so we have to do this here;
			self:diffuse(StageToColor(curStage));
			self:diffusetopedge(ColorLightTone(StageToColor(curStage)));
		end;
	};
};
return t
