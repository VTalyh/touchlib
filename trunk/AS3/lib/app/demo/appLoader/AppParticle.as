package app.demo.appLoader
{
	import com.touchlib.*;
	import app.demo.appLoader.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import fl.controls.Button;
	import flash.text.*;
	import flash.net.*;
	
	public class AppParticle extends Sprite
	{
		private var direction:int = 0;		
		private var dirChangeCount:int = 0;
		
		private var cursor:Point;
		
		private var upVec:Point;
		
		private var history:Array;
		
		function AppParticle()
		{
			direction = int(Math.random()*8);
			dirChangeCount = int(Math.random()*50);
			upVec = new Point();
			cursor = new Point(0,0);
			addEventListener(Event.ENTER_FRAME, frameUpdate);
		}
		
		function frameUpdate()
		{
			// FIXME: draw from last history point to cursor
			
			var m:Matrix = new Matrix();
			m.rotate(direction * Math.PI / 4.0);
			var delta:Point = m.transformPoint(upVec);
			
			cursor += delta;

			dirChangeCount -= 1;
			
			if(dirChangeCount <= 0)
			{
				direction += int(Math.random()*4)-2;
				dirChangeCount = int(Math.random()*50);
			
				history.push(new Point(cursor.x, cursor.y));
				
				if(history.length >= 10)
				{
					history.splice(0, 1);
				}
				
				this.graphics.clear();
				
				for(var i:int =0; i<history.length; i++)
				{
					// FIXME: draw history.. 
				}
			
			}						
			
			
		}
	}
}