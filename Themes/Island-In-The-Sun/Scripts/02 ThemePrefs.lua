-- Etterna 0.74.4 Compatibility Layer
if not _G.COMPAT_INITIALIZED then
    _G.COMPAT_INITIALIZED = true
    _G.REAL_SINGLETONS = _G.REAL_SINGLETONS or {}
    Trace("COMPAT: Initializing Robust Etterna 0.74.4 Compatibility Layer")

    -- 1. Robust Singleton Proxy Shims
    -- Necessary because singletons' metatables are often protected or return strings
    local function CreateRobustShim(globalName, shims)
        local realObj = _G[globalName]
        Trace("COMPAT: Checking " .. globalName .. " (type: " .. type(realObj) .. ")")
        -- Avoid double-shimming
        if realObj and not _G[globalName .. "_SHIMMED"] then
            _G.REAL_SINGLETONS[globalName] = realObj
            local shim = {}
            setmetatable(shim, {
                __index = function(t, k)
                    -- 1. Check for explicit shims first
                    if shims[k] then return shims[k] end
                    
                    -- 2. Safely attempt to index the real object
                    local success, val = pcall(function() return realObj[k] end)
                    if not success then return nil end

                    -- 3. Wrap functions to ensure correct 'self' (the real engine object)
                    if type(val) == "function" then
                        return function(self, ...)
                            local target = (self == shim or self == t) and realObj or self
                            return val(target, ...)
                        end
                    end
                    return val
                end,
                __newindex = function(_, k, v)
                    pcall(function() realObj[k] = v end)
                end,
                __tostring = function() return globalName .. " (Robust Shim)" end
            })
            _G[globalName] = shim
            _G[globalName .. "_SHIMMED"] = true
            Trace("COMPAT: " .. globalName .. " Robust Proxy Shim active")
        end
    end
    _G.CreateRobustShim = CreateRobustShim

    -- SONGMAN Shims
    CreateRobustShim("SONGMAN", {
        -- GetRandomSong was removed/renamed in some 0.74 scenarios
        GetRandomSong = function() 
            local sm = _G.REAL_SINGLETONS.SONGMAN or _G.SONGMAN
            local success, chart = pcall(function() return sm:GetRandomChart() end)
            if success and chart and chart.GetSong then
                return chart:GetSong()
            end
            return nil 
        end,
        GetNumCourses = function() return 0 end,
        GetNumAdditionalCourses = function() return 0 end,
        GetNumUnlockedSongs = function() return 0 end,
    })

    -- GAMESTATE Shims
    CreateRobustShim("GAMESTATE", {
        GetCurrentStage = function() return "Stage_1st" end,
        GetCurrentStageIndex = function() return 0 end,
        GetPlayMode = function()
            local gs = _G.REAL_SINGLETONS.GAMESTATE or _G.GAMESTATE
            local success, isCourse = pcall(function() return gs:IsCourseMode() end)
            if success and isCourse then return "PlayMode_Nonstop" end
            return "PlayMode_Regular"
        end,
        EnoughCreditsToJoin = function() return true end,
    })

    -- 2. Global Function Shims
    if not _G.VersionDate then
        _G.VersionDate = function() 
            if _G.ProductVersion then return _G.ProductVersion() end
            return "0.74.4" 
        end
    end

    if not _G.thified_curstage_index then
        _G.thified_curstage_index = function(dummy) return "1st" end
    end

    -- 3. Actor Metatable Injection
    local dummyActor = Def.Actor{}
    local actorTable = getmetatable(dummyActor)
    if actorTable and not actorTable.hibernate then
        actorTable.hibernate = function(self, seconds)
            self:visible(false)
            return self
        end
        Trace("COMPAT: Actor:hibernate injected")
    end

    -- Compatibility Layer Cleanup: HelpDisplay shim removed as theme was modernized.

end

-- StepMania 5 Default Theme Preferences Handler
local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

