/*
	
	Touchlib

	An open-source library for Multitouch input using computer vision techniques.

	Please see:

	http://www.whitenoiseaudio.com/blog/
	http://www.nuigroup.com/wiki/Touchlib
	http://www.nuigroup.com/
*/

#include "CTouchScreen.h"
#include "FilterFactory.h"
#include "tinyxml.h"
#include <highgui.h>

using namespace touchlib;

#ifdef WIN32
HANDLE CTouchScreen::hThread = 0;
HANDLE CTouchScreen::eventListMutex = 0;
#else
pthread_t CTouchScreen::hThread = 0;
pthread_mutex_t CTouchScreen::eventListMutex = PTHREAD_MUTEX_INITIALIZER;
#endif

// FIXME: Maybe some of this calibration stuff should be moved to the config app

CTouchScreen::CTouchScreen()
{
	frame = 0;

	tracker.registerListener((ITouchListener *)this);

#ifdef WIN32
	eventListMutex = CreateMutex(NULL, 0, NULL);
#else
	pthread_mutex_init(&eventListMutex, NULL);
#endif

	reject_distance_threshold = 250;
	reject_min_dimension = 2;
	reject_max_dimension = 250;

	ghost_frames = 0;
	minimumDisplacementThreshold = CBlobTracker::DEFAULT_MINIMUM_DISPLACEMENT_THRESHOLD;

	screenBB = rect2df(vector2df(0.0f, 0.0f), vector2df(1.0f, 1.0f));
	initScreenPoints();
	initCameraPoints();

	debugMode = true;
	bTracking = false;

	screenMesh.recalcBoundingBox();

	int i,j;
	int t = 0;
	for(j=0; j<GRID_Y; j++)
	{
		for(i=0; i<GRID_X; i++)
		{
			triangles[t+0] = (i+0) + ((j+0) * (GRID_X+1));
			triangles[t+1] = (i+1) + ((j+0) * (GRID_X+1));
			triangles[t+2] = (i+0) + ((j+1) * (GRID_X+1));

			t += 3;

			triangles[t+0] = (i+1) + ((j+0) * (GRID_X+1));
			triangles[t+1] = (i+1) + ((j+1) * (GRID_X+1));
			triangles[t+2] = (i+0) + ((j+1) * (GRID_X+1));

			t += 3;
		}
	}


	bCalibrating = false;
	calibrationStep = 0;

}

CTouchScreen::~CTouchScreen()
{
	unsigned int i;

#ifdef WIN32
	if(hThread)
		TerminateThread(hThread, 0);

	CloseHandle(eventListMutex);
#else
	if(hThread){
		pthread_kill(hThread,15);
		hThread = 0;
	}
	
	pthread_mutex_destroy(&eventListMutex);
#endif


	
	for(i=0; i<filterChain.size(); i++)
		delete filterChain[i];

		
}

void CTouchScreen::initScreenPoints()
{
	int p = 0;

	int i,j;

	vector2df xd(screenBB.lowerRightCorner.X-screenBB.upperLeftCorner.X,0.0f);
	vector2df yd(0.0f, screenBB.lowerRightCorner.Y-screenBB.upperLeftCorner.Y);
	xd /= (float) GRID_X;
	yd /= (float) GRID_Y;
	
	for(j=0; j<=GRID_Y; j++)
	{
		for(i=0; i<=GRID_X; i++)
		{			
			screenPoints[p] = screenBB.upperLeftCorner + xd*i + yd*j;			
			printf("(%d, %d) = (%f, %f)\n", i, j, screenPoints[p].X, screenPoints[p].Y);
			p++;
		}
	}
}

void CTouchScreen::initCameraPoints()
{
	int p = 0;
	
	float cw = 640.0, ch = 480.0; // defaults if no frame is available
	// try and get a frame from the filter stack, and we'll use that as our frame size
	if(filterChain.size() > 0) {
		filterChain[0]->process(NULL);
		IplImage *output = filterChain.back()->getOutput();
		
		cw = (float)output->width;
		ch = (float)output->height;
	}

	int i,j;
	for(j=0; j<=GRID_Y; j++)
	{
		for(i=0; i<=GRID_X; i++)
		{
			cameraPoints[p] = vector2df((i * cw) / (float)GRID_X, (j * ch) / (float)GRID_Y);
			p++;
		}
	}
}


