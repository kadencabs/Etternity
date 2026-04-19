return Def.BitmapText {
	File = THEME:GetPathF("HelpDisplay", "text");
	InitCommand=function(self)
		local s = THEME:GetString(Var "LoadingScreen","AlternateHelpText");
		self:playcommand("SetHelpText", {Text = s});
	end;
	SetHelpTextCommand=function(self, params)
		if not params.Text or params.Text == "" then 
			self:settext("")
			return
		end
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
    SetTipsColonSeparated = function(self, tips)
        self:playcommand("SetHelpText", {Text = tips})
    end;
};
--[[ local sString = THEME:GetString(Var "LoadingScreen","AlternateHelpText");
local tItems = split(sString,"&");

local t = Def.ActorScroller {
	NumItemsToDraw=#tItems;
	SecondsPerItem=1.25;
	TransformFunction=function( self, offset, itemIndex, numItems )
		self:x( offset*74 );
	end;
	InitCommand=function(self) self:SetLoop(true) end;
-- 	OnCommand=function(self) self:scrollwithpadding(10,0) end;
};

for i=1,#tItems do
	t[#t+1] = Def.ActorFrame {
		LoadFont("HelpDisplay", "text") .. {
			Text=tostring(tItems[i]);
			OnCommand=THEME:GetMetric( Var "LoadingScreen","HelpOnCommand");
		};
	};
end

return t; --]]
