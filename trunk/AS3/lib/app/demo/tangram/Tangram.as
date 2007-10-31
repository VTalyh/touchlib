// This is the class which addes the puzzle pieces to the main stage
// The objects are draggable and Rotatable, however they are not scalable
package app.demo.tangram
{	
	import com.touchlib.*;
	import app.core.action.Rotatable;
	import app.demo.tangram.*;
	
	import flash.events.*;
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
    import flash.display.StageScaleMode;
	import flash.filters.*;
	
	public class Tangram extends Rotatable
	{
		private var tr1:Sprite;
		private var tr2:MovieClip; 
		private var tr3:MovieClip;
		private var tr4:MovieClip;
		private var tr5:MovieClip;
		private var sq1:MovieClip;
		private var bf:BevelFilter;
		private var bevelfilter:Array;
		private var puzzle:MovieClip;
		//private var thestage:Stage;
		
		
		public function Tangram()
		{
			bringToFront = true;
			noScale = true;    //make it not scale
			
			bf = new BevelFilter(2,180,0xEDEDED,0.7,0x808080,0.3,1,1,1,3,"full",false);
			bevelfilter = new Array ();
			bevelfilter.push (bf);
			
			
		
			arrange();
		}
		
		private function arrange() 
		{
				
			tr1 = new t1(); this.addChild(tr1); tr1.x = 400.8-75 ; tr1.y = 234.8; tr1.filters = bevelfilter;
			tr2 = new t2(); this.addChild(tr2); tr2.x = 335.2-75 ; tr2.y = 299.9; tr2.filters = bevelfilter;
			tr3 = new t3(); this.addChild(tr3); tr3.x = 434.3-75 ; tr3.y = 300.0; tr3.filters = bevelfilter;
			tr4 = new t4(); this.addChild(tr4); tr4.x = 335.0-75 ; tr4.y = 398.4; tr4.filters = bevelfilter;
			tr5 = new t5(); this.addChild(tr5); tr5.x = 499.4-75 ; tr5.y = 397.6; tr5.filters = bevelfilter;
			sq1 = new s1(); this.addChild(sq1); sq1.x = 400.6-75 ; sq1.y = 364.8; sq1.filters = bevelfilter;
		   sq2a = new s2a();this.addChild(sq2a);sq2a.x = 500-75 ; sq2a.y = 267; sq2a.filters = bevelfilter;
			
			// the flip gesture
			//sq2a.sq_catch.addEventListener(TUIOEvent.RollOutEvent, function() {sq2a.scaleX= -sq2a.scaleX; },true, 0, true);			
		}						
		
	}//end class
}//end package 