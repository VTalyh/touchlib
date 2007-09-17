//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.documentClass
{

	import flash.display.Sprite;
	
	import com.touchlib.TUIO;
	import app.PaintSurface;

	public class Paint extends Sprite {

		private var naturalPaint:PaintSurface;

		public function Paint() {
		trace("Paint Initialized");
		TUIO.init( this, 'localhost', 3000, 800, 600, '', true );
		var naturalPaint = new PaintSurface();
		this.addChild(naturalPaint);
		}
	}
}