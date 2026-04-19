local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
  InitCommand=function(self) self:Center() end;
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(color("#947B7E")):diffusebottomedge(color("#D698A0")) end;
	};
};

t[#t+1] = Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+20):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT*0.70) end;
		OnCommand=function(self) self:diffuse(color("#61414B")):diffusealpha(0.75) end;
	};
};

return t;
