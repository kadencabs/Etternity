return LoadFont("Common normal") ..
	{
		InitCommand = function(self)
			self:zoom(0.7):diffuse(color("#FFFFFF")):maxwidth(20):maxheight(8):valign(0.2)
		end
	}
