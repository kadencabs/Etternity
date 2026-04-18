# Install script for directory: C:/Users/kaden/Documents/GitHub/Etternity

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/Etternity")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/kaden/Documents/GitHub/Etternity/build/src/Etterna/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/kaden/Documents/GitHub/Etternity/build/src/arch/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/kaden/Documents/GitHub/Etternity/build/src/archutils/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/kaden/Documents/GitHub/Etternity/build/src/RageUtil/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/kaden/Documents/GitHub/Etternity/build/src/Core/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Program" TYPE FILE FILES
    "C:/Users/kaden/Documents/GitHub/Etternity/extern/ffmpeg/windows/64bit/avcodec-55.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/extern/ffmpeg/windows/64bit/avformat-55.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/extern/ffmpeg/windows/64bit/avutil-52.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/extern/ffmpeg/windows/64bit/swscale-2.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/Program/avcodec-55.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/Program/avformat-55.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/Program/avutil-52.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/Program/swscale-2.dll"
    "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/crashpad_handler.exe"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Program" TYPE EXECUTABLE FILES "C:/Users/kaden/Documents/GitHub/Etternity/Program/Etterna.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Program" TYPE EXECUTABLE FILES "C:/Users/kaden/Documents/GitHub/Etternity/Program/Etterna-RelWithDebInfo.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Program" TYPE EXECUTABLE FILES "C:/Users/kaden/Documents/GitHub/Etternity/Program/Etterna-debug.exe")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    include("C:/Users/kaden/Documents/GitHub/Etternity/build/CMakeFiles/Etterna.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    include("C:/Users/kaden/Documents/GitHub/Etternity/build/CMakeFiles/Etterna.dir/install-cxx-module-bmi-RelWithDebInfo.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    include("C:/Users/kaden/Documents/GitHub/Etternity/build/CMakeFiles/Etterna.dir/install-cxx-module-bmi-Debug.cmake" OPTIONAL)
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Docs" TYPE FILE FILES "C:/Users/kaden/Documents/GitHub/Etternity/CMake/CPack/license_install.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Songs" TYPE FILE FILES "C:/Users/kaden/Documents/GitHub/Etternity/Songs/instructions.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Announcers" TYPE FILE FILES "C:/Users/kaden/Documents/GitHub/Etternity/Announcers/instructions.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/Assets")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/BackgroundEffects")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/BackgroundTransitions")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/BGAnimations")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/Data")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/NoteSkins")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/Scripts")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Etterna" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE DIRECTORY FILES "C:/Users/kaden/Documents/GitHub/Etternity/Themes")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/kaden/Documents/GitHub/Etternity/build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/kaden/Documents/GitHub/Etternity/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
