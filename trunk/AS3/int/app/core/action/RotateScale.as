package app.core.action {
	import com.touchlib.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public dynamic class RotateScale extends MovieClip
	{
		private var blobs:Array;		// blobs we are currently interacting with
		private var GRAD_PI:Number = 180.0 / 3.14159;
		public var state:String;
		private var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point = new Point(0,0);

		private var basePos1:Point = new Point(0,0);		
		private var basePos2:Point = new Point(0,0);				
		
		private var blob1:Object;
		private var blob2:Object;		
		public var bringToFront:Boolean = true;
		public var noScale = false;
		public var noRotate = false;		
		public var noSelection = false;	
			
		public var dX:Number;
		public var dY:Number;		
		public var dAng:Number;
		public var dcoef:Number = 0.5;
		
		public function RotateScale()
		{
			state = "none";
			blobs = new Array();
			
			this.addEventListener(TUIOEvent.TUIO_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OUT, this.rollOutHandler, false, 0, true);		
		
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOutHandler);	
													
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);
					
			dX = 0;
			dY = 0;			
			dAng = 0;
		}
		
		function addBlob(id:Number, origX:Number, origY:Number)
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
				trace("Dragging");				
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;				
				blob1 = blobs[0];
				alpha = 1;
			} 
			else if(blobs.length == 2)
			{
				state = "rotatescale";
				trace("Rotate/Scale");				
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;							
				blob1 = blobs[0];								
				blob2 = blobs[1];						
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				if(tuioobj1)
				{
					var curPt1 = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));								
					blob1.origX = curPt1.x;
					blob1.origY = curPt1.y;
				}				
			}
		}
		
		function removeBlob(id:Number)
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
						curAngle = this.rotation;			
						curPosition.x = x;
						curPosition.y = y;					
						
						blob1 = blobs[0];		
						
						var tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{						
							var curPt1 = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
						
					}
					if(blobs.length >= 2) {
						state = "rotatescale";
						trace(state);				
						curScale = this.scaleX;
						curAngle = this.rotation;					
						curPosition.x = x;
						curPosition.y = y;				
						alpha=this.scaleX;
						
						blob1 = blobs[0];								
						blob2 = blobs[1];		
						
						var tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{
							var curPt1 = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}									
					}
				
				return;
					
				}
			}			
		}
		
		public function downEvent(e:TUIOEvent)
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			addBlob(e.ID, curPt.x, curPt.y);
			if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
			e.stopPropagation();
		}
		
		public function upEvent(e:TUIOEvent)
		{		
			removeBlob(e.ID);							
			e.stopPropagation();		
				
		}		

		public function moveHandler(e:TUIOEvent)
		{
//			e.stopPropagation();			
		}
		
		public function rollOverHandler(e:TUIOEvent)
		{
//			e.stopPropagation();			
		}
		
		public function rollOutHandler(e:TUIOEvent)
		{
			//e.stopPropagation();
			
		}
		public function mouseDownEvent(e:MouseEvent)
		{
				if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			this.startDrag();	
			
			if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
				
			if(!noSelection)
				{
						
				}
			e.stopPropagation();
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{
			this.stopDrag();	
				if(!noSelection)
				{
		
				}
			e.stopPropagation();
		}		

		public function mouseMoveHandler(e:MouseEvent)
		{
		//this.alpha=0.5;
		}
		
		public function mouseRollOverHandler(e:MouseEvent)
		{
		//this.alpha=0.5;
		}
		
		public function mouseRollOutHandler(e:MouseEvent)
		{
		//this.alpha=1.0;	
		}	
		
		function getAngleTrig(X:Number, Y:Number): Number
		{
			if (X == 0.0)
			{
				if(Y < 0.0)
					return 270;
				else
					return 90;
			} else if (Y == 0)
			{
				if(X < 0)
					return 180;
				else
					return 0;
			}

			if ( Y > 0.0)
				if (X > 0.0)
					return Math.atan(Y/X) * GRAD_PI;
				else
					return 180.0-Math.atan(Y/-X) * GRAD_PI;
			else
				if (X > 0.0)
					return 360.0-Math.atan(-Y/X) * GRAD_PI;
				else
					return 180.0+Math.atan(-Y/-X) * GRAD_PI;
		} 
		
		public function released(dx:Number, dy:Number, dang:Number)
		{
		}
		
		private function update(e:Event)
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

				//trace("Moving (" + int(blob1.origX) + "," + int(blob1.origY) + ") - (" + int(curPt.x) + "," + int(curPt.y) + ")");
//				trace(curPt.y + " " + blobs[0].origX);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;

				x = curPosition.x + (curPt.x - (blob1.origX ));		
				y = curPosition.y + (curPt.y - (blob1.origY ));
				dX *= dcoef;
				dY *= dcoef;						
				dAng *= dcoef;
				dX += x - oldX;
				dY += y - oldY;		
								
					//if (scaleX <= 0.8)
					//alpha = 0.8;			
					//else alpha = 1.0;
					trace("Dragging: scale:" +scaleX + "  alpha:" + alpha);
				

				
			} else if(state == "rotatescale")
			{
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj1)
				{
					removeBlob(blob1.id);
					return;
				}				
				
				var curPt1 = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));								
				
				var tuioobj2 = TUIO.getObjectById(blob2.id);
				
				// if not found, then it must have died..
				if(!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}								
				
				var curPt2 = parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));				
				var curCenter = Point.interpolate(curPt1, curPt2, 0.5);				
