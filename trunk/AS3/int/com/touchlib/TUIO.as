package com.touchlib {
	
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.XMLSocket;
//import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
//import flash.events.MouseEvent;
import flash.display.*;
import app.core.element.Wrapper;
import flash.events.MouseEvent;

	public class TUIO
	{
		static var FLOSCSocket:XMLSocket;		
		static var FLOSCSocketHost:String;			
		static var FLOSCSocketPort:Number;	
		
		static var thestage:Stage;
		static var objectArray:Array;
		static var idArray:Array;
		
		public static var debugMode:Boolean;		
		
		static var debugText:TextField;
		//static var debugToggle:TextField;
		static var recordedXML:XML;
		static var bRecording:Boolean = false;
		//static var xmlPlaybackURL:String = "www/xml/test.xml"; 
		static var xmlPlaybackURL:String = ""; 
		static var xmlPlaybackLoader:URLLoader;
		static var playbackXML:XML;
			
		static var bInitialized = false;
		
	
		public static function init (s:DisplayObjectContainer, host:String, port:Number, debugXMLFile:String, dbug:Boolean = true):void
		{
			if(bInitialized)
				return;
			debugMode = dbug;
			FLOSCSocketHost=host;			
			FLOSCSocketPort=port;			
			bInitialized = true;
			thestage = s.stage;
			
			//thestage.displayState = StageDisplayState.FULL_SCREEN;
			thestage.align = "TL";
			thestage.scaleMode = "noScale";						
			
			objectArray = new Array();
			idArray = new Array();
			try
			{
			
				FLOSCSocket = new XMLSocket();
	
				FLOSCSocket.addEventListener(Event.CLOSE, closeHandler);
				FLOSCSocket.addEventListener(Event.CONNECT, connectHandler);
				FLOSCSocket.addEventListener(DataEvent.DATA, dataHandler);
				FLOSCSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				FLOSCSocket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				FLOSCSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	
				FLOSCSocket.connect(host, port);			
			
			} catch (e)
			{
			}
			
			if(debugMode)
			{
				var format:TextFormat = new TextFormat();
				debugText = new TextField();
       			format.font = "Verdana";
     			format.color = 0xFFFFFF;
        		format.size = 10;
        
				debugText.defaultTextFormat = format;
				debugText.autoSize = TextFieldAutoSize.LEFT;
				debugText.background = true;	
				debugText.backgroundColor = 0x000000;	
				debugText.border = true;	
				debugText.borderColor = 0x333333;	
				thestage.addChild( debugText );	
					
				thestage.setChildIndex(debugText, thestage.numChildren-1);	
		
				recordedXML = <OSCPackets></OSCPackets>;	
				
				var buttonSprite = new Sprite();	
					
				buttonSprite.graphics.beginFill(0xFFFFFF,0.25);
				buttonSprite.graphics.drawRoundRect(0, -10, 50, 60,10);	
				buttonSprite.addEventListener(MouseEvent.CLICK, toggleDebug);					

				var WrapperObject:Wrapper = new Wrapper(buttonSprite);
			
				thestage.addChild(WrapperObject);
	
				
				thestage.setChildIndex(WrapperObject, thestage.numChildren-1);	
				//trace(thestage.numChildren);
				
				 if(xmlPlaybackURL != "")
				 {
					xmlPlaybackLoader = new URLLoader();
					xmlPlaybackLoader.addEventListener("complete", xmlPlaybackLoaded);
					xmlPlaybackLoader.load(new URLRequest(xmlPlaybackURL));
			
					thestage.addEventListener(Event.ENTER_FRAME, frameUpdate);
				 }
				
			} else {
				recordedXML = <OSCPackets></OSCPackets>;
				bRecording = false;
			}
			
		}

		private static function xmlPlaybackLoaded(evt:Event) {
			trace("Loaded xml debug data:");
			playbackXML = new XML(xmlPlaybackLoader.data);
		}
		
		private static function frameUpdate(evt:Event)
		{
			if(playbackXML && playbackXML.OSCPACKET && playbackXML.OSCPACKET[0])
			{
				processMessage(playbackXML.OSCPACKET[0]);

				delete playbackXML.OSCPACKET[0];
			}
		}		
		
		public static function getObjectById(id:Number): TUIOObject
		{
			for(var i=0; i<objectArray.length; i++)
			{
				if(objectArray[i].ID == id)
				{
					//trace("found " + id);
					return objectArray[i];
				}
			}
			//trace("Notfound");
			
			return null;
		}
		
		public static function listenForObject(id:Number, reciever:Object)
		{
			var tmpObj:TUIOObject = getObjectById(id);
			
			if(tmpObj)
			{
				tmpObj.addListener(reciever);				
			}

		}
		
		public static function processMessage(msg:XML)
		{

			var fseq:String;
			var node:XML;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "fseq")
					fseq = node.ARGUMENT[1].@VALUE;					
			}
///			trace("fseq = " + fseq);

			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "alive")
				{
					for each (var obj1:TUIOObject in objectArray)
					{
						obj1.isAlive = false;
					}
					
					var newIdArray:Array = new Array();					
					for each(var aliveItem:XML in node.ARGUMENT.(@VALUE != "alive"))
					{
						if(getObjectById(aliveItem.@VALUE))
							getObjectById(aliveItem.@VALUE).isAlive = true;

					}   
					
					//trace(idArray);

					idArray = newIdArray;
				}

			}			
			
							
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0])
				{
					var type:String;
					
					if(node.@NAME == "/tuio/2Dobj")
					{
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var sID = node.ARGUMENT[1].@VALUE;
							var id = node.ARGUMENT[2].@VALUE;
							var x = Number(node.ARGUMENT[3].@VALUE) * thestage.stageWidth;
							var y = Number(node.ARGUMENT[4].@VALUE) * thestage.stageHeight;
							var a = Number(node.ARGUMENT[5].@VALUE);
							var X = Number(node.ARGUMENT[6].@VALUE);
							var Y = Number(node.ARGUMENT[7].@VALUE);
							var A = Number(node.ARGUMENT[8].@VALUE);
							var m = node.ARGUMENT[9].@VALUE;
							var r = node.ARGUMENT[10].@VALUE;
							
							// send object update event..
							
							var objArray:Array = thestage.getObjectsUnderPoint(new Point(x, y));
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);							
							var dobj = null;
							
//							if(displayObjArray.length > 0)								
//								dobj = displayObjArray[displayObjArray.length-1];										

							
						
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y, X, Y, sID, a, 0, 0, dobj);
								thestage.addChild(tuioobj.spr);
								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();								
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;								
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.oldX = tuioobj.x;
								tuioobj.oldY = tuioobj.y;
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();								
							}
							
							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e)
							{
							}

		
						}
						
					} else if(node.@NAME == "/tuio/2Dcur")
					{
//						trace("2dcur");
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var id = node.ARGUMENT[1].@VALUE;
							var x = Number(node.ARGUMENT[2].@VALUE) * thestage.stageWidth;
							var y = Number(node.ARGUMENT[3].@VALUE) *  thestage.stageHeight;
							var X = Number(node.ARGUMENT[4].@VALUE);
							var Y = Number(node.ARGUMENT[5].@VALUE);
							var m = Number(node.ARGUMENT[6].@VALUE);
							var wd:Number=0.0, ht:Number = 0.0;
							
							if(node.ARGUMENT[7])
								wd = Number(node.ARGUMENT[7].@VALUE) * thestage.stageWidth;							
							
							if(node.ARGUMENT[8])
								ht = Number(node.ARGUMENT[8].@VALUE) * thestage.stageHeight;
							
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);
							var dobj = null;
							if(displayObjArray.length > 0)								
								dobj = displayObjArray[displayObjArray.length-1];							
														
								
							var sztmp:String="";
