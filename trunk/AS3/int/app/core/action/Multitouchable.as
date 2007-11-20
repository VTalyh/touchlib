// This will be a low level class that handles the basics of tracking multiple blob id's that may affect this Sprite. This includes touching this Sprite,
// moving over this sprite. It handles keeping a list of blob id's that are alive and firing off event handler functions. When you extend this class
// you just implement the event handler funcs. This class will be used to greatly simplify the paint canvas and could also be used to simplify 'RotatableScalable'.

package app.core.action
{
	import flash.display.*;		
	import flash.events.*;
	import com.touchlib.*;		
	
	class Multitouchable extends Sprite
	{
		protected var blobs:Array;		// blobs we are currently interacting with			
		
		function Multitouchable()
		{
		
			this.addEventListener(TUIOEvent.TUIO_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.downHandler, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, this.upHander false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OUT, this.rollOutHandler, false, 0, true);		
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, false, 0, true);			
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseDownHandler, false, 0, true);						
		}

		function idExists(id:int):Boolean
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return true;
			}			
			
			return false;
		}
	
		function addBlob(id:int, origX:Number, origY:Number, c:Boolean):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, clicked:c, origX: origX, origY:origY, clicked:c} );
		}
		
		function removeBlob(id:int):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);		
					return;
				}
			}
		}	
		
		function getBlobInfo(id:int):Object
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return blobs[i];

			}			
			
			return null;
		}
		
		private function downHandler(e:TUIOEvent):void
		{
		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
				
			TUIO.listenForObject(e.ID, this);							
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));												

			addBlob(e.ID, curPt.x, curPt.y, true);
			
			handleDownEvent(e.ID, curPt.x, curPt.y);
			e.stopPropagation();			
		}
		
		
		private function upHandler(e:TUIOEvent):void
		{
			handleUpEvent(e.ID);
			removeBlob(e.ID);
			e.stopPropagation();
		}		
		
		public function moveHandler(e:TUIOEvent):void
		{
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			if(!idExists(e.ID))
			{
				trace("Error, shouldn't this blob already be in the list?");
				//TUIO.listenForObject(e.ID, this);			
				addBlob(e.ID);
			}
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));																	
			handleMoveEvent(e.ID, curPt.x, curPt.y);			
			
			e.stopPropagation();						
		}		
		
		public function rollOverHandler(e:TUIOEvent):void
		{
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));																		
			
			if(!idExists(e.ID))
			{
				TUIO.listenForObject(e.ID, this);			
				addBlob(e.ID, curPt.x, curPt.y, false);
			}
			

			handleRollOverEvent(e.ID, curPt.x, curPt.y);			
			
			e.stopPropagation();									
		}
		
		public function rollOutHandler(e:TUIOEvent):void
		{
			if(e.stageX == 0 && e.stageY == 0)
				return;			
				
		
		// FIXME: only remove if not clicked?
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));												
			handleRollOutEvent(e.ID, curPt.x, curPt.y);			
			
			if(!getBlobInfo(e.id).clicked)
				removeBlob(e.ID);			
			
			e.stopPropagation();									
		}		
		
		public function handleDownEvent(id:int, x:Number, y:Number)
		{
		}
		
		public function handleUpEvent(id:int)
		{
		}
		
		public function handleRollOverEvent(id:int, x:Number, y:Number)
		{
		}		
		
		public function handleRollOutEvent(id:int, x:Number, y:Number)
		{
		}				

		public function handleMoveEvent(id:int, x:Number, y:Number)
		{
		}				
	}
}