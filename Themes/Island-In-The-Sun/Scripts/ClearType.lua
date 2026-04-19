------------------------------------------------------
--Methods for generating IIDX-esque ClearType texts --
------------------------------------------------------
-- Adapted for the 'default' theme

local stypetable = {
	[1] = "MFC",
	[2] = "WF",
	[3] = "SDP",
	[4] = "PFC",
	[5] = "BF",
	[6] = "SDG",
	[7] = "FC",
	[8] = "MF",
	[9] = "SDCB",
	[10] = "Clear",
	[11] = "Failed",
	[12] = "Invalid",
	[13] = "No Play",
	[14] = "-"
}

local typetable = {
	[1] = "MFC",
	[2] = "WF",
	[3] = "SDP",
	[4] = "PFC",
	[5] = "BF",
	[6] = "SDG",
	[7] = "FC",
	[8] = "MF",
	[9] = "SDCB",
	[10] = "Clear",
	[11] = "Failed",
	[12] = "Invalid",
	[13] = "No Play",
	[14] = "-"
}

local typecolors = {
	[1] = color("#FFFFFF"), -- MFC (white/silver/gold) - usually GameColor.Judgment["JudgmentLine_W1"] but let's do White
	[2] = color("#E6E6EB"), -- WF
	[3] = color("#CC99FF"), -- SDP
	[4] = color("#FFFF00"), -- PFC
	[5] = color("#777777"), -- BF
	[6] = color("#4488FF"), -- SDG
	[7] = color("#66FF66"), -- FC
	[8] = color("#CC6633"), -- MF
	[9] = color("#FF9900"), -- SDCB
	[10] = color("#0000FF"), -- Clear
	[11] = color("#FF0000"), -- Failed
	[12] = color("#E61E25"), -- Invalid
	[13] = color("#555555"), -- NoPlay
	[14] = color("#555555")  -- None
}

local typetranslations = {
	"MFC",
	"WF",
	"SDP",
	"PFC",
	"BF",
	"SDG",
	"FC",
	"MF",
	"SDCB",
	"Clear",
	"Failed",
	"Invalid",
	"No Play",
	"-"
}

local function getClearTypeItem(clearlevel, ret)
	if ret == 0 then
		return typetable[clearlevel]
	elseif ret == 1 then
		return stypetable[clearlevel]
	elseif ret == 2 then
		return typecolors[clearlevel]
	else
		return clearlevel
	end
end

local function clearTypes(grade, playCount, perfcount, greatcount, misscount, returntype)
	grade = grade or 0
	playCount = playCount or 0
	misscount = misscount or 0
	local clearlevel = 13 -- no play

	if grade == 0 then
		if playCount == 0 then
			clearlevel = 13
		end
	else
		if grade == "Grade_Failed" then -- failed
			clearlevel = 11
		elseif misscount > 0 then
			if misscount == 1 then
				clearlevel = 8 -- missflag
			elseif misscount > 1 and misscount < 10 then
				clearlevel = 9 -- SDCB
			else
				clearlevel = 10 -- Clear
			end
		elseif misscount == 0 then
			if greatcount == 0 then
				if perfcount == 0 then -- MFC
					clearlevel = 1
				elseif perfcount == 1 then -- whiteflag
					clearlevel = 2
				elseif perfcount < 10 and perfcount > 1 then -- SDP
					clearlevel = 3
				else -- PFC
					clearlevel = 4
				end
			else
				if greatcount < 10 and greatcount > 1 then -- SDG
					clearlevel = 6
				elseif greatcount == 1 then -- blackflag
					clearlevel = 5
				else -- FC
					clearlevel = 7
				end
			end
		else
			clearlevel = 12 -- this would mean negative misses
		end
	end
	return getClearTypeItem(clearlevel, returntype)
end

function getClearTypeFromScore(pn, score, ret)
	local song
	local steps
	local profile
	local playCount = 0
	local greatcount = 0
	local perfcount = 0
	local misscount = 0
	local grade = 0
	
	if score == nil then
		return getClearTypeItem(13, ret)
	end
	song = GAMESTATE:GetCurrentSong()
	steps = GAMESTATE:GetCurrentSteps(pn)
	profile = GetPlayerOrMachineProfile(pn)
	
	-- In Etterna 0.74, isScoreValid might not be present or different, but we'll approximate.
	-- Actually we can just check if score is non-nil.
	
	if score ~= nil and song ~= nil and steps ~= nil then
		playCount = profile:GetSongNumTimesPlayed(song)
		grade = score:GetWifeGrade()
		perfcount = score:GetTapNoteScore("TapNoteScore_W2")
		greatcount = score:GetTapNoteScore("TapNoteScore_W3")
		misscount =
			score:GetTapNoteScore("TapNoteScore_Miss") + score:GetTapNoteScore("TapNoteScore_W5") +
			score:GetTapNoteScore("TapNoteScore_W4")
	end

	return clearTypes(grade, playCount, perfcount, greatcount, misscount, ret) or typetable[12]
end
