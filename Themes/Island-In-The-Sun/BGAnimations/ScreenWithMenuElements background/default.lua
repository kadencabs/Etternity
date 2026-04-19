if ThemePrefs.Get("FancyUIBG") then
	return Def.ActorFrame {
		
		LoadActor(THEME:GetPathG("common bg", "base")) .. {
			InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
		},
		
		LoadActor("_maze") .. {
			OnCommand=function(self) self:Center():diffuse(color("#f6784922")):effectperiod(10):spin():effectmagnitude(0,0,2.2) end
		},
		
		LoadActor("_barcode") .. {
			InitCommand=function(self) self:zoomto(36,1024):blend('BlendMode_Add'):x(SCREEN_LEFT+6):y(SCREEN_CENTER_Y):diffusealpha(0.08) end;
			OnCommand=function(self) self:customtexturerect(0,0,1,1):texcoordvelocity(0,-0.1) end;
		};
		LoadActor("_barcode") .. {
			InitCommand=function(self) self:zoomto(36,1024):blend('BlendMode_Add'):x(SCREEN_RIGHT-6):y(SCREEN_CENTER_Y):diffusealpha(0.08) end;
			OnCommand=function(self) self:customtexturerect(0,0,1,1):texcoordvelocity(0,0.1) end;
		};
		
		Def.ActorFrame {
		OnCommand=function(self) self:diffusealpha(0):decelerate(1.8):diffusealpha(1) end;
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:x(SCREEN_LEFT+160):y(SCREEN_CENTER_Y):blend('BlendMode_Add'):rotationz(-20) end,
				OnCommand=function(self) self:zoom(1.75):diffusealpha(0.14):spin():effectmagnitude(0,0,16.5) end
			};	
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:x(SCREEN_LEFT+160):y(SCREEN_CENTER_Y):blend('BlendMode_Add'):rotationz(-10) end,
				OnCommand=function(self) self:zoom(1.0):diffusealpha(0.12):spin():effectmagnitude(0,0,-11) end
			};
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:x(SCREEN_LEFT+160):y(SCREEN_CENTER_Y):blend('BlendMode_Add'):rotationz(0) end,
				OnCommand=function(self) self:zoom(0.5):diffusealpha(0.10):spin():effectmagnitude(0,0,5.5) end
			};		
			LoadActor("_tunnel1") .. {
				InitCommand=function(self) self:x(SCREEN_LEFT+160):y(SCREEN_CENTER_Y):blend('BlendMode_Add'):rotationz(-10) end,
				OnCommand=function(self) self:zoom(0.2):diffusealpha(0.08):spin():effectmagnitude(0,0,-2.2) end
			};
	};
	}
else
	return 	LoadActor(THEME:GetPathG("common bg", "base")) .. {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end
	}
end