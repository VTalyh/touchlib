package app.demo.pong
{
	import flash.display.MovieClip;
  	import flash.filters.*;
  	
	public class RectangularMovieClip extends MovieClip
	{
		function setDimensions(width:Number, height:Number, color)
		{
			
			this.graphics.beginFill(color, 1.0);
			this.graphics.drawRoundRect(0, 0, width, height,10);
			this.graphics.endFill();
			var _shadow : DropShadowFilter = new DropShadowFilter(4,30,0,.5,20,20);
			this.filters = [_shadow];
		}
	}
}