IplImage* CTouchScreen::getFilterImage(std::string & label)
{
	std::map<std::string,Filter*>::iterator iter = filterMap.find(label);
	if(iter == filterMap.end())
		return NULL;
	return iter->second->getOutput();	
}

IplImage* CTouchScreen::getFilterImage(int step)
{
	step = step >= filterChain.size() ? filterChain.size()-1:step;
	step = step < 0? 0:step;
	return filterChain[step]->getOutput();	
}

void CTouchScreen::setScreenScale(float s)
{
	// legacy
	float offset = (1.0f - s)*0.5f;
	screenBB = rect2df(vector2df(offset,offset),vector2df(1.0f-offset,1.0f-offset));
	initScreenPoints();
}

float CTouchScreen::getScreenScale()
{
	// legacy, take the minimum scale value that fits inside the bounding box
	float minValL = MIN(screenBB.lowerRightCorner.X,screenBB.lowerRightCorner.Y);
	minValL = 1.0f - minValL;
	float minValU = MAX(screenBB.upperLeftCorner.X,screenBB.upperLeftCorner.Y);
	float minVal = MIN(minValL,minValU);
	return 1.0f - (2.0f * minVal);	
}

void CTouchScreen::setScreenBBox(rect2df &box)
{
	screenBB = box;
	initScreenPoints();
}

bool CTouchScreen::getFingerInfo(int ID, TouchData *data)
{
	return tracker.getFingerInfo(ID, data);
}


void CTouchScreen::registerListener(ITouchListener *listener)
{
	listenerList.push_back(listener);
}


bool CTouchScreen::process()
{

	while(1)
	{

		if(filterChain.size() == 0)
			return false;
		//printf("Process chain\n");
		filterChain[0]->process(NULL);
		IplImage *output = filterChain.back()->getOutput();

		if(output)		
		{
			//printf("Process chain complete\n");
			frame = output;

			if(labelImg.getHeight() == 0) 
			{
				labelImg = cvCreateImage(cvSize(output->width,output->height), 8, 1);
			}
			cvZero(labelImg.imgp);

			if(bTracking == true)
			{
				//printf("Tracking 1\n");
				tracker.findBlobs_contour(frame, labelImg);
				tracker.ProcessResults();

#ifdef WIN32				
				DWORD dw = WaitForSingleObject(eventListMutex, INFINITE);
				//dw == WAIT_OBJECT_0
				if(dw == WAIT_TIMEOUT || dw == WAIT_FAILED) {
					// handle time-out error
					//throw TimeoutExcp();
					printf("Failed %d", dw);
					
				} 
				else 
				{
					//printf("Tracking 2\n");
					tracker.gatherEvents();
					ReleaseMutex(eventListMutex);
				}
#else
				int err;
				if((err = pthread_mutex_lock(&eventListMutex)) != 0){
					// some error occured
					fprintf(stderr,"locking of mutex failed\n");
				}else{
					tracker.gatherEvents();
					pthread_mutex_unlock(&eventListMutex);
				}
#endif
			}
			//return true;
		}
		SLEEP(32);
	}

}


void CTouchScreen::getRawImage(char **img, int &width, int &height)
{
	*img = ((IplImage *)frame.imgp)->imageData;
	width = frame.getWidth();
	height = frame.getHeight();
	return;
}


