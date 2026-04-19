local t = Def.ActorFrame{};

t[#t+1] = LoadActor("_badge") .. {
		effectclock,'beatnooffset';effectperiod,2);
};
t[#t+1] = Def.Quad {
		diffusealpha,0.5;fadeleft,0.25;faderight,0.25);
};
t[#t+1] = Def.BitmapText {
	Font="Common Normal";
	Text="AG";
	InitCommand=function(self)
		self:shadowlength(1):zoom(0.875)
	end;
};

return t;