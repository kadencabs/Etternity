local raveChildren

local bg = Def.ActorFrame{
	Def.Quad{
		InitCommand=function(self)
			self:FullScreen():diffuse(color("0,0,0,0"))
		end;
		OnCommand=function(self)
			self:linear(5):diffusealpha(1)
		end;
	};
};

return bg