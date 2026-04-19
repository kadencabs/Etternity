-- You know what, I guess the "fancy UI background" theme option can be put to use.
if ThemePrefs.Get("FancyUIBG") then
	return Def.ActorFrame {
			Def.Quad {
				InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(color("#18060C")):diffusetopedge(color("#000000")) end;
			};
			
			LoadActor("_base") .. {
			InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):blend('BlendMode_Add') end;
			},
			
			LoadActor("_barcode") .. {
				InitCommand=function(self) self:zoomto(36,1024):diffuse(color("#882D47")):x(SCREEN_LEFT+15):y(SCREEN_CENTER_Y):diffusealpha(0.1) end;
				OnCommand=function(self) self:customtexturerect(0,0,1,1):texcoordvelocity(0,-0.1) end;
			};
			
			LoadActor("_barcode") .. {
				InitCommand=function(self) self:zoomto(36,1024):diffuse(color("#882D47")):x(SCREEN_RIGHT-15):y(SCREEN_CENTER_Y):diffusealpha(0.1) end;
				OnCommand=function(self) self:customtexturerect(0,0,1,1):texcoordvelocity(0,0.1) end;
			};
		};
else
	return 	Def.ActorFrame {
		Def.Quad {
			InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(color("#18060C")):diffusetopedge(color("#000000")) end;
		};
			
		LoadActor("_base") .. {
			InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):blend('BlendMode_Add') end;
		},
	};
end