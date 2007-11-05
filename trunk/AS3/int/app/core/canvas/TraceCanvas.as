package app.core.canvas {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import com.touchlib.*;
	import flash.geom.*;

	import flash.filters.*;

	public class TraceCanvas extends MovieClip {

		private var blobs:Array;
		
		private var sourceBmp:BitmapData;
		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;
		private var buffer:BitmapData;
		private var paintBmp:Bitmap;
		private var brush:MovieClip;
		private var menu:MovieClip;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;
		private var col:ColorTransform;

		private var redButton:MovieClip;
		private var blueButton:MovieClip;
		private var greenButton:MovieClip;
		private var clearButton:MovieClip;
		private var bmp:MovieClip;
		private var Paths: Array;

		public function TraceCanvas() {
			Init();
		}
		
		function Init() {
			blobs = new Array();
			
			Paths = new Array();
			
			paintBmpData = new BitmapData(1024, 768, true, 0x0FFFFFF);
			
			paintBmp = new Bitmap(paintBmpData,'auto',true);
		
			this.addEventListener(TUIOEvent.TUIO_MOVE, this.moveHandler, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_UP, this.upEvent, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_OVER, this.rollOverHandler, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_OUT, this.rollOutHandler, false, 0, true);

			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);
			
			this.addChild(paintBmp);
			/*
			var exitButton:Loader = new Loader();
			exitButton.load(new URLRequest("closeButton.png"));
			exitButton.x = 20;
			exitButton.y = 768 - 148;
			exitButton.alpha = 0.8;
			exitButton.addEventListener(TUIOEvent.DownEvent, this.exit);
			this.addChild(exitButton);
			*/
		}
		/*
		function exit(e:Event) {
			var subobj = new mTouchSurface();
			subobj.name = "SurfaceHolder";
			parent.addChild(subobj);
			parent.removeChild(parent.getChildByName("DebugSurface"));
		}*/
		function addBlob(id:Number, origX:Number, origY:Number) {
			for (var i=0; i<blobs.length; i++) {
				if (blobs[i].id == id) {
					return;
				}
			}
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y, oldX:x, oldY: y} );
			
			var holder: MovieClip = new MovieClip();
			var blobID:Number;
			
			Paths.push({mc: holder, blobID: id});
			addChild(Paths[Paths.length -1].mc);
		}
		function removeBlob(id:Number) {
			for (var i=0; i<blobs.length; i++) {
				if (blobs[i].id == id) {
					blobs.splice(i, 1);
					
					trace('===');
					for(var j:int = 0; j<Paths.length; j++) {
						trace(Paths[j].blobID);
						if (Paths[j].blobID == id) {
							//Paths[j].mc.clear();
							removeChild(Paths[j].mc);
							Paths.splice(j,1);
						}
					}
					return;
				}
			}
		}
		function update(e:Event) {

			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			var fIndex:Number = -1;
			for(var i:int = 0; i<blobs.length; i++)
			{				
				var tuioobj:TUIOObject = TUIO.getObjectById(blobs[i].id);
				//trace(tuioobj);
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blobs[i].id);
					/*for(var j:int = 0; j<Paths.length; j++) {
						if (Paths[j].blobID == blobs[i].id) {
							removeChild(Paths[j].mc);
							Paths.splice(j,1);
						}
					}*/
				} else {
					for(var j:int = 0; j<Paths.length; j++) {
						if (Paths[j].blobID == blobs[i].id) {
							//trace('Found '+j);
							fIndex = j;
						}
					}
					if (fIndex == -1)  {
						if (Paths[fIndex] == undefined) {
												
						}
					}
					else
					{
						var Line:MovieClip = Paths[fIndex].mc;
							Line.graphics.lineStyle(2,tuioobj.color,1.0);
							Line.graphics.moveTo(tuioobj.x,tuioobj.y);
							Line.graphics.lineTo(tuioobj.oldX,tuioobj.oldY);
					}
				}
			}
		}
		public function downEvent(e:TUIOEvent) {
			if (e.stageX == 0 && e.stageY == 0) {
				return;
			}

			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));
			addBlob(e.ID, curPt.x, curPt.y);

			e.stopPropagation();
		}
		public function upEvent(e:TUIOEvent) {
			
			removeBlob(e.ID);
			e.stopPropagation();

		}

		public function moveHandler(e:TUIOEvent) {

			e.stopPropagation();
		}
		public function rollOverHandler(e:TUIOEvent) {
		}
		public function rollOutHandler(e:TUIOEvent) {

		}
	}
}