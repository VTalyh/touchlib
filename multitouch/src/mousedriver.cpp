#pragma once
#define WIN32_LEAN_AND_MEAN 
#define _WIN32_WINNT  0x0500

#include <windows.h>

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <map>

#include <tchar.h>


#pragma comment( lib, "user32" )

#include "TouchScreenDevice.h"
#include "TouchData.h"

using namespace touchlib;

#include <stdio.h>

#include <cvcam.h>


static bool keystate[256];
bool ok=true;
ITouchScreen *screen;



class TestApp : public ITouchListener
{
public:
	TestApp()
	{
	}

	~TestApp()
	{

	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		//fingerList[data.ID] = FingerElement(colors[0], data);
		
		printf("Press detected: %f, %f\n", data.X, data.Y);

			INPUT aInput;

		aInput.type = INPUT_MOUSE;
		aInput.mi.dwFlags = MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
		aInput.mi.dwExtraInfo = 0;
		aInput.mi.mouseData = 0;
		aInput.mi.time = 0;
		aInput.mi.dx = (data.X * 65535.0f);
		aInput.mi.dy = (data.Y * 65535.0f);

		int aResult = SendInput(1, &aInput, sizeof(INPUT) );
		
	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		//fingerList[data.ID].data = data;

			INPUT aInput;

			aInput.type = INPUT_MOUSE;
			aInput.mi.dwFlags = MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
			aInput.mi.dwExtraInfo = 0;
			aInput.mi.mouseData = 0;
			aInput.mi.time = 0;
			aInput.mi.dx = (data.X * 65536.0f);
			aInput.mi.dy = (data.Y * 65535.0f);

			int aResult = SendInput(1, &aInput, sizeof(INPUT) );
		
	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		INPUT aInput;

		aInput.type = INPUT_MOUSE;
		aInput.mi.dwFlags = MOUSEEVENTF_LEFTUP;
		aInput.mi.dwExtraInfo = 0;
		aInput.mi.mouseData = 0;
		aInput.mi.time = 0;
		int aResult = SendInput(1, &aInput, sizeof(INPUT) );

	}

private:
	//std::map<int, FingerElement> fingerList;

};



TestApp app;

int _tmain(int argc, char * argv[])
{
	screen = TouchScreenDevice::getTouchScreen();
	cvNamedWindow( "mywindow", CV_WINDOW_AUTOSIZE );

	screen->setDebugMode(false);
	if(!screen->loadConfig("config.xml"))
	{
		screen->pushFilter("dsvlcapture", "capture1");
		screen->pushFilter("mono", "mono2");
		screen->pushFilter("smooth", "smooth3");
		screen->pushFilter("backgroundremove", "background4");

		screen->pushFilter("brightnesscontrast", "bc5");
		screen->pushFilter("rectify", "rectify6");

		screen->setParameter("rectify6", "level", "25");

		screen->setParameter("capture1", "source", "cam");
		//screen->setParameter("capture1", "source", "../tests/simple-2point.avi");
		//screen->setParameter("capture1", "source", "../tests/hard-5point.avi");

		screen->setParameter("bc5", "brightness", "0.1");
		screen->setParameter("bc5", "contrast", "0.4");

		screen->saveConfig("config.xml");
	}

	screen->registerListener((ITouchListener *)&app);
	// Note: Begin processing should only be called after the screen is set up

	screen->beginProcessing();
	Sleep(2000);
	screen->beginTracking();

	do
	{
		//printf("Doing keypress\n");
		int keypressed = cvWaitKey(16) & 255;

		if(keypressed != 255 && keypressed > 0)
			printf("KP: %d\n", keypressed);
        if( keypressed == 27) break;		// ESC = quit
        if( keypressed == 98)				// b = recapture background
		{
			screen->setParameter("background4", "capture", "");
			//app.clearFingers();
		}
        if( keypressed == 114)				// r = auto rectify..
		{
			screen->setParameter("rectify6", "level", "auto");
		}

  		screen->getEvents();
		Sleep(16);

	} while( ok );
	cvDestroyWindow( "mywindow" );
	//screen->saveConfig("config.xml");
	TouchScreenDevice::destroy();
	return 0;
}