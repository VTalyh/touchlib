﻿package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import flash.geom.*;	
	
	public class Boid2 extends ISwarmMember 
	{

		var state:int;
		
		private var tmp:Point;		
		
		private var vec:Point;
		private var ang:Number;
		
		private var angle:Number = 0;

		public function Boid2() 
		{
			tmp = new Point();
			vec = new Point(0.0, -1.0);
			/*
			graphics.beginFill(0xff0000);
			graphics.drawCircle(0,0, 4);
			graphics.endFill();
			*/
		}
		
		override public function track(pt:Point)
		{
			if(Math.random() > 0.6)
			{
				tmp.x = pt.x - this.x;
				tmp.y = pt.y - this.y;
				tmp.normalize(1.0);
	
				ang = Math.atan2(tmp.x, tmp.y);
			}
				//trace(angle + " / " + ang);
				var dist1 = Math.abs(ang - angle);
				var dist2 = Math.abs((Math.PI*2) - dist1);

	
				if(ang > this.angle)
				{				
					if(dist1 < dist2)
						angle += Math.PI/20;
					else
						angle -= Math.PI/20;	
						
				} 
				if(ang <= this.angle)
				{
					if(dist1 < dist2)
						angle -= Math.PI/30;	
					else
						angle += Math.PI/30;	
				}
				
				if(angle > Math.PI)
					angle -= Math.PI*2.0;
				if(angle < -Math.PI)
					angle += Math.PI*2.0;
					
				var mat:Matrix = new Matrix();
				mat.rotate(-this.angle + (Math.PI));
				vel = mat.transformPoint(vec);
	
				vel.normalize(10.0);
				
			var dist:Number;			
			for(var i:int = 0; i<swarm.members.length; i++)
			if(swarm.members[i] != this)			
			{

				dist = Point.distance(new Point(this.x, this.y), new Point(swarm.members[i].x, swarm.members[i].y)) ;
				
				dist -= 40;
				
				if(dist < 1)
					dist = 1;

				vel.x -= (1.1 * (swarm.members[i].x - this.x)) / (dist * dist);
				vel.y -= (1.1 * (swarm.members[i].y - this.y)) / (dist * dist);				

			}				
			
			this.rotation = 360 - (angle * 180.0 / Math.PI);

				
			

			this.x += vel.x;
			this.y += vel.y;

		}
		
		override public function setupInfo(data:XMLList)
		{

			
		}		
	}
}