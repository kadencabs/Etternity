# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "C:/Users/kaden/Documents/GitHub/Etternity/extern/crashpad/crashpad")
  file(MAKE_DIRECTORY "C:/Users/kaden/Documents/GitHub/Etternity/extern/crashpad/crashpad")
endif()
file(MAKE_DIRECTORY
  "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad"
  "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad"
  "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/tmp"
  "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/src/crashpad_init-stamp"
  "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/src"
  "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/src/crashpad_init-stamp"
)

set(configSubDirs Release;RelWithDebInfo;Debug)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/src/crashpad_init-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Users/kaden/Documents/GitHub/Etternity/build/gn_crashpad/src/crashpad_init-stamp${cfgdir}") # cfgdir has leading slash
endif()
