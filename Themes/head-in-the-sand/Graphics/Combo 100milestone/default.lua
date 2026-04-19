local ShowFlashyCombo = ThemePrefs.Get("FlashyCombo")
return Def.ActorFrame {
	LoadActor("explosion") .. {
		InitCommand=function(self)
			self:diffusealpha(0):blend('BlendMode_Add'):hide_if(not ShowFlashyCombo)
		end;
		MilestoneCommand=function(self)
			self:rotationz(0):zoom(2):diffusealpha(0.5):linear(0.5):rotationz(90):zoom(1.75):diffusealpha(0)
		end;
	};
	LoadActor("explosion") .. {
		InitCommand=function(self)
			self:diffusealpha(0):blend('BlendMode_Add'):hide_if(not ShowFlashyCombo)
		end;
		MilestoneCommand=function(self)
			self:rotationz(0):zoom(2):diffusealpha(0.5):linear(0.5):rotationz(-90):zoom(2.5):diffusealpha(0)
		end;
	};
};