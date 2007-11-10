//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.demo.multiKey {

	import flash.display.Sprite;
	import flash.system.Capabilities;
	import com.touchlib.*;
	import app.demo.multiKey.*;
	
	public class MultiKey extends Sprite {
		
		private var octaves1 = 1;   //how many octaves on first keyboard
		private var octaves2 = 2;   //how many octaves on second keyboard
		//private var octaves3 = 1; //how many octaves on third keyboard
		//private var octaves4 = 2; //how many octaves on fourth keyboard
		

		public function MultiKey() {

			TUIO.init( this, 'localhost', 3000, '', false );

			var mainClip:Sprite = new Sprite();	
			this.addChild(mainClip);
						
			//first keyboard							
			var fullPiano = new AddPiano(octaves1);
			//addChild(fullPiano);			
			fullPiano.x = fullPiano.width/2.3;
			fullPiano.y = fullPiano.height/3;			
			fullPiano.scaleX = .32;
			fullPiano.scaleY = .32;
			fullPiano.rotation = 60;				
			
			//second keyboard	
			var fullPiano2 = new AddPiano(octaves2);
			//addChild(fullPiano2);			
			
			if (octaves2 == 1) {
				fullPiano2.scaleX = .8;
				fullPiano2.scaleY = .8;
				fullPiano2.x = fullPiano2.width/1.6;
				fullPiano2.y = fullPiano2.height/1.6;			
			}			
			if (octaves2 == 2){
				fullPiano2.x = fullPiano2.width/4;
				fullPiano2.y = fullPiano2.height/2;			
				fullPiano2.scaleX = .42;
				fullPiano2.scaleY = .42;
			}

			mainClip.addChild(fullPiano);
			mainClip.addChild(fullPiano2);
			
          //Keyboard surface. Needs to be fixed. Keyboards shouldn't move clicking on them (unless highlighted).
			//var pianoSurface = new PianoSurface();
			//pianoSurface.addChild(fullPiano);		
			//pianoSurface.addChild(fullPiano2);
			//addChild(pianoSurface);
			//setChildIndex(pianoSurface, 2) 


			
		}
	}
}