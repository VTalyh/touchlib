package app.demo.musicalSquares 
{
	import flash.display.Sprite;
	import com.touchlib.*;
	import flash.events.*;
	import app.demo.musicalSquares.*;

	public class MusicalSquares extends Sprite {

		private var collider:Colliding;
		
		public function MusicalSquares() {

			TUIO.init( this, 'localhost', 3000, '', false );

			collider = new Colliding();
			addChild(collider);
			collider.x = 0;
			collider.y = 0;
			
			addEventListener(Event.UNLOAD, collider.unload, false, 0, true);
		}
		
		function unloadHandler(e:Event)
		{
			trace("UNLOAD event");
			
			//collider(unload);
		}
	
	}
}