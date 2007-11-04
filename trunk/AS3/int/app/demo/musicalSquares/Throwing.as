//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Extends RotateableScalable and creates throw physics//
////
//////////////////////////////////////////////////////////////////////

package app.demo.musicalSquares
{
	import com.touchlib.*;
	import app.core.action.RotatableScalable;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.touchlib.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class Throwing extends RotatableScalable {

		public var throwBall:Ball = new Ball();

		public var velX:Number = 0.0;
		public var velY:Number = 0.0;
		private var friction:Number = 1;
		private var bounce:Number = -.9;
		public var hitloop:Number;
		public var thisState:String;

		private var ballTween:Tween;

		public function Throwing(size:Number, color:uint) {
			
			bringToFront = false;
			noScale = false;//make it not scale
			noRotate = true;//make it not rotate
			noMove = false;//make it not move			

			//Main Ball
			var throwBall:Ball = new Ball(size, color);
			throwBall.name = "throwBall";

			//Outline
			var ballO:BallOutline = new BallOutline(size, color);

			addChild(throwBall);
			addChild(ballO);

			arrange();
			this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);
			this.addEventListener(Event.UNLOAD, unloadHandler, false, 0, true);
		}
		
		
		private function arrange() {

			throwBall.x = -throwBall.width/2;
			throwBall.y = -throwBall.height/2;
			throwBall.scaleX = 1.0;
			throwBall.scaleY = 1.0;
		}
		
		public function unloadHandler(e:Event)
		{
			//trace("throwing unload");
			this.removeEventListener(Event.ENTER_FRAME, slide );
			this.removeEventListener(Event.UNLOAD, unloadHandler);
		}
		
		public override function released(dx:Number, dy:Number, dang:Number) {

			velX = dx;
			velY = dy;
		}
		
		
		private function slide(e:Event):void {
			
			this.thisState = this.state;			
			
				if (this.x + this.width/2 > 750 || this.x - this.width/2 < 50 ||
				    this.y + this.width/2 > 490 || this.y - this.width/2 < 110) {
					
					if (this.state == "none") {
					
					this.thisState = "release"

					this.removeEventListener(Event.ENTER_FRAME, slide);
					this.addEventListener(TUIOEvent.TUIO_MOVE, this.moveHandler, false, 0, true);
					this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);
					this.addEventListener(TUIOEvent.TUIO_UP, this.upEvent, false, 0, true);
					this.addEventListener(TUIOEvent.TUIO_OVER, this.rollOverHandler, false, 0, true);
					this.addEventListener(TUIOEvent.TUIO_OUT, this.rollOutHandler, false, 0, true);
					this.removeEventListener(Event.ENTER_FRAME, this.update);
				}
			}
	

			if (this.state == "none") {
				if (Math.abs(velX) < 0.001) {
					velX = 0;
				} else {
					x += velX;
					velX *= friction;
				}
				if (Math.abs(velY) < 0.001) {
					velY = 0;
				} else {
					y += velY;
					velY *= friction;
				}
				//Sets boundries off square  
				if (x + this.width/2 > 750) {
					x = 750 - this.width/2;

					velX *= bounce;
					Sounds.sound(this);
					doTween(this);

				} else if (x - this.width/2 < 50) {
					x = this.width/2 + 50;
					velX *= bounce;
					Sounds.sound(this);
					doTween(this);
				}
				if (y + this.width/2 > 490) {
					y = 490 - this.width/2;

					//if (Math.abs(velY) < .9){
					//velY = 0;}
					//else { velY *= bounce; }

					velY *= bounce;
					doTween(this);

					if (Math.abs(velY) > 0.1) {
						Sounds.sound(this);
					}
				} else if (y - this.width/2 < 110) {
					y = this.width/2 + 110;
					velY *= bounce;
					Sounds.sound(this);
					doTween(this);
				}
			}
		}
		
		/////////////////////////////////////////////
		//Change the alpha of the square when it hits
		/////////////////////////////////////////////
		public function doTween(throwBall) {

			ballTween = new Tween(this.getChildByName("throwBall"), "alpha", Regular.easeOut, 1, 0.15, 1, true);
		}
	}
}