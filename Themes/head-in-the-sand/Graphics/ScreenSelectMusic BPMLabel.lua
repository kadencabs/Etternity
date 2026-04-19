return Def.ActorFrame {
	LoadFont("Common Normal") .. {
		Text="BPM";
		InitCommand=function(self)
			self:horizalign(right):zoom(0.75):strokecolor(Color("Outline"))
		end;
	};
};