package
{
	import flash.display.*;
	import flash.events.*;
	import whitenoise.*;
	import flash.geom.*;
	import flash.display.*;
	 import flash.net.URLRequest;	
	
	public class AppClose extends MovieClip
	{
		public function AppClose ()
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.downEvent);									
		}
		
		public function downEvent(e:MouseEvent)
		{
			delete this.root;
			

		}
		
	}
}