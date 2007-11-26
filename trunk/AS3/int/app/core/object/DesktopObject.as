package app.core.object
{ 			
    import flash.display.Sprite;
    import fvnc.FVNC;
	import fvnc.events.FVNCEvent;
	import fvnc.events.ConnectEvent;		
	
	import app.core.action.RotatableScalable;	
	
	 public class DesktopObject extends Sprite {	 
	 			
	 public var remoteScreen:FVNC;		
	
	 public function DesktopObject(host:String, port:Number, fitScreen:Boolean):void
			{
				remoteScreen = new FVNC()
				remoteScreen.host = host;
				remoteScreen.port = port;
				remoteScreen.fitToScreen = fitScreen;				
				this.addChild(remoteScreen);
			
				try
				{
					remoteScreen.connect();					
					//stage.focus = remoteScreen;	
				}
				catch ( e:Error )
				{
					trace(e);
				}
				
			}	
	}
}

		   
		