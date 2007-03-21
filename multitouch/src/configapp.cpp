#pragma once
#define WIN32_LEAN_AND_MEAN 
#define _WIN32_WINNT  0x0500

#include <windows.h>

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <map>

#include <tchar.h>

#include "glut.h"
#pragma comment( lib, "glut32" )
#pragma comment( lib, "user32" )

#include "TouchScreenDevice.h"
#include "TouchData.h"

using namespace touchlib;

#include <stdio.h>

#include <cvcam.h>

void glutDrawBox(float x1, float y1, float x2, float y2, float r, float g, float b);
void glutDrawPlus(float x1, float y1, float s, float r, float g, float b);

static bool keystate[256];
bool ok=true;
ITouchScreen *screen;
int configStep = 0;
int curcalib = -1;

class FingerElement
{
public:
	FingerElement()
	{
	}
	FingerElement(RgbPixel c, TouchData d)
	{
		color = c;
		data = d;

	}
	RgbPixel color;
	TouchData data;
	void draw()
	{
		float rad = sqrtf(data.Area) / 50.0;

		float X = (data.X*2.0f) - 1.0;
		float Y = ((1.0-data.Y)*2.0f) - 1.0;

		if(configStep == 1)
			glutDrawBox(X-rad, Y-rad, X+rad, Y+rad, (float)color.r/255.0f, (float)color.g/255.0f, (float)color.b/255.0f);
	}
};


class TestApp : public ITouchListener
{
public:
	TestApp()
	{
		colors[0].r = 255;
		colors[0].g = 255;
		colors[0].b = 255;

		colors[1].r = 255;
		colors[1].g = 255;
		colors[1].b = 255;

		colors[2].r = 255;
		colors[2].g = 0;
		colors[2].b = 255;

		colors[3].r = 255;
		colors[3].g = 0;
		colors[3].b = 255;

		colors[4].r = 128;
		colors[4].g = 255;
		colors[4].b = 255;

		colors[5].r = 128;
		colors[5].g = 128;
		colors[5].b = 255;

		colors[6].r = 128;
		colors[6].g = 128;
		colors[6].b = 0;

		colors[7].r = 128;
		colors[7].g = 64;
		colors[7].b = 0;

        CvSize size;
        size.width = 640;
        size.height = 640;

		// Create named window in which the captured images will be presented
		cvNamedWindow( "mywindow", CV_WINDOW_AUTOSIZE );
        window_img = cvCreateImage(size, 8, 3);
	}

