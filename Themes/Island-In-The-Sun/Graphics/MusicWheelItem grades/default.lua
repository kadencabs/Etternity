-- This actor is duplicated.  Upvalues will not be duplicated.
local grades = {
	Grade_Tier01 = 0,
	Grade_Tier02 = 1,
	Grade_Tier03 = 2,
	Grade_Tier04 = 3,
	Grade_Tier05 = 4,
	Grade_Tier06 = 5,
	Grade_Tier07 = 6,
	Grade_Tier08 = 7,
	Grade_Tier09 = 8,
	Grade_Tier10 = 9,
	Grade_Tier11 = 10,
	Grade_Tier12 = 11,
	Grade_Tier13 = 12,
	Grade_Tier14 = 13,
	Grade_Tier15 = 14,
	Grade_Tier16 = 15,
	Grade_Tier17 = 16,
	Grade_Failed = 17,
	Grade_None = nil
};

return LoadFont("Common Normal")..{
	InitCommand=function(self) self:zoom(0.75):shadowlength(1) end;
	SetGradeCommand=function(self, params)
		local grade = params.Grade;
		if grade == "Grade_None" or not grade then
			self:visible(false)
		else
			self:visible(true)
			self:settext(GetGradeString(grade))
			self:diffuse(GetGradeColor(grade))
		end
	end;
};