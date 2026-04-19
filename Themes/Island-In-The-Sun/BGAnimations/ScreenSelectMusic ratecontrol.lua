-- Rate Control and Chart Preview for ScreenSelectMusic
-- Handles Effect Up/Effect Down for rate toggling (0.05x to 3.0x)
-- Handles Select button (Space key) for chart preview toggle

local MIN_RATE = 0.05
local MAX_RATE = 3.0
local RATE_INCREMENT = 0.05
local chartPreviewEnabled = false

-- Function to get current rate
local function getCurrentRate()
    local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
    if so and so.MusicRate then
        return so:MusicRate()
    end
    return 1.0
end

-- Function to set rate with seamless music manipulation
local function setRate(newRate)
    -- Clamp rate to valid range
    newRate = math.max(MIN_RATE, math.min(MAX_RATE, newRate))
    -- Round to 2 decimal places to avoid floating point issues
    newRate = math.floor(newRate * 100 + 0.5) / 100

    local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
    if so and so.MusicRate then
        so:MusicRate(newRate)

        -- Seamlessly update preview music rate without restarting
        local screen = SCREENMAN:GetTopScreen()
        if screen then
            -- Use the screen's music rate manipulation if available
            if screen.SetMusicRate then
                screen:SetMusicRate(newRate)
            elseif screen.PausePreviewMusic and screen.PlayPreviewMusic then
                -- Fallback: quickly pause and restart with new rate
                local wasPlaying = false
                if screen.GetMusicPlaying then
                    wasPlaying = screen:GetMusicPlaying()
                end
                if wasPlaying then
                    screen:PausePreviewMusic()
                    -- Small delay then restart at new rate
                    screen:PlayPreviewMusic()
                    -- Adjust position to maintain seamless feel
                    if screen.SetPreviewMusicPosition then
                        local song = GAMESTATE:GetCurrentSong()
                        if song then
                            local length = song:MusicLengthSeconds()
                            local previewStart = song:GetSampleStart()
                            local previewLength = song:GetSampleLength()
                            if previewLength > 0 then
                                -- Reposition to maintain relative position
                                local currentPos = previewStart
                                if screen.GetPreviewMusicPosition then
                                    currentPos = screen:GetPreviewMusicPosition()
                                end
                                if currentPos then
                                    local newPos = previewStart + (currentPos - previewStart) * (1.0 / newRate)
                                    screen:SetPreviewMusicPosition(newPos)
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Broadcast rate changed message
        MESSAGEMAN:Broadcast("RateChanged")
    end

    return newRate
end

-- Function to increase rate
local function increaseRate()
    local currentRate = getCurrentRate()
    local newRate = currentRate + RATE_INCREMENT

    if newRate > MAX_RATE then
        return currentRate -- Don't go above max
    end

    return setRate(newRate)
end

-- Function to decrease rate
local function decreaseRate()
    local currentRate = getCurrentRate()
    local newRate = currentRate - RATE_INCREMENT

    if newRate < MIN_RATE then
        return currentRate -- Don't go below min
    end

    return setRate(newRate)
end

-- Function to toggle chart preview
local function toggleChartPreview()
    chartPreviewEnabled = not chartPreviewEnabled
    MESSAGEMAN:Broadcast("ChartPreviewToggled", {Enabled = chartPreviewEnabled})
    return chartPreviewEnabled
end

-- Function to check if chart preview is enabled
local function isChartPreviewEnabled()
    return chartPreviewEnabled
end

-- Global accessor functions
_G.RateControl = {
    GetCurrentRate = getCurrentRate,
    SetRate = setRate,
    IncreaseRate = increaseRate,
    DecreaseRate = decreaseRate,
    MinRate = MIN_RATE,
    MaxRate = MAX_RATE,
    RateIncrement = RATE_INCREMENT
}

_G.ChartPreview = {
    Toggle = toggleChartPreview,
    IsEnabled = isChartPreviewEnabled
}

return {
    GetCurrentRate = getCurrentRate,
    SetRate = setRate,
    IncreaseRate = increaseRate,
    DecreaseRate = decreaseRate,
    ToggleChartPreview = toggleChartPreview,
    IsChartPreviewEnabled = isChartPreviewEnabled
}
