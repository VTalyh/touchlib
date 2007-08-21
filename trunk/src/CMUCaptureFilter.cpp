
#include <CMUCaptureFilter.h>


THREAD_HANDLE CMUCaptureFilter::hThread = 0;

CMUCaptureFilter::CMUCaptureFilter(char* s) : Filter(s)
{
	flipRGB = false;
	sMode = CMU320x240yuv422;
	sRate = CMURate15fps;
	mode = 1;
	rate = 3;
	format = 0;
	capture = NULL;
	lID.QuadPart = 0;
}


CMUCaptureFilter::~CMUCaptureFilter()
{
	if(capture){
		capture->StopVideoStream();
		delete capture;
		capture = NULL;
	}
}


void CMUCaptureFilter::process(IplImage *frame)
{
	Filter::process(frame);
}

void CMUCaptureFilter::getParameters(ParameterMap& pMap)
{
	if(sMode.size())
		pMap[std::string("mode")] = sMode;
	if(sRate.size())
		pMap[std::string("rate")] = sRate;
	pMap[std::string("flipRGB")] = std::string(flipRGB?"true":"false");
	if(sVendor.size())
		pMap[std::string("vendor")] = sVendor;
	if(sName.size())
		pMap[std::string("name")] = sName;
	if(lID.QuadPart != 0)
		pMap[std::string("uniqueID")] = toString(lID.HighPart)+ " " + toString(lID.LowPart);
}

void CMUCaptureFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name,"vendor") == 0){
		sVendor = value;
	}else if(strcmp(name,"name") == 0){
		sName = value;
	}else if(strcmp(name,"uniqueID") == 0){
		sscanf(value,"%li %li",&lID.HighPart,&lID.LowPart);
	}else if(strcmp(name,"flipRGB") == 0){
		if(strcmp(value,"true") == 0)
			flipRGB = true;
		else
			flipRGB = false;
	}else if(strcmp(name,"mode") == 0){
		sMode = value;
		if(strcmp(value, CMU160x120yuv444 ) == 0){
			mode = 0;
			format = 0;
		}else if(strcmp(value, CMU320x240yuv422 ) == 0){
			mode = 1;
			format = 0;
		}else if(strcmp(value, CMU640x480yuv411 ) == 0){
			mode = 2;
			format = 0;
		}else if(strcmp(value, CMU640x480yuv422 ) == 0){
			mode = 3;
			format = 0;
		}else if(strcmp(value, CMU640x480rgb ) == 0){
			mode = 4;
			format = 0;
		}else if(strcmp(value, CMU640x480mono ) == 0){
			mode = 5;
			format = 0;
		}else if(strcmp(value, CMU640x480mono16 ) == 0){
			mode = 6;
			format = 0;
		}else if(strcmp(value, CMU800x600yuv422 ) == 0){
			mode = 0;
			format = 1;
		}else if(strcmp(value, CMU800x600rgb ) == 0){
			mode = 1;
			format = 1;
		}else if(strcmp(value, CMU800x600mono ) == 0){
			mode = 2;
			format = 1;
		}else if(strcmp(value, CMU1024x768yuv422 ) == 0){
			mode = 3;
			format = 1;
		}else if(strcmp(value, CMU1024x768rgb ) == 0){
			mode = 4;
			format = 1;
		}else if(strcmp(value, CMU1024x768mono ) == 0){
			mode = 5;
			format = 1;
		}else if(strcmp(value, CMU800x600mono16 ) == 0){
			mode = 6;
			format = 1;
		}else if(strcmp(value, CMU1024x768mono16 ) == 0){
			mode = 7;
			format = 1;
		}else if(strcmp(value, CMU1280x960yuv422 ) == 0){
			mode = 0;
			format = 2;
		}else if(strcmp(value, CMU1280x960rgb ) == 0){
			mode = 1;
			format = 2;
		}else if(strcmp(value, CMU1280x960mono ) == 0){
			mode = 2;
			format = 2;
		}else if(strcmp(value, CMU1600x1200yuv422 ) == 0){
			mode = 3;
			format = 2;
		}else if(strcmp(value, CMU1600x1200rgb ) == 0){
			mode = 4;
			format = 2;
		}else if(strcmp(value, CMU1600x1200mono ) == 0){
			mode = 5;
			format = 2;
		}else if(strcmp(value, CMU1280x960mono16 ) == 0){
			mode = 6;
			format = 2;
		}else if(strcmp(value, CMU1600x1200mono16 ) == 0){
			mode = 7;
			format = 2;
		}
	} else if(strcmp(name,"rate") == 0){
		sRate = value;
		if(strcmp(value, CMURate2fps ) == 0){
			rate = 0;
		}else if(strcmp(value, CMURate4fps ) == 0){
			rate = 1;
		}else if(strcmp(value, CMURate7fps ) == 0){
			rate = 2;
		}else if(strcmp(value, CMURate15fps ) == 0){
			rate = 3;
		}else if(strcmp(value, CMURate30fps ) == 0){
			rate = 4;
		}else if(strcmp(value, CMURate60fps ) == 0){
			rate = 5;
		}else if(strcmp(value, CMURate120fps ) == 0){
			rate = 6;
		}else if(strcmp(value, CMURate240fps ) == 0){
			rate = 7;
		}
	}
}