//				trace(blobs[0].origX + "," + blobs[0].origY);
//				trace(blobs[1].origX + "," + blobs[1].origY);				
				
//				trace(curPt1.x + "," + curPt1.y);
//				trace(curPt2.x + "," + curPt2.y);				

				var origPt1 = new Point(blob1.origX, blob1.origY);
				var origPt2 = new Point(blob2.origX, blob2.origY);
				var centerOrig = Point.interpolate(origPt1, origPt2, 0.5);
				
				var offs:Point = curCenter.subtract(centerOrig);
				
				var len1:Number = Point.distance(origPt1, origPt2);
				var len2:Number = Point.distance(curPt1, curPt2);								
				var len3:Number = Point.distance(origPt1, new Point(0,0));
				
//				trace(len2 + " / " + len1);
				
				var newscale:Number = curScale * len2 / len1;

				if(newscale < 0.1) newscale = 0.1;
				if(newscale < 0.1) newscale = 0.1;

				if(newscale > 4.0) newscale = 4.0;
				if(newscale > 4.0) newscale = 4.0;				
				
				if(!noScale)
				{
					scaleX = newscale;
					scaleY = newscale;		
					alpha = newscale+0.4;				
				}
	
				var origLine:Point = origPt1;
				origLine = origLine.subtract(origPt2);
				
				var ang1:Number = getAngleTrig(origLine.x, origLine.y);
				
				var curLine:Point = curPt1;
				curLine = curLine.subtract(curPt2);
				
				var ang2 = getAngleTrig(curLine.x, curLine.y);
				var oldAngle = rotation;
				if(!noRotate)
					rotation = curAngle + (ang2 - ang1);
				
//				x = curPt1.x - ((curLine.x / len2) * len3 * newscale);
//				y = curPt1.y - ((curLine.y / len2) * len3 * newscale);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
				x = curPosition.x + (curCenter.x - centerOrig.x);
				y = curPosition.y + (curCenter.y - centerOrig.y);				
				
				
				dX *= dcoef;
				dY *= dcoef;		
				dAng *= dcoef;				
				
				dX += x - oldX;
				dY += y - oldY;
				
				dAng += rotation - oldAngle;		
				
		

			} 
			else {
				if(dX != 0 || dY != 0)
				{
					this.released(dX, dY, dAng);
					dX = 0;
					dY = 0;
					dAng = 0;
					if (scaleX <= 0.75)
					alpha = scaleX+0.2;			
					else alpha = 1.0;
					trace("Released: scale:" +scaleX + "  alpha:" + alpha);
				}
			}
		}
	}
}

