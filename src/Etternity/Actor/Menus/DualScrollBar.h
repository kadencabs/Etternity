#ifndef DUAL_SCROLLBAR_H
#define DUAL_SCROLLBAR_H

#include "Etternity/Actor/Base/ActorFrame.h"
#include "Etternity/Actor/Base/AutoActor.h"
#include "Etternity/Models/Misc/PlayerNumber.h"
/** @brief A scrollbar with two independent thumbs. */
class DualScrollBar : public ActorFrame
{
  public:
	DualScrollBar();

	void Load(const std::string& sType);
	void SetBarHeight(float fHeight) { m_fBarHeight = fHeight; }
	void SetBarTime(float fTime) { m_fBarTime = fTime; }
	void SetPercentage(PlayerNumber pn, float fPercent);
	void EnablePlayer(PlayerNumber pn, bool on);

  private:
	/** @brief The height of the scrollbar. */
	float m_fBarHeight;
	float m_fBarTime;

	AutoActor m_sprScrollThumbOverHalf;
	AutoActor m_sprScrollThumbUnderHalf;
};

#endif
