local t = Def.ActorFrame {};

-- Rate Control and Chart Preview Module
local MIN_RATE = 0.05
local MAX_RATE = 3.0
local RATE_INCREMENT = 0.05
local chartPreviewEnabled = false

-- Function to get current rate
local function getCurrentRate()
    local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
    if so and so.MusicRate then
        return so:MusicRate()
    end
    return 1.0
end

-- Function to set rate (updates all 3 ModsLevel objects)
local function setRate(newRate)
    newRate = math.max(MIN_RATE, math.min(MAX_RATE, newRate))
    newRate = math.floor(newRate * 100 + 0.5) / 100

    local prefOpts = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
    local songOpts = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
    local curOpts = GAMESTATE:GetSongOptionsObject("ModsLevel_Current")

    if prefOpts and prefOpts.MusicRate then prefOpts:MusicRate(newRate) end
    if songOpts and songOpts.MusicRate then songOpts:MusicRate(newRate) end
    if curOpts and curOpts.MusicRate then curOpts:MusicRate(newRate) end

    MESSAGEMAN:Broadcast("RateChanged", {rate = newRate})
    return newRate
end

local function increaseRate()
    local currentRate = getCurrentRate()
    local newRate = currentRate + RATE_INCREMENT
    if newRate > MAX_RATE then return currentRate end
    return setRate(newRate)
end

local function decreaseRate()
    local currentRate = getCurrentRate()
    local newRate = currentRate - RATE_INCREMENT
    if newRate < MIN_RATE then return currentRate end
    return setRate(newRate)
end

local function toggleChartPreview()
    chartPreviewEnabled = not chartPreviewEnabled
    MESSAGEMAN:Broadcast("ChartPreviewToggled", {Enabled = chartPreviewEnabled})
    return chartPreviewEnabled
end

-- Input handler using CodeMessageCommand (Etterna standard)
local function codeMessageHandler(self, params)
    if not params or not params.Name then return end

    if params.Name == "NextRate" then
        local newRate = increaseRate()
        MESSAGEMAN:Broadcast("RateChanged", {rate = newRate})
    elseif params.Name == "PrevRate" then
        local newRate = decreaseRate()
        MESSAGEMAN:Broadcast("RateChanged", {rate = newRate})
    elseif params.Name == "ChartPreview" then
        local enabled = toggleChartPreview()
        MESSAGEMAN:Broadcast("ChartPreviewToggled", {Enabled = enabled})
    end
end

-- Input handler Actor using CodeMessageCommand
t[#t+1] = Def.Actor {
    CodeMessageCommand = codeMessageHandler
};

-- Sort order
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:x(SCREEN_RIGHT-290):y(SCREEN_TOP+49) end;
    OffCommand=function(self) self:linear(0.3):diffusealpha(0) end;
	LoadActor(THEME:GetPathG("", "_sortFrame"))  .. {
	    InitCommand=function(self) self:diffusealpha(0.9):zoom(1.5) end;
		OnCommand=function(self)
			self:diffuse(ColorMidTone(ScreenColor(SCREENMAN:GetTopScreen():GetName())));
		end
	};

    LoadFont("Common Condensed") .. {
            InitCommand=function(self) self:zoom(1):diffuse(color("#FFFFFF")):diffusealpha(0.85):horizalign(left):addx(-115) end;
            OnCommand=function(self) self:queuecommand("Set") end;
            ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
            SetCommand=function(self)
                self:settext("SORT:");
                self:queuecommand("Refresh");
            end;
    };

    LoadFont("Common Condensed") .. {
          InitCommand=function(self) self:zoom(1):maxwidth(SCREEN_WIDTH):addx(115):diffuse(color("#FFFFFF")):uppercase(true):horizalign(right):maxwidth(157) end;
          OnCommand=function(self) self:queuecommand("Set") end;
          SortOrderChangedMessageCommand=function(self) self:queuecommand("Set") end;
          ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
          SetCommand=function(self)
               local sortorder = GAMESTATE:GetSortOrder();
               if sortorder then
					self:finishtweening();
					self:smooth(0.4);
					self:diffusealpha(0);
                    self:settext(SortOrderToLocalizedString(sortorder));
                    self:queuecommand("Refresh"):stoptweening():diffusealpha(0):smooth(0.3):diffusealpha(1)
				else
					self:settext("");
					self:queuecommand("Refresh");
               end
          end;
    };
};

