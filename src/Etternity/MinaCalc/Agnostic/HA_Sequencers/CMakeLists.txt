list(APPEND HA_SEQUENCERS
    "FlamSequencing.h"
    "ThingSequencing.h"
    "TrillSequencing.h")

target_sources(Etternity PUBLIC ${HA_SEQUENCERS})