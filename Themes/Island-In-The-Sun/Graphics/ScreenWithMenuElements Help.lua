return Def.BitmapText {
	File = THEME:GetPathF("HelpDisplay", "text");
	InitCommand=function(self)
		local s = THEME:GetString(Var "LoadingScreen","HelpText");
		self:playcommand("SetHelpText", {Text = s});
	end;
	SetHelpTextCommand=function(self, params)
		if not params.Text or params.Text == "" then 
			self:settext("")
			return
		end
		-- Handle colon-separated tips by joining them for BitmapText
		local tips = {}
		for tip in params.Text:gmatch("([^:]+)") do
			if tip ~= "" then table.insert(tips, tip) end
		end
		if #tips > 1 then
			self:settext(table.concat(tips, "  •  "))
		elseif #tips == 1 then
			self:settext(tips[1])
		else
			self:settext(params.Text)
		end
	end;
    -- Legacy compatibility method for theme code calling it directly
    SetTipsColonSeparated = function(self, tips)
        self:playcommand("SetHelpText", {Text = tips})
    end;
};