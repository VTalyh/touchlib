ADD_LIBRARY(touchlib BackgroundFilter.cpp BrightnessContrastFilter.cpp CBlobTracker.cpp CTouchScreen.cpp CvCaptureFilter.cpp filter.cpp FilterFactory.cpp MonoFilter.cpp RectifyFilter.cpp ResizeFilter.cpp SmoothingFilter.cpp  TouchScreenDevice.cpp  )
ADD_EXECUTABLE(sampleapp sampleapp.cpp)
TARGET_LINK_LIBRARIES(sampleapp touchlib tinyxml)
SET_TARGET_PROPERTIES(sampleapp 
			PROPERTIES LINK_FLAGS ${OPENCV_LINKDIR} LINK_FLAGS ${OPENCV_LDFLAGS})
