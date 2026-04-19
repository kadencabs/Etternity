-- Pack Download Overlay for Island-In-The-Sun
-- Simplified pack download UI that shows download progress

local t = Def.ActorFrame {
    Name = "PackDownloadOverlay",
    InitCommand = function(self)
        self:visible(false)
    end,
    
    -- Show when downloads are active
    DLProgressAndQueueUpdateMessageCommand = function(self, params)
        local dlsize = params and params.dlsize or 0
        local queuesize = params and params.queuesize or 0
        
        if dlsize > 0 or queuesize > 0 then
            self:visible(true)
            self:playcommand("UpdateDisplay", params)
        else
            self:visible(false)
        end
    end,
    
    -- Hide during gameplay
    PausingDownloadsMessageCommand = function(self)
        self:visible(false)
    end,
    
    -- Show after gameplay
    ResumingDownloadsMessageCommand = function(self)
        local downloading = DLMAN:GetDownloadingPacks()
        local queued = DLMAN:GetQueuedPacks()
        if #downloading > 0 or #queued > 0 then
            self:visible(true)
        end
    end,
    
    -- Hide when all done
    AllDownloadsCompletedMessageCommand = function(self)
        self:visible(false)
    end,
}

-- Background panel
local panelWidth = 400
local panelHeight = 80
local panelX = SCREEN_RIGHT - panelWidth - 20
local panelY = SCREEN_TOP + 100

t[#t+1] = Def.Quad {
    Name = "BG",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX, panelY)
        self:zoomto(panelWidth, panelHeight)
        self:diffuse(color("#1a1a1a"))
        self:diffusealpha(0.9)
    end
}

-- Border
local borderColor = color("#9d324e")

t[#t+1] = Def.Quad {
    Name = "BorderTop",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX, panelY)
        self:zoomto(panelWidth, 2)
        self:diffuse(borderColor)
    end
}

t[#t+1] = Def.Quad {
    Name = "BorderBottom",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX, panelY + panelHeight - 2)
        self:zoomto(panelWidth, 2)
        self:diffuse(borderColor)
    end
}

-- Title
local titleTextSize = 0.6
t[#t+1] = LoadFont("Common Normal") .. {
    Name = "Title",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX + 10, panelY + 8)
        self:zoom(titleTextSize)
        self:diffuse(color("#FFFFFF"))
        self:settext("Pack Downloads")
    end
}

-- Download count text
t[#t+1] = LoadFont("Common Normal") .. {
    Name = "DownloadCount",
    InitCommand = function(self)
        self:halign(1):valign(0)
        self:xy(panelX + panelWidth - 10, panelY + 8)
        self:zoom(0.5)
        self:diffuse(color("#CCCCCC"))
        self:settext("")
    end,
    UpdateDisplayCommand = function(self, params)
        local dlsize = params and params.dlsize or 0
        local queuesize = params and params.queuesize or 0
        local text = ""
        if dlsize > 0 then
            text = string.format("Downloading: %d", dlsize)
        end
        if queuesize > 0 then
            if text ~= "" then text = text .. " | " end
            text = text .. string.format("Queued: %d", queuesize)
        end
        self:settext(text)
    end
}

-- Progress bar background
t[#t+1] = Def.Quad {
    Name = "ProgressBG",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX + 10, panelY + 40)
        self:zoomto(panelWidth - 20, 12)
        self:diffuse(color("#333333"))
    end
}

-- Progress bar fill
local progressColor = color("#4B82DC")

t[#t+1] = Def.Quad {
    Name = "ProgressFill",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX + 10, panelY + 40)
        self:zoomto(0, 12)
        self:diffuse(progressColor)
    end,
    UpdateDisplayCommand = function(self, params)
        local dlprogress = params and params.dlprogress or ""
        -- Parse progress string like "PackName: 45%"
        local percent = 0
        if dlprogress and dlprogress ~= "" then
            -- Try to extract percentage from the progress string
            local num = dlprogress:match("(%d+)%%")
            if num then
                percent = tonumber(num) / 100
            end
        end
        
        local maxWidth = panelWidth - 20
        self:zoomto(maxWidth * percent, 12)
    end
}

-- Current pack name / progress text
t[#t+1] = LoadFont("Common Normal") .. {
    Name = "ProgressText",
    InitCommand = function(self)
        self:halign(0):valign(0)
        self:xy(panelX + 10, panelY + 56)
        self:zoom(0.45)
        self:diffuse(color("#AAAAAA"))
        self:maxwidth((panelWidth - 20) / 0.45)
        self:settext("")
    end,
    UpdateDisplayCommand = function(self, params)
        local dlprogress = params and params.dlprogress or ""
        local queuedpacks = params and params.queuedpacks or ""
        
        local text = ""
        if dlprogress and dlprogress ~= "" then
            text = dlprogress
        elseif queuedpacks and queuedpacks ~= "" then
            text = "Queued: " .. queuedpacks
        end
        self:settext(text)
    end
}

-- Input handling for cancel functionality
t[#t+1] = Def.ActorFrame {
    InitCommand = function(self)
        self:SetUpdateFunction(function()
            -- Check if downloads are still active
            local downloading = DLMAN:GetDownloadingPacks()
            local queued = DLMAN:GetQueuedPacks()
            if #downloading == 0 and #queued == 0 then
                self:GetParent():visible(false)
            end
        end)
        self:SetUpdateFunctionInterval(0.5)
    end
}

return t
