// IDEA: use the ability to save animations as code somehow.. 

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
		private var waitCount:int = 5;
		public function ArtGenMain() 
		{
			trace("ArtGenCanvas Initialized");

	
			var spr:Sprite = new Sprite();
			addChild(spr);
			
			s = new Swarm();
			addChild(s);
			
			s.setDrawingCanvas(spr);
			
			s.setupInfo(<swarm>
							<swarmType>HoppingBugs</swarmType>
							<numMembers>5</numMembers>
							<shape>Shape1.swf</shape>
							<algorithm>
								<speed>10</speed>
							</algorithm>
							<trail>
								<lifeTime>1000</lifeTime>
							</trail>
						</swarm>);
			
			addEventListener(Event.ENTER_FRAME, frameUpdate);
			addEventListener(Event.UNLOAD, unloadHandler);
			
			TUIO.init( this, 'localhost', 3000, '', true );			
		}
		
		public function frameUpdate(e:Event)
		{
			s.track(new Point(this.mouseX, this.mouseY));
			waitCount -= 1;
			
			if(waitCount == 0)
			{
				s.draw();
				waitCount = 1;
			}
		}
		
		public function unloadHandler(e:Event)
		{
			removeEventListener(Event.ENTER_FRAME, frameUpdate);			
		}
	}
}