local ShowFlashyCombo = ThemePrefs.Get("FlashyCombo")
return Def.ActorFrame {
	LoadActor("explosion") .. {
		InitCommand=function(self) self:diffusealpha(0):blend('BlendMode_Add'):hide_if(not ShowFlashyCombo) end;
		MilestoneCommand=function(self) self:rotationz(0):zoom(0.5):diffusealpha(0.6):linear(0.3):zoom(0.75):diffusealpha(0) end;
	};
};