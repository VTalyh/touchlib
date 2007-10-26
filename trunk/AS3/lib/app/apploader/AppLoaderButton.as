// FIXME: animate tank tread spinning..

package app.apploader
{
	import com.touchlib.*;
	import app.apploader.*;
	import app.documentClass.AppLoader;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import fl.controls.Button;
	import flash.text.*;

	
	dynamic public class AppLoaderButton extends Sprite
	{
		var buttonOverlay:MovieClip;
		var buttonImage:Loader;

		function AppLoaderButton(app:AppLoader, appname:String, appLabel:String)
		{
			buttonOverlay = new ButtonOverlay();
			buttonImage = new Loader();
			
			buttonImage.load(new URLRequest("images/apps/" + appname + ".png");
			
			
			addChild(buttonImage);
			addChild(buttonOverlay);
			
			this.addEventListener(TUIOEvent.MoveEvent, this.tuioMoveHandler);			
			this.addEventListener(TUIOEvent.DownEvent, this.tuioDownEvent);						
			this.addEventListener(TUIOEvent.UpEvent, this.tuioUpEvent);									
			this.addEventListener(TUIOEvent.RollOverEvent, this.tuioRollOverHandler);									
			this.addEventListener(TUIOEvent.RollOutEvent, this.tuioRollOutHandler);			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOutHandler);
			
		}
		
		
		public function tuioDownEvent(e:TUIOEvent)
		{		

			TUIO.listenForObject(e.ID, this);

			e.stopPropagation();
		}

		public function tuioUpEvent(e:TUIOEvent)
		{		

			e.stopPropagation();
		}		

		public function tuioMoveHandler(e:TUIOEvent)
		{
			if(isActive)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);							
				
				var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														
				activeX = localPt.x;
				activeY = localPt.y;

			}			

			e.stopPropagation();			
		}
		
		public function tuioRollOverHandler(e:TUIOEvent)
		{
			
		}
		
		public function tuioRollOutHandler(e:TUIOEvent)
		{
			e.stopPropagation();			
		
		}			
		
		public function mouseDownEvent(e:MouseEvent)
		{		

		}
		
		public function mouseUpEvent(e:MouseEvent)
		{		



		}		

		public function mouseMoveHandler(e:MouseEvent)
		{

		}
		
		public function mouseRollOverHandler(e:MouseEvent)
		{
		}
		
		public function mouseRollOutHandler(e:MouseEvent)
		{

		
		}							

		

	}
}