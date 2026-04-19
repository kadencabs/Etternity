-- Pack Download Screen Decorations for Island-In-The-Sun
-- Full pack browser with download functionality

local t = Def.ActorFrame {
    Name = "PackDownloadDecorations",
}

-- Screen layout
local frameWidth = 750
local frameHeight = 500
local frameX = SCREEN_CENTER_X
local frameY = SCREEN_CENTER_Y + 10
local headerHeight = 50
local itemHeight = 38
local listTop = frameY - frameHeight/2 + headerHeight + 20

-- Pack data
local pl = nil
local selectedIndex = 1
local pageSize = 10

-- Colors
local colorHeader = color("#9d324e")
local colorText = color("#FFFFFF")
local colorTextDim = color("#888888")
local colorSelected = color("#4B82DC")

-- Main frame
t[#t+1] = Def.Quad {
    Name = "FrameBG",
    InitCommand = function(self)
        self:zoomto(frameWidth, frameHeight)
        self:diffuse(color("#1a1a1a"))
        self:diffusealpha(0.95)
        self:xy(frameX, frameY)
    end
}

-- Header bar
t[#t+1] = Def.Quad {
    Name = "HeaderBG",
    InitCommand = function(self)
        self:zoomto(frameWidth, headerHeight)
        self:diffuse(color("#252525"))
        self:xy(frameX, frameY - frameHeight/2 + headerHeight/2)
    end
}

-- Title
t[#t+1] = LoadFont("Common Normal") .. {
    Name = "Title",
    InitCommand = function(self)
        self:xy(frameX - frameWidth/2 + 15, frameY - frameHeight/2 + 25)
        self:halign(0)
        self:zoom(0.75)
        self:diffuse(colorText)
        self:settext(THEME:GetString("ScreenPackDownloader", "Title"))
    end
}

-- Column Headers
t[#t+1] = LoadFont("Common Normal") .. {
    Name = "HeaderName",
    InitCommand = function(self)
        self:xy(frameX - frameWidth/2 + 30, listTop - 15)
        self:halign(0)
        self:zoom(0.5)
        self:diffuse(colorHeader)
        self:settext(THEME:GetString("ScreenPackDownloader", "HeaderName"))
    end
}

t[#t+1] = LoadFont("Common Normal") .. {
    Name = "HeaderMSD",
    InitCommand = function(self)
        self:xy(frameX + 180, listTop - 15)
        self:halign(0)
        self:zoom(0.5)
        self:diffuse(colorHeader)
        self:settext(THEME:GetString("ScreenPackDownloader", "HeaderAverage"))
    end
}

t[#t+1] = LoadFont("Common Normal") .. {
    Name = "HeaderSize",
    InitCommand = function(self)
        self:xy(frameX + 280, listTop - 15)
        self:halign(0)
        self:zoom(0.5)
        self:diffuse(colorHeader)
        self:settext(THEME:GetString("ScreenPackDownloader", "HeaderSize"))
    end
}

