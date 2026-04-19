Branch.OptionsEdit = function()
	if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
		return "ScreenHowToInstallSongs"
	end
	return "ScreenEditMenu"
end

Branch.AfterGameplay = function()
	if GAMESTATE:IsCourseMode() then
		return "ScreenEvaluationSummary"
	else
		return "ScreenEvaluationNormal"
	end
end

Branch.AfterEvaluation = function()
	return "ScreenSelectMusic"
end