void CTouchScreen::saveConfig(const char* filename)
{
	ParameterMap pMap;
	ParameterMap::iterator pMapItr;

	TiXmlDocument doc(filename);
	TiXmlDeclaration* decl = new TiXmlDeclaration("1.0", "", "");
	doc.LinkEndChild(decl);


	char sztmp[50];

	TiXmlElement* configElement = new TiXmlElement("blobconfig");
	doc.LinkEndChild(configElement);	


	configElement->SetAttribute("distanceThreshold", reject_distance_threshold);
	configElement->SetAttribute("minDimension", reject_min_dimension);
	configElement->SetAttribute("maxDimension", reject_max_dimension);
	configElement->SetAttribute("ghostFrames", ghost_frames);
	sprintf(sztmp, "%f", minimumDisplacementThreshold);
	configElement->SetAttribute("minDisplacementThreshold", sztmp);



	TiXmlElement* bbelement = new TiXmlElement("bbox");
	sprintf(sztmp, "%f", screenBB.upperLeftCorner.X);
	bbelement->SetAttribute("ulX", sztmp);	
	sprintf(sztmp, "%f", screenBB.upperLeftCorner.Y);
	bbelement->SetAttribute("ulY", sztmp);	
	sprintf(sztmp, "%f", screenBB.lowerRightCorner.X);
	bbelement->SetAttribute("lrX", sztmp);	
	sprintf(sztmp, "%f", screenBB.lowerRightCorner.Y);
	bbelement->SetAttribute("lrY", sztmp);	
	doc.LinkEndChild(bbelement);

	TiXmlElement* screenRoot = new TiXmlElement("screen");
	doc.LinkEndChild(screenRoot);
	int i;

	for(i=0; i<GRID_POINTS; i++)
	{

		TiXmlElement* element = new TiXmlElement("point");
		sprintf(sztmp, "%f", cameraPoints[i].X);
		element->SetAttribute("X", sztmp);
		sprintf(sztmp, "%f", cameraPoints[i].Y);
		element->SetAttribute("Y", sztmp);
		screenRoot->LinkEndChild(element);
	}
	

	TiXmlElement* fgRoot = new TiXmlElement("filtergraph");
	doc.LinkEndChild(fgRoot);
	
	for(i = 0; i < filterChain.size(); i++)
	{
		TiXmlElement* element = new TiXmlElement(filterChain[i]->getType());
		element->SetAttribute("label", filterChain[i]->getName());

		filterChain[i]->getParameters(pMap);

		for(pMapItr = pMap.begin(); pMapItr != pMap.end(); pMapItr++)
		{
			TiXmlElement* param = new TiXmlElement(pMapItr->first.c_str());
			param->SetAttribute("value", pMapItr->second.c_str());
			element->LinkEndChild(param);
		}

		fgRoot->LinkEndChild(element);
		pMap.clear();
	}
	doc.SaveFile();
}



bool CTouchScreen::loadConfig(const char* filename)
{
	TiXmlDocument doc(filename);

	if(!doc.LoadFile())
		return false;

	TiXmlElement* configElement = doc.FirstChildElement("blobconfig");
	if(configElement){
		configElement->Attribute("distanceThreshold", &reject_distance_threshold);
		configElement->Attribute("minDimension", &reject_min_dimension);
		configElement->Attribute("maxDimension", &reject_max_dimension);
		configElement->Attribute("ghostFrames", &ghost_frames);

		double temp;
		configElement->Attribute("minDisplacementThreshold", &temp);
		minimumDisplacementThreshold = (float) temp;
	}

	// set up some configuration variables
	this->tracker.setup(reject_distance_threshold, reject_min_dimension, reject_max_dimension, ghost_frames, minimumDisplacementThreshold);

	TiXmlElement* bboxRoot = doc.FirstChildElement("bbox");
	if(bboxRoot){
		vector2df ul(atof(bboxRoot->Attribute("ulX")),atof(bboxRoot->Attribute("ulY")));
		vector2df lr(atof(bboxRoot->Attribute("lrX")),atof(bboxRoot->Attribute("lrY")));
		rect2df bb(ul,lr);
		setScreenBBox(bb);
	}else{
		setScreenScale(1.0f);
	}

	TiXmlElement* screenRoot = doc.FirstChildElement("screen");

	printf("Reading camera points\n");
	if(screenRoot)
	{

		int i=0;
		for(TiXmlElement* pointElement = screenRoot->FirstChildElement(); 
			pointElement != NULL;
			pointElement = pointElement->NextSiblingElement()) 
		{
			cameraPoints[i] = vector2df(atof(pointElement->Attribute("X")),atof(pointElement->Attribute("Y")));
			printf("%f, %f\n", cameraPoints[i].X,cameraPoints[i].Y);
			i++;

		}
	}

	TiXmlElement* fgRoot = doc.FirstChildElement("filtergraph");
	
	if(fgRoot)
	{


		for(TiXmlElement* filterElement = fgRoot->FirstChildElement(); 
			filterElement != NULL;
			filterElement = filterElement->NextSiblingElement()) 
		{
			pushFilter(filterElement->Value(), filterElement->Attribute("label"));
			// fixme: we should check to see whether pushfilter succeeded.
			if(filterChain.size() > 0)
			{
				Filter* curFilter = filterChain[filterChain.size()-1];

				for(TiXmlElement* paramElement = filterElement->FirstChildElement();
					paramElement != NULL;
					paramElement = paramElement->NextSiblingElement()) 
				{
						curFilter->setParameter(paramElement->Value(), paramElement->Attribute("value"));
				}
			}
		}

	}
	return true;
}

