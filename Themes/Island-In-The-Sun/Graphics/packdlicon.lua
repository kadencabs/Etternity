-- Download Icon for Pack Downloader
-- Simple downward arrow icon drawn with primitives

local size = Var "IconSize" or 32

return Def.ActorFrame {
    Name = "DownloadIcon",
    
    -- Background circle
    Def.Quad {
        Name = "BG",
        InitCommand = function(self)
            self:zoomto(size, size)
            self:diffuse(color("#333333"))
            self:diffusealpha(0.8)
        end
    },
    
    -- Arrow shaft (vertical line)
    Def.Quad {
        Name = "ArrowShaft",
        InitCommand = function(self)
            self:zoomto(size * 0.2, size * 0.5)
            self:y(-size * 0.1)
            self:diffuse(color("#FFFFFF"))
        end
    },
    
    -- Arrow head (triangle pointing down)
    Def.ActorFrame {
        Name = "ArrowHead",
        InitCommand = function(self)
            self:y(size * 0.25)
        end,
        
        Def.Quad {
            Name = "Left",
            InitCommand = function(self)
                self:zoomto(size * 0.3, size * 0.2)
                self:x(-size * 0.15)
                self:rotationz(45)
                self:diffuse(color("#FFFFFF"))
            end
        },
        
        Def.Quad {
            Name = "Right",
            InitCommand = function(self)
                self:zoomto(size * 0.3, size * 0.2)
                self:x(size * 0.15)
                self:rotationz(-45)
                self:diffuse(color("#FFFFFF"))
            end
        }
    }
}
