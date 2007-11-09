package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import app.demo.artgen.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.events.*;
	
	public class Swarm extends Sprite 
	{
		public var members:Array;
		public var shapeloader:URLLoader;
		//public var guide:Sprite;
		
		private var drawingCanvas:Sprite;
		
		private var xmlSetupInfo:XML;

		public function Swarm() 
		{

			members = new Array();
		}
		
		public function setDrawingCanvas(dc:Sprite)
		{
			drawingCanvas = dc;
		}
		
		public function addMember(m:ISwarmMember)
		{
			addChild(m);
			members.push(m);
		}
		
		public function setupInfo(data:XML)
		{
			trace("www/shapes/" + data.shape);
			xmlSetupInfo = data;
			shapeloader = new URLLoader( );	
			shapeloader.dataFormat = URLLoaderDataFormat.BINARY;
			shapeloader.load( new URLRequest(	"www/shapes/" + data.shape ) );
			shapeloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderEvent);

			shapeloader.addEventListener(Event.COMPLETE, loaderEvent);
			
			// FIXME: create members.. 
			// Factory kinda thing.. 
			
			for( var i:int = 0; i<data.numMembers; i++)
			{
				addMember(createMember(data.swarmType, data.algorithm));
				trace("Member");
			}
		}
		
		public function loaderEvent(e:Event)
		{
			trace("URLLoader event " + e.type);
			
			if(e.type == "complete")
			{
				trace(shapeloader.dataFormat);
				trace(shapeloader.data);
				trace(shapeloader.bytesLoaded);
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
				case "Boid2":
					m = new Boid2();
					break;					
			}
			m.x = 400;
			m.y = 400;
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
		
		public function draw()
		{

//			drawingCanvas.graphics.beginFill(0xffffff);
			if(shapeloader.data != null)
			{
				for(var i:int =0; i<members.length; i++)
				{
	//				drawingCanvas.graphics.drawCircle(members[i].x, members[i].y, 5);


					var t:Sprite = new Trail(xmlSetupInfo.trail, shapeloader.data);
					t.x = members[i].x;
					t.y = members[i].y;
					
					t.rotation = members[i].rotation; //+ Math.random()*40;
	// Math.atan2(members[i].vel.x, members[i].vel.y) * 180 / Math.PI;
					
					drawingCanvas.addChild(t);
					t = null;
				}
			}			
//			drawingCanvas.graphics.endFill();
try {
   new LocalConnection().connect('foo');
   new LocalConnection().connect('foo');
} catch (e:*) {}


		}
		

	}
}