std::list<std::string> CTouchScreen::findFilters(const char * type)
{
	std::list<std::string> filters;
	for(std::vector<Filter*>::iterator iter = filterChain.begin();iter!=filterChain.end();iter++){
		if(!strcmp((*iter)->getType(),type)){
			filters.push_back(std::string((*iter)->getName()));
		}
	}
	return filters;
}

std::string CTouchScreen::findFirstFilter(const char * type)
{
	std::string filter;
	for(std::vector<Filter*>::iterator iter = filterChain.begin();iter!=filterChain.end();iter++){
		if(!strcmp((*iter)->getType(),type)){
			filter = (*iter)->getName();
			break;
		}
	}
	return filter;
}

void CTouchScreen::setParameter(std::string & label, char *param, char *value)
{
	std::map<std::string,Filter*>::iterator iter = filterMap.find(label);
	if(iter == filterMap.end())
		return;
	iter->second->setParameter(param, value);	
}

std::string CTouchScreen::pushFilter(const char *type, const char * inlabel)
{
	std::string label;
	unsigned int n = filterChain.size();
	if(inlabel){
		label = inlabel;
	}else{	
		label = type;
		// ugly, but a pain with safe functions because of windows function names
		char buffer[20];
		sprintf(buffer,"%d",n);
		label += buffer;
	}
	Filter *newfilt = FilterFactory::createFilter(type, label.c_str());
	
	if(newfilt)
	{
		// lets tile all the output windows nicely
	

		// FIXME: we are assuming 1024 x 768 screen res. We should
		// have a cross platform way to get the current screen res.

		// also we are assuming a camera res of 320x200..
		int num_per_row = 1024 / 320;
		int i = n % num_per_row;
		int j = n / num_per_row;
		newfilt->showOutput(debugMode, i*320, j * 200);

		if(filterChain.size() > 0)
			filterChain.back()->connectTo(newfilt);

		filterChain.push_back(newfilt);
		filterMap.insert(std::make_pair(label,newfilt));
		return label;
	}
	return std::string();
}


void CTouchScreen::doTouchEvent(TouchData data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)
	{
		listenerList[i]->fingerDown(data);
	}
}


void CTouchScreen::doUpdateEvent(TouchData data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)
	{
		listenerList[i]->fingerUpdate(data);
	}
}


void CTouchScreen::doUntouchEvent(TouchData data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)
	{
		listenerList[i]->fingerUp(data);
	}
}

void CTouchScreen::fingerDown(TouchData data)
{
	CTouchEvent e;

	if(bCalibrating) {
		cameraPoints[calibrationStep] = vector2df(data.X, data.Y);
		//printf("%d (%f, %f)\n", calibrationStep, data.X, data.Y);
	}

	transformDimension(data.width, data.height, data.X, data.Y);
	data.area = data.width * data.height;

	cameraToScreenSpace(data.X, data.Y);
	
	e.data = data;
	e.type = TOUCH_PRESS;

	e.data.dX = 0;
	e.data.dY = 0;

	eventList.push_back(e);
}


