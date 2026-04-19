#include "Etternity/Globals/global.h"
#include "Etternity/Actor/Base/ActorUtil.h"
#include "Etternity/Singletons/GameState.h"
#include "Etternity/Models/Misc/LocalizedString.h"
#include "Etternity/Models/Misc/PlayerState.h"
#include "Etternity/Singletons/ProfileManager.h"
#include "Etternity/Singletons/ScreenManager.h"
#include "ScreenSystemLayer.h"
#include "Etternity/Singletons/ThemeManager.h"
#include "Etternity/Models/Misc/ThemeMetric.h"

namespace {
LocalizedString CREDITS_LOAD_FAILED("ScreenSystemLayer", "CreditsLoadFailed");
LocalizedString CREDITS_LOADED_FROM_LAST_GOOD_APPEND(
  "ScreenSystemLayer",
  "CreditsLoadedFromLastGoodAppend");

ThemeMetric<bool> CREDITS_JOIN_ONLY("ScreenSystemLayer", "CreditsJoinOnly");

std::string
GetCreditsMessage(PlayerNumber pn)
{
	if (static_cast<bool>(CREDITS_JOIN_ONLY) && !GAMESTATE->PlayersCanJoin())
		return std::string();

	bool bShowCreditsMessage;
	if ((SCREENMAN != nullptr) && (SCREENMAN->GetTopScreen() != nullptr) &&
		SCREENMAN->GetTopScreen()->GetScreenType() == system_menu)
		bShowCreditsMessage = true;
	else
		bShowCreditsMessage = !GAMESTATE->m_bSideIsJoined;

	if (!bShowCreditsMessage) {
		const Profile* pProfile = PROFILEMAN->GetProfile(pn);
		// this is a local machine profile
		if (PROFILEMAN->LastLoadWasFromLastGood(pn))
			return pProfile->GetDisplayNameOrHighScoreName() +
				   CREDITS_LOADED_FROM_LAST_GOOD_APPEND.GetValue();
		else if (PROFILEMAN->LastLoadWasTamperedOrCorrupt(pn))
			return CREDITS_LOAD_FAILED.GetValue();
		return pProfile->GetDisplayNameOrHighScoreName();
	}
	return std::string();
}
};

// lua start
#include "Etternity/Models/Lua/LuaBinding.h"

namespace {
int
GetCreditsMessage(lua_State* L)
{
	PlayerNumber pn = PLAYER_1;
	std::string sText = GetCreditsMessage(pn);
	LuaHelpers::Push(L, sText);
	return 1;
}

const luaL_Reg ScreenSystemLayerHelpersTable[] = { LIST_METHOD(
													 GetCreditsMessage),
												   { nullptr, nullptr } };
} // namespace

LUA_REGISTER_NAMESPACE(ScreenSystemLayerHelpers)

REGISTER_SCREEN_CLASS(ScreenSystemLayer);
void
ScreenSystemLayer::Init()
{
	Screen::Init();

	m_sprOverlay.Load(THEME->GetPathB(m_sName, "overlay"));
	this->AddChild(m_sprOverlay);
	m_errLayer.Load(THEME->GetPathB(m_sName, "error"));
	this->AddChild(m_errLayer);
}
