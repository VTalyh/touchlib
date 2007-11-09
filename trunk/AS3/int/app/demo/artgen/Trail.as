package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import flash.geom.*;	
	import flash.utils.*;
	
	public class Trail extends Sprite
	{
		private var ldr:Loader;
		private var lifeTimer:Timer;
		private var startTimeMS:Number;
		function Trail(info:XMLList)
		{
			ldr = new Loader();
			addChild(ldr);
			ldr.load(new URLRequest("www/shapes/" + info.name));
			
			lifeTimer = new Timer(info.lifeTime, 0);
			lifeTimer.start();
			var d:Date=  new Date();
			startTimeMS = d.time;
			

		}
	}
}