-- Example usage of new system (absolutely fully implemented and completely usable)
local Prefs =
{
	AutoSetStyle =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowStepsDisplay = 
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowScore =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ShowLotsaOptions =
	{
		Default = true,
		Choices = { OptionNameString('Many'), OptionNameString('Few') },
		Values = { true, false }
	},
	LongFail =
	{
		Default = false,
		Choices = { OptionNameString('Short'), OptionNameString('Long') },
		Values = { false, true }
	},
	NotePosition =
	{
		Default = true,
		Choices = { OptionNameString('Normal'), OptionNameString('Lower') },
		Values = { true, false }
	},
	ComboOnRolls =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FlashyCombo =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ComboUnderField =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FancyUIBG =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TimingDisplay =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayFooter =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	PreferredMeter =
	{
		Default = "old",
		Choices = { OptionNameString('MeterClassic'), OptionNameString('MeterX'), OptionNameString('MeterPump') },
		Values = { "old", "X", "pump" }
	},
	CustomComboContinue =
	{
		Default = "default",
		Choices = { OptionNameString('Default'), OptionNameString('TNS_W1'), OptionNameString('TNS_W2'), OptionNameString('TNS_W3'), OptionNameString('TNS_W4')  },
		Values = { "default", "TapNoteScore_W1", "TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4" }
	},
	CustomComboMaintain =
	{
		Default = "default",
		Choices = { OptionNameString('Default'), OptionNameString('TNS_W1'), OptionNameString('TNS_W2'), OptionNameString('TNS_W3'), OptionNameString('TNS_W4')  },
		Values = { "default", "TapNoteScore_W1", "TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4" }
	},
	ForcedExtraMods =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	}
}

ThemePrefs.InitAll(Prefs)

function InitUserPrefs()
	local Prefs = {
		UserPrefScoringMode = 'DDR Extreme',
        UserPrefSoundPack   = 'default',
		UserPrefProtimingP1 = false,
		UserPrefProtimingP2 = false,
	}
	for k, v in pairs(Prefs) do
		-- kind of xxx
		local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		if GetPref(k) == nil then
			SetUserPref(k, v)
		end
	end

	-- screen filter
	setenv("ScreenFilterP1",0)
	setenv("ScreenFilterP2",0)

	-- Ensure Compatibility Shims are active (Sometime singletons aren't ready at script load)
	if _G.CreateRobustShim then
		_G.CreateRobustShim("SONGMAN", {
			GetRandomSong = function() 
				local sm = _G.REAL_SINGLETONS.SONGMAN or _G.SONGMAN
				local success, chart = pcall(function() return sm:GetRandomChart() end)
				if success and chart and chart.GetSong then return chart:GetSong() end
				return nil 
			end,
			GetNumCourses = function() return 0 end,
			GetNumAdditionalCourses = function() return 0 end,
			GetNumUnlockedSongs = function() return 0 end,
		})
	end
end

function GetProTiming(pn)
	local pname = ToEnumShortString(pn)
	if GetUserPref("ProTiming"..pname) then
		return GetUserPrefB("ProTiming"..pname)
	else
		SetUserPref("ProTiming"..pname,false)
		return false
	end
end

--[[ option rows ]]

-- screen filter
function OptionRowScreenFilter()
	return {
		Name="ScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { THEME:GetString('OptionNames','Off'), '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1.0', },
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local filterValue = getenv("ScreenFilter"..pName)
			if filterValue ~= nil then
				local val = scale(tonumber(filterValue),0,1,1,#list )
				list[val] = true
			else
				setenv("ScreenFilter"..pName,0)
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						local val = scale(i,1,#list,0,1)
						setenv("ScreenFilter"..pName,val)
						found = true
					end
				end
			end
		end,
	}
end

-- protiming
function OptionRowProTiming()
	return {
		Name = "ProTiming",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = {
			THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionNames','On')
		},
		LoadSelections = function(self, list, pn)
			if GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn)) then
				local bShow = GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn))
				if bShow then
					list[2] = true
				else
					list[1] = true
				end
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave = list[2] and true or false
			SetUserPref("UserPrefProtiming" .. ToEnumShortString(pn), bSave)
		end
	}
end

--[[ end option rows ]]
