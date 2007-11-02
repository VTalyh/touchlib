package app.demo{
	
import com.touchlib.*;

import app.core.canvas.*;
import app.core.loader.*;
import app.core.utl.*;
import flash.display.*;

//import app.ext.flare.*;
//import app.ext.tweener.*;
//import app.ext.p3d.*;

import flash.events.Event;
import flash.system.Capabilities;

public class Debug extends Sprite
{		
	public function Debug()
		{					
		Settings.instance.loadSettings('www/xml/config.xml');
		Settings.instance.addEventListener(Settings.INIT, initApp);	
		}
		
	public function initApp(event:Event):void
		{				
		if (Settings.instance.debug == true){	
		var DEBUG_FPS:FPS = new FPS();
		var debugMode:Boolean = Settings.instance.debug;
		this.addChild(DEBUG_FPS);
		}
		this.stage.frameRate = Settings.instance.framerate;
		trace(' ~ '); 
        trace(' v '+Settings.instance.version);
        trace('-------------------------------------------------------------------------------------------------------------------------------');
        trace(' Theme : '+Settings.instance.theme); 
        trace(' Debug : '+Settings.instance.debug); 
        trace(' FPS : '+Settings.instance.framerate);		
        TUIO.init( this, Settings.instance.host, Settings.instance.TCP, '', false);	        
        trace(' TUIO Socket Enabled : Host: '+Settings.instance.host+' TCP: '+Settings.instance.TCP+' UDP: '+Settings.instance.UDP);	
	    trace('-------------------------------------------------------------------------------------------------------------------------------');		
		trace(' Modules Available : '+Settings.instance.modules_avail);
		trace('-------------------------------------------------------------------------------------------------------------------------------');
		trace(' Modules Loaded : '+Settings.instance.modules);	
  		trace('-------------------------------------------------------------------------------------------------------------------------------');
  		setupStage();
  		}
  		
	public function setupStage()
		{			
		//var subobj = new MediaCanvas();
		var subobj = new TestCanvas();
		//this.addChild(subobj);
		//var flickrLoader = new Flickr(subobj);
		//var localLoader = new Local(subobj);
		var sysManager = new MemoryMonitor();
		var fpsManager = new FPS();
		this.addChild(sysManager);
		this.addChild(fpsManager);
	
		var bFullscreen:Shape = new Shape();
		bFullscreen.graphics.beginFill(0x000000,0.0);
		bFullscreen.graphics.drawRect(Capabilities.screenResolutionX-200,0,200,200);
		bFullscreen.graphics.endFill();	
		this.addChild(bFullscreen);  
		
		bFullscreen.addEventListener(TUIOEvent.DownEvent, function() {
		if (stage.displayState == "fullScreen") {stage.displayState = "normal";} 
		else {stage.displayState = "fullScreen";}
		});	
		
		var buttonSprite0:Sprite = new Sprite();
		buttonSprite0.graphics.lineStyle(1, 0x202020,0.5);
		buttonSprite0.graphics.beginFill(0x00FF00,0.5);
		buttonSprite0.graphics.drawCircle(500, 600, 60);
		//this.addChild(buttonSprite0);
		//setChildIndex(subobj,3);
		
		if (Settings.instance.background != "none"){
		var bg = new BrowserBackground(Settings.instance.background);
		this.addChildAt(bg, 0);	

		bg.addEventListener(BrowserBackground.BACKGROUND_LOADING, loading);
		bg.addEventListener(BrowserBackground.BACKGROUND_LOADED, loaded);
			
	
			
		function loaded(e:Event) {
		bg.removeEventListener(BrowserBackground.BACKGROUND_LOADING, loading);
		bg.removeEventListener(BrowserBackground.BACKGROUND_LOADED, loaded);
		}

		function loading(e:Event) {
		var bL:Number = bg.bytesLoaded;
		var bT:Number = bg.bytesTotal;	
		var bT:Number = bg.bytesTotal;		
		 trace('Loading URL: ' + Settings.instance.background +' - '+ bT / 1000 + 'KB / ' +uint(100 * bL / bT)+'%');
		}	
  		}	
  		}
	public function testFunction(e:TUIOEvent)
		{	
		trace('Test');
		//scrollCanvas0._scrollContent._tf.text = '';
		//scrollCanvas0._scrollContent._tf.text = TUIO.recordedXML.toString();
		//var sliderValue = slider0.getValue;		
		//this.stage.frameRate = sliderValue;
		//trace(sliderValue);		
		}
  }	
}























/*
import com.touchlib.TUIO;
import app.core.canvas.*;
import app.core.loader.*;
import app.core.utl.*;

import flash.events.Event;
import flash.system.Capabilities;

TUIO.init( this, 'localhost', 3000, '', false );

//var subobj = new MediaCanvas();
var subobj = new TestCanvas();
//this.addChild(subobj);
//var flickrLoader = new Flickr(subobj);
//var localLoader = new Local(subobj);
var sysManager = new MemoryMonitor();
var fpsManager = new FPS();
this.addChild(sysManager);
this.addChild(fpsManager);

stage.addEventListener(Event.RESIZE,onResize);  
stage.align = "TL"; 
stage.scaleMode = "noScale";  
function onResize(e:Event = null):void {
var stageW:int = stage.stageWidth;
var stageH:int = stage.stageHeight;
	this.center_mc.x = stageW/2;
	this.center_mc.y = stageH/2;	
	this.sysManager.x = stageW-350;
	this.sysManager.y = stageH-220;	
	this.fpsManager.x = stageW-340;
	this.fpsManager.y = stageH-238;	
	}
onResize();

*/