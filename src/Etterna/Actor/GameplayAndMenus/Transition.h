/* Transition - Transition that draws an actor. */

#ifndef TRANSITION_H
#define TRANSITION_H

#include "Etternity/Actor/Base/ActorFrame.h"
#include "Etternity/Actor/Base/AutoActor.h"
#include "Etternity/Screen/Others/ScreenMessage.h"

class Transition : public ActorFrame
{
  public:
	Transition();

	void Load(const std::string& sBGAniDir);

	void UpdateInternal(float fDeltaTime) override;

	virtual void StartTransitioning(ScreenMessage send_when_done = SM_None);
	bool EarlyAbortDraw() const override;
	float GetTweenTimeLeft() const override;
	void Reset(); // explicitly allow transitioning again

	bool IsWaiting() const { return m_State == waiting; };
	bool IsTransitioning() const { return m_State == transitioning; };
	bool IsFinished() const { return m_State == finished; };

  protected:
	enum State
	{
		waiting,
		transitioning,
		finished
	} m_State;

	AutoActor m_sprTransition;

	ScreenMessage m_MessageToSendWhenDone;
};

#endif
