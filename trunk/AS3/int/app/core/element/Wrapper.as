// This class makes it possible to wrap any of the existing Flash controls to use them with touchlib,
// though most of them would require re-skinning to make them bigger at least. Button components work well. 
// You still need to make sure that the control is added to the library (drag at least one control on stage).

// controls will be sent mouse events whenever they are hit with a TUIO event.. You just listen for the event you
// are interested in. 

/*
var comp:Button = new Button();
comp.setSize(200, 200);
comp.addEventListener(MouseEvent.CLICK, testFunc);

var subobj:MovieClip = new TouchlibWrapper(comp);
subobj.x = 290;
subobj.y = 245;

addChild(subobj);
*/

package app.core.element{

	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import com.touchlib.*;	
	import flash.geom.*;			
    import flash.filters.*;
	

	public class Wrapper extends MovieClip
	{

		private var gfxActiveGlow:Sprite;

		private var knobValue:Number = 0.0;
		private var isActive:Boolean = false;
		private var mouseActive:Boolean = false;
		
		private var activeX:Number;
		private var activeY:Number;		
		
		private var wrappedComponent:InteractiveObject;

		public function Wrapper(cmp:InteractiveObject)
		{
			wrappedComponent = cmp;
			
			addChild(cmp);
			
			var blurfx:BlurFilter = new BlurFilter(10, 10, 1);
			
			gfxActiveGlow = new Sprite();
			gfxActiveGlow.graphics.beginFill(0xFFFFFF, 0.7);
			gfxActiveGlow.graphics.drawCircle(0,0,20);
			gfxActiveGlow.visible = false;
			gfxActiveGlow.filters = [blurfx];
			addChild(gfxActiveGlow);			

			this.addEventListener(TUIOEvent.TUIO_MOVE, this.tuioMoveHandler, false, 0, true);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.tuioDownEvent, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, this.tuioUpEvent, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OVER, this.tuioRollOverHandler, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OUT, this.tuioRollOutHandler, false, 0, true);

			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate, false, 0, true);
			
			updateGraphics();
		}
		
		function updateGraphics()
		{

		}

		function touchStartDrag()
		{
			isActive = true;
			//gfxActiveGlow.visible = true;			
		}
		

		
		function touchStopDrag()
		{
			if(isActive)
			{
				isActive = false;
				gfxActiveGlow.visible = false;			
			}
			mouseActive = false;					
		}		
		
		public function getActive():Boolean
		{
			return isActive;
		}
		
		function frameUpdate(e:Event)
		{
			if(isActive)
			{
				if(mouseActive)
				{
					activeX = this.mouseX;
					activeY = this.mouseY;
				}
				//gfxActiveGlow.x = activeX;
				//gfxActiveGlow.y = activeY;
			}
		}

		
		public function tuioDownEvent(e:TUIOEvent)
		{
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
			var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));	
			
			TUIO.listenForObject(e.ID, this);
			touchStartDrag();			
			
			if(this.visible && wrappedComponent.visible)			
			{
				wrappedComponent.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, localPt.x, localPt.y));
			}
				
			e.stopPropagation();
		}

		public function tuioUpEvent(e:TUIOEvent)
		{		
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
			var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));
			
			touchStopDrag();		
			if(this.visible && wrappedComponent.visible)			
			{
				wrappedComponent.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, localPt.x, localPt.y));			
				wrappedComponent.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, localPt.x, localPt.y));						
			}
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
				
				if(this.visible && wrappedComponent.visible)			
				{
					wrappedComponent.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, localPt.x, localPt.y));							
				}
			}

			e.stopPropagation();			
		}
		
		public function tuioRollOverHandler(e:TUIOEvent)
		{
		
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);										
			var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														

				
//			wrappedComponent.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, localPt.x, localPt.y));										
		}
		
		public function tuioRollOutHandler(e:TUIOEvent)
		{
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);										
			var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														

				
			//wrappedComponent.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, localPt.x, localPt.y));										
		
		}			


	}
}