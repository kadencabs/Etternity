local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathG("ScreenEvaluation", "StageDisplay")) .. {
		InitCommand=function(self) self:x(SCREEN_RIGHT-290):y(SCREEN_TOP+49) end;
		OffCommand=function(self) self:sleep(0.175):decelerate(0.4):addy(-105) end,
	}
}

if GAMESTATE.HasEarnedExtraStage and GAMESTATE:HasEarnedExtraStage() then
	t[#t+1] =  Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_RIGHT-290):y(SCREEN_TOP+49) end;
		OffCommand=function(self) self:sleep(0.175):decelerate(0.4):addy(-105) end,
			LoadActor(THEME:GetPathG("", "_sortFrame"))  .. {
				InitCommand=function(self) self:diffusealpha(0.9):zoom(1.5) end;
				BeginCommand=function(self)
					self:playcommand("Set")
				end;
				SetCommand=function(self)
					local curStage = GAMESTATE:GetCurrentStage();
					self:diffuse(StageToColor(curStage));
				end
			};
			LoadActor(THEME:GetPathG("", "_sortFrame"))  .. {
				InitCommand=function(self) self:diffusealpha(0.9):zoom(1.5):diffuse(color("#FFFFFF")):blend('add') end;
				BeginCommand=function(self) self:diffuseshift():effectcolor2(color("1,1,1,0.3")):effectcolor2(color("1,1,1,0")):effectperiod(2) end;
			};
			LoadFont("Common Italic Condensed") .. {
				InitCommand=function(self) self:y(-1):zoom(1):shadowlength(1):uppercase(true):maxwidth(220) end;
				BeginCommand=function(self)
					self:playcommand("Set")
				end;
				CurrentSongChangedMessageCommand= function(self) self:playcommand("Set") end,
				SetCommand=function(self)
					local curStage = GAMESTATE:GetCurrentStage();
					local text = string.upper(THEME:GetString("ScreenEvaluation", "ExtraUnlocked"))
					self:settext(text)
					-- StepMania is being stupid so we have to do this here;
					self:diffuse(StageToColor(curStage)):diffusetopedge(ColorLightTone(StageToColor(curStage)));
					self:diffusealpha(0):smooth(0.3):diffusealpha(1);
				end;
			};
	}
end;

return t;