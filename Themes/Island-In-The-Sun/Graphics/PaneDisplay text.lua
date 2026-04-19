local iPN = ...;
assert(iPN,"[Graphics/PaneDisplay text.lua] No PlayerNumber Provided.");

local t = Def.ActorFrame {};

-- Etterna Skillsets
local skillsets = {
	"SkillsetStream",
	"SkillsetJumpstream",
	"SkillsetHandstream",
	"SkillsetStamina",
	"SkillsetJackspeed",
	"SkillsetChordjack",
	"SkillsetTechnical",
	"SkillsetOverall"
}

-- MSD indices for Step:GetMSD(rate, index)
-- In Etterna, index 1-7 are specific skillsets, index 8 is Overall (depending on version, but standard is 1-indexed for Lua)
-- Actually, let's use the names directly for the display, and index for the values.
-- MSD Skills Indices (Shisted for Correct Etterna Mapping: 1=Overall, 2-8=Skillsets)
local msd_indices = { 2, 3, 4, 5, 6, 7, 8, 1 }

-- Robust Step Retrieval to ensure chart info displays even if a player isn't joined
local function GetSteps( pnPlayer )
	local steps = GAMESTATE:GetCurrentSteps( pnPlayer )
	local song = GAMESTATE:GetCurrentSong()

	-- Validation: Ensure steps belong to the current song to avoid stale data during transitions
	-- Defensive check: ensure steps is userdata and has GetSong method
	if steps and song and type(steps) == "userdata" and steps.GetSong and steps:GetSong() ~= song then
		steps = nil
	end

	if not steps then
		-- Fallback to the other player if the current one isn't joined or is stale
		if pnPlayer == PLAYER_1 then
			steps = GAMESTATE:GetCurrentSteps( PLAYER_2 )
		else
			steps = GAMESTATE:GetCurrentSteps( PLAYER_1 )
		end
		if steps and song and type(steps) == "userdata" and steps.GetSong and steps:GetSong() ~= song then
			steps = nil
		end
	end

	-- Final Fallback: If still nil, try to get the first available chart for the song
	if not steps and song then
		local st = GAMESTATE:GetCurrentStyle():GetStepsType()
		local allSteps = song:GetStepsByStepsType(st)
		if allSteps and #allSteps > 0 then
			steps = allSteps[1]
		end
	end

	return steps
end

local function GetRadarData( pnPlayer, rcRadarCategory )
	local steps = GetSteps( pnPlayer )
	local fDesiredValue = 0;
	if steps then
		fDesiredValue = steps:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	-- Removed GetCurrentTrail dependency (Courses are deprecated in Etterna)
	end;
	return fDesiredValue;
end

local function GetMSDData( pnPlayer, skillsetIndex )
	local steps = GetSteps( pnPlayer )
	if not steps then return 0 end
	local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
	return steps:GetMSD(rate, skillsetIndex)
end

local function CreatePaneDisplayItem( _pnPlayer, _sLabel, _rcOrIndex )
	local lastValue = nil
	return Def.ActorFrame {
		LoadFont("Common Italic Condensed") .. {
			Text=string.upper( THEME:GetString("PaneDisplay",_sLabel) );
			InitCommand=function(self) self:horizalign(left) end;
			OnCommand=function(self) self:zoom(0.8):diffuse(color("0.9,0.9,0.9")):shadowlength(1) end;
		};
		LoadFont("Common Condensed") .. {
			InitCommand=function(self) self:x(122):horizalign(right) end;
			OnCommand=function(self) self:zoom(0.8):shadowlength(1) end;
			-- Use queuecommand to allow GAMESTATE to settle during rapid transitions
			CurrentSongChangedMessageCommand=function(self) self:finishtweening():sleep(0.01):queuecommand("Set") end;
			CurrentStepsP1ChangedMessageCommand=function(self) self:finishtweening():sleep(0.01):queuecommand("Set") end;
			CurrentStepsP2ChangedMessageCommand=function(self) self:finishtweening():sleep(0.01):queuecommand("Set") end;
			CurrentRateChangedMessageCommand=function(self) self:finishtweening():sleep(0.01):queuecommand("Set") end;
			-- Also update when either player changes steps (for single player mode where P1 controls both displays)
			PlayerJoinedMessageCommand=function(self) self:finishtweening():sleep(0.01):queuecommand("Set") end;
			-- Removed Trail/Course message commands
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local value = 0
				if not song then
					if iPN == PLAYER_2 then
						value = 0
					else
						value = 0
					end
				else
					if iPN == PLAYER_2 then
						value = GetMSDData( _pnPlayer, _rcOrIndex )
					else
						value = GetRadarData( _pnPlayer, _rcOrIndex )
					end
				end
				lastValue = value
				if iPN == PLAYER_2 then
					self:settextf("%05.2f", value)
				else
					self:settextf("%04i", value)
				end
			end;
			-- Continuous polling as fallback
			InitCommand=function(self)
				self:SetUpdateFunction(function()
					local song = GAMESTATE:GetCurrentSong()
					local currentValue = 0
					if song then
						if iPN == PLAYER_2 then
							currentValue = GetMSDData( _pnPlayer, _rcOrIndex )
						else
							currentValue = GetRadarData( _pnPlayer, _rcOrIndex )
						end
					end
					if currentValue ~= lastValue then
						lastValue = currentValue
						if iPN == PLAYER_2 then
							self:settextf("%05.2f", currentValue)
						else
							self:settextf("%04i", currentValue)
						end
					end
				end)
			end;
		};
	};
