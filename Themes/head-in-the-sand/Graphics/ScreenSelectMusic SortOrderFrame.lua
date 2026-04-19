return Def.ActorFrame {
	LoadActor(THEME:GetPathG("_icon","Sort")) .. {
		InitCommand=function(self)
			self:x(-60):shadowlength(1)
		end;
	};
};
