//
#include <ResizeFilter.h>


ResizeFilter::ResizeFilter(char* s) : Filter(s)
{
	ownsImage = false;
}


ResizeFilter::~ResizeFilter()
{
	if(ownsImage)
		cvReleaseImage(&destination);
}


void ResizeFilter::kernel()
{
    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvSize(DEFAULT_RESIZEWIDTH,DEFAULT_RESIZEHEIGHT), source->depth, 1);
        destination->origin = source->origin;  // same vertical flip as source

		ownsImage = true;
	} 

	cvResize(source, destination, CV_INTER_LINEAR);

}
