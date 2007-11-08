package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import flash.geom.*;	
	
	public class Boid extends ISwarmMember 
	{

		var state:int;
		
		private var tmp:Point;		

		public function Boid() 
		{
			tmp = new Point();
			
			graphics.beginFill(0xff0000);
			graphics.drawCircle(0,0, 10);
			graphics.endFill();
		}
		
		override public function track(pt:Point)
		{

			tmp.x = pt.x - this.x + (Math.random()*10);
			tmp.y = pt.y - this.y + (Math.random()*10);
			vel = Point.interpolate (tmp, vel, 0.01);

			var cent:Point = swarm.getCentroid();

			tmp.x = cent.x - this.x;
			tmp.y = cent.y - this.y;			
			vel = Point.interpolate (tmp, vel, 0.04);

			var avgvel:Point = swarm.getAverageVel();
		
//			tmp.x = avgvel.x - this.vel.x;
//			tmp.y = avgvel.y - this.vel.y;			
			vel = Point.interpolate (avgvel, vel, 0.04);
			

			var dist:Number;			
			for(var i:int = 0; i<swarm.members.length; i++)
			if(swarm.members[i] != this)			
			{

				dist = Point.distance(new Point(this.x, this.y), new Point(swarm.members[i].x, swarm.members[i].y)) + 1;

				vel.x -= (10.1 * (swarm.members[i].x - this.x)) / (dist * dist);
				vel.y -= (10.1 * (swarm.members[i].y - this.y)) / (dist * dist);				

			}
		

			this.x += vel.x;
			this.y += vel.y;

		}
		
		override public function setupInfo(data:XMLList)
		{

			
		}		
	}
}