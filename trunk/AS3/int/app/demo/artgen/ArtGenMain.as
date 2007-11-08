package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import app.demo.artgen.*;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ArtGenMain extends MovieClip 
	{
		private var s:Swarm = null;

		public function ArtGenMain() 
		{
			trace("ArtGenCanvas Initialized");

	
			s = new Swarm();
			addChild(s);
			
			s.setupInfo(<swarm>
							<swarmType>Boid</swarmType>
							<numMembers>10</numMembers>
							<algorithm>
								<speed>10</speed>
							</algorithm>
						</swarm>);
			
			addEventListener(Event.ENTER_FRAME, frameUpdate);
			addEventListener(Event.UNLOAD, unloadHandler);
			
			TUIO.init( this, 'localhost', 3000, '', true );			
		}
		
		public function frameUpdate(e:Event)
		{
			s.track(new Point(this.mouseX, this.mouseY));
		}
		
		public function unloadHandler(e:Event)
		{
			removeEventListener(Event.ENTER_FRAME, frameUpdate);			
		}
	}
}