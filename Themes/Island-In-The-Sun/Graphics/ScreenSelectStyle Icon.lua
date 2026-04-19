local gc = Var("GameCommand");

local string_name = gc:GetText();
local string_expl = THEME:GetString("StyleType", gc:GetStyle():GetStyleType());
local icon_color = color("#FFCB05");
local icon_color2 = color("#F0BA00");

local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame { 
	GainFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconGainFocusCommand");
	LoseFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconLoseFocusCommand");

	LoadActor(THEME:GetPathG("ScreenSelectPlayMode", "icon/_background base"))..{
		GainFocusCommand=function(self) self:diffuse(color("#981F41")) end;
		LoseFocusCommand=function(self) self:diffuse(color("#740A27")) end;
	};
	LoadFont("_overpass 36px")..{
		Text=string.upper(string_name);
		InitCommand=function(self) self:y(-12):maxwidth(232) end;
		OnCommand=function(self) self:diffuse(icon_color) end;
	};
	LoadFont("Common Italic Condensed")..{
		Text=string.upper(string_expl);
		InitCommand=function(self) self:y(29.5):maxwidth(128) end;
	};

	LoadActor(THEME:GetPathG("ScreenSelectPlayMode", "icon/_background base"))..{
		DisabledCommand=function(self) self:diffuse(color("0,0,0,0.5")) end;
		EnabledCommand=function(self) self:diffuse(color("1,1,1,0")) end;
	};
};
return t