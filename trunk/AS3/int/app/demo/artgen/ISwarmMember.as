package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import flash.geom.*;	
	
	public class ISwarmMember extends Shape 
	{
		protected var swarm:Swarm;
		public var vel:Point;
	
		public function ISwarmMember() 
		{
			vel = new Point();			
		}
		
		public function track(pt:Point)
		{
		}
		
		public function setSwarm(s:Swarm)
		{
			swarm = s;
		}
		
		public function setupInfo(data:XMLList)
		{
			
		}				
	}
}