-- Create pack list items
for i = 1, pageSize do
    local yPos = listTop + (i-1) * itemHeight + itemHeight/2
    
    t[#t+1] = Def.ActorFrame {
        Name = "PackItem_" .. i,
        InitCommand = function(self)
            self:xy(frameX, yPos)
            self.index = i
            self.visible = false
            self.pack = nil
        end,
        
        -- Selection highlight
        Def.Quad {
            Name = "Highlight",
            InitCommand = function(self)
                self:zoomto(frameWidth - 20, itemHeight - 2)
                self:diffuse(colorSelected)
                self:diffusealpha(0)
            end,
            SetSelectedCommand = function(self, params)
                if params.selected then
                    self:diffusealpha(0.3)
                else
                    self:diffusealpha(0)
                end
            end
        },
        
        -- Pack name
        LoadFont("Common Normal") .. {
            Name = "Name",
            InitCommand = function(self)
                self:xy(-frameWidth/2 + 30, 0)
                self:halign(0)
                self:zoom(0.55)
                self:maxwidth(350/0.55)
                self:settext("")
            end,
            SetPackCommand = function(self, params)
                local pack = params.pack
                if pack then
                    self:settext(pack:GetName() or "")
                    if pack:IsNSFW() then
                        self:diffuse(color("#FF6B6B"))
                    else
                        self:diffuse(colorText)
                    end
                else
                    self:settext("")
                end
            end
        },
        
        -- MSD
        LoadFont("Common Normal") .. {
            Name = "MSD",
            InitCommand = function(self)
                self:xy(180, 0)
                self:halign(0)
                self:zoom(0.55)
            end,
            SetPackCommand = function(self, params)
                local pack = params.pack
                if pack then
                    local msd = pack:GetAvgDifficulty()
                    self:settextf("%.2f", msd)
                    -- Color by difficulty
                    if msd < 10 then self:diffuse(color("#4A90D9"))
                    elseif msd < 20 then self:diffuse(color("#9B59B6"))
                    elseif msd < 30 then self:diffuse(color("#E74C3C"))
                    else self:diffuse(color("#C0392B")) end
                else
                    self:settext("")
                end
            end
        },
        
        -- Size
        LoadFont("Common Normal") .. {
            Name = "Size",
            InitCommand = function(self)
                self:xy(280, 0)
                self:halign(0)
                self:zoom(0.55)
            end,
            SetPackCommand = function(self, params)
                local pack = params.pack
                if pack then
                    local sizeMB = pack:GetSize() / 1024 / 1024
                    self:settextf("%.0f MB", sizeMB)
                    self:diffuse(colorTextDim)
                else
                    self:settext("")
                end
            end
        },
        
        -- Status (Installed/Queued/Downloading)
        LoadFont("Common Normal") .. {
            Name = "Status",
            InitCommand = function(self)
                self:xy(frameWidth/2 - 50, 0)
                self:halign(1)
                self:zoom(0.5)
                self:settext("")
            end,
            SetPackCommand = function(self, params)
                local pack = params.pack
                if pack then
                    local name = pack:GetName()
                    if SONGMAN:DoesSongGroupExist(name) then
                        self:settext("Installed")
                        self:diffuse(color("#2ECC71"))
                    else
                        self:settext("")
                    end
                else
                    self:settext("")
                end
            end
        }
    }
end

-- Selection cursor
t[#t+1] = Def.Quad {
    Name = "Cursor",
    InitCommand = function(self)
        self:zoomto(4, itemHeight - 4)
        self:diffuse(color("#FFFFFF"))
        self:diffusealpha(0.8)
        self:halign(0)
        self:xy(frameX - frameWidth/2 + 10, listTop + itemHeight/2)
    end,
    MoveCommand = function(self)
        local yPos = listTop + (selectedIndex-1) * itemHeight + itemHeight/2
        self:stoptweening()
        self:decelerate(0.1)
        self:y(yPos)
    end
}

-- Page indicator
t[#t+1] = LoadFont("Common Normal") .. {
    Name = "PageText",
    InitCommand = function(self)
        self:xy(frameX, frameY + frameHeight/2 - 35)
        self:zoom(0.6)
        self:diffuse(colorText)
        self:settext("Page 1")
    end,
    UpdatePageCommand = function(self)
        if pl then
            local current = pl:GetCurrentPage() or 1
            local total = pl:GetTotalPages() or 1
            self:settext(string.format("Page %d / %d", current, total))
        end
    end
}

