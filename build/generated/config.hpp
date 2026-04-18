#ifndef CONFIG_HPP_
#define CONFIG_HPP_

/* Auto-generated config.h file powered by cmake. */

/* Defined to 1 if <alloca.h> is found. */
/* #undef HAVE_ALLOCA_H */

/* Defined to 1 if <dirent.h> is found. */
/* #undef HAVE_DIRENT_H */

/* Defined to 1 if <inttypes.h> is found. */
#define HAVE_INTTYPES_H 1

/* Defined to 1 if <stdint.h> is found. */
#define HAVE_STDINT_H 1

/* Defined to 1 if <sys/param.h> is found. */
/* #undef HAVE_SYS_PARAM_H */

/* Defined to 1 if <sys/utsname.h> is found. */
/* #undef HAVE_SYS_UTSNAME_H */

/* Defined to 1 if <fcntl.h> is found. */
#define HAVE_FCNTL_H 1

/* Defined to 1 if <unistd.h> is found. */
/* #undef HAVE_UNISTD_H */

/* Defined to 1 if the underlying system provides the _mkdir function. */
#define HAVE__MKDIR 1

/* Defined to 1 if the underlying system provides the mkdir function. */
#define HAVE_MKDIR 1

/* Defined to 1 if the underlying system provides the _snprintf function. */
#define HAVE__SNPRINTF 1

/* Defined to 1 if the underlying system provides the snprintf function. */
#define HAVE_SNPRINTF 1

/* Defined to 1 if the underlying system provides the stricmp function. */
#define HAVE_STRICMP 1

/* Defined to 1 if the underlying system provides the _stricmp function. */
#define HAVE__STRICMP 1

/* Defined to 1 if the underlying system provides the strcasecmp function. */
/* #undef HAVE_STRCASECMP */

/* Defined to 1 if <unistd.h> is found. */
/* #undef HAVE_UNISTD_H */

/* Defined to 1 if the underlying system provides the pthread_mutex_timedlock function. */
/* #undef HAVE_PTHREAD_MUTEX_TIMEDLOCK */

/* Defined to 1 if the underlying system provides the pthread_cond_timedwait function. */
/* #undef HAVE_PTHREAD_COND_TIMEDWAIT */


/* Defined to 1 if building on a windows system, and thus uses the windows loading window. */
/* #undef NEED_WINDOWS_LOADING_WINDOW */

/* Defined to 1 if logging timing segment additions and removals. */
/* #undef WITH_LOGGING_TIMING_DATA */

/* Defined to 1 if the PBS_MARQUEE symbol was found. */
/* #undef HAVE_PBS_MARQUEE */

/* Defined to 1 if the PBM_SETMARQUEE symbol was found. */
/* #undef HAVE_PBM_SETMARQUEE */

#if defined(NEED_WINDOWS_LOADING_WINDOW)
#if !defined(HAVE_PBS_MARQUEE)
#define PBS_MARQUEE 0x08
#endif
#if !defined(HAVE_PBM_SETMARQUEE)
#define PBM_SETMARQUEE (WM_USER+10)
#endif
#endif

#if defined(__GNUC__)
/** @brief Define a macro to tell the compiler that a function has printf()
 * semantics, to aid warning output. */
#define PRINTF(a,b) __attribute__((format(__printf__,a,b)))
#define CONST_FUNCTION __attribute__((const))
#else
/** @brief A dummy define to keep things going smoothly. */
#define PRINTF(a,b)
/** @brief A dummy define to keep things going smoothly. */
#define CONST_FUNCTION
#endif

/* Ensure we have a function that acts like a size limited sprintf. */
#if defined(HAVE_SNPRINTF)
#elif defined(HAVE__SNPRINTF)
#define snprintf _snprintf
#else
#error "No size limited sprintf function available. Aborting."
#endif

/* Ensure we have a function that acts like a case insensitive string comparison. */
#if defined(HAVE_STRCASECMP)
#elif defined(HAVE__STRICMP)
#define strcasecmp _stricmp
#elif defined(HAVE_STRICMP)
#define strcasecmp stricmp
#else
#error "No case insensitive string comparison function available. Aborting."
#endif

/* Ensure we have a function that can create a directory on the file system. */
#if defined(HAVE__MKDIR)
#include <direct.h>
#define mkdir(path, mode) _mkdir(path)
#else
#if !defined(HAVE_MKDIR)
#error "No create directory function available. Aborting."
#else
#include <sys/types.h>
#include <sys/stat.h>
#if defined(__MINGW32__) || defined(__MINGW64__)
#define mkdir(path, mode) mkdir(path)
#endif
#endif
#endif


#endif
