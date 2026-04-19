#ifndef SCREEN_SONG_OPTIONS_H
#define SCREEN_SONG_OPTIONS_H

#include "Etternity/Screen/Options/ScreenOptionsMaster.h"

class ScreenSongOptions : public ScreenOptionsMaster
{
  public:
	void Init() override;

  private:
	void ExportOptions(int iRow, const PlayerNumber& vpns) override;
};

#endif
