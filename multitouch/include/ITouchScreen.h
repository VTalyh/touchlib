#ifndef __TOUCHLIB_ITOUCHSCREEN__
#define __TOUCHLIB_ITOUCHSCREEN__

#include "ITouchListener.h"
#include "ITouchEvent.h"

#include "Image.h"
#include "vector2d.h"
#include "mesh2d.h"

namespace touchlib
{
	#define GRID_X	4
	#define GRID_Y	3
	#define GRID_POINTS	((GRID_X+1) * (GRID_Y+1))
	#define GRID_INDICES (GRID_X * GRID_Y * 3 * 2)

	class TOUCHLIB_EXPORT ITouchScreen
	{
	public:
		//! A client queries the host for a specific finger ID
		virtual bool getFingerInfo(int ID, TouchData *data) = 0;

		//! A client registers itself as a listener for touch events
		virtual void registerListener(ITouchListener *listener) = 0;

		//! capture the frame and do the detection
		virtual bool process() = 0;

		//! Gets the raw camera output
		virtual void getRawImage(char **img, int &width, int &height) = 0;

		//! add a new filter on the end of the chain
		virtual void pushFilter(const char *type, const char *label) = 0;

		//! load the filter graph from file
		virtual bool loadConfig(const char* filename) = 0;

		//! save the filter graph to file
		virtual void saveConfig(const char* filename) = 0;

		//! set a filter parameter
		virtual void setParameter(char *label, char *param, char *value) = 0;

		//! start the processing and video capturing
		virtual void beginProcessing() = 0;

		//! toggles displaying of debug info.
		virtual void setDebugMode(bool m) = 0;

		//! get events
		virtual void getEvents() = 0;

		//! starts calibration
		virtual void beginCalibration() = 0;

		//! goes to the next step
		virtual void nextCalibrationStep() = 0;

		//!
		virtual float getScreenScale() = 0;
		virtual rect2df getScreenBBox() = 0;

		//! access calibration data.. this may get refactored.
		virtual void setScreenScale(float s) = 0;
		virtual void setScreenBBox(rect2df & bbox) = 0;

		virtual vector2df *getScreenPoints() = 0;
		virtual vector2df *getCameraPoints() = 0;

		// start the processing and video capturing
		virtual void beginTracking() = 0;


	};

}

#endif  // __TOUCHLIB_ITOUCHSCREEN__