	~TestApp()
	{
		cvDestroyWindow( "mywindow" );
	    cvReleaseImage( &window_img);
	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		fingerList[data.ID] = FingerElement(colors[data.ID % 8], data);
		
		printf("Press detected: %f, %f\n", data.X, data.Y);

		if(curcalib == -1)
		{
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
	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		fingerList[data.ID].data = data;

		if(curcalib == -1)
		{
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
	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		std::map<int, FingerElement>::iterator iter;

		for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
		{
			if(iter->second.data.ID == data.ID)
			{
				fingerList.erase(iter);
				return;
			}
		}

		if(curcalib == -1)
		{
			INPUT aInput;

			aInput.type = INPUT_MOUSE;
			aInput.mi.dwFlags = MOUSEEVENTF_LEFTUP;
			aInput.mi.dwExtraInfo = 0;
			aInput.mi.mouseData = 0;
			aInput.mi.time = 0;
			int aResult = SendInput(1, &aInput, sizeof(INPUT) );
		}
	}

	void draw()
	{

		float scale = screen->getScreenScale();

		if(fingerList.size() > 0)
			glutDrawBox(-(1.0f * (scale)), -(1.0f * (scale)), (1.0f * (scale)), (1.0f * (scale)), 1.0, 1.0, 1.0);
		else
			glutDrawBox(-(1.0f * (scale)), -(1.0f * (scale)), (1.0f * (scale)), (1.0f * (scale)), 0.0, 0.2, 0.0);

		vector2df *screenpts = screen->getScreenPoints();
		vector2df *campts = screen->getCameraPoints();

		int i;
		for(i=0; i<GRID_POINTS; i++)
		{

			if(curcalib == i)
				glutDrawPlus((screenpts[i].X*2.0f)-1.0f, ((1.0-screenpts[i].Y)*2.0f)-1.0f, 0.02, 1.0, 0.0, 0.0);
			else
				glutDrawPlus((screenpts[i].X*2.0f)-1.0f, ((1.0-screenpts[i].Y)*2.0f)-1.0f, 0.02, 0.0, 1.0, 0.0);
		}

/*
//Draw the 'mapping' points (camera space)...
		for(i=0; i<GRID_POINTS; i++)
		{
			if(curcalib == i)
				glutDrawPlus((campts[i].X/300.0f)-1.0f, (campts[i].Y/300.0f)-1.0f, 0.02, 0.2, 0.2, 0.2);
			else
				glutDrawPlus((campts[i].X/300.0f)-1.0f, (campts[i].Y/300.0f)-1.0f, 0.02, 0.1, 0.1, 0.1);
		}
*/

		// only draw fingers when not calibrating..
		if(curcalib == -1)
		{
			std::map<int, FingerElement>::iterator iter;

			for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
			{
				iter->second.draw();
			}
		}
	}
private:
	std::map<int, FingerElement> fingerList;
    RgbPixel colors[8];
    IplImage *window_img;
};



TestApp app;

void glutKeyboardUpCallback( unsigned char key, int x, int y )
{
    printf( "keyup=%i\n", key );
    keystate[key] = false;
}


void glutKeyboardCallback( unsigned char key, int x, int y )
{
    printf( "keydn=%i\n", key );
    keystate[key] = true;

	if(key == 99)			// c
	{
		printf("Calibrate");
		screen->beginCalibration();
		curcalib = 0;
	} else if(key == 27)			// esc
	{
		glutLeaveGameMode();
		screen->saveConfig("config.xml");
		TouchScreenDevice::destroy();
		exit(1);
	}
    else if( key == 98)				// b = recapture background
	{
		screen->setParameter("background4", "capture", "");
	} else if( key == 32)				// space = next calibration step
	{
		screen->nextCalibrationStep();
		curcalib ++;
		if(curcalib >= GRID_POINTS)
			curcalib = -1;
	}
}

void glutDrawBox(float x1, float y1, float x2, float y2, float r, float g, float b)
{
	glBegin(GL_LINE_STRIP);
	glLineWidth(2.0);
	glColor3f(r, g, b);

	glVertex2f(x1,y1);
	glColor3f(r, g, b);
	glVertex2f(x2,y1);
	glColor3f(r, g, b);
	glVertex2f(x2,y2);
	glColor3f(r, g, b);
	glVertex2f(x1,y2);
	glColor3f(r, g, b);
	glVertex2f(x1,y1);

	glEnd();

}

void glutDrawPlus(float x1, float y1, float s, float r, float g, float b)
{
	glBegin(GL_LINES);
	glLineWidth(2.0);

	float sx = s;
	float sy = s;


	glColor3f(r, g, b);
	glVertex2f(x1,y1-sy);
	glColor3f(r, g, b);
	glVertex2f(x1,y1+sy);

	glColor3f(r, g, b);
	glVertex2f(x1-sx,y1);
	glColor3f(r, g, b);
	glVertex2f(x1+sx,y1);

	glEnd();

}

void glutDisplayCallback( void )
{

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glutDrawBox(-1,1,1,-1, 1.0, 1.0, 1.0);
	screen->getEvents();
	app.draw();

	glFlush();
	glutSwapBuffers();

	glutPostRedisplay();
}

void startGLApp(int argc, char * argv[])
{
	screen->beginTracking();

	glutInit( &argc, argv );

	// set RGBA mode with double and depth buffers
	glutInitDisplayMode( GLUT_RGBA | GLUT_DEPTH | GLUT_DOUBLE );

	// 640x480, 16bit pixel depth, 60Hz refresh rate
	glutGameModeString( "800x600:16@60" );

	// start fullscreen game mode
	glutEnterGameMode();

	// setup callbacks
	glutKeyboardFunc( glutKeyboardCallback );
	glutKeyboardUpFunc( glutKeyboardUpCallback );
	glutDisplayFunc( glutDisplayCallback );

	configStep = 1;



	// enter main loop
	glutMainLoop();
}

int _tmain(int argc, char * argv[])
{
	screen = TouchScreenDevice::getTouchScreen();

	if(!screen->loadConfig("config.xml"))
	{
		screen->pushFilter("dsvlcapture", "capture1");
		screen->pushFilter("mono", "mono2");
		screen->pushFilter("smooth", "smooth3");
		screen->pushFilter("backgroundremove", "background4");

		//screen->pushFilter("brightnesscontrast", "bc5");
		screen->pushFilter("rectify", "rectify6");

		screen->setParameter("rectify6", "level", "25");

		screen->setParameter("capture1", "source", "cam");
		//screen->setParameter("capture1", "source", "../tests/simple-2point.avi");
		//screen->setParameter("capture1", "source", "../tests/hard-5point.avi");

		screen->setParameter("background4", "threshold", "0");

		//screen->setParameter("bc5", "brightness", "0.1");
		//screen->setParameter("bc5", "contrast", "0.4");

		screen->saveConfig("config.xml");
	}

	screen->registerListener((ITouchListener *)&app);
	// Note: Begin processing should only be called after the screen is set up

	screen->beginProcessing();

	do
	{

		int keypressed = cvWaitKey(32) & 255;

		if(keypressed != 255 && keypressed > 0)
			printf("KP: %d\n", keypressed);
        if( keypressed == 27) break;		// ESC = quit
        if( keypressed == 98)				// b = recapture background
		{
			screen->setParameter("background4", "capture", "");
		}
        if( keypressed == 114)				// r = auto rectify..
		{
			screen->setParameter("rectify6", "level", "auto");
		}

        if( keypressed == 13)				// enter = calibrate position
		{
			startGLApp(argc, argv);
		}

	} while( ok );

	screen->saveConfig("config.xml");
	TouchScreenDevice::destroy();
	return 0;
}