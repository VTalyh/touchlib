package {
	import flash.display.*;
	import flash.events.*;
	import whitenoise.*;
	import flash.geom.*;
	
	public class Block extends MovieClip
	{
		private var bDragging:Boolean = false;
		private var draggingID:Number;
		public function Block()
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.downEvent);						
			this.addEventListener(MouseEvent.MOUSE_UP, this.upEvent);									
			this.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);									
			this.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);												
			this.addEventListener(Event.ENTER_FRAME, this.update);
		}
		
		private function downEvent(e:MouseEvent)
		{		
			trace("MouseDown");
			
			if(e is TUIOEvent)
			{
				bDragging = true;
				draggingID = e.ID; 
				
			}
		}
		
		private function upEvent(e:MouseEvent)
		{		
			
			if(e is TUIOEvent)
			{
				if(draggingID == e.ID)
					bDragging = false;

				
			}
		}		

		private function moveHandler(e:MouseEvent)
		{
			if(e is TUIOEvent)
			{
//				trace("TUIO Move " + TUIOEvent(e).ID);
			} else {
///				trace("MouseMove ");				
			}

//			this.x = this.x + e.localX;
//			this.y = this.y + e.localY;	
		}		
		private function rollOverHandler(e:MouseEvent)
		{


		}
		private function rollOutHandler(e:MouseEvent)
		{
		}		
		
		private function update(e:Event)
		{
			if(bDragging)
			{
				this.alpha = 0.5;				
				var tuioobj = TUIO.getObjectById(draggingID);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					bDragging = false;
					return;
				}
				
				var mypt = this.parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));
				this.x = mypt.x;
				this.y = mypt.y;
			} else {
				this.alpha = 1.0;				
			}
		}
	}
}