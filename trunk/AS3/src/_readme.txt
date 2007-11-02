Hello,

Here is a overview of the Touchlib AS3 project:

------------------------------------------------
//Applications
------------------------------------------------

Core
---------------
AppLoader
Base - Base testing for table operations. (debug)

Effects
---------------
Ripples
Paint
Trace

Multimemdia
---------------
Photo
Viewer
Piano
MusicalSquares
Turntables

Games
--------------
Puzzle
Tangram
Tank


------------------------------------------------
//Structure
------------------------------------------------

src - Flash CS3 source and deployment assets
lib - internal libraries
ext - external libraries (papervision, tweener, etc..)

com.touchlib - TUIO socket (renders touch input)

app.core.action - Actions for objects (Rotate/Scale, scroll, doubletap)
app.core.canvas - Container and lens objects (MediaCanvas, nCanvas, Zoom)
app.core.element - Interactive objects that typically act as controllers (Knob, Slider, Toggle)
app.core.loader - External content loaders
app.core.object - Objects that can be rendered on a canvas element (ImageObject, VideoOject)
app.core.utl - Misc utils

app.demo - Demo applications assets
 

------------------------------------------------
//Development
------------------------------------------------
Here is some general guidelines to follow when building demo applications.

Think of the app.demo folder as you would Windows Program files, all application classes and assets 
go into a folder. A typical folder:

app/demo/appName - Folder
app/demo/appName/assets - externals (images, fonts)
app/demo/appName/appNameClass.as - Document Class
app/demo/appName/readme.txt - About the app (license, version)


When committing new applications please keep graphics to minimum, exclude things like background 
and text objects unless necessary for programs operation. If possible put on solid black background.
Also try to clean up any unused library elements. 

Use flash components as much as possible eg: Button

------------------------------------------------
//FLA Setup
------------------------------------------------
Document Class: app.core.appName
Source Paths: ../lib and ../ext
Publish Resolution: 1024x786
Background: Solid Black
Publish path: deploy/appName.swf

------------------------------------------------
//Deployment
------------------------------------------------
www - dynamic web objects 
local - dynamic local objects
appName.swf

------------------------------------------------
Developers:
------------------------------------------------
whitenoiseaudio.com
nuiman.com
timroth.de
multigesture.net
cerupcat
adi/deej
jensfranke

------------------------------------------------
License:
------------------------------------------------
Core - GPL
Demo Applications - License determined by author(s).


-------------------------------------------------------------
//Notes
-------------------------------------------------------------
c.moore: developers let me know if have any ideas, please put here with your contact.

Home: http://touchlib.com
SVN : http://touchlib.googlecode.com




