package app.demo.pong
{
	/**
	 * A wall, which serves as a game boundary
	 */
	public class Wall extends RectangularMovieClip implements Bouncer
	{
		/**
		 * Bounce a ball off of the wall.
		 * @param ball Ball to bounce
		 */
		public function bounce(ball:Ball):void
		{
			// Reverse Y direction and bounce
			ball.vY = -ball.vY;
			ball.y += ball.vY;
		}
	}
}