void CTouchScreen::fingerUp(TouchData data)
{
	CTouchEvent e;

	float tx, ty;

	tx = data.X + data.dX;
	ty = data.Y + data.dY;

	transformDimension(data.width, data.height, data.X, data.Y);
	data.area = data.width * data.height;

	cameraToScreenSpace(data.X, data.Y);
	cameraToScreenSpace(tx, ty);

	e.data = data;
	e.type = TOUCH_RELEASE;
	e.data.dX = tx - data.X;
	e.data.dY = ty - data.Y;

	eventList.push_back(e);
}


void CTouchScreen::fingerUpdate(TouchData data)
{
	CTouchEvent e;

	float tx, ty;

	tx = data.X + data.dX;
	ty = data.Y + data.dY;

	transformDimension(data.width, data.height, data.X, data.Y);
	data.area = data.width * data.height;

	cameraToScreenSpace(data.X, data.Y);
	cameraToScreenSpace(tx, ty);

	e.data = data;
	e.type = TOUCH_UPDATE;
	e.data.dX = tx - data.X;
	e.data.dY = ty - data.Y;

	eventList.push_back(e);
}

void CTouchScreen::transformDimension(float &width, float &height, float centerX, float centerY)
{
	// transform width/height
        float halfX = width * 0.5f;
        float halfY = height * 0.5f;

        float ulX = centerX - halfX;
        float ulY = centerY - halfY;
        float lrX = centerX + halfX;
        float lrY = centerY + halfY;

        cameraToScreenSpace(ulX, ulY);
        cameraToScreenSpace(lrX, lrY);

        width = lrX - ulX;
        height = lrY - ulY;
}



bool isPointInTriangle(vector2df p, vector2df a, vector2df b, vector2df c)
{
	if (vector2df::isOnSameSide(p,a, b,c) && vector2df::isOnSameSide(p,b, a,c) && vector2df::isOnSameSide(p, c, a, b))
		return true;
    else 
		return false;
}



int CTouchScreen::findTriangleWithin(vector2df pt)
{
	int t;

	for(t=0; t<GRID_INDICES; t+=3)
	{
		if( isPointInTriangle(pt, cameraPoints[triangles[t]], cameraPoints[triangles[t+1]], cameraPoints[triangles[t+2]]) )
		{
			return t;
		}
	}

	return -1;
}


// Transforms a camera space coordinate into a screen space coord
void CTouchScreen::cameraToScreenSpace(float &x, float &y)
{

	vector2df pt(x, y);
	int t = findTriangleWithin(pt);

	if(t != -1)
	{

		vector2df A = cameraPoints[triangles[t+0]];
		vector2df B = cameraPoints[triangles[t+1]];
		vector2df C = cameraPoints[triangles[t+2]];
		float total_area = (A.X - B.X) * (A.Y - C.Y) - (A.Y - B.Y) * (A.X - C.X);

		// pt,B,C
		float area_A = (pt.X - B.X) * (pt.Y - C.Y) - (pt.Y - B.Y) * (pt.X - C.X);

		// A,pt,C
		float area_B = (A.X - pt.X) * (A.Y - C.Y) - (A.Y - pt.Y) * (A.X - C.X);

		float bary_A = area_A / total_area;
		float bary_B = area_B / total_area;
		float bary_C = 1.0f - bary_A - bary_B;	// bary_A + bary_B + bary_C = 1

		vector2df sA = screenPoints[triangles[t+0]];
		vector2df sB = screenPoints[triangles[t+1]];
		vector2df sC = screenPoints[triangles[t+2]];

		vector2df transformedPos;

		transformedPos = (sA*bary_A) + (sB*bary_B) + (sC*bary_C);

		x = transformedPos.X;
		y = transformedPos.Y;
		return;
	}

	x = 0;
	y = 0;
	// FIXME: what to do in the case that it's outside the mesh?


}

THREAD_RETURN_TYPE CTouchScreen::_processEntryPoint(void * obj)
{
	((CTouchScreen *)obj)->process();
}


