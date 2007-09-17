//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.documentClass
{

	import flash.display.Sprite;
	import flash.system.Capabilities;
	
	import com.touchlib.TUIO;
	import app.createKeyboard.*;

	public class Keyboard extends Sprite {

		private var naturalKeys:CreatingKeyboard;
		private var sharpeKeys:CreatingKeyboard;


		public function Keyboard() {
			
			trace("Keyboard Initialized");

			//Set TUIO Port
			TUIO.init( this, 'localhost', 3000, 800, 600, '', true );
			
			//Create Natural Keys on stage (begin, keyAlpha, keyColor, gradAngle kWidth, kHeight, numKeys, natural, outline)
			naturalKeys = new CreatingKeyboard(0, 1, 0xFFFFFF, 3/2*Math.PI,  stage.stageWidth , stage.stageHeight, 8, true, true);
			addChild(naturalKeys);
			naturalKeys.x = 0;
			naturalKeys.y = 0;
			//naturalKeys.scaleX = .5;
			//naturalKeys.scaleY = .5;

			//Create C# and D# keys on stage (begin, keyAlpha, keyColor, kWidth, kHeight, numKeys, natural, outline)
			sharpeKeys = new CreatingKeyboard(0, 1, 0x000000, 0,  stage.stageWidth , stage.stageHeight, 2, false, false);
			addChild(sharpeKeys);
			sharpeKeys.x = 0;
			sharpeKeys.y = 0;
			//sharpeKeys.scaleX = .5;
			//sharpeKeys.scaleY = .5;

			//Create F#, G#, and A# keys on stage (begin, keyAlpha, keyColor, kWidth, kHeight, numKeys, natural, outline)
			sharpeKeys = new CreatingKeyboard(3, 1, 0x000000, 0, stage.stageWidth , stage.stageHeight, 6, false, false);
			addChild(sharpeKeys);
			sharpeKeys.x = 0;
			sharpeKeys.y = 0;
			//sharpeKeys.scaleX = .5;
			//sharpeKeys.scaleY = .5;
			
			setChildIndex(naturalKeys,1);
			}
		}
	}