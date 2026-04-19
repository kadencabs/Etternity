## CPack Setup
set(CPACK_PACKAGE_NAME "Etternity")
set(CPACK_PACKAGE_VENDOR "Etternity Team")
set(CMAKE_PACKAGE_DESCRIPTION "Advanced cross-platform rhythm game focused on keyboard play")
set(CPACK_RESOURCE_FILE_LICENSE ${PROJECT_SOURCE_DIR}/CMake/CPack/license_install.txt)
set(CPACK_COMPONENT_ETTERNA_REQUIRED TRUE)  # Require Etternity component to be installed

# Custom Variables
set(INSTALL_DIR "Etternity" CACHE STRING "Output directory for built game")
set(ASSET_DIR "${INSTALL_DIR}" CACHE STRING "Output directory for game assets")

if(UNIX)
    set(CPACK_GENERATOR TGZ)
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "")
    set(CPACK_PACKAGE_CONTACT https://github.com/etternagame/etternity)

    install(TARGETS Etternity COMPONENT Etternity DESTINATION ${INSTALL_DIR})
    if(WITH_CRASHPAD AND TARGET crashpad)
        install(FILES ${PROJECT_BINARY_DIR}/gn_crashpad/crashpad_handler
                COMPONENT Etternity
                DESTINATION ${INSTALL_DIR}
                PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                            GROUP_READ GROUP_EXECUTE
                            WORLD_READ WORLD_EXECUTE)
    endif()
endif()

# Windows Specific CPack
if(WIN32)
    set(CPACK_GENERATOR "NSIS")
    set(CPACK_NSIS_INSTALL_ROOT "C:\\\\Games") # Default install directory
    set(CPACK_NSIS_EXECUTABLES_DIRECTORY Program)
    set(CPACK_NSIS_MUI_FINISHPAGE_RUN Etternity.exe)
    set(CPACK_NSIS_MUI_ICON ${PROJECT_SOURCE_DIR}/CMake/CPack/Windows/Install.ico)
    set(CPACK_NSIS_MUI_UNIICON ${PROJECT_SOURCE_DIR}/CMake/CPack/Windows/Install.ico)
    set(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP ${PROJECT_SOURCE_DIR}/CMake/CPack/Windows/welcome-ett.bmp)
	set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
	set(CPACK_NSIS_MODIFY_PATH OFF)
    set(CPACK_PACKAGE_INSTALL_DIRECTORY Etternity)
    set(CPACK_PACKAGE_EXECUTABLES Etternity;Etternity)
	set(CPACK_CREATE_DESKTOP_LINKS Etternity.exe)
    set(CPACK_PACKAGE_ICON ${PROJECT_SOURCE_DIR}\\\\CMake\\\\CPack\\\\Windows\\\\header-ett.bmp)
    set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "CreateShortCut \\\"$INSTDIR\\\\Etternity.lnk\\\" \\\"$INSTDIR\\\\Program\\\\Etternity.exe\\\"")
    set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "Delete \\\"$INSTDIR\\\\Etternity.lnk\\\"")

    ## Switch the strings below to use backslashes. NSIS requires it for those variables in particular. Copied from original script.
    string(REGEX REPLACE "/" "\\\\\\\\" CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP "${CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP}")

    ## force install everything in the same directory :)
    set(INSTALL_DIR ".")
    set(ASSET_DIR ".")

    # List every DLL etternity needs.
    list(APPEND WIN_DLLS "${PROJECT_SOURCE_DIR}/Program/avcodec-55.dll" "${PROJECT_SOURCE_DIR}/Program/avformat-55.dll"
                         "${PROJECT_SOURCE_DIR}/Program/avutil-52.dll" "${PROJECT_SOURCE_DIR}/Program/swscale-2.dll")
    if(WITH_CRASHPAD AND TARGET crashpad)
        list(APPEND WIN_DLLS ${PROJECT_BINARY_DIR}/gn_crashpad/crashpad_handler.exe)
    endif()
    install(FILES ${WIN_DLLS}   COMPONENT Etternity DESTINATION Program)
    install(TARGETS Etternity     COMPONENT Etternity DESTINATION Program)
    install(FILES CMake/CPack/license_install.txt COMPONENT Etternity DESTINATION Docs)

# macOS Specific CPack
elseif(APPLE)
    # CPack Packaging
    set(CPACK_GENERATOR DragNDrop)
    set(CPACK_DMG_VOLUME_NAME Etternity)

    # Workaround XProtect race condition for "hdiutil create" for MacOS 13
    set(CPACK_COMMAND_HDIUTIL "${CMAKE_CURRENT_LIST_DIR}/hdiutil_repeat.sh")

    if(DEFINED ENV{ETT_MAC_SYS_NAME})
        set(CPACK_SYSTEM_NAME "$ENV{ETT_MAC_SYS_NAME}")
    endif()

    install(TARGETS Etternity COMPONENT Etternity DESTINATION Etternity)
    if(WITH_CRASHPAD AND TARGET crashpad)
        install(FILES ${PROJECT_BINARY_DIR}/gn_crashpad/crashpad_handler
                COMPONENT Etternity DESTINATION ${INSTALL_DIR}
                PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                            GROUP_READ GROUP_EXECUTE
                            WORLD_READ WORLD_EXECUTE)
    endif()
endif()

# Universal Install Directories
## Files Only
install(FILES Songs/instructions.txt        COMPONENT Etternity DESTINATION "${ASSET_DIR}/Songs")
install(FILES Announcers/instructions.txt   COMPONENT Etternity DESTINATION "${ASSET_DIR}/Announcers")

## Essential Game Files
install(DIRECTORY Assets                    COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY BackgroundEffects         COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY BackgroundTransitions     COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY BGAnimations              COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY Data                      COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY NoteSkins                 COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY Scripts                   COMPONENT Etternity DESTINATION "${ASSET_DIR}")
install(DIRECTORY Themes                    COMPONENT Etternity DESTINATION "${ASSET_DIR}")
