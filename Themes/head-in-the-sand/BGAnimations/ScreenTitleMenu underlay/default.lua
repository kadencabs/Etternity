return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self)
			self:horizalign(left):vertalign(top):y(SCREEN_TOP+8)
		end;
		OnCommand=function(self)
			self:diffuse(Color.Black):diffusealpha(0.5):zoomto(256,84):faderight(1)
		end;
	};
	Def.Quad {
		InitCommand=function(self)
			self:horizalign(right):vertalign(top):x(SCREEN_RIGHT):y(SCREEN_TOP+8)
		end;
		OnCommand=function(self)
			self:diffuse(Color.Black):diffusealpha(0.5):zoomto(256,46):fadeleft(1)
		end;
	};
};