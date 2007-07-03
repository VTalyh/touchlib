package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import whitenoise.*;	
	import flash.geom.*;			
	
	
    import flash.filters.*;


	public class PaintSurface extends MovieClip
	{
//		[Embed(source="brush.swf", symbol="Brush")]
//		public var Brush:Class;


		private var blobs:Array;		// blobs we are currently interacting with		
		
		private var sourceBmp:BitmapData;		
		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;		
		private var buffer:BitmapData;		
		private var paintBmp:Bitmap;
		private var brush:MovieClip;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;
		private var col:ColorTransform;
		
		private var redButton:MovieClip;
		private var blueButton:MovieClip;		
		private var greenButton:MovieClip;				
		
		public function PaintSurface()
		{
			blobs = new Array();
			paintBmpData = new BitmapData(800, 600, true, 0x00000000);

			brush = new BrushObj();
			
			trace(brush);
			this.addEventListener(TUIOEvent.MoveEvent, this.moveHandler);			
			this.addEventListener(TUIOEvent.DownEvent, this.downEvent);						
			this.addEventListener(TUIOEvent.UpEvent, this.upEvent);									
			this.addEventListener(TUIOEvent.RollOverEvent, this.rollOverHandler);									
			this.addEventListener(TUIOEvent.RollOutEvent, this.rollOutHandler);															
			
			redButton = new MovieClip();
			greenButton = new MovieClip();
			blueButton = new MovieClip();
			
		
			
			greenButton.x = 50;
			blueButton.x = 100;			
			
			redButton.graphics.beginFill(0xFF0000);
			redButton.graphics.drawRect(-1, -1, 50, 50);			
			
			greenButton.graphics.beginFill(0x00FF00);
			greenButton.graphics.drawRect(-1, -1, 50, 50);						
			
			blueButton.graphics.beginFill(0x0000FF);
			blueButton.graphics.drawRect(-1, -1, 50, 50);									
			
			
			redButton.addEventListener(TUIOEvent.DownEvent, this.setRed);									
			greenButton.addEventListener(TUIOEvent.DownEvent, this.setGreen);															
			blueButton.addEventListener(TUIOEvent.DownEvent, this.setBlue);												

			redButton.addEventListener(MouseEvent.CLICK, this.setRed);									
			greenButton.addEventListener(MouseEvent.CLICK, this.setGreen);															
			blueButton.addEventListener(MouseEvent.CLICK, this.setBlue);															
			
			this.addEventListener(Event.ENTER_FRAME, this.update);			
			paintBmp = new Bitmap(paintBmpData);
			
			var cmat:Array = [ 1, 1, 1,
						       1, 1, 1,
							   1, 1, 1 ] ;
			filter = new ConvolutionFilter(3, 3, cmat, 9, 0);
			filter2 = new BlurFilter(4,4);
			
//			filter = new BlurFilter(5, 5);
			addChild(paintBmp);
//			addChild(brush);

			this.addChild(redButton);
			this.addChild(greenButton);
			this.addChild(blueButton);	

			setBlue(new Event("dummy"));

			
		}
		
		function setColor(r:Number, g:Number, b:Number)
		{
			col = new ColorTransform(r, g, b);
		}
		
		function setRed(e:Event)
		{
			trace("Set Red" );
			setColor(1.0, 0.0, 0.0);
		}
		function setGreen(e:Event)
		{
			setColor(0.0, 1.0, 0.0);
		}		
		
		function setBlue(e:Event)
		{
			setColor(0.0, 0.0, 1.0);
		}				
		
		function addBlob(id:Number, origX:Number, origY:Number)
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
		}
		
		function removeBlob(id:Number)
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
		
		function update(e:Event)
		{
			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			for(var i:int = 0; i<blobs.length; i++)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blobs[i].id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blobs[i].id);
				} else {
					var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));										
					var m:Matrix = new Matrix();
					m.translate(localPt.x, localPt.y);
					paintBmpData.draw(brush, m, col, 'add');
				}
			}
			
			paintBmpData.applyFilter(paintBmpData, paintBmpData.rect, new Point(), filter2);
		}
		
		
		public function downEvent(e:TUIOEvent)
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									

			addBlob(e.ID, curPt.x, curPt.y);
				
			e.stopPropagation();
		}
		
		public function upEvent(e:TUIOEvent)
		{		
			
				
			removeBlob(e.ID);			
				
			e.stopPropagation();				
				
		}		

		public function moveHandler(e:TUIOEvent)
		{
		}
		
		public function rollOverHandler(e:TUIOEvent)
		{
		}
		
		public function rollOutHandler(e:TUIOEvent)
		{
		
		}		
		
	}
}