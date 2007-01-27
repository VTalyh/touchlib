#ifndef __TOUCHLIB_TOUCHDATA__
#define __TOUCHLIB_TOUCHDATA__

struct TouchData
{
	int ID;
	float X;
	float Y;
	float Area;
	float dX;
	float dY;
	float dArea;
};

#endif