local t = Def.ActorFrame {};

t[#t+1] = LoadActor(THEME:GetPathG("common bg", "base")) .. {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
	};

-- Fade
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:Center() end;	
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.8) end;
	};
};
-- Emblem
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y) end;
	OnCommand=function(self) self:diffusealpha(0.5) end;
	LoadActor("_warning bg") .. {
	};
};

-- Text
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y-120) end;
	OnCommand=function(self) self:diffusealpha(0):linear(0.2):diffusealpha(1) end;
	LoadFont("_roboto condensed Bold 48px") .. {
		Text=Screen.String("Caution");
		OnCommand=function(self) self:skewx(-0.1):diffuse(color("#E6BF7C")):diffusebottomedge(color("#FFB682")):strokecolor(color("#594420")) end;
	};
	LoadFont("Common Fallback Font") .. {
		Text=Screen.String("CautionText");
		InitCommand=function(self) self:y(128) end;
		OnCommand=function(self) self:strokecolor(color("0,0,0,0.5")):shadowlength(1):wrapwidthpixels(SCREEN_WIDTH/0.5) end;
	};
};
--
return t
