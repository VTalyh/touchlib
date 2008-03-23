package app.core.utl
{
	import flash.display.*;		
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class GestureSimulator
	{
		var gesture:int;
		var centerX:Number;
		var centerY:Number;
		var numBlobs:int;
		
		var aBlobs:Array;
		
		var updateTimer:Timer;
		
		var deleteTimer:Timer;
		
		var target:EventDispatcher;
		public function GestureSimulator(targ:EventDispatcher, g:int, x:Number, y:Number, num:int, rad:Number)
		{
			target = targ;
			gesture = g;
			centerX = x;
			centerY = y;
			numBlobs = num;
			
			var i:int;
			
			aBlobs = new Array();
			for(i=0; i<numBlobs; i++)
			{
				
				var to:TUIOObject = new TUIOObject("2DObj", int(Math.random()*65536), x + 2.0*(Math.random()-0.5)*rad, y + 2.0*(Math.random()-0.5)*rad, 0,0, -1, 0, 10, 10, target);
				to.addListener(target);
				to.notifyCreated();				
				aBlobs.push(to);

			}
			
			updateTimer = new Timer(1000/30);
			updateTimer.addEventListener(TimerEvent.TIMER, updateBlobs);
			updateTimer.start();
			deleteTimer = new Timer(1000);
			deleteTimer.addEventListener(TimerEvent.TIMER, deleteMe);			
			deleteTimer.start();
			
		}
		
		public function updateBlobs(e:Event)
		{
			var i:int;
			
			//trace("Updating");
		
			if(gesture == 0)
			{
			
				for(i=0; i<aBlobs.length; i++)
				{
					var m:Matrix = new Matrix();
					var p:Point = new Point(aBlobs[i].x - centerX, aBlobs[i].y - centerY);
					m.rotate(Math.PI * 0.01);
					p = m.transformPoint(p);					
				
				
					aBlobs[i].x = p.x + centerX;
					aBlobs[i].y = p.y + centerY;					

					aBlobs[i].notifyMoved();
				}
			}
			
			if(gesture == 1)
			{

				for(i=0; i<aBlobs.length; i++)
				{
					var m:Matrix = new Matrix();
					var p:Point = new Point(aBlobs[i].x - centerX, aBlobs[i].y - centerY);
					m.scale(0.95, 0.95);
					p = m.transformPoint(p);

					aBlobs[i].x = p.x + centerX;
					aBlobs[i].y = p.y + centerY;

					aBlobs[i].notifyMoved();
				}
			}
			
			if(gesture == 2)
			{
				for(i=0; i<aBlobs.length; i++)
				{
					var m:Matrix = new Matrix();
					var p:Point = new Point(aBlobs[i].x - centerX, aBlobs[i].y - centerY);
					m.rotate(Math.PI * 0.01);
					m.scale(1.05, 1.05);					
					p = m.transformPoint(p);

					aBlobs[i].x = p.x + centerX;
					aBlobs[i].y = p.y + centerY;

					aBlobs[i].notifyMoved();
				}
			}			
		}
		
		public function deleteMe(e:Event)
		{
			for(i=0; i<aBlobs.length; i++)
			{
				aBlobs[i].notifyRemoved();
			}			
			
			aBlobs = null;
			
			updateTimer.removeEventListener(TimerEvent.TIMER, updateBlobs);
			deleteTimer.removeEventListener(TimerEvent.TIMER, deleteMe);
			updateTimer.stop();
			deleteTimer.stop();
			updateTimer = null;
			deleteTimer = null;
		}
	}
}