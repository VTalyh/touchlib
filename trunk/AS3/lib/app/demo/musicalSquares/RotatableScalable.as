package app.demo.musicalSquares
{
	import flash.display.*;
	import flash.events.*;
	import com.touchlib.*;
	import flash.geom.*;
	
	public dynamic class RotatableScalable extends MovieClip
	{
		public var blobs:Array;		// blobs we are currently interacting with
		private var GRAD_PI:Number = 180.0 / 3.14159;
		public var state:String;
		private var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point = new Point(0,0);

		private var basePos1:Point = new Point(0,0);		
		private var basePos2:Point = new Point(0,0);				
		
		public var blob1:Object;
		public var blob2:Object;		
		public var bringToFront:Boolean = true;
		public var noScale = false;
		public var noRotate = false;		
		public var noMove = false;
		
		public var dX:Number;
		public var dY:Number;		
		public var dAng:Number;
		public var dcoef:Number = 0.85;
		
		public function RotatableScalable()
		{
			state = "none";

			blobs = new Array();
			this.addEventListener(TUIOEvent.TUIO_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OUT, this.rollOutHandler, false, 0, true);												
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);
			
			dX = 0;
			dY = 0;			
			dAng = 0;
		}
		
		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
			
			if(blobs.length == 1)
			{
				state = "dragging";
				trace("Drag : ");
				
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;
				
				blob1 = blobs[0];
			} else if(blobs.length == 2)
			{
				state = "rotatescale";
				//trace("Scale : "+this.scaleX);		
				//trace("Rotation : "+this.rotation);				
				curScale = this.scaleX;
				curPosition.x = x;
				curPosition.y = y;		
				
				blob1 = blobs[0];								
				blob2 = blobs[1];		
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(tuioobj1)
				{
					var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
					
					blob1.origX = curPt1.x;
					blob1.origY = curPt1.y;
				}				
				

			}
		}
		
		function removeBlob(id:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);
					
					if(blobs.length == 0)
						state = "none";
					if(blobs.length == 1) 
					{
						state = "dragging";					
	
						curScale = this.scaleX;
						curPosition.x = x;
						curPosition.y = y;					
						
						blob1 = blobs[0];		
						
						var tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{						
							var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
						
					}
					if(blobs.length >= 2) {
						state = "rotatescale";
						
						//trace(state);				
						curScale = this.scaleX;
						curPosition.x = x;
						curPosition.y = y;				
						
						blob1 = blobs[0];								
						blob2 = blobs[1];		
						
						var tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{
							var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}									
					}
				
				return;
					
				}
			}			
		}
		
		public function downEvent(e:TUIOEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			

			addBlob(e.ID, curPt.x, curPt.y);
			
			if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
				
			e.stopPropagation();
		}
		
		public function upEvent(e:TUIOEvent):void
		{		
							
			removeBlob(e.ID);			
				
			e.stopPropagation();				
				
		}		

		public function moveHandler(e:TUIOEvent):void
		{
//			e.stopPropagation();			
		}
		
		public function rollOverHandler(e:TUIOEvent):void
		{
//			e.stopPropagation();			
		}
		
		public function rollOutHandler(e:TUIOEvent):void
		{
			//e.stopPropagation();
			
		}
		
		
		
		
		public function released(dx:Number, dy:Number, dang:Number)
		{
			
			state == "released";
		}
		
		
		
		
		public function update(e:Event):void
		{			

			if(state == "dragging")
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}


				var curPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));					//  this.globalToLocal(
				
//				this.x += tuioobj.dX;
//				this.y += tuioobj.dY;				

//				trace("Moving (" + int(blob1.origX) + "," + int(blob1.origY) + ") - (" + int(curPt.x) + "," + int(curPt.y) + ")");
//				trace(curPt.y + " " + blobs[0].origX);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;

				if(!noMove){
					
				x = curPosition.x + (curPt.x - (blob1.origX ));		
				y = curPosition.y + (curPt.y - (blob1.origY ));
				
				}
				
				dX *= dcoef;
				dY *= dcoef;						
				dX += x - oldX;
				dY += y - oldY;		
				

				
			} else if(state == "rotatescale")
			{
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj1)
				{
					removeBlob(blob1.id);
					return;
				}				
				
				var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));								
				
				var tuioobj2 = TUIO.getObjectById(blob2.id);
				
				// if not found, then it must have died..
				if(!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}								
				
				var curPt2:Point = parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));				
				var curCenter:Point = Point.interpolate(curPt1, curPt2, 0.5);				
//				trace(blobs[0].origX + "," + blobs[0].origY);
//				trace(blobs[1].origX + "," + blobs[1].origY);				
				
//				trace(curPt1.x + "," + curPt1.y);
//				trace(curPt2.x + "," + curPt2.y);				

				var origPt1:Point = new Point(blob1.origX, blob1.origY);
				var origPt2:Point = new Point(blob2.origX, blob2.origY);
				var centerOrig:Point = Point.interpolate(origPt1, origPt2, 0.5);
				
				var offs:Point = curCenter.subtract(centerOrig);
				
				var len1:Number = Point.distance(origPt1, origPt2);
				var len2:Number = Point.distance(curPt1, curPt2);				
				
				var len3:Number = Point.distance(origPt1, new Point(0,0));
				
//				trace(len2 + " / " + len1);
				
				var newscale:Number = curScale * len2 / len1;

				if(newscale < 0.1) newscale = 0.1;
				if(newscale < 0.1) newscale = 0.1;

				//Stop ZUI
				if(newscale > 4.0) newscale = 4.0;
				if(newscale > 4.0) newscale = 4.0;				
				
				if(!noScale)
				{
					scaleX = newscale;
					scaleY = newscale;				
				}
	
				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
				
				if(!noMove){
				x = curPosition.x + (curCenter.x - centerOrig.x);
				y = curPosition.y + (curCenter.y - centerOrig.y);				
				}
				
				dX *= dcoef;
				dY *= dcoef;		
				
				dX += x - oldX;
				dY += y - oldY;
				

			} 
			
			else {
				if(dX != 0 || dY != 0)
				{
					this.released(dX, dY, dAng);
					dX = 0;
					dY = 0;
				}
			}
		}
	}
}

