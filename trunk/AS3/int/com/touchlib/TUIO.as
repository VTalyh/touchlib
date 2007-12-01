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
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.display.Stage;
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import app.core.element.Wrapper;

	public class TUIO
	{
		static var FLOSCSocket:XMLSocket;		
		static var FLOSCSocketHost:String;			
		static var FLOSCSocketPort:Number;	
		
		static var thestage:Stage;
		static var objectArray:Array;
		static var idArray:Array;
		
		static var debugMode:Boolean;		
		
		static var debugText:TextField;
		static var recordedXML:XML;
		static var bRecording:Boolean = true;
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
			
			xmlPlaybackURL = debugXMLFile;
			
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
			
			} catch (e){}
			
			if(debugMode)
			{
				var format:TextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
				debugText = new TextField();       
				debugText.defaultTextFormat = format;
				debugText.autoSize = TextFieldAutoSize.LEFT;
				debugText.background = true;	
				debugText.backgroundColor = 0x000000;	
				debugText.border = true;	
				debugText.borderColor = 0x333333;	
				thestage.addChild( debugText );						
				thestage.setChildIndex(debugText, thestage.numChildren-1);	
		
				recordedXML = <OSCPackets></OSCPackets>;	
				
				var debugBtn = new Sprite();						
				debugBtn.graphics.beginFill(0xFFFFFF,0.25);
				debugBtn.graphics.drawRect(thestage.stageWidth-210, 0, 200, 65);	
				debugBtn.addEventListener(MouseEvent.CLICK, toggleDebug);
				var debugBtnW:Wrapper = new Wrapper(debugBtn);			
				debugBtnW.y = 20;				
				thestage.addChildAt(debugBtnW, thestage.numChildren-1);								
				
				var recordBtn = new Sprite();						
				recordBtn.graphics.beginFill(0xFF0000,0.5);
				recordBtn.graphics.drawRect(thestage.stageWidth-210, 0, 200, 65);	
				recordBtn.addEventListener(MouseEvent.CLICK, toggleRecord);
				var recordBtnW:Wrapper = new Wrapper(recordBtn);			
				recordBtnW.y = 85;				
				thestage.addChildAt(recordBtnW, thestage.numChildren-1);	
				
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
			if(id == 0)
			{
				return new TUIOObject("mouse", 0, thestage.mouseX, thestage.mouseY, 0, 0, 0, 0, 10, 10, null);
			}
			for(var i=0; i<objectArray.length; i++)
			{
				if(objectArray[i].ID == id)
				{
					return objectArray[i];
				}
			}

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
						/*
						
						// fixme: ensure everything is working properly here.
						
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
						*/
						
					} else if(node.@NAME == "/tuio/2Dcur")
					{
						//trace("2dcur");
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var x:Number,
								y:Number,
								X:Number,
								Y:Number,
								m:Number,
								wd:Number = 0, 
								ht:Number = 0;
							try 
							{
								id = node.ARGUMENT[1].@VALUE;
								x = Number(node.ARGUMENT[2].@VALUE) * thestage.stageWidth;
								y = Number(node.ARGUMENT[3].@VALUE) *  thestage.stageHeight;
								X = Number(node.ARGUMENT[4].@VALUE);
								Y = Number(node.ARGUMENT[5].@VALUE);
								m = Number(node.ARGUMENT[6].@VALUE);
						

								if(node.ARGUMENT[7])
									wd = Number(node.ARGUMENT[7].@VALUE) * thestage.stageWidth;							
								
								if(node.ARGUMENT[8])
									ht = Number(node.ARGUMENT[8].@VALUE) * thestage.stageHeight;
							} catch (e)
							{
								trace("Error parsing");
							}
							
							trace("Blob : ("+id + ")" + x + " " + y + " " + wd + " " + ht);
							
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
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dcur", id, 0, 0));
								}
							} catch (e)
							{
								trace("(" + e + ")Dispatch event failed " + tuioobj.ID);
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
					{	var tmp = (int(objectArray[i].area)/-100000);
						trace('area: '+tmp);
						debugText.appendText("  " + (i + 1) +" - " +objectArray[i].ID + "  X:" + int(objectArray[i].x) + "  Y:" + int(objectArray[i].y) +
						"  A:" + int(tmp) + "  \n");						
						debugText.x = thestage.stageWidth-200;
						debugText.y = 25;	
					}
					}
			}
		}
		
		private static function toggleDebug(e:Event)
		{ 
			if(!debugMode){
			debugMode=true;		
			//FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.alpha=1;
			}
			else{
			debugMode=false;
			//FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.alpha=0.25;	
			}
		}
		private static function toggleRecord(e:Event)
		{ 
			if(!bRecording){
			bRecording = true;
			e.target.alpha=1;				
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- DEBUG ON  ----------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			recordedXML = new XML();	
			}
			else{
			bRecording = false;
			e.target.alpha=0.25;	
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- DEBUG OFF ----------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			trace(recordedXML);	
			//recordedXML = new XML();	
			}
		}
        private static function dataHandler(event:DataEvent):void {           			
			if(bRecording)
			recordedXML.appendChild( XML(event.data) );			
			processMessage(XML(event.data));
        }     	
     	private static function connectHandler(event:Event):void {
            //trace("connectHandler: " + event);
        }       
        private static function ioErrorHandler(event:IOErrorEvent):void {
            //trace("ioErrorHandler: " + event);
        }
        private static function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }
       private static function closeHandler(event:Event):void {
            //trace("closeHandler: " + event);
        }
        private static function securityErrorHandler(event:SecurityErrorEvent):void {
            //trace("securityErrorHandler: " + event);
        }
	}
}