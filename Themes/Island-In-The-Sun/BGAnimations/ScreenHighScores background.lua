return Def.ActorFrame {
	LoadActor(THEME:GetPathG("common bg", "base")) .. {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
	};
}