-- Status bar
t[#t+1] = Def.ActorFrame {
    Name = "StatusBar",
    InitCommand = function(self)
        self:xy(frameX, frameY + frameHeight/2 - 12)
    end,
    
    Def.Quad {
        InitCommand = function(self)
            self:zoomto(frameWidth, 20)
            self:diffuse(color("#252525"))
        end
    },
    
    LoadFont("Common Normal") .. {
        Name = "StatusText",
        InitCommand = function(self)
            self:zoom(0.45)
            self:diffuse(colorTextDim)
            self:settext("Press &UP;/&DOWN; to select, &START; to download, &BACK; to exit")
        end,
        UpdateStatusCommand = function(self)
            local downloading = DLMAN:GetDownloadingPacks()
            local queued = DLMAN:GetQueuedPacks()
            
            local status = ""
            if #downloading > 0 then
                status = string.format("Downloading: %d | ", #downloading)
            end
            if #queued > 0 then
                status = status .. string.format("Queued: %d | ", #queued)
            end
            status = status .. "Press &UP;/&DOWN; to select, &START; to download, &BACK; to exit"
            self:settext(status)
        end
    }
}

-- Main controller
t[#t+1] = Def.ActorFrame {
    Name = "Controller",
    
    InitCommand = function(self)
        -- Initialize PackList
        if PackList then
            pl = PackList:new()
            if pl then
                pl:FilterAndSearch("", {}, true, pageSize)
            end
        end
        selectedIndex = 1
    end,
    
    OnCommand = function(self)
        self:playcommand("RefreshList")
        
        -- Setup input handling
        local screen = SCREENMAN:GetTopScreen()
        if screen then
            screen:AddInputCallback(function(event)
                if event.type ~= "InputEventType_FirstPress" then return end
                
                -- Navigation
                if event.GameButton == "MenuUp" or event.GameButton == "Up" then
                    selectedIndex = math.max(1, selectedIndex - 1)
                    self:GetParent():GetChild("Cursor"):playcommand("Move")
                    self:playcommand("RefreshList")
                    
                elseif event.GameButton == "MenuDown" or event.GameButton == "Down" then
                    selectedIndex = math.min(pageSize, selectedIndex + 1)
                    self:GetParent():GetChild("Cursor"):playcommand("Move")
                    self:playcommand("RefreshList")
                    
                elseif event.GameButton == "MenuLeft" or event.GameButton == "Left" then
                    if pl and pl:PrevPage() then
                        selectedIndex = 1
                        self:GetParent():GetChild("Cursor"):playcommand("Move")
                        self:sleep(0.1):queuecommand("RefreshList")
                    end
                    
                elseif event.GameButton == "MenuRight" or event.GameButton == "Right" then
                    if pl and pl:NextPage() then
                        selectedIndex = 1
                        self:GetParent():GetChild("Cursor"):playcommand("Move")
                        self:sleep(0.1):queuecommand("RefreshList")
                    end
                    
                elseif event.GameButton == "Back" or event.GameButton == "MenuBack" then
                    SCREENMAN:SetNewScreen("ScreenTitleMenu")
                    
                elseif event.GameButton == "Start" or event.GameButton == "MenuStart" then
                    -- Download selected pack
                    if pl then
                        local packs = pl:GetPacks()
                        if packs and packs[selectedIndex] then
                            local pack = packs[selectedIndex]
                            local name = pack:GetName()
                            if not SONGMAN:DoesSongGroupExist(name) then
                                -- Check if already downloading
                                local downloading = DLMAN:GetDownloadingPacks()
                                local queued = DLMAN:GetQueuedPacks()
                                local alreadyDownloading = false
                                
                                for _, dp in ipairs(downloading) do
                                    if dp:GetName() == name then
                                        alreadyDownloading = true
                                        break
                                    end
                                end
                                for _, qp in ipairs(queued) do
                                    if qp:GetName() == name then
                                        alreadyDownloading = true
                                        break
                                    end
                                end
                                
                                if not alreadyDownloading then
                                    pack:DownloadAndInstall(false)
                                    self:GetParent():GetChild("StatusBar"):GetChild("StatusText"):playcommand("UpdateStatus")
                                end
                            end
                        end
                    end
                    
                end
            end)
        end
        
        -- Periodic status update
        self:SetUpdateFunction(function()
            self:GetParent():GetChild("StatusBar"):GetChild("StatusText"):playcommand("UpdateStatus")
        end)
        self:SetUpdateFunctionInterval(1.0)
    end,
    
    RefreshListCommand = function(self)
        if not pl then return end
        
        local packs = pl:GetPacks()
        local cursor = self:GetParent():GetChild("Cursor")
        
        for i = 1, pageSize do
            local item = self:GetParent():GetChild("PackItem_" .. i)
            if item then
                local pack = packs and packs[i]
                local highlight = item:GetChild("Highlight")
                
                if pack then
                    item:diffusealpha(1)
                    item:playcommand("SetPack", {pack = pack})
                    if highlight then
                        highlight:playcommand("SetSelected", {selected = (i == selectedIndex)})
                    end
                else
                    item:diffusealpha(0)
                end
            end
        end
        
        -- Update page indicator
        self:GetParent():GetChild("PageText"):playcommand("UpdatePage")
    end,
    
    PackListRequestFinishedMessageCommand = function(self)
        self:playcommand("RefreshList")
    end
}

return t