//							for(var i=0; i<displayObjArray.length; i++)
//								sztmp += (displayObjArray[i] is InteractiveObject) + ",";
//							trace(sztmp);

							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dcur", id, x, y, X, Y, -1, 0, wd, ht, dobj);

								thestage.addChild(tuioobj.spr);								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.oldX = tuioobj.x;
								tuioobj.oldY = tuioobj.y;
								tuioobj.width = wd;
								tuioobj.height = ht;
								tuioobj.area = wd * ht;								
								tuioobj.dX = X;
								tuioobj.dY = Y;

								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();
							}  

							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e)
							{
								trace("Dispatch event failed " + tuioobj.name);
							}

	
						}
					}
				}
			}
			

			if(debugMode)
			{
				debugText.text = "";
				debugText.y = -2000;
				debugText.x = -2000;	
			}	
			for (var i=0; i<objectArray.length; i++ )
			{
				if(objectArray[i].isAlive == false)
				{
					objectArray[i].kill();
					thestage.removeChild(objectArray[i].spr);
					objectArray.splice(i, 1);
					i--;

				} else {
					if(debugMode)
					{
						debugText.appendText("  " + (i + 1) +" - " +objectArray[i].ID + "  X:" + int(objectArray[i].x) + "  Y:" + int(objectArray[i].y) + "  \n");
						debugText.x = thestage.stageWidth-160;
						debugText.y = 40;		
					}
					}
			}
		}
		

		
		private static function toggleDebug(e:Event)
		{ 
			if(!debugMode){
			debugMode=true;	
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			//e.target.x=20;
			e.target.alpha=1;
			}
			else{
			debugMode=false;
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			//e.target.x=0;
			e.target.alpha=0.25;
			}
			
			// show XML
			//bRecording = false;
			//debugMode = false;			
			//debugText.text = recordedXML.toString();
			//debugText.x = 0;
			//debugText.y = 0;	
		}
		
        private static function closeHandler(event:Event):void {
            //trace("closeHandler: " + event);
        }

        private static function connectHandler(event:Event):void {
         //   trace("connectHandler: " + event);
        }

        private static function dataHandler(event:DataEvent):void {
			
            //trace("dataHandler: " + event);
			
			if(bRecording)
				recordedXML.appendChild( XML(event.data) );
			
			processMessage(XML(event.data));
        }

        private static function ioErrorHandler(event:IOErrorEvent):void {
//			thestage.tfDebug.appendText("ioError: " + event + "\n");			
            trace("ioErrorHandler: " + event);
        }

        private static function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private static function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
//			thestage.tfDebug.appendText("securityError: " + event + "\n");			
        }
	}
}