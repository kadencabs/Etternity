local gc = Var("GameCommand");

local string_name = gc:GetText()
local string_expl = THEME:GetString(Var "LoadingScreen", gc:GetName().."Explanation")
local icon_color = ModeIconColors[gc:GetName()];

local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
	GainFocusCommand=function(self)
		self:stoptweening():bob():effectmagnitude(0,6,0):decelerate(0.05):zoom(1)
	end;
	LoseFocusCommand=function(self)
		self:stoptweening():stopeffect():decelerate(0.1):zoom(0.6)
	end;

	LoadActor("_background base")..{
		InitCommand=function(self)
			self:diffuse(icon_color)
		end;
	};
	LoadActor("_background effect");
	LoadActor("_gloss");
	LoadActor("_stroke");
	LoadActor("_cutout");

	-- todo: generate a better font for these.
	LoadFont("Common Large")..{
		Text=string.upper(string_name);
		InitCommand=function(self)
			self:y(-12):maxwidth(232)
		end;
		OnCommand=function(self)
			self:diffuse(Color.Black):shadowlength(1):shadowcolor(color("#ffffff77")):skewx(-0.125)
		end;
	};
	LoadFont("Common Normal")..{
		Text=string.upper(string_expl);
		InitCommand=function(self)
			self:y(27.5):maxwidth(232)
		end;
	};
	LoadActor("_background base") .. {
		DisabledCommand=function(self)
			self:diffuse(color("0,0,0,0.5"))
		end;
		EnabledCommand=function(self)
			self:diffuse(color("1,1,1,0"))
		end;
	};
};
return t