void CTouchScreen::beginProcessing()
{
#ifdef WIN32
	hThread = (HANDLE)_beginthread(_processEntryPoint, 0, this);
	//SetThreadPriority(hThread, THREAD_PRIORITY_ABOVE_NORMAL);
#else
	pthread_create(&hThread,0,_processEntryPoint,this);
#endif
}


void CTouchScreen::getEvents()
{
	unsigned int i=0;

#ifdef WIN32				
	DWORD dw = WaitForSingleObject(eventListMutex, INFINITE);		// 
	//dw == WAIT_OBJECT_0
	if(dw == WAIT_TIMEOUT || dw == WAIT_FAILED) {
		// handle time-out error
		//throw TimeoutExcp();
		printf("Failed %d", dw);
		return;
	} 
#else
	int err;
	if((err = pthread_mutex_lock(&eventListMutex)) != 0){
		// some error occured
		fprintf(stderr,"locking of mutex failed\n");
		return;
	}
#endif		
	for(i=0; i<eventList.size(); i++)
		{
			switch(eventList[i].type)
				{
				case TOUCH_PRESS:
					doTouchEvent(eventList[i].data);
					break;
				case TOUCH_RELEASE:
					doUntouchEvent(eventList[i].data);
					break;
				case TOUCH_UPDATE:
					doUpdateEvent(eventList[i].data);
					break;
				};
		}
	
	eventList.clear();
#ifdef WIN32
	ReleaseMutex(eventListMutex);
#else
	pthread_mutex_unlock(&eventListMutex);
#endif

}


void CTouchScreen::beginCalibration()
{
	 bCalibrating = true;
	 calibrationStep = 0;
}


void CTouchScreen::nextCalibrationStep()
{
	if(bCalibrating)
	{
		calibrationStep++;
		if(calibrationStep >= GRID_POINTS)
		{

			printf("Calibration complete\n");

			bCalibrating = false;
			calibrationStep = 0;
		}
	}
}

void CTouchScreen::revertCalibrationStep()
{
	if(bCalibrating)
	{
		calibrationStep--;
		if(calibrationStep < 0)
		{
			calibrationStep = 0;
		}
	}
}

// Code graveyard:
/*
// Transforms a camera space coordinate into a screen space coord
void CTouchScreen::cameraToScreenSpace(float &x, float &y)
{
	// Reference: http://www.cescg.org/CESCG97/olearnik/txmap.htm
	// FIXME: these could be precalculated.

	//x = x / 320.0f;
	//y = y / 240.0f;
	//return;

	float ax = screenPoints[0].X;
	float ay = screenPoints[0].Y;

	float bx = screenPoints[1].X -  screenPoints[0].X; 
	float by = screenPoints[1].Y -  screenPoints[0].Y;

	float cx = screenPoints[3].X - screenPoints[0].X;
	float cy = screenPoints[3].Y - screenPoints[0].Y;

	float dx = screenPoints[0].X - screenPoints[1].X - screenPoints[3].X + screenPoints[2].X;
	float dy = screenPoints[0].Y - screenPoints[1].Y - screenPoints[3].Y + screenPoints[2].Y;


	float K = (float) ((cx*dy) - (cy*dx));
	float L = (float) ((dx*y) - (dy*x) + (ax*dy) - (ay*dx) + (cx*by) - (cy*bx));
	float M = (float) ((bx*y) - (by*x) + (ax*by));

	float u, v;

	if (K == 0.0)
		v = -M / L;
	else 
		v = (float) ((-L - sqrtf((L*L) - (4.0 * K*M) ) ) / (2.0 * K)) ;
	
	u = (float) ((x - ax - (cx * v)) / (bx + (dx * v)));


	//x = u * 800.0;
	//y = v * 600.0;

	if(u < 0.0f)
		u *= -1.0f;
	if(v < 0.0f)
		v *= -1.0f;

	u *= screenScale;
	v *= screenScale;

	u += 0.5 - (screenScale*0.5);
	v += 0.5 - (screenScale*0.5);

	x = u;
	y = v;
}
*/
