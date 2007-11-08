package app.demo.artgen
{
	import flash.display.Sprite;
	import com.touchlib.*;

	public class ArtGenMain extends MovieClip {


		public function ArtGenMain() {
			trace("ArtGenCanvas Initialized");
			TUIO.init( this, 'localhost', 3000, '', true );

		}
	}
}