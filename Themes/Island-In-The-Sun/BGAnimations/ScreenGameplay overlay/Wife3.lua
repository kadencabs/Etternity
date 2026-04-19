local pn = ...
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

local t = Def.ActorFrame {
	InitCommand=function(self)
		-- Position based on player number
		local x_pos = (pn == PLAYER_1) and (SCREEN_RIGHT-160) or (SCREEN_LEFT+160)
		self:x(x_pos):y(SCREEN_TOP+60)
	end;

	LoadFont("_overpass Score") .. {
		Name="WifePercent";
		InitCommand=function(self)
			local align = (pn == PLAYER_1) and right or left
			self:zoom(1.0):horizalign(align):shadowlength(1):strokecolor(Color.Outline)
			self:settext("100.00%")
		end;
		OnCommand=function(self)
			local wife_pct = pss:GetWifeScore() * 100
			self:settext(string.format("%.2f%%", wife_pct))
			if GetGradeColor and GetGradeFromPercent then
				self:diffuse(GetGradeColor(GetGradeFromPercent(wife_pct / 100)))
			end
		end;
		JudgmentMessageCommand=function(self, params)
			if params.Player == pn then
				local wife_pct = params.WifePercent or (pss:GetWifeScore() * 100)
				
				self:settext(string.format("%.2f%%", wife_pct))
				if GetGradeColor and GetGradeFromPercent then
					self:diffuse(GetGradeColor(GetGradeFromPercent(wife_pct / 100)))
				end
				self:finishtweening():zoom(1.05):linear(0.05):zoom(1.0)
			end
		end;
	};
}

return t
