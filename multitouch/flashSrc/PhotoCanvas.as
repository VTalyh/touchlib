package {
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import whitenoise.*;	
	import flash.geom.*;		
	
	public class PhotoCanvas extends RotatableScalable
	{

		
		private var clickgrabber:Shape = new Shape();				
		private var sizeX:int = 2000;
		private var sizeY:int = 2000;
		function PhotoCanvas()
		{
			bringToFront = false;			
			noScale = true;
			noRotate = true;
			
			clickgrabber.graphics.beginFill(0xffffff, 0.0);
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();						
			
			this.addChild( clickgrabber );			
		}
	}
}