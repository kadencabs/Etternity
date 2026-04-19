return Def.ActorFrame {
	LoadFont("Common Condensed") .. {
		Text=string.format("%s %s", ProductFamily(), ProductVersion());
		AltText="StepMania";
		InitCommand=function(self) self:zoom(1) end;
		OnCommand=function(self) self:horizalign(right):diffusealpha(0.9) end;
	};
	LoadFont("Common Normal") .. {
		Text=string.format("%s", VersionDate());
		AltText="Unknown Version";
		InitCommand=function(self) self:y(19):zoom(0.75) end;
		OnCommand=function(self) self:horizalign(right):diffusealpha(0.7) end;
	};
};