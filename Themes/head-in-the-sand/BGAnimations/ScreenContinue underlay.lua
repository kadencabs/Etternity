local timer_seconds = THEME:GetMetric(Var "LoadingScreen","TimerSeconds");
local t = Def.ActorFrame {};

-- Fade
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:Center()
	end;
	Def.Quad {
		InitCommand=function(self)
			self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT)
		end;
					sleep,timer_seconds/2;  
					linear,timer_seconds/2-0.5;diffusealpha,1);
	};
	-- Warning Fade
	Def.Quad {
		InitCommand=function(self)
			self:y(16):scaletoclipped(SCREEN_WIDTH,148)
		end;
					  linear,timer_seconds;zoomtoheight,148*0.75);
	}
};
--
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:Center():y(SCREEN_CENTER_Y-24)
	end;
	-- Underline
	Def.Quad {
		InitCommand=function(self)
			self:y(16):zoomto(256,1)
		end;
		OnCommand=function(self)
			self:diffuse(color("#ffd400")):shadowlength(1):shadowcolor(BoostColor(color("#ffd40077"),0.25)):linear(0.25):zoomtowidth(256):fadeleft(0.25):faderight(0.25)
		end;
	};
	LoadFont("Common Bold") .. {
		Text="Continue?";
		OnCommand=function(self)
			self:skewx(-0.125):diffuse(color("#ffd400")):shadowlength(2):shadowcolor(BoostColor(color("#ffd40077"),0.25))
		end;
	};
};
--
return t
