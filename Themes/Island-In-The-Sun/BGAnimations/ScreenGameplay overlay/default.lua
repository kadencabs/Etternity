local t = Def.ActorFrame {};
local function UpdateTime(self)
	local c = self:GetChildren();
	for pn in ivalues(PlayerNumber) do
		local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( pn );
		local vTime;
		local obj = self:GetChild( string.format("RemainingTime" .. PlayerNumberToString(pn) ) );
		if vStats and obj then
			vTime = vStats:GetLifeRemainingSeconds()
			obj:settext( SecondsToMMSSMsMs( vTime ) );
		end;
	end;
end
local function songMeterScale(val) return scale(val,0,1,-380/2,380/2) end

-- Survival mode removed in Etterna 0.74.4
t.InitCommand=function(self) self:SetUpdateFunction(UpdateTime) end;
	
	if GAMESTATE:GetPlayMode() ~= 'PlayMode_Rave' then
		for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
			if ShowStandardDecoration("LifeMeterBar" ..  ToEnumShortString(pn)) then
				local life_type = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song"):LifeSetting()
				t[#t+1] = LoadActor(THEME:GetPathG(Var "LoadingScreen", "lifebar_" .. ToEnumShortString(life_type)), pn) .. {
					InitCommand=function(self)
						self:name("LifeMeterBar" .. ToEnumShortString(pn))
						ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
					end
				}
			end
			-- Always show Wife3 for enabled players
			t[#t+1] = LoadActor("Wife3.lua", pn)
		end;
		
		for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
				local life_x_position = string.find(pn, "P1") and SCREEN_LEFT+40 or SCREEN_RIGHT-40
				local life_tween = string.find(pn, "P1") and -1 or 1
				local second_tween = string.find(pn, "P1") and 1 or -1
				t[#t+1] = Def.ActorFrame {
					InitCommand=function(self) self:x(life_x_position):y(SCREEN_CENTER_Y):rotationz(-90) end;
					OnCommand=function(self) self:addx(100*life_tween):sleep(0.25):decelerate(0.9):addx(100*second_tween) end;
					OffCommand=function(self) self:sleep(1):decelerate(0.9):addx(100*life_tween) end;
					LoadActor(THEME:GetPathG("LifeMeter", "bar frame")) .. {
					};
					Def.ActorFrame {
						InitCommand=function(self) self:x(-207):y(0) end;
						LoadActor("_diffdia") .. {
						OnCommand=function(self) self:playcommand("Set") end;
						["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
						SetCommand=function(self)
							steps_data = GAMESTATE:GetCurrentSteps(pn)
							local song = GAMESTATE:GetCurrentSong();
							if song then
								if steps_data ~= nil then
									local st = steps_data:GetStepsType();
									local diff = steps_data:GetDifficulty();
									local cd = GetCustomDifficulty(st, diff);
									self:diffuse(CustomDifficultyToColor(cd));
								end
							end
						end;
						};
						LoadFont("StepsDisplay description") .. {
							  InitCommand=function(self) self:zoom(0.75):horizalign(center):rotationz(90) end;
							  OnCommand=function(self) self:playcommand("Set") end;
							  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
							  ChangedLanguageDisplayMessageCommand=function(self) self:playcommand("Set") end;
							  SetCommand=function(self)
								steps_data = GAMESTATE:GetCurrentSteps(pn)
								local song = GAMESTATE:GetCurrentSong();
								if song then
									if steps_data ~= nil then
										local st = steps_data:GetStepsType();
										local diff = steps_data:GetDifficulty();
										local cd = GetCustomDifficulty(st, diff);
										self:settext(steps_data:GetMeter()):diffuse(color("#000000")):diffusealpha(0.8);
									else
										self:settext("")
									end
								else
									self:settext("")
								end
							  end
						};
					};
				};
		end;
	end;
	
	-- Move diamonds on battle
	if GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
	-- P1
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X-110):y(SCREEN_BOTTOM-55) end;
		LoadActor("_diffdia") .. {
		OnCommand=function(self) self:playcommand("Set") end;
		CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if stepsP1 ~= nil then
					local st = stepsP1:GetStepsType();
					local diff = stepsP1:GetDifficulty();
					local cd = GetCustomDifficulty(st, diff);
					self:diffuse(CustomDifficultyToColor(cd));
				end
			end
		end;
		};
		LoadFont("StepsDisplay description") .. {
			  InitCommand=function(self) self:zoom(0.75):horizalign(center) end;
			  OnCommand=function(self) self:playcommand("Set") end;
			  CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:playcommand("Set") end;
			  SetCommand=function(self)
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					if stepsP1 ~= nil then
						local st = stepsP1:GetStepsType();
						local diff = stepsP1:GetDifficulty();
						local cd = GetCustomDifficulty(st, diff);
						self:settext(stepsP1:GetMeter()):diffuse(color("#000000")):diffusealpha(0.8);
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
	};
	-- P2
		t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X+110):y(SCREEN_BOTTOM-55) end;
		LoadActor("_diffdia") .. {
		OnCommand=function(self) self:playcommand("Set") end;
		CurrentstepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if stepsP2 ~= nil then
					local st = stepsP2:GetStepsType();
					local diff = stepsP2:GetDifficulty();
					local cd = GetCustomDifficulty(st, diff);
					self:diffuse(CustomDifficultyToColor(cd));
				end
			end
		end;
		};
		LoadFont("StepsDisplay description") .. {
			  InitCommand=function(self) self:zoom(0.75):horizalign(center) end;
			  OnCommand=function(self) self:playcommand("Set") end;
			  CurrentstepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:playcommand("Set") end;
			  SetCommand=function(self)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					if stepsP2 ~= nil then
						local st = stepsP2:GetStepsType();
						local diff = stepsP2:GetDifficulty();
						local cd = GetCustomDifficulty(st, diff);
						self:settext(stepsP2:GetMeter()):diffuse(color("#000000")):diffusealpha(0.8);					
						else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};
	};
	end;

	t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X+103):y(SCREEN_BOTTOM-25) end;
		OnCommand=function(self) self:draworder(DrawOrder.Screen):addy(100):sleep(0.5):decelerate(0.7):addy(-100) end;
		OffCommand=function(self) self:sleep(1):decelerate(0.9):addy(100) end;
		Def.Quad {
			InitCommand=function(self) self:zoomto(264,12) end;
			OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.3):fadeleft(0.05):faderight(0.05) end;
		};
		Def.Quad {
			InitCommand=function(self) self:zoomto(2,8) end;
			OnCommand=function(self) self:x(songMeterScale(0.25)):diffuse(PlayerColor(pn)):diffusealpha(0.5) end;
		};
		Def.Quad {
			InitCommand=function(self) self:zoomto(2,8) end;
			OnCommand=function(self) self:x(songMeterScale(0.5)):diffuse(PlayerColor(pn)):diffusealpha(0.5) end;
		};
		Def.Quad {
			InitCommand=function(self) self:zoomto(2,8) end;
			OnCommand=function(self) self:x(songMeterScale(0.75)):diffuse(PlayerColor(pn)):diffusealpha(0.5) end;
		};
		Def.SongMeterDisplay {
			StreamWidth=260;
			Stream=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'stream') )..{
				InitCommand=function(self) self:diffuse(Color.White):diffusealpha(0.4):blend(Blend.Add) end;
			};
			Tip=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'tip')) .. { 
			InitCommand=function(self) self:visible(false) end; 
			};
		};
	};
return t
