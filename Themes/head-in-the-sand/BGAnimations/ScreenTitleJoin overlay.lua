local t = Def.ActorFrame{};

-- todo: add event mode indicators and such
if GAMESTATE:IsEventMode() then
	t[#t+1] = LoadFont("Common Large")..{
		Text=Screen.String("EventMode");
		InitCommand=function(self)
			self:CenterX():y(SCREEN_BOTTOM-72):zoom(0.675):diffuse(Color.Yellow):strokecolor(ColorDarkTone(Color.Yellow)):shadowlength(1)
		end;
		OnCommand=function(self)
			self:glowshift():textglowmode('TextGlowMode_Inner'):effectperiod(2)
		end;
	};
end;

return t;