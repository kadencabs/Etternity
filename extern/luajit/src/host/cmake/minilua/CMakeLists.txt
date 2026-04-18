cmake_minimum_required(VERSION 3.5)

project(minilua)

find_library(LIBM_LIBRARIES NAMES m)

# add_executable(minilua ../../minilua.c)
add_executable(minilua
    ${CMAKE_CURRENT_LIST_DIR}/../../minilua.c
)
if (LIBM_LIBRARIES)
   target_link_libraries(minilua ${LIBM_LIBRARIES})
endif()