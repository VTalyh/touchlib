//This class adds a puzzle bar on the right, which gives the user an option to select a puzzle out of 20 preset puzzles

package app.demo.tangram
{	
	import com.touchlib.*;
	import app.core.action.Scrollable;
	
	import flash.events.*;
	import flash.display.*;	
	import flash.display.MovieClip;
	import flash.events.Event;	
	import flash.filters.*;
	
	public class PuzzleBar extends Scrollable
		{
			public var scroller:Sprite;
			private var velX:Number = 0.0;
			private var velY:Number = 0.0;			
			private var velAng:Number = 0.0;		
			private var friction:Number = 0.8;
			private var angFriction:Number = 0.92;
			
			private var currpuzz:Sprite;
			private var initDepth:Number;
		
			
						
			public function PuzzleBar()
			{
				
				trace("[MY TANGRAM ] > [PUZZLEBAR.AS ] > INSTANTIATING PUZZLE BAR");
				bringToFront = true;
				noScale = true;               //make it not scale
				noRotate = true;
				
				scroller = new myscroll(); this.addChild(scroller);
				scroller.x = 725 ; scroller.y = 250;												
				this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);
				
				
				
			}
			
			
			
			public override function released(dx:Number, dy:Number, dang:Number)
			{
				velX = dx;			
				velY = dy;					
				velAng = dang;
			}
		
			private function slide(e:Event):void 
			{
				if(this.state == "none")
				{		
					if(Math.abs(velX) < 0.001)
						velX = 0;
					else {
						x += velX;
						velX *= friction;										
					}
					if(Math.abs(velY) < 0.001)
						velY = 0;					
					else {
						y += velY;
						velY *= friction;						
					}
					if(Math.abs(velAng) < 0.001)
						velAng = 0;					
					else {
						velAng *= angFriction;				
						this.rotation += velAng;					
					}
				}
			}
			
				
					
	}//end class
	
}//end package 