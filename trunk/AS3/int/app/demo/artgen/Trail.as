package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import flash.geom.*;	
	import flash.utils.*;
	import flash.net.*;
	import flash.events.Event;
	
	public class Trail extends Sprite
	{
		private var ldr:Loader;
		private var startTimeMS:int;
		private var lifeTime:int;
		function Trail(info:XMLList, bytes:ByteArray)
		{
			ldr = new Loader();
			addChild(ldr);
			ldr.loadBytes(bytes);
			
			lifeTime = info.lifeTime;
			
			var d:Date=  new Date();
			startTimeMS = d.time;

			
			this.addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);
		}
		
		function frameUpdate(e:Event)
		{
			var d:Date = new Date();
			var curTime:int = d.time;			
			
			// fixme: add frame by frame modulations..

			if(curTime - startTimeMS > lifeTime)
			{
//				this.visible = false;
				ldr.unload();
				removeEventListener(Event.ENTER_FRAME, frameUpdate);
				this.parent.removeChild(this);
				removeChild(ldr);
				ldr = null;

				delete this;
			}
			
		}
	}
}