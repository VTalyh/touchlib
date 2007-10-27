package app.demo.musicalSquares 
{
	import flash.display.Sprite;
	import com.touchlib.*;
	import app.demo.musicalSquares.*;

	public class MusicalSquares extends Sprite {

		public function MusicalSquares() {

			TUIO.init( this, 'localhost', 3000, '', false );

			var it:Colliding = new Colliding();
			addChild(it);
			it.x = 0;
			it.y = 0;

		}
	}
}