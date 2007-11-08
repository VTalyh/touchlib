package app.demo.artgen
{
	import flash.display.Sprite;
	import com.touchlib.*;
	import app.demo.artgen.*;
	import flash.geom.*;
	
	public class Swarm extends Sprite 
	{

		public var members:Array;
		//public var guide:Sprite;

		public function Swarm() 
		{
			members = new Array();
		}
		
		public function addMember(m:ISwarmMember)
		{
			addChild(m);
			members.push(m);
		}
		
		public function setupInfo(data:XML)
		{
			// FIXME: create members.. 
			// Factory kinda thing.. 
			
			for( var i:int = 0; i<data.numMembers; i++)
			{
				addMember(createMember(data.swarmType, data.algorithm));
				trace("Member");
			}
		}
		
		public function createMember(sz:String, data:XMLList):ISwarmMember
		{
			var m:ISwarmMember;
			switch(sz)
			{
				case "LazyFollower":
					m = new LazyFollower();
					break;
				case "HoppingBugs":
					m = new HoppingBugs();
					break;
				case "Boid":
					m = new Boid();
					break;
			}
			m.setSwarm(this);
			m.setupInfo(data);
			return m;
		}
		

		public function getCentroid():Point
		{

			var pt = new Point();
			for( var i:int = 0; i<members.length; i++)
			{			
				pt.x += members[i].x;
				pt.y += members[i].y;
			}
			
			pt.x /= members.length;
			pt.y /= members.length;
			return pt;
		}
		
		public function getAverageVel():Point
		{
			var pt = new Point();
			for( var i:int = 0; i<members.length; i++)
			{			
				pt.x += members[i].vel.x;
				pt.y += members[i].vel.y;			
			}
			
			pt.x /= members.length;
			pt.y /= members.length;
			return pt;
		}
		
		public function track(pt:Point)
		{
			for(var i:int =0; i<members.length; i++)
			{
				members[i].track(pt);
			}
		}		
		

	}
}