local t = Def.ActorFrame{
	InitCommand=function(self) self:fov(70) end;
	Def.ActorFrame {
		InitCommand=function(self) self:zoom(0.75) end;
		OnCommand=function(self) self:diffusealpha(0):zoom(0.4):decelerate(0.7):diffusealpha(1):zoom(0.75) end;
			LoadActor("_text");
			LoadActor("_text")..{
				Name="TextGlow";
				InitCommand=function(self) self:blend(Blend.Add):diffusealpha(0.05) end;
				OnCommand=function(self) self:glowshift():effectperiod(5):effectcolor1(color("1,1,1,0.25")):effectcolor2(color("1,1,1,1")) end;
			};
		};
	};

return t;
