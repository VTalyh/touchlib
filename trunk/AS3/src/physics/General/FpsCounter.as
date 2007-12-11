//===========================================================
//=========================================================//
//						-=ANTHEM=-
//	file: .as
//
//	copyright: Matthew Bush 2007
//
//	notes:
//
//=========================================================//
//===========================================================



//===========================================================
// FPS COUNTER CLASS
//===========================================================
package General{
	
	import flash.display.Sprite;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.events.*;
	import flash.system.System;
	
	public class FpsCounter extends Sprite{
		
		//======================
		// constructor
		//======================
		public function FpsCounter(){
			
			// create text field
			textBox = new TextField();
			textBox.text = "fps average";
			textBox.textColor = 0xaa1144;
			textBox.selectable = false;
			
			textBox2 = new TextField();
			textBox2.text = "fps (physics)";
			textBox2.textColor = 0xaa1144;
			textBox2.selectable = false;
			textBox2.y = 15;
			
			textBox3 = new TextField();
			textBox3.text = "memory wasted";
			textBox3.textColor = 0xaa1144;
			textBox3.selectable = false;
			textBox3.y = 30;
			
			// set initial lastTime
			oldT = getTimer();
			
			addChild(textBox);
			addChild(textBox2);
			addChild(textBox3);
		}
		
		//======================
		// update function
		//======================
		public function update(){
			var newT:uint = getTimer();
			var f1:uint = newT-oldT;
			mfpsCount += f1;
			if (avgCount < 1){
				textBox.text = String(Math.round(1000/(mfpsCount/30))+" fps average");
				avgCount = 30;
				mfpsCount = 0;
			}
			avgCount--;
			oldT = getTimer();
			
			textBox3.text = Math.round(System.totalMemory/(1024*1024)) + " MB used"
			
		}
		
		
		public function updatePhys(oldT2:uint){
			var newT:uint = getTimer();
			var f1:uint = newT-oldT2;
			mfpsCount2 += f1;
			if (avgCount2 < 1){
				textBox2.text = String(Math.round(1000/(mfpsCount2/30))+" fps (physics)");
				avgCount2 = 30;
				mfpsCount2 = 0;
			}
			avgCount2--;
		}
		
		
		//======================
		// updateend function
		//======================
		public function updateEnd(){
			// wrong
			/*var newT:uint = getTimer();
			var f1:uint = newT-oldT;
			mfpsCount2 += f1;
			if (avgCount2 < 1){
				textBox2.text = String(Math.round(1000/(mfpsCount2/30))+" fps uncapped");
				avgCount2 = 30;
				mfpsCount2 = 0;
			}
			avgCount2--;*/
			
		}
		
		
		//======================
		// private variables
		//======================
		var textBox:TextField;
		var textBox2:TextField;
		var textBox3:TextField;
		var mfpsCount:int = 0;
		var mfpsCount2:int = 0;
		var avgCount:int = 30;
		var avgCount2:int = 30;
		var oldT:uint;
	}
}




// End of file
//===========================================================
//===========================================================


