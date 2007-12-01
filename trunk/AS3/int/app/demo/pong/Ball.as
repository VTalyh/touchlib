package app.demo.pong
{
	import flash.display.Sprite; 	
	import flash.filters.*;

	public class Ball extends Sprite
	{
		var vX:Number = 0;
		var vY:Number = 0;

		var bouncers:Array;
		
		var ball:Sprite;
		
		var ballX:Number;
		var ballY:Number;

		 public function Ball(){
			 			

			var ball=new Sprite();
			ball.graphics.beginFill(0xFFFFFF,0.85);
			ball.graphics.drawCircle(0,0,25);		
			this.addChild(ball);
			//var blurfx:BlurFilter = new BlurFilter(10, 10, 1);
			//this.filters = [blurfx];
			 
			 
			 }
		 
		 
		function update():Number
		{
			// Update based on velocity
			this.x += vX;
			this.y += vY;
			
			ballX = this.x;
			ballY = this.y;
			
			
			// Check if we've gone off the left side (P2 wins)
			if (this.x < PongGame.playArea.x)
			{
				return 1;
			}

			// Check if we've gone off the right side (P1 wins)
			if (this.x >= PongGame.playArea.x + PongGame.playArea.width)
			{
				return 0;
			}
			
			// Check if we hit any of the bouncers. If we did, have it bounce us.
			for (var it:String in this.bouncers)
			{
				var bouncer:Bouncer = this.bouncers[it];
	
				// Check if we hit the current bouncer
				if (hitTestObject(bouncer))
				{
					// Bounce off the current bouncer and stop checking
					bouncer.bounce(this);
					break;
				}
			}
			
			return -1;
		}
	}
}