package app.documentClass
{
	import flash.display.Sprite;
	import com.touchlib.*;
	import app.RippleSurface;
	
	public class Ripples extends Sprite {
		
		private var subobj:RippleSurface;
		
		public function Ripples() {
		
		trace("Ripples Initialized");
		TUIO.init( this, 'localhost', 3000, 800, 600, '', true );
		var subobj = new RippleSurface();
		this.addChild(subobj);

		}
	}
}