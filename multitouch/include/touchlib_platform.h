
#ifndef __TOUCHLIB_PLATFORM__
#define __TOUCHLIB_PLATFORM__

#ifdef WIN32
#    ifdef _BUILDINGDLL
#         define TOUCHLIB_EXPORT __declspec( dllexport )
#         define TOUCHLIB_CORE_EXPORT
#         define TOUCHLIB_FILTER_EXPORT
#    else
#         define TOUCHLIB_EXPORT __declspec( dllimport )
#         define TOUCHLIB_CORE_EXPORT
#         define TOUCHLIB_FILTER_EXPORT
#    endif
#else
#    define TOUCHLIB_EXPORT
#    define TOUCHLIB_CORE_EXPORT
#    define TOUCHLIB_FILTER_EXPORT
#endif

#endif // __TOUCHLIB_PLATFORM__