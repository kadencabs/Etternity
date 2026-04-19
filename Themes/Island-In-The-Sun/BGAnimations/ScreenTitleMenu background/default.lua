-- You know what, I guess the "fancy UI background" theme option can be put to use.
if ThemePrefs.Get("FancyUIBG") then
	return Def.ActorFrame {
	LoadActor(THEME:GetPathG("common bg", "base")) .. {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
	};
	
	LoadActor("_particleLoader") .. {
	};
	
	LoadActor("_maze") .. {
		OnCommand=function(self) self:Center():diffuse(color("#f6784922")):effectperiod(10):spin():effectmagnitude(0,0,2.2) end
	};
	
	Def.ActorFrame {
		OnCommand=function(self) self:diffusealpha(0):decelerate(1.8):diffusealpha(1) end;
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:Center():blend('BlendMode_Add'):rotationz(-20) end,
				OnCommand=function(self) self:zoom(1.75):diffusealpha(0.12):spin():effectmagnitude(0,0,16.5) end
			};	
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:Center():blend('BlendMode_Add'):rotationz(-10) end,
				OnCommand=function(self) self:zoom(1.0):diffusealpha(0.09):spin():effectmagnitude(0,0,-11) end
			};
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:Center():blend('BlendMode_Add'):rotationz(0) end,
				OnCommand=function(self) self:zoom(0.5):diffusealpha(0.06):spin():effectmagnitude(0,0,5.5) end
			};		
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:Center():blend('BlendMode_Add'):rotationz(-10) end,
				OnCommand=function(self) self:zoom(0.2):diffusealpha(0.03):spin():effectmagnitude(0,0,-2.2) end
			};
	};
	
	}
else
	return LoadActor(THEME:GetPathG("common bg", "base")) .. {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
	}
end