bool CMUCaptureFilter::isRunning()
{
	return destination != NULL;
}

int CMUCaptureFilter::Init()
{
	capture = new C1394Camera();
	capture->RefreshCameraList();
	int count = capture->GetNumberCameras();	
	if(!count){
		capture = NULL;
		return CAM_ERROR;
	}

	char *buffer = new char[255];
	int lastWorking = -1;
	bool searchCam = false;
	if(sVendor.size() || sName.size() || lID.QuadPart)
		searchCam = true;

	bool gotCam = false;
	for(int i=0;i<count;i++){				
		if(capture->SelectCamera(i) == CAM_SUCCESS){
			lastWorking = i;
			if(searchCam){
				if(lID.QuadPart){
					LARGE_INTEGER cID;
					capture->GetCameraUniqueID(&cID);					
					if(cID.QuadPart == lID.QuadPart){
						gotCam = true;
						break;
					}
				}
				if(sName.size()){
					capture->GetCameraName(buffer,255);
					buffer = _strlwr(buffer);
					if(sName == buffer){
						gotCam = true;
						break;
					}					
				}
				if(sVendor.size()){
					capture->GetCameraVendor(buffer,255);
					buffer = _strlwr(buffer);
					if(sVendor == buffer){
						gotCam = true;
						break;
					}					
				}
			}else{
				gotCam = true;
				break;
			}
		}
	}	
	delete buffer;
	if(!gotCam && lastWorking != -1){
		capture->SelectCamera(lastWorking);
	}else{
		if(!gotCam)
			goto bailout;
	}
	if(capture->InitCamera(true) != CAM_SUCCESS)
		goto bailout;
	if(capture->SetVideoMode(mode) != CAM_SUCCESS)
		goto bailout;
	if(capture->SetVideoFormat(format) != CAM_SUCCESS)
		goto bailout;
	if(capture->SetVideoFrameRate(rate) != CAM_SUCCESS)
		goto bailout;
	capture->GetVideoFrameDimensions(&w,&h);

	CvSize size;
	size.height = h;
	size.width = w;
	destination = cvCreateImage(size,IPL_DEPTH_8U, 3);
	rawImage = cvCreateImage(size,IPL_DEPTH_8U, 3);
	capture->StartImageAcquisition();

	return CAM_SUCCESS;

	bailout:
	if(capture){
		delete capture;
		capture = NULL;
	}
	return CAM_ERROR;
}

void CMUCaptureFilter::kernel()
{
	if(!capture){
		if(Init() != CAM_SUCCESS)
			return;
	}
	int dropped = 0;
	if(capture->AcquireImageEx(true,&dropped) == CAM_SUCCESS){
		if(flipRGB){			
			capture->getRGB((unsigned char*)rawImage->imageData,rawImage->imageSize);
			cvCvtColor(rawImage,destination,CV_RGB2BGR); 
		}else{
			capture->getRGB((unsigned char*)destination->imageData,destination->imageSize);					
		}
	}

}