-- Rate Display and Control
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self)
        self:x(SCREEN_CENTER_X-228):y(SCREEN_CENTER_Y-220)
        self:visible(not GAMESTATE:IsCourseMode())
    end;

    OnCommand=function(self)
        self:diffusealpha(0):smooth(0.3):diffusealpha(1)
    end;

    OffCommand=function(self)
        self:linear(0.2):diffusealpha(0)
    end;

    RateChangedMessageCommand=function(self)
        local rateValue = self:GetChild("RateValue")
        if rateValue then
            rateValue:playcommand("Set")
        end
    end;

    -- Background quad
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(468, 30):diffuse(color("#000000")):diffusealpha(0.7)
        end;
    };

    -- Rate label
    LoadFont("Common Condensed") .. {
        InitCommand=function(self)
            self:x(-200):zoom(1):diffuse(color("#FFFFFF")):horizalign(left)
            self:settext("RATE:")
        end;
    };

    -- Rate value display
    LoadFont("_overpass Score") .. {
        Name="RateValue";
        InitCommand=function(self)
            self:x(0):zoom(0.8):diffuse(color("#00BFFF")):horizalign(center)
            self:settext("1.00x")
        end;

        CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
        SetCommand=function(self)
            local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
            local rate = so and so.MusicRate and so:MusicRate() or 1.0
            self:settext(string.format("%.2fx", rate))
        end;
    };
};

-- Chart Preview Toggle Status
t[#t+1] = Def.ActorFrame {
    Name="ChartPreviewStatus";
    InitCommand=function(self)
        self:x(SCREEN_RIGHT-80):y(SCREEN_CENTER_Y-220)
        self:visible(false)
        self:draworder(1000)
    end;

    OnCommand=function(self)
        self:diffusealpha(0)
    end;

    ChartPreviewToggledMessageCommand=function(self, params)
        if params and params.Enabled then
            self:visible(true)
            self:finishtweening()
            self:diffusealpha(0)
            self:smooth(0.2)
            self:diffusealpha(1)
        else
            self:finishtweening()
            self:smooth(0.2)
            self:diffusealpha(0)
            self:queuecommand("Hide")
        end
    end;

    HideCommand=function(self)
        self:visible(false)
    end;

    -- Preview background
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(160, 30):diffuse(color("#000000")):diffusealpha(0.8)
        end;
    };

    -- Preview text
    LoadFont("Common Condensed") .. {
        InitCommand=function(self)
            self:zoom(0.9):diffuse(color("#FFD700")):horizalign(center)
            self:settext("PREVIEW ON")
        end;
    };
};

-- Chart Preview Mini Gameplay Display
t[#t+1] = Def.ActorFrame {
    Name="ChartPreviewDisplay";

    InitCommand=function(self)
        self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y)
        self:visible(false)
        self:draworder(500)
    end;

    OnCommand=function(self)
        self:diffusealpha(0)
    end;

    ChartPreviewToggledMessageCommand=function(self, params)
        if params and params.Enabled then
            local song = GAMESTATE:GetCurrentSong()
            local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
            if song and steps then
                self:visible(true)
                self:finishtweening()
                self:diffusealpha(0)
                self:smooth(0.3)
                self:diffusealpha(1)
            else
                -- Don't show if no song/steps selected
                self:visible(false)
            end
        else
            self:finishtweening()
            self:smooth(0.3)
            self:diffusealpha(0)
            self:queuecommand("Hide")
        end
    end;

    HideCommand=function(self)
        self:visible(false)
    end;

    CurrentSongChangedMessageCommand=function(self)
        -- Update visibility based on current song/steps
        if chartPreviewEnabled then
            local song = GAMESTATE:GetCurrentSong()
            local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
            if song and steps then
                self:visible(true)
            else
                self:visible(false)
            end
        end
    end;

    CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("CurrentSongChangedMessage") end;

    -- Background dimmer
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(color("#000000")):diffusealpha(0.85)
        end;
    };

    -- Title text
    LoadFont("Common Condensed") .. {
        InitCommand=function(self)
            self:y(-200):zoom(1.2):diffuse(color("#FFD700")):shadowlength(2)
            self:settext("CHART PREVIEW")
        end;

        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            if song then
                self:settext("CHART PREVIEW: " .. song:GetDisplayMainTitle())
            else
                self:settext("CHART PREVIEW")
            end
        end;
    };

    -- BPM and Rate info
    Def.ActorFrame {
        InitCommand=function(self) self:y(180) end;

        LoadFont("Common Normal") .. {
            InitCommand=function(self)
                self:zoom(0.8):diffuse(color("#FFFFFF"))
                self:settext("Press Space/Select to toggle preview")
            end;
        };
    };

    -- Instructions
    LoadFont("Common Condensed") .. {
        InitCommand=function(self)
            self:y(210):zoom(0.7):diffuse(color("#AAAAAA"))
            self:settext("Effect Up/Down: Change Rate (0.05x - 3.0x)")
        end;
    };

    -- Current rate display in preview
    LoadFont("_overpass Score") .. {
        InitCommand=function(self)
            self:y(240):zoom(0.6):diffuse(color("#00BFFF"))
            self:settext("Rate: 1.00x")
        end;

        RateChangedMessageCommand=function(self)
            local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
            local rate = so and so.MusicRate and so:MusicRate() or 1.0
            self:settext("Rate: " .. string.format("%.2fx", rate))
        end;
    };
};

return t