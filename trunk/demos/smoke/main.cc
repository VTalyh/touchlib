
#ifdef WIN32
	#include <tchar.h>
	#include <AtlConv.h>
#endif
#include <iostream>

#include "glutMaster.h"
#include "glutWindow.h"
#include "glutApplication.h"
#include "TouchScreenDevice.h"
#include "fluid2d.h"

GlutMaster* glutMaster;

#ifdef WIN32
int _tmain(int argc, _TCHAR* argv[])
#else
int main(int argc, char* argv[])
#endif
{
	glutMaster = new GlutMaster();    

	ITouchScreen* screen = TouchScreenDevice::getTouchScreen();	
	if( argc == 2 && screen->loadConfig((const char *) argv[1] ))
		std::cout << "Loaded configuration file " << argv[1] << std::endl;
	else if( screen->loadConfig("config.xml") )
		std::cout << "Loaded default configuration file config.xml" << std::endl;
	else
	{
		screen->pushFilter("cvcapture", "capture1");
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

	SLEEP(2000);
	screen->setParameter("background4", "mask", (char*)screen->getCameraPoints());
	screen->setParameter("background4", "capture", "");

	int meshsize = 50;
	float timestep = 0.5;
	float viscosity = 0.008;
	Fluid2D* fluid = new Fluid2D(meshsize, timestep, viscosity);

	glutApplication* application  = new glutApplication(glutMaster, 600,600, 200,100, screen, fluid, "Demo Smoke");
	application->StartSpinning(glutMaster);   // enable idle function

	screen->beginProcessing();
	screen->beginTracking();
	glutMaster->CallGlutMainLoop();

	TouchScreenDevice::destroy();
}
