#include "Etternity/Globals/global.h"
#include "ScreenGameplayNormal.h"
#include "Etternity/Models/Misc/Difficulty.h"

REGISTER_SCREEN_CLASS(ScreenGameplayNormal);

void
ScreenGameplayNormal::FillPlayerInfo(PlayerInfo* vPlayerInfoOut)
{
	vPlayerInfoOut->Load(
	  PLAYER_1, MultiPlayer_Invalid, true, Difficulty_Invalid);
};

// lua end
