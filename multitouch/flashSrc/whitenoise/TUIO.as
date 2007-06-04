// FIXME: need velocity

package whitenoise {
	import flash.events.*;
	import flash.xml.*;
	import flash.net.*
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.describeType;

	public class TUIO
	{
		static var FLOSCSocket:XMLSocket;
		static var thestage:DisplayObject;
		static var objectArray:Array;
		static var idArray:Array;
		public static var debugMode:Boolean = true;		
		static var debugText:TextField;
		static var recordedXML:XML;
		static var bRecording:Boolean = true;
		static var xmlPlaybackURL:String = "test2.xml"; 
		static var xmlPlaybackLoader:URLLoader;
		static var playbackXML:XML;
		
		static var stagewidth:int;
		static var stageheight:int;
		
		static var bInitialized = false;


		public static function init (s:DisplayObjectContainer, host:String, port:Number, wd:int = 800, ht:int = 600)
		{
			if(bInitialized)
				return;
			
			bInitialized = true;
			stagewidth = wd;
			stageheight = ht;
			thestage = s;
			objectArray = new Array();
			idArray = new Array();
			FLOSCSocket = new XMLSocket();

            FLOSCSocket.addEventListener(Event.CLOSE, closeHandler);
            FLOSCSocket.addEventListener(Event.CONNECT, connectHandler);
            FLOSCSocket.addEventListener(DataEvent.DATA, dataHandler);
            FLOSCSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            FLOSCSocket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            FLOSCSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			FLOSCSocket.connect(host, port);			
			
			if(debugMode)
			{
				// set some debug stuff?
				var t:TextField = new TextField();
				t.autoSize = TextFieldAutoSize.LEFT;
				t.background = true;
				t.border = true;				
				t.text = "Debug info";
				t.width = 100;
				t.y = 40;
				debugText = t;
				thestage.addChild(t);
				
				recordedXML = <OSCPackets></OSCPackets>;
				
				 var buttonSprite:Sprite = new Sprite();
				 buttonSprite.graphics.lineStyle(2, 0x202020);
				 buttonSprite.graphics.beginFill(0x00FF00);
				 buttonSprite.graphics.drawRect(2, 2, 40, 38);
				 
				 buttonSprite.addEventListener(TUIOEvent.DownEvent, stopRecording);
				 
				 thestage.addChild(buttonSprite);
				 
				 if(xmlPlaybackURL != "")
				 {
					xmlPlaybackLoader = new URLLoader();
					xmlPlaybackLoader.addEventListener("complete", xmlPlaybackLoaded);
					xmlPlaybackLoader.load(new URLRequest(xmlPlaybackURL));				 
			
					thestage.addEventListener(Event.ENTER_FRAME, frameUpdate);
				 }
				
			}
			
		}
		
		
		

		private static function xmlPlaybackLoaded(evt:Event) {
			trace("Loaded xml debug data");
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
		
		public static function processMessage(msg:XML)
		{

			var fseq:String;
			for each(var node:XML in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "fseq")
					fseq = node.ARGUMENT[1].@VALUE;					
			}
///			trace("fseq = " + fseq);

			for each(var node:XML in msg.MESSAGE)
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
			
							
			for each(var node:XML in msg.MESSAGE)
			{
				if(node.ARGUMENT[0])
				{
					if(node.@NAME == "/tuio/2Dobj")
					{
						var type:String = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var sID = node.ARGUMENT[1].@VALUE;
							var id = node.ARGUMENT[2].@VALUE;
							var x = Number(node.ARGUMENT[3].@VALUE) * stagewidth;
							var y = Number(node.ARGUMENT[4].@VALUE) * stageheight;
							var a = Number(node.ARGUMENT[5].@VALUE);
							var X = Number(node.ARGUMENT[6].@VALUE);
							var Y = Number(node.ARGUMENT[7].@VALUE);
							var A = Number(node.ARGUMENT[8].@VALUE);
							var m = node.ARGUMENT[9].@VALUE;
							var r = node.ARGUMENT[10].@VALUE;
							
							// send object update event..
							
							var objArray:Array = thestage.stage.getObjectsUnderPoint(new Point(x, y));
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.stage.getObjectsUnderPoint(stagePoint);							
							var dobj = null;
							
//							if(displayObjArray.length > 0)								
//								dobj = displayObjArray[displayObjArray.length-1];										

							
						
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y, X, Y, sID, a, dobj);
								thestage.addChild(tuioobj.spr);
								
								objectArray.push(tuioobj);
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;								
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
							}
							
							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.MoveEvent, true, false, x, y, localPoint.x, localPoint.y, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e)
							{
							}

		
						}
						
					} else if(node.@NAME == "/tuio/2Dcur")
					{
//						trace("2dcur");
						var type:String = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var id = node.ARGUMENT[1].@VALUE;
							var x = Number(node.ARGUMENT[2].@VALUE) * stagewidth;
							var y = Number(node.ARGUMENT[3].@VALUE) * stageheight;
							var X = Number(node.ARGUMENT[4].@VALUE);
							var Y = Number(node.ARGUMENT[5].@VALUE);
							var m = node.ARGUMENT[6].@VALUE;
							var area = node.ARGUMENT[7].@VALUE;							
							
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.stage.getObjectsUnderPoint(stagePoint);
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
								tuioobj = new TUIOObject("2Dcur", id, x, y, X, Y, -1, 0, dobj);
								tuioobj.area = area;
								thestage.addChild(tuioobj.spr);								
								objectArray.push(tuioobj);
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.area = area;								
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
							}

							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.MoveEvent, true, false, x, y, localPoint.x, localPoint.y, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
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
				debugText.text = "";
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
						debugText.appendText(objectArray[i].ID + ": (" + int(objectArray[i].x) + "," + int(objectArray[i].y) + ")\n");
				}
			}
		}
		

		
		private static function stopRecording(e:MouseEvent)
		{
			// show XML
			bRecording = false;
			debugMode = false;
			debugText.text = recordedXML.toString();
		}
		
        private static function closeHandler(event:Event):void {
            //trace("closeHandler: " + event);
        }

        private static function connectHandler(event:Event):void {

            trace("connectHandler: " + event);
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