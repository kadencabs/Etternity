list(APPEND HD_SEQUENCERS
    "CJOHASequencing.h"
    "GenericSequencing.h"
    "OHJSequencing.h"
    "RMSequencing.h")

target_sources(Etternity PUBLIC ${HD_SEQUENCERS})