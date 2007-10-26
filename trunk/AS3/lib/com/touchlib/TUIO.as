// FIXME: need velocity

package com.touchlib {
import flash.display.*;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.XMLSocket;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;



	public class TUIO
	{
		static var FLOSCSocket:XMLSocket;
		static var thestage:DisplayObjectContainer;
		static var objectArray:Array;
		static var idArray:Array;
		

		public static var debugMode:Boolean;		
		
		static var DEBUG_TEXT:TextField;
		static var recordedXML:XML;
		static var bRecording:Boolean = true;
		static var xmlPlaybackURL:String;  
		static var xmlPlaybackLoader:URLLoader;
		static var playbackXML:XML;
		
		static var stagewidth:int;
		static var stageheight:int;
		
		static var bInitialized = false;


		public static function init (s:Sprite, host:String, port:Number, nXML:String, dbug:Boolean = true):void
		{
			xmlPlaybackURL = nXML; 
			if(bInitialized)
				return;
			debugMode = dbug;
			
			bInitialized = true;
			stagewidth = s.stage.stageWidth;
			stageheight = s.stage.stageHeight;
			thestage = s.stage;
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
			
			} catch (e:Event)
			{
			}
			
			if(debugMode)
			{
				var format:TextFormat = new TextFormat();
				DEBUG_TEXT = new TextField();
       			format.font = "Verdana";
     			format.color = 0xFFFFFF;
        		format.size = 10;
        
				DEBUG_TEXT.defaultTextFormat = format;
				DEBUG_TEXT.autoSize = TextFieldAutoSize.LEFT;
				DEBUG_TEXT.background = true;	
				DEBUG_TEXT.backgroundColor = 0x000000;	
				DEBUG_TEXT.border = true;	
				DEBUG_TEXT.borderColor = 0x333333;	
				thestage.addChild( DEBUG_TEXT );		
		
				recordedXML = <OSCPackets></OSCPackets>;				
				var buttonSprite:Sprite = new Sprite();
				buttonSprite.graphics.lineStyle(2, 0x202020);
				buttonSprite.graphics.beginFill(0xF80101,0.5);
				buttonSprite.graphics.drawRoundRect(10, 10, 200, 200,6);				 
				buttonSprite.addEventListener(TUIOEvent.DownEvent, stopRecording);				 
				//thestage.addChild(buttonSprite);
				 
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
		
		private static function setDimensions(wd:int = 800, ht:int = 600):void
		{
			stagewidth = wd;
			stageheight = ht;			
		}

		private static function xmlPlaybackLoaded(evt:Event):void
		{
			trace("Loaded xml debug data");
			playbackXML = new XML(xmlPlaybackLoader.data);
		}
		
		private static function frameUpdate(evt:Event):void
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
		
		public static function listenForObject(id:Number, reciever:Object):void
		{
			var tmpObj:TUIOObject = getObjectById(id);
			
			if(tmpObj)
			{
				tmpObj.addListener(reciever);				
			}

		}
		
		public static function processMessage(msg:XML):void
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
					
					var sID:int;
					var id:int;
					var x:Number;
					var y:Number;
					var a:Number;
					var X:Number;
					var Y:Number;
					var A:Number;
					var m:Number;
					var r:Number;					
					
					var objArray:Array;
					var stagePoint:Point;
					var displayObjArray:Array;
					var dobj = null;					
					
					var tuioobj:Object;
					
					var localPoint:Point;
					
					if(node.@NAME == "/tuio/2Dobj")
					{
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							sID = node.ARGUMENT[1].@VALUE;
							id = node.ARGUMENT[2].@VALUE;
							x = Number(node.ARGUMENT[3].@VALUE) * stagewidth;
							y = Number(node.ARGUMENT[4].@VALUE) * stageheight;
							a = Number(node.ARGUMENT[5].@VALUE);
							X = Number(node.ARGUMENT[6].@VALUE);
							Y = Number(node.ARGUMENT[7].@VALUE);
							A = Number(node.ARGUMENT[8].@VALUE);
							m = node.ARGUMENT[9].@VALUE;
							r = node.ARGUMENT[10].@VALUE;
							
							// send object update event..
							
							objArray = thestage.stage.getObjectsUnderPoint(new Point(x, y));
							stagePoint = new Point(x,y);					
							displayObjArray = thestage.stage.getObjectsUnderPoint(stagePoint);							
							dobj = null;
							
//							if(displayObjArray.length > 0)								
//								dobj = displayObjArray[displayObjArray.length-1];										

							tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y, X, Y, sID, a, dobj);
								thestage.addChild(tuioobj.spr);
								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();								
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;								
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();								
							}
							
							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									
									localPoint = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.MoveEvent, true, false, x, y, localPoint.x, localPoint.y, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e:Event)
							{
							}

		
						}
						
					} else if(node.@NAME == "/tuio/2Dcur")
					{
//						trace("2dcur");
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							id = node.ARGUMENT[1].@VALUE;
							x = Number(node.ARGUMENT[2].@VALUE) * stagewidth;
							y = Number(node.ARGUMENT[3].@VALUE) * stageheight;
							X = Number(node.ARGUMENT[4].@VALUE);
							Y = Number(node.ARGUMENT[5].@VALUE);
							m = node.ARGUMENT[6].@VALUE;
							//var area = node.ARGUMENT[7].@VALUE;							
							
							stagePoint = new Point(x,y);					
							displayObjArray = thestage.stage.getObjectsUnderPoint(stagePoint);
							dobj = null;
							if(displayObjArray.length > 0)								
								dobj = displayObjArray[displayObjArray.length-1];							
														
								
							var sztmp:String="";
//							for(var i=0; i<displayObjArray.length; i++)
//								sztmp += (displayObjArray[i] is InteractiveObject) + ",";
//							trace(sztmp);

							tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dcur", id, x, y, X, Y, -1, 0, dobj);
								//tuioobj.area = area;
								thestage.addChild(tuioobj.spr);								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;
								tuioobj.x = x;
								tuioobj.y = y;
								//tuioobj.area = area;								
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();
							}

							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									localPoint = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.MoveEvent, true, false, x, y, localPoint.x, localPoint.y, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e:Event)
							{
								trace("Dispatch event failed " + tuioobj.name);
							}

	
						}
					}
				}
			}
			

			if(debugMode)
			{
				DEBUG_TEXT.text = "";
				DEBUG_TEXT.y = -2000;
				DEBUG_TEXT.x = -2000;		
			}
			
			for (var i=0; i<objectArray.length; i++ )
			{
				if(objectArray[i].isAlive == false)
				{
					objectArray[i].removeObject();
					thestage.removeChild(objectArray[i].spr);
					objectArray.splice(i, 1);
					i--;

				} else {
					if(debugMode)
					{
						DEBUG_TEXT.appendText("  " + (i + 1) +" - " +objectArray[i].ID + "  X:" + int(objectArray[i].x) + "  Y:" + int(objectArray[i].y) + "  \n");
						DEBUG_TEXT.x = stagewidth-160;
						DEBUG_TEXT.y = 8;		
					}
					//trace(stagewidth);		
				}
			}
		}
		

		
		private static function stopRecording(e:Event):void
		{
			// show XML
			bRecording = false;
			debugMode = false;
			//trace(recordedXML.toString());
		}
		
        private static function closeHandler(event:Event):void {
            //trace("closeHandler: " + event);
        }

        private static function connectHandler(event:Event):void {

            trace("TUIO Connected : " + event);
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