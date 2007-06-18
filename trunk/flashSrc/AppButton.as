package
{
	import flash.display.*;
	import flash.events.*;
	import whitenoise.*;
	import flash.geom.*;
	import flash.display.*;
	import flash.net.URLRequest;	
	
	public class AppButton extends MovieClip
	{
		private var appURL:String;
		public function AppButton ()
		{
			appURL = "photo.swf";
			this.addEventListener(TUIOEvent.DownEvent, this.downEvent);									
		}
		
		public function downEvent(e:MouseEvent)
		{
			 var ldr:Loader = new Loader();
			 var urlReq:URLRequest = new URLRequest(appURL);
			 ldr.load(urlReq);
			 this.root.addChild(ldr);
			

		}
		
	}
}