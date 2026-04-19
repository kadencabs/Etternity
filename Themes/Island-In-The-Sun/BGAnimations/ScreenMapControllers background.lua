local t = Def.ActorFrame {};

t[#t+1] = LoadActor(THEME:GetPathG("common bg", "base")) .. {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
	};

-- Overlay
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:Center() end;	
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.8) end;
	};
};
--
return t
