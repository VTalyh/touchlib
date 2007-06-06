
#include <HighpassFilter.h>


HighpassFilter::HighpassFilter(char* s) : Filter(s)
{
	
	filtermat1 = cvCreateMat(5,5,CV_32FC1);

	cvSet2D( filtermat1, 0, 0, cvRealScalar(-0.5) );
	cvSet2D( filtermat1, 0, 1, cvRealScalar(0) );
	cvSet2D( filtermat1, 0, 2, cvRealScalar(-0.5) );
	cvSet2D( filtermat1, 0, 3, cvRealScalar(0) );
	cvSet2D( filtermat1, 0, 4, cvRealScalar(-0.5) );

	cvSet2D( filtermat1, 1, 0, cvRealScalar(-0.5) );
	cvSet2D( filtermat1, 1, 1, cvRealScalar(-1) );
	cvSet2D( filtermat1, 1, 2, cvRealScalar(-1) );
	cvSet2D( filtermat1, 1, 3, cvRealScalar(-1) );
	cvSet2D( filtermat1, 1, 4, cvRealScalar(-0.5) );

	cvSet2D( filtermat1, 2, 0, cvRealScalar(-1) );
	cvSet2D( filtermat1, 2, 1, cvRealScalar(-1) );
	cvSet2D( filtermat1, 2, 2, cvRealScalar(20) );
	cvSet2D( filtermat1, 2, 3, cvRealScalar(-1) );
	cvSet2D( filtermat1, 2, 4, cvRealScalar(-1) );

	cvSet2D( filtermat1, 3, 0, cvRealScalar(-0.5) );
	cvSet2D( filtermat1, 3, 1, cvRealScalar(-1) );
	cvSet2D( filtermat1, 3, 2, cvRealScalar(-1) );
	cvSet2D( filtermat1, 3, 3, cvRealScalar(-1) );
	cvSet2D( filtermat1, 3, 4, cvRealScalar(-0.5) );

	cvSet2D( filtermat1, 4, 0, cvRealScalar(-0.5) );
	cvSet2D( filtermat1, 4, 1, cvRealScalar(0) );
	cvSet2D( filtermat1, 4, 2, cvRealScalar(-0.5) );
	cvSet2D( filtermat1, 4, 3, cvRealScalar(0) );
	cvSet2D( filtermat1, 4, 4, cvRealScalar(-0.5) );

	

/*
	cvSet2D( filtermat1, 0, 0, cvRealScalar(1) );
	cvSet2D( filtermat1, 0, 1, cvRealScalar(1) );
	cvSet2D( filtermat1, 0, 2, cvRealScalar(1) );
	cvSet2D( filtermat1, 1, 0, cvRealScalar(1) );
	cvSet2D( filtermat1, 1, 1, cvRealScalar(1) );
	cvSet2D( filtermat1, 1, 2, cvRealScalar(1) );
	cvSet2D( filtermat1, 2, 0, cvRealScalar(1) );
	cvSet2D( filtermat1, 2, 1, cvRealScalar(1) );
	cvSet2D( filtermat1, 2, 2, cvRealScalar(1) );
	*/
}


HighpassFilter::~HighpassFilter()
{
}

void HighpassFilter::kernel()
{
	
    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
        destination->origin = source->origin;  // same vertical flip as source

        blurred = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
        blurred->origin = source->origin;  // same vertical flip as source

		outra = cvCreateImage( cvGetSize(source), IPL_DEPTH_16S, 1 );
		outra->origin = source->origin;

		outra2 = cvCreateImage( cvGetSize(source), IPL_DEPTH_16S, 1 );
		outra2->origin = source->origin;
    }
   
	cvSmooth( source, blurred, CV_GAUSSIAN, 13, 13, 0, 0 );
	cvSub(source, blurred, destination);
	cvSmooth( destination, destination, CV_GAUSSIAN, 13, 13, 0, 0 );

	// load src
	//cvFilter2D( source, destination, filtermat1, cvPoint(-1,-1) );

	//cvSobel( destination, outra, 1, 0, 1);
	//cvSobel( source, outra2, 0, 1, 1);
    //cvSmooth( gray, edge, CV_BLUR, 3, 3, 0, 0 );
	//cvCanny(source, destination, 32,32, 3);
	//cvNot(
	//cvSub(outra, outra2, outra);
	//cvConvertScale( outra, destination );

    //cvSmooth( destination, destination, CV_BLUR, 3, 3, 0, 0 );


	//cvFilter2D( destination, destination, filtermat1, cvPoint(-1,-1) );
}



