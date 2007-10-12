#include "FilterFactory.h"

#include "CvCaptureFilter.h"
#ifdef WIN32
	#include "VideoWrapperFilter.h"
	#include "DSVLCaptureFilter.h"
	#include "CMUCapturefilter.h"
#endif

#include "BrightnessContrastFilter.h"
#include "MonoFilter.h"
#include "RectifyFilter.h"
#include "SmoothingFilter.h"
#include "BackgroundFilter.h"
#include "ResizeFilter.h"
#include "HighpassFilter.h"
#include "InvertFilter.h"
#include "ScalerFilter.h"
#include "SimpleHighpassFilter.h"
#include "ThresholdFilter.h"

FilterFactory::FilterFactory()
{
}

Filter *FilterFactory::createFilter(const char *type, const char *label)
{
	// FIXME: we could create a default label if none is supplied. 

	Filter* newFilter;
	if(strcmp(type, "cvcapture") == 0)
	{
		newFilter = (Filter *)new CvCaptureFilter((char*)label);
#ifdef WIN32
	} else if(strcmp(type, "vwcapture") == 0) {
		newFilter = (Filter *)new VideoWrapperFilter((char*)label);
	} else if(strcmp(type, "dsvlcapture") == 0) {
		newFilter = (Filter *)new DSVLCaptureFilter((char*)label);
	} else if(strcmp(type, "cmucapture") == 0) {
		newFilter = (Filter *)new CMUCaptureFilter((char*)label);
#endif
	} else if(strcmp(type, "mono") == 0) {
		newFilter = (Filter *)new MonoFilter((char*)label);
	} else if(strcmp(type, "rectify") == 0) {
		newFilter = (Filter *)new RectifyFilter((char*)label);
	} else if(strcmp(type, "highpass") == 0) {
		newFilter = (Filter *)new HighpassFilter((char*)label);
	} else if(strcmp(type, "invert") == 0) {
		newFilter = (Filter *)new InvertFilter((char*)label);
	} else if(strcmp(type, "scaler") == 0) {
		newFilter = (Filter *)new ScalerFilter((char*)label);
	} else if (strcmp(type, "simplehighpass") == 0) {
		newFilter = (Filter *) new SimpleHighpassFilter((char *) label);
	} else if(strcmp(type, "smooth") == 0) {
		newFilter = (Filter *)new SmoothingFilter((char*)label);
	} else if(strcmp(type, "brightnesscontrast") == 0) {
		newFilter = (Filter *)new BrightnessContrastFilter((char*)label);
	} else if(strcmp(type, "backgroundremove") == 0) {
		newFilter = (Filter *)new BackgroundFilter((char*)label);
	} else if(strcmp(type, "resize") == 0) {
		newFilter = (Filter *)new ResizeFilter((char*)label);
	} else if (strcmp(type, "threshold") == 0) {
		newFilter = (Filter *) new ThresholdFilter((char *) label);
	} else {
		return NULL;
	}

	newFilter->type = new std::string(type);
	return newFilter;
}
