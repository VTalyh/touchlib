#include <SimpleHighpassFilter.h>
#include <highgui.h>


// ----  initialization of non-integral constants  ----------------------------


const char *SimpleHighpassFilter::TRACKBAR_LABEL_BLUR = "blur";
const char *SimpleHighpassFilter::TRACKBAR_LABEL_NOISE = "noise";


// ----  implementations  -----------------------------------------------------


SimpleHighpassFilter::SimpleHighpassFilter(char *s) : Filter(s)
{
	blurLevel = DEFAULT_BLUR_LEVEL;
	blurLevelSlider = blurLevel;

	noiseLevel = DEFAULT_NOISE_LEVEL;
	noiseLevelSlider = noiseLevel;

	buffer = NULL;
}


SimpleHighpassFilter::~SimpleHighpassFilter()
{
	if (buffer != NULL)
		cvReleaseImage(&buffer);
}

void SimpleHighpassFilter::getParameters(ParameterMap &pMap)
{
	pMap[std::string("blur")] = toString(blurLevel);
	pMap[std::string("noise")] = toString(noiseLevel);
}

void SimpleHighpassFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "blur") == 0) {
		blurLevel = (int) atof(value);
		if (show)
			cvSetTrackbarPos(TRACKBAR_LABEL_BLUR, this->name->c_str(), blurLevel);
	}

	if(strcmp(name, "noise") == 0) {
		noiseLevel = (int) atof(value);
		if (show)
			cvSetTrackbarPos(TRACKBAR_LABEL_NOISE, this->name->c_str(), noiseLevel);
	}
}

void SimpleHighpassFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if (value) {
		cvCreateTrackbar(TRACKBAR_LABEL_BLUR, name->c_str(), &blurLevelSlider, 20, NULL);
		cvCreateTrackbar(TRACKBAR_LABEL_NOISE, name->c_str(), &noiseLevelSlider, 20, NULL);
	}
}

void SimpleHighpassFilter::kernel()
{
	if (show) {
		blurLevel = blurLevelSlider;
		noiseLevel = noiseLevelSlider;
	}
	
	if (destination == NULL) {
		destination = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
		destination->origin = source->origin;  // same vertical flip as source
	}
	if (buffer == NULL) {
		buffer = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
		buffer->origin = source->origin;
	}

	// create the unsharp mask using a linear average filter
	int blurParameter = blurLevel*2+1;
	cvSmooth(source, buffer, CV_BLUR, blurParameter, blurParameter);
	cvSub(source, buffer, buffer);

	// filter out the noise using a median filter
	int noiseParameter = noiseLevel*2+1;
	cvSmooth(buffer, destination, CV_MEDIAN, noiseParameter, noiseParameter);
}

