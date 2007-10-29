//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.demo.piano
{

	import flash.display.Sprite;
	import flash.system.Capabilities;
	
	import com.touchlib.TUIO;
	import app.demo.piano.*;

	public class Piano extends Sprite {

		private var naturalKeys:CreatingKeyboard;
		private var sharpeKeys:CreatingKeyboard; 


		public function Piano() {
			
			trace("Keyboard Initialized");
			
			var wd:int;
			var ht:int;
			
			if(stage)
			{
				wd = stage.stageWidth;
				ht = stage.stageHeight;
				
			
				//Set TUIO Port
				TUIO.init( this, 'localhost', 3000, '', true );				
			} else {
				wd = 800;
				ht = 600;
			}

			//Create Natural Keys on stage (begin, keyAlpha, keyColor, gradAngle kWidth, kHeight, numKeys, natural, outline)
			naturalKeys = new CreatingKeyboard(0, 1, 0xFFFFFF, 3/2*Math.PI,  wd, ht, 8, true, true);
			addChild(naturalKeys);
			naturalKeys.x = 0;
			naturalKeys.y = 0;
			//naturalKeys.scaleX = .5;
			//naturalKeys.scaleY = .5;
			//Create C# and D# keys on stage (begin, keyAlpha, keyColor, kWidth, kHeight, numKeys, natural, outline)
			sharpeKeys = new CreatingKeyboard(0, 1, 0x000000, 0,  wd, ht, 2, false, false);
			addChild(sharpeKeys);
			sharpeKeys.x = 0;
			sharpeKeys.y = 0;
			//sharpeKeys.scaleX = .5;
			//sharpeKeys.scaleY = .5;

			//Create F#, G#, and A# keys on stage (begin, keyAlpha, keyColor, kWidth, kHeight, numKeys, natural, outline)
			sharpeKeys = new CreatingKeyboard(3, 1, 0x000000, 0, wd, ht, 6, false, false);
			addChild(sharpeKeys);
			sharpeKeys.x = 0;
			sharpeKeys.y = 0;
			//sharpeKeys.scaleX = .5;
			//sharpeKeys.scaleY = .5;
			
			//setChildIndex(naturalKeys,1);

			}
		}
	}