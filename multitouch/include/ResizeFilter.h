
#ifndef __TOUCHLIB_FILTER_RESIZE__
#define __TOUCHLIB_FILTER_RESIZE__

#include <TouchlibFilter.h>

#define DEFAULT_RESIZEWIDTH 480
#define DEFAULT_RESIZEHEIGHT 640


class TOUCHLIB_FILTER_EXPORT ResizeFilter : public Filter
{

public:

    ResizeFilter(char* name);
    void kernel();
    ~ResizeFilter();

private:
	IplImage* reference;
	bool ownsImage;

};

#endif // __TOUCHLIB_FILTER_RESIZE__
