package app.demo.musicalSquares
{
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.display.*;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextFieldAutoSize;
		import flash.text.*;
		import flash.geom.Point;
		import com.touchlib.*;
	
	
		public class Colliding extends Sprite {
	
			public var squares:Array;
			private var numSquares:Number = 8;
			private var hitloop:Number = 0;
			//Color of Square
			private var colorArray:Array = new Array(0xED441B, 0xEFD918, 0x70EF18, 0x17F0AF, 
				                                     0x17C6F0, 0xFFFFFF, 0x595959, 0x000000);
			//In case I want to attach the Note name to the Square
			private var letterArr:Array = new Array("C", "D", "E", "F", "G", "A", "B", "C2");
			//private var bounce:Number = -0.8;
			//private var spring:Number = .4;
			//private var friction:Number = 1;
			//private var gravity:Number = 0;
			//public var velX:Number;
			//public var velY:Number;	
	
			public function Colliding() {
	
				init();
			}
			
			private function init():void {
	
				squares = new Array();	

				//Create Squares (balls)
				for (var i:uint = 0; i < numSquares; i++) {
	
					var color = colorArray[i];
					var square:Throwing = new Throwing(25, color);
	
					square.x = (i * 85) + 95 ;
					square.y = 400 + (-i * 30);
					square.velX = 0;
					square.velY = 1;
					square.name = "ball" + i;
					square.getChildByName("throwBall").alpha = .15;

					addChild(square);
					squares.push(square);
				}
				
				newSquares();				
				addEventListener(Event.ENTER_FRAME, checkCollision, false, 0, true);
			}

			public function unload(e:Event)
			{
				trace("unloading..");
				removeEventListener(Event.ENTER_FRAME, checkCollision);
				for (var i:uint = 0; i < numSquares; i++) 
				{
					squares[i].unloadHandler(new Event(Event.UNLOAD));
				}
	
				// remove squares too?
			}

			private function newSquares(){				
				
			for (var j:uint = 0; j < numSquares; j++) {				
	
				var color = colorArray[j];
				var staticSquare:Ball = new Ball(20, color);

				staticSquare.x = 25;
				staticSquare.y = 400 + (-j * 30);
				staticSquare.name = "ball" + j;

				addChild(staticSquare);
				staticSquare.addEventListener(TUIOEvent.TUIO_DOWN, addSquare, false, 0, true);				
				}			
				
			for (var h:uint = 0; h < numSquares; h++) {				
	
				var color = colorArray[h];
				var staticSquare:Ball = new Ball(20, color);

				staticSquare.x = 775;
				staticSquare.y = (h * 30) + 190;
				staticSquare.name = "ball" + h;

				addChild(staticSquare);
				staticSquare.addEventListener(TUIOEvent.TUIO_DOWN, addSquare, false, 0, true);				
				}				
			}
			

			/**********************************************************
			* When pressed, add new square
			***********************************************************/			
			private function addSquare(e:TUIOEvent):void {
				
				switch (e.currentTarget.name) {								
				
				case "ball0" :					
					var color = colorArray[0];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;				
				
				case "ball1" :			
					var color = colorArray[1];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball2" :			
					var color = colorArray[2];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball3" :			
					var color = colorArray[3];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball4" :			
					var color = colorArray[4];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball5" :			
					var color = colorArray[5];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball6" :			
					var color = colorArray[6];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball7" :			
					var color = colorArray[7];
					var square:Throwing = new Throwing(25, color);	
					square.name = e.currentTarget.name;
					break;
			}			
				var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
				var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));
				
				square.x = tuioobj.x;
			    square.y = tuioobj.y;	
			
				addChild(square);
				squares.push(square);	
				
				square.state = "dragging";				
				square.dispatchEvent(new TUIOEvent (TUIOEvent.TUIO_DOWN, false, false, tuioobj.x, tuioobj.y, localPt.x, localPt.y, null, false, false, false, false, 0, "2Dcur", e.ID, e.sID, e.angle));
			}
					
		
			
			private function checkCollision(event:Event):void {
	
				var square0:Throwing;
				var square1:Throwing;
				var j:uint;
				var i:uint = 0;
								
								
				if (squares.length < 1){
					var n:uint = 1;				
			  	   }else
				   {var n:uint = squares.length - 1;				   
			       }				
	
				for (; i < n; i++) {;
	
				square0 = squares[i];
				j = i + 1;
	
				for (; j < squares.length; j++) {
	
					square1 = squares[j];
	
					if (square0.hitTestObject(square1)) {
	
						//Play sound
						Sounds.sound(square0);
						Sounds.sound2(square1);
	
						//Change alpha
						square1.doTween(square0);
						square0.doTween(square1);
	
						//Reaction Code
						var firstVelX:Number = square0.velX;
						var firstVelY:Number = square0.velY;
						square0.velX = square1.velX;
						square0.velY = square1.velY;
						square1.velX = firstVelX;
						square1.velY = firstVelY;
	
						square0.hitloop = 0;
	
						//This part ensures the balls separate from eachother. Better way?
						while (square0.hitTestObject(square1)) {
	
							if (square0.hitloop >= 1) {
								square0.x = square0.x + 1 * (square0.velX - firstVelX) * .5;
								square0.y = square0.y + 1 * (square0.velY - firstVelY) * .5;
							}
							square0.hitloop++;
	
							if (square0.hitloop >= 80) {
								square0.x = square0.x + 15;
								square1.x = square1.x - 15;
							}
						}
					}
				}
			}
			for (i = 0; i < squares.length; i++) {
				var square:Throwing = squares[i];		
				move(square);
			}			
		}
		
		private function move(square:Throwing):void {
	
				 if (square.thisState == "release"){				
				  
					var index = squares.indexOf(square);					
					
					squares.splice(index, 1);	
					//null position in array and delete it
					squares.splice(index, 0);
					//remove eventlistener
					square.removeEventListener(Event.ENTER_FRAME, checkCollision);
					//kill ball
					removeChild(square);					
					//remove All children whithin ball
					while (square.numChildren > 0) {
					       square.removeChildAt(0);
						   
				}
			}
		}
	} 
}