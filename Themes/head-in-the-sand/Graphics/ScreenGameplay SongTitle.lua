return LoadFont("ScreenGameplay","SongTitle") .. {
	CurrentSongChangedMessageCommand=function(self)
		self:playcommand("Refresh")
	end;
	RefreshCommand=function(self)
		local vSong = GAMESTATE:GetCurrentSong();
		local sText = ""
		if vSong then
			sText = vSong:GetDisplayArtist() .. " - " .. vSong:GetDisplayFullTitle()
		end
		self:settext( sText );
		self:playcommand( "On" );
	end;
};