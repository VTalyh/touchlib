

#ifndef __TOUCHSCREEN_FILTER_HIGHPASS__
#define __TOUCHSCREEN_FILTER_HIGHPASS__

#include <TouchlibFilter.h>

class TOUCHLIB_FILTER_EXPORT HighpassFilter : public Filter
{

public:

    HighpassFilter(char*);
    ~HighpassFilter();
    void kernel();

private:
	IplImage* blurred;
	IplImage* outra;
	IplImage* outra2;
	CvMat* filtermat1;
	CvMat* filtermat2;

};

#endif // __TOUCHSCREEN_FILTER_HIGHPASS__
