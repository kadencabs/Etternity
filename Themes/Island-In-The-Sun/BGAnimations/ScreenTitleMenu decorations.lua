InitUserPrefs();

local t = Def.ActorFrame {}

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		if not FILEMAN:DoesFileExist("Save/ThemePrefs.ini") then
			Trace("ThemePrefs doesn't exist; creating file")
			ThemePrefs.ForceSave()
		end

		ThemePrefs.Save()
	end;
};

t[#t+1] = StandardDecorationFromFileOptional("Logo","Logo");
t[#t+1] = StandardDecorationFromFileOptional("VersionInfo","VersionInfo");
t[#t+1] = StandardDecorationFromFileOptional("CurrentGametype","CurrentGametype");
t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("NetworkStatus","NetworkStatus");
t[#t+1] = StandardDecorationFromFileOptional("SystemDirection","SystemDirection");

t[#t+1] = StandardDecorationFromFileOptional("NumSongs","NumSongs") .. {
	SetCommand=function(self)
		local InstalledSongs, AdditionalSongs, InstalledCourses, AdditionalCourses, Groups, Unlocked = 0;
		if SONGMAN:GetNumSongs() > 0 then
			InstalledSongs, AdditionalSongs, InstalledCourses, AdditionalCourses, Groups, Unlocked =
				SONGMAN:GetNumSongs(),
				SONGMAN:GetNumAdditionalSongs(),
				SONGMAN:GetNumCourses(),
				SONGMAN:GetNumAdditionalCourses(),
				SONGMAN:GetNumSongGroups(),
				SONGMAN:GetNumUnlockedSongs();
		else
			return
		end

		self:settextf(THEME:GetString("ScreenTitleMenu","%i Songs (%i Groups)"), InstalledSongs, Groups);
	end;
};

return t
