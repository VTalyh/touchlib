//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Extends RotateableScalable and creates throw physics//
////
//////////////////////////////////////////////////////////////////////

package app.MusicalSquares{

	import com.touchlib.*;
	import app.MusicalSquares.RotatableScalable;
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



		public function Throwing(size:Number, color:uint) {

			//Main Ball
			var throwBall:Ball = new Ball(size, color);
			throwBall.name = "throwBall";

			//Outline
			var ballO:BallOutline = new BallOutline(size, color);

			bringToFront = false;
			noScale = false;//make it not scale
			noRotate = true;//make it not rotate
			noMove = false;//make it not move

			addChild(throwBall);
			addChild(ballO);

			arrange();
			this.addEventListener(Event.ENTER_FRAME, slide);
		}
		
		
		private function arrange() {

			throwBall.x = -throwBall.width/2;
			throwBall.y = -throwBall.height/2;
			throwBall.scaleX = 1.0;
			throwBall.scaleY = 1.0;
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
					this.removeEventListener(TUIOEvent.MoveEvent, this.moveHandler);
					this.removeEventListener(TUIOEvent.DownEvent, this.downEvent);
					this.removeEventListener(TUIOEvent.UpEvent, this.upEvent);
					this.removeEventListener(TUIOEvent.RollOverEvent, this.rollOverHandler);
					this.removeEventListener(TUIOEvent.RollOutEvent, this.rollOutHandler);
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

			var ballTween = new Tween(this.getChildByName("throwBall"), "alpha", Regular.easeOut, 1, 0.15, 1, true);
		}
	}
}