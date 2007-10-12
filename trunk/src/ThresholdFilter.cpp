#include <ThresholdFilter.h>
#include <highgui.h>
#include <Image.h>

// ----  initialization of non-integral constants  ----------------------------

const float ThresholdFilter::DEFAULT_THRESHOLD = 0.10f;
const char *ThresholdFilter::TRACKBAR_LABEL_MODE = "mode";
const char *ThresholdFilter::TRACKBAR_LABEL_THRESHOLD = "level";

const char *ThresholdFilter::PARAMETER_MODE = "mode";
const char *ThresholdFilter::PARAMETER_THRESHOLD = "level";


// ----  implementations  -----------------------------------------------------



ThresholdFilter::ThresholdFilter(char *s) : Filter(s)
{
	overallMax = 0.0f;
	threshold = DEFAULT_THRESHOLD;
	thresholdSlider = (int) (threshold * 255.0f);

	reinitDynamicStatisticsFrames = DEFAULT_REINIT_DYNAMIC_STATISTICS_FRAMES;
	setMode(DEFAULT_MODE);
}


ThresholdFilter::~ThresholdFilter()
{
}

void ThresholdFilter::getParameters(ParameterMap &pMap)
{
	pMap[std::string(PARAMETER_MODE)] = toString(mode);

	if (!isDynamic) {
		pMap[std::string(PARAMETER_THRESHOLD)] = toString(threshold);
	}
}

void ThresholdFilter::setParameter(const char *name, const char *value)
{
	if (strcmp(name, PARAMETER_MODE) == 0) {
		setMode(atoi(value));

		if (show) {
			cvSetTrackbarPos(TRACKBAR_LABEL_MODE, this->name->c_str(), mode);
		}
	} else if (strcmp(name, PARAMETER_THRESHOLD) == 0) {
		setMode(MODE_MANUAL);
		threshold = atof(value);
		if (threshold > 1.0f) {
			threshold = 1.0f;
		}

		if (show) {
			cvSetTrackbarPos(TRACKBAR_LABEL_MODE, this->name->c_str(), mode);
			cvSetTrackbarPos(TRACKBAR_LABEL_THRESHOLD, this->name->c_str(), (int) (threshold * 255.0f));
		}
	}
}

void ThresholdFilter::setMode(int mode) {
	this->mode = mode;

	switch (mode) {
		case MODE_DYNAMIC:
			isDynamic = true;
			reinitDynamicStatisticsFrames = 0;
			break;
		case MODE_MANUAL:
			isDynamic = false;
			break;
	}
}

void ThresholdFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if (show) {
		cvCreateTrackbar(TRACKBAR_LABEL_MODE, name->c_str(), &modeSlider, 1, NULL);
		cvCreateTrackbar(TRACKBAR_LABEL_THRESHOLD, name->c_str(), &thresholdSlider, 255, NULL);
	}
}

void ThresholdFilter::kernel()
{
	if (show) {
		if (!isDynamic) {
			threshold = thresholdSlider / 255.0f;
		}
		setMode(modeSlider);
	}

	if (destination == NULL) {
		destination = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
		destination->origin = source->origin;  // same vertical flip as source
	}

	touchlib::BwImage src(source), dest(destination);

	float localMax = 0.0f;
	float localAverage = 0.0f;

	for (int y = 0; y < source->height; y++) {
		for (int x = 0; x < source->width; x++) {

			// did we reach a new local max?
			float srcFloat = src[y][x] / 255.0f;
			if (srcFloat > localMax)
				localMax = srcFloat;
			localAverage += srcFloat;

			// drop pixels below threshold
			if (srcFloat < threshold)
				dest[y][x] = 0;
			else
				dest[y][x] = src[y][x];
		}
	}

	if (isDynamic) {
		localAverage /= source->width * source->height;

		if (reinitDynamicStatisticsFrames > 0) {
			reinitDynamicStatisticsFrames--;
			if (reinitDynamicStatisticsFrames == 0) {
				// reset
				threshold = localMax * 1.8f;
				overallMax = 2 * threshold - localAverage;
			} else {
				threshold = 1.0f;
			}
		} else {
			if (localMax > overallMax) {
				overallMax = localMax;
			} else if (localMax > threshold) {
				overallMax = overallMax * 0.995f + localMax * 0.005f;
			}
	
			threshold = (localAverage + overallMax) * 0.5f;
		}

		if (show) {
			int level = (int) (threshold * 255.0f);
			if (level > 255) {
				level = 255;
			}

			cvSetTrackbarPos(TRACKBAR_LABEL_THRESHOLD, this->name->c_str(), level);
		}
	}
}
