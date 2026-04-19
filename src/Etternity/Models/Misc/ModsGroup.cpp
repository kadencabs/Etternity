#include "Etternity/Globals/global.h"
#include "EnumHelper.h"
#include "Etternity/Singletons/LuaManager.h"
#include "ModsGroup.h"

static const char* ModsLevelNames[] = {
	"Preferred",
	"Stage",
	"Song",
	"Current",
};
XToString(ModsLevel);
LuaXType(ModsLevel);
