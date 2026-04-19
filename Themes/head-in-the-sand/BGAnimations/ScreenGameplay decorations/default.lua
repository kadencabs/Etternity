local maxSegments = 150

local t = LoadFallbackB()
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrame","ScoreFrame");

local function songMeterScale(val) return scale(val,0,1,-380/2,380/2) end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "SongMeterDisplay" .. PlayerNumberToString(pn);
	local songMeterDisplay = Def.ActorFrame{
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(420,20)
			end;
			OnCommand=function(self)
				self:fadeleft(0.35):faderight(0.35):diffuse(Color.Black):diffusealpha(0.5)
			end;
		};
 		LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'frame ' .. PlayerNumberToString(pn) ) ) .. {
			InitCommand=function(self)
				self:name('Frame'); 
				ActorUtil.LoadAllCommandsAndSetXY(self,MetricsName); 
			end;
		};
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(2,8)
			end;
			OnCommand=function(self)
				self:x(songMeterScale(0.25)):diffuse(PlayerColor(pn)):diffusealpha(0.5)
			end;
		};
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(2,8)
			end;
			OnCommand=function(self)
				self:x(songMeterScale(0.5)):diffuse(PlayerColor(pn)):diffusealpha(0.5)
			end;
		};
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(2,8)
			end;
			OnCommand=function(self)
				self:x(songMeterScale(0.75)):diffuse(PlayerColor(pn)):diffusealpha(0.5)
			end;
		};
		Def.SongMeterDisplay {
			StreamWidth=THEME:GetMetric( MetricsName, 'StreamWidth' );
			Stream=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'stream ' .. PlayerNumberToString(pn) ) )..{
				InitCommand=function(self)
					self:diffuse(PlayerColor(pn)):diffusealpha(0.5):blend(Blend.Add)
				end;
			};
			
			Tip=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'tip ' .. PlayerNumberToString(pn) ) ) .. {
				 InitCommand=function(self)
					self:visible(false)
				end
			};
		};
	};
	t[#t+1] = songMeterDisplay
end;

for pn in ivalues(PlayerNumber) do
	local MetricsName = "ToastyDisplay" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG("Player", 'toasty'), pn ) .. {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
end;


t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
t[#t+1] = StandardDecorationFromFileOptional("SongTitle","SongTitle");

return t
