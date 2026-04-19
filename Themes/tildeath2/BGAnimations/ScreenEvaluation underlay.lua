local enabled = PREFSMAN:GetPreference("ShowBackgrounds")
local brightness = 0.35
local t = Def.ActorFrame {}

if enabled then
	t[#t + 1] = Def.Sprite {
		OnCommand = function(self)
			if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetBackgroundPath() then
				self:finishtweening()
				self:visible(true)
				self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath())
				self:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_BOTTOM)
				self:diffusealpha(brightness)
			else
				self:visible(false)
			end
		end
	}

	t[#t + 1] = Def.Quad {
		OnCommand = function(self)
			self:diffuse(color("#000000")):fadebottom(0.9)
			self:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_BOTTOM)
			self:addy(-100)
		end
	}

	t[#t + 1] = Def.Quad {
		OnCommand = function(self)
			self:diffuse(getMainColor("positive")):fadetop(0.4):diffusealpha(0.4)
			self:scaletocover(0, SCREEN_HEIGHT / 1.5, SCREEN_WIDTH, SCREEN_BOTTOM)
			self:addy(350)
			self:blend("BlendMode_Normal")
		end
	}
end


t[#t + 1] = Def.Sprite {
	Name = "Banner",
	OnCommand = function(self)
		self:x(SCREEN_CENTER_X - 240):y(98):valign(0)
		self:scaletoclipped(capWideScale(get43size(336), 336), capWideScale(get43size(105), 105))
		local bnpath = GAMESTATE:GetCurrentSong():GetBannerPath()
		self:visible(true)
		if not BannersEnabled() then
			self:visible(false)
		elseif not bnpath then
			bnpath = THEME:GetPathG("Common", "fallback banner")
		end
		self:LoadBackground(bnpath)
	end
}

return t
