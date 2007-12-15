package app.demo.pong
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.*;
	import app.core.utl.FPS;

	public class PongGame extends MovieClip
	{
	
		static var playArea:Rectangle;
		private var gameOver:GameOver = new GameOver();
		private var scores:Score = new Score();
		
		//private var aiPaddle:AIPaddle = new AIPaddle();
		
		private var userPaddle1:UserPaddle = new UserPaddle();		
		private var userPaddle2:UserPaddle = new UserPaddle();
		
		private var ball:Ball = new Ball();		
		private var ballTrail = new BallFade();

		private var wallTop:Wall = new Wall();
		private var wallBottom:Wall = new Wall();
			
		private var net:Net = new Net();
		
		function PongGame()
		{	
			TUIO.init( stage, 'localhost', 3000, '', true );	
			
			var wallHeight:Number = 10;
			
			PongGame.playArea = new Rectangle(
				0,
				wallHeight,
				this.stage.stageWidth,
				this.stage.stageHeight - wallHeight
			);
			
			// Setup the graphical elements on the stage
			//this.ball.setDimensions(20, 20);
			this.wallTop.setDimensions(this.stage.stageWidth, wallHeight, 0x000000);
			this.wallBottom.setDimensions(PongGame.playArea.width, wallHeight, 0x000000);
			this.userPaddle1.setDimensions(50, 150, 0xFF0000);
			this.userPaddle2.setDimensions(50, 150, 0x0000FF);
			//this.aiPaddle.setDimensions(15, 75);
			this.wallTop.y -= this.wallTop.height;
			this.wallBottom.y = this.stage.stageHeight;// - this.wallBottom.height;
			//this.scores.y = this.wallTop.y + this.wallTop.height;
			this.userPaddle1.x = 18;
			this.userPaddle1.y = 161.9;
			this.userPaddle2.x = 1024-18-this.userPaddle2.width;
			this.userPaddle2.y = 161.9;			
			
			// Add all the graphical elements to the stage
			addChild(this.scores);
			addChild(this.gameOver);
			//addChild(this.aiPaddle);
			addChild(this.ball);
			addChild(this.ballTrail);
			addChild(this.userPaddle1);
			addChild(this.userPaddle2);
			addChild(this.wallTop);
			addChild(this.wallBottom);
		//	addChild(this.ad);
		
			//addChild(this.net);

			// Bound the paddles top to the bottom of the top wall and bottom to the top of
			// the bottom wall
			Paddle.topBound = this.wallTop.y + this.wallTop.height;
			Paddle.bottomBound = this.wallBottom.y - this.userPaddle1.height;
			
			// Inform the AI paddle about the ball so it can try to hit it
			//this.aiPaddle.ball = this.ball;

			// Set up the ball to bounce off the paddles and walls
			this.ball.bouncers = [
				this.userPaddle1,
				this.userPaddle2,
				//this.aiPaddle,
				this.wallTop,
				this.wallBottom
			];
			
			// Reset the game to initialize it
			reset(true);
			
			// Lock the player's paddle to the mouse to give them control
			this.userPaddle1.lockToMouse();
			this.userPaddle2.lockToMouse();
			
			// Update the game every time a frame is played
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Reset the game. The game should be initialized first.
		 * @param clearScores If scores should be cleared as well
		 */
		private function reset(clearScores:Boolean):void
		{
			// Hide the game over
			this.gameOver.visible = false;

			// Set the ball's initial position to be the center of the stage
			this.ball.x = (this.stage.stageWidth - this.ball.width)/2;
			this.ball.y = (this.stage.stageHeight - this.ball.height)/2;
			
			// Serve the ball by giving it a random initial velocity
			this.ball.vX = (Math.random() % 2 == 0 ? 1 : -1) * 10;
			this.ball.vY = Math.random() % 5;
			
			// Reset the scores
			if (clearScores)
			{
				setGameScore(0, 0);
			}
		}
	
		/**
		 * End the game and wait for the user to restart it
		 * @param msg Message to display to the player while the game is over
		 */
		private function endGame(msg:String):void
		{
			// Show the requested message
			this.gameOver.setMessage(msg);
			this.gameOver.x = (this.stage.stageWidth - this.gameOver.width) / 2;
			this.gameOver.y = (this.stage.stageHeight - this.gameOver.height) / 2;
			this.gameOver.visible = true;
			
			// Stop allowing the player to control the paddle
			this.userPaddle1.unlockFromMouse();
			
			// Stop the ball
			this.ball.vX = this.ball.vY = 0;
			
			// Listen for the user pressing the mouse. When they do, reset and play again
			this.stage.addEventListener(MouseEvent.CLICK, gameOverMouseListener);
			this.stage.addEventListener(TouchEvent.MOUSE_DOWN, gameOverMouseListener);
			
			// Wait for the user to press the mouse
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Listen for mouse clicks on the game over screen
		 * @param event Mouse click event to respond to
		 */
		private function gameOverMouseListener(event:Event):void
		{
			// Reset the game and stop listening for the user to do so again
			reset(true);
			this.stage.removeEventListener(MouseEvent.CLICK, gameOverMouseListener);
			this.stage.removeEventListener(TouchEvent.MOUSE_DOWN, gameOverMouseListener);
			// Play the game again
			this.userPaddle1.lockToMouse();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Update the game
		 * @param event Event we are updating for
		 */
		private function update(event:Event):void
		{
			// Update the AI's paddle
			//this.aiPaddle.update();
			ballTrail.x = ball.ballX - ball.vX*1;
			ballTrail.y = ball.ballY - ball.vY*1;
			
			
			// Update the ball's movement and check for the game over condition
			var winnerIndex:Number = this.ball.update();
			switch (winnerIndex)
			{
				case 0:
				case 1:
					// Award a point to the player who scored it
					var oldScores:Array = this.scores.getScores();
					oldScores[winnerIndex]++;
					setGameScore(oldScores[0], oldScores[1]);
			
					// If the player who scored won, end the game
					var newScores:Array = this.scores.getScores();
					if (newScores[winnerIndex] == 5)
					{
						endGame(winnerIndex == 0 ? "Red Wins!" : "Blue Wins!");
					}
					// Otherwise, start a new round after a little bit
					else
					{
						reset(false);
					}
					break;
			}
			
			// If the game is not over, keep running the game by going to our own frame
			// to form the main loop
			//gotoAndPlay(1);
		}
		
		/**
		 * Set the score of the game and update the score display
		 * @param player The player's score
		 * @param ai The AI's score
		 */
		private function setGameScore(player:Number, ai:Number)
		{
			this.scores.setScore(player, ai);
			this.scores.x = (this.stage.stageWidth - this.scores.width) / 2;
		}
	}
}