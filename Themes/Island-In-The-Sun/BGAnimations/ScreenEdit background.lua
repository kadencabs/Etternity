local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
  FOV=90;
  InitCommand=function(self) self:Center() end;
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(ColorMidTone(color("#451A20"))):diffusebottomedge(ColorMidTone(color("#5E2A30"))):diffusealpha(0.9) end;
	};
	LoadActor (GetSongBackground()) .. {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffusealpha(0.1) end;
	};
};

return t;
