// Filter description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Name: Barrel Distortion Correction Filter
// Purpose: Allows the user to crop the source image
// Original author: Laurence Muller (aka Falcon4ever)

#ifndef __TOUCHSCREEN_FILTER_BARRELDISTORTIONCORRECTION__
#define __TOUCHSCREEN_FILTER_BARRELDISTORTIONCORRECTION__

#include <TouchlibFilter.h>

class TOUCHLIB_FILTER_EXPORT BarrelDistortionCorrectionFilter : public Filter
{
	public:
		BarrelDistortionCorrectionFilter(char*);
		virtual ~BarrelDistortionCorrectionFilter();
		void kernel();

	private:
		CvFileStorage *fs;
		CvFileNode *node;		
		CvMat *camera, *dist_coeffs;
};

#endif // __TOUCHSCREEN_FILTER_BARRELDISTORTIONCORRECTION__
