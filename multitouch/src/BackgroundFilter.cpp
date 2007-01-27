
#include <BackgroundFilter.h>
#include <Image.h>
#include <highgui.h>
#define ROWSTOSCAN	40

#define UPDATERATE_UP		2
#define UPDATERATE_DOWN		1

#define DEFAULT_UPDATE_THRESH	50

BackgroundFilter::BackgroundFilter(char* s) : Filter(s)
{
	reference = NULL;
	recapture = false;
	count = -1;
	updateThreshold = DEFAULT_UPDATE_THRESH;
	currentRow = 0;
}


BackgroundFilter::~BackgroundFilter()
{
	if(destination)
		cvReleaseImage(&destination);
	if(reference)
		cvReleaseImage(&reference);
}

void BackgroundFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "capture") == 0)
	{
		printf("Recap\n");
		recapture = true;	
	} else if(strcmp(name, "threshold") == 0)
	{
		updateThreshold = (int) atof(value);
		cvSetTrackbarPos("threshold", this->name->c_str(), updateThreshold);
	}
}


void BackgroundFilter::showOutput(bool value)
{
	Filter::showOutput(value);

	if(value)
	{
		cvCreateTrackbar( "threshold", name->c_str(), &updateThreshold, 255, NULL);
	}
}

void BackgroundFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("threshold")] = toString(updateThreshold);
}




void BackgroundFilter::kernel()
{
	// derived class responsible for allocating storage for filtered image
	if( !destination )
	{
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, 1);
        destination->origin = source->origin;  // same vertical flip as source
	}

	if(count > -1)
		count--;
	
	if( !reference || recapture || count == 0)
	{
		if(reference)
			cvCopy(source, reference);
		else
			reference = cvCloneImage(source);

		recapture = false;
	}

	touchlib::BwImage imgSrc(source), imgRef(reference);

	int x, y;
	int h, w;
	h = source->height;
	w = source->width;

	int stoprow = currentRow + ROWSTOSCAN;

	if(stoprow > h)
		stoprow = h;

	// only do N number of rows per frame to speed up processing.. 
	for(y=currentRow; y<stoprow; y++)
	{
		for(x=0; x<w; x++)
		{
			int pix, ref;
			pix = imgSrc[y][x];
			ref = imgRef[y][x];
			if(pix - ref < updateThreshold)		// bright spots are assummed to be active fingers, not background..
			{
				if(pix > ref) 
				{
					ref += UPDATERATE_UP;
					if(ref > pix)
						ref = pix;

					imgRef[y][x] = ref;		// update background
				}

				// In most cases we won't really need to go 'down'..
				// as the screen gets dirtier, it gets brighter.. 
				// 
				//if(pix < ref)
					//ref -= UPDATERATE_DOWN;
				
			}

		}
	}
	currentRow += ROWSTOSCAN;

	if(currentRow >= h)
		currentRow = 0;

	// destination = source-reference
	cvSub(source, reference, destination);

/*

	*/

}
