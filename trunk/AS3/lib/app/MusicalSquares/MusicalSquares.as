package app.MusicalSquares {

	import flash.display.Sprite;
	import com.touchlib.*;


	public class newMain extends Sprite {

		public function newMain() {

			TUIO.init( this, 'localhost', 3000, '', false );

			var it:Colliding = new Colliding();
			addChild(it);
			it.x = 0;
			it.y = 0;

		}
	}
}