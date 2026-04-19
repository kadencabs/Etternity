# This should be modified and eventually removed with better methods for passing this info to the compiler
list(APPEND cdefs CPU_X86_64 HAVE_LIBPTHREAD
	"BACKTRACE_METHOD_X86_LINUX"
	"BACKTRACE_METHOD_TEXT=\"x86 custom backtrace\""
	"BACKTRACE_LOOKUP_METHOD_TEXT=\"backtrace_symbols\""
	"BACKTRACE_LOOKUP_METHOD_DLADDR"
	PACKAGE_NAME="Etternity"
	PACKAGE_VERSION="EtternityVersion")
set_target_properties(Etternity PROPERTIES COMPILE_DEFINITIONS "${cdefs}")

# Find Libraries
find_package(X11 REQUIRED)
find_package(DLFCN REQUIRED)
find_package(OpenGL REQUIRED)
find_package(Xrandr REQUIRED)
find_package(Xinerama)
find_package(PulseAudio)
find_package(ALSA)
find_package(JACK)
find_package(OSS)

# Linking
target_link_libraries(Etternity PRIVATE ${X11_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${DL_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${XRANDR_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${PULSEAUDIO_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${ALSA_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${JACK_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${VA_LIBRARIES})
target_link_libraries(Etternity PRIVATE ${OPENGL_LIBRARY})