end;

--[[ Numbers ]]
t[#t+1] = Def.ActorFrame {
	-- Left Column
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[1], msd_indices[1] )
		else
			return CreatePaneDisplayItem( iPN, "Taps", 'RadarCategory_TapsAndHolds' )
		end
	end)() .. {
		InitCommand=function(self) self:x(-128+16+8):y(-14) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.4):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.1):diffusealpha(0):zoomy(0.8) end;
	};
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[2], msd_indices[2] )
		else
			return CreatePaneDisplayItem( iPN, "Jumps", 'RadarCategory_Jumps' )
		end
	end)() .. {
		InitCommand=function(self) self:x(-128+16+8):y(-14+24) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.5):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.15):diffusealpha(0):zoomy(0.8) end;
	};
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[3], msd_indices[3] )
		else
			return CreatePaneDisplayItem( iPN, "Holds", 'RadarCategory_Holds' )
		end
	end)() .. {
		InitCommand=function(self) self:x(-128+16+8):y(-14+24*2) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.6):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.2):diffusealpha(0):zoomy(0.8) end;
	};
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[4], msd_indices[4] )
		else
			return CreatePaneDisplayItem( iPN, "Mines", 'RadarCategory_Mines' )
		end
	end)() .. {
		InitCommand=function(self) self:x(-128+16+8):y(-14+24*3) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.7):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.25):diffusealpha(0):zoomy(0.8) end;
	};

	-- Center Column
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[5], msd_indices[5] )
		else
			return CreatePaneDisplayItem( iPN, "Hands", 'RadarCategory_Hands' )
		end
	end)() .. {
		InitCommand=function(self) self:x(36):y(-14) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.4):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.1):diffusealpha(0):zoomy(0.8) end;
	};
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[6], msd_indices[6] )
		else
			return CreatePaneDisplayItem( iPN, "Rolls", 'RadarCategory_Rolls' )
		end
	end)() .. {
		InitCommand=function(self) self:x(36):y(-14+24) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.5):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.15):diffusealpha(0):zoomy(0.8) end;
	};
	(function()
		if iPN == PLAYER_2 then
			return CreatePaneDisplayItem( iPN, skillsets[7], msd_indices[7] )
		else
			return CreatePaneDisplayItem( iPN, "Lifts", 'RadarCategory_Lifts' )
		end
	end)() .. {
		InitCommand=function(self) self:x(36):y(-14+24*2) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.6):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.2):diffusealpha(0):zoomy(0.8) end;
	};
	(function()
		if iPN == PLAYER_2 then
			-- Slot 8 is empty for P2 as Overall is moved to score area
			return Def.Actor {};
		else
			return CreatePaneDisplayItem( iPN, "Fakes", 'RadarCategory_Fakes' )
		end
	end)() .. {
		InitCommand=function(self) self:x(36):y(-14+24*3) end;
		OnCommand=function(self) self:zoomy(0.8):diffusealpha(0):sleep(0.7):linear(0.3):diffusealpha(1):zoomy(1) end;
		OffCommand=function(self) self:linear(0.25):diffusealpha(0):zoomy(0.8) end;
	};
};

return t;