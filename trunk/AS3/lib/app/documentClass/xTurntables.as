package app.documentClass
{
	import flash.display.MovieClip;
	import com.touchlib.*;
	
	public class Turntables extends MovieClip {
		
		public function Turntables() {
		
		trace("Ripples Initialized");
		TUIO.init( this, 'localhost', 3000, '', true );

		}
	}
}