package app.demo.nuiSurface {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.geom.*;

	import com.touchlib.*;	
	import app.demo.nuiSurface.*;
	import app.core.element.*;
	import app.core.action.*;		
	import flash.filters.*;

	public class PaintSurface extends Multitouchable {
		//[Embed(source="brush.swf", symbol="Brush")]
		//public var Brush:Class;


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
		private var exitButton:Loader;

		public function PaintSurface() 
		{
			Init();
		}
		
		function Init() 
		{
			blobs = new Array();
			paintBmpData = new BitmapData(1024, 768, true, 0x00000000);

			brush = new BrushObj();

			menu = new MenuObj();

			trace(menu);


			redButton = new MovieClip();
			greenButton = new MovieClip();
			blueButton = new MovieClip();
			clearButton = new MovieClip();
			bmp = new MovieClip();

			redButton.x = 10;
			greenButton.x = 10;
			blueButton.x = 10;
			clearButton.x = 10;

			redButton.y = 10;
			greenButton.y = 70;
			blueButton.y = 130;
			clearButton.y = 190;
			//bmp.removeChild(paintBmp);

			bmp.x = 0;
			bmp.y = 0;
			
			redButton.graphics.beginFill(0xFF0000);
			redButton.graphics.drawEllipse(-1, -1, 50, 50);

			greenButton.graphics.beginFill(0x00FF00);
			greenButton.graphics.drawEllipse(-1, -1, 50, 50);

			blueButton.graphics.beginFill(0x0000FF);
			blueButton.graphics.drawEllipse(-1, -1, 50, 50);

			clearButton.graphics.beginFill(0xFFFFFF);
			clearButton.graphics.drawRect(-1, -1, 50, 50);
			
			//bmp.graphics.beginFill(0x000000,0.0);
			//bmp.graphics.drawRect(-1, -1, 800, 600);

			redButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setRed);
			greenButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setGreen);
			blueButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setBlue);
			clearButton.addEventListener(TUIOEvent.TUIO_DOWN, this.clearLayer);

			redButton.addEventListener(MouseEvent.CLICK, this.setRed);
			greenButton.addEventListener(MouseEvent.CLICK, this.setGreen);
			blueButton.addEventListener(MouseEvent.CLICK, this.setBlue);
			clearButton.addEventListener(MouseEvent.CLICK, this.clearLayer);
			
			this.addEventListener(Event.ENTER_FRAME, this.update);

			paintBmp = new Bitmap(paintBmpData,'auto',true);

			var cmat:Array = [ 1, 1, 1,
			       1, 1, 1,
			   1, 1, 1 ];
			filter = new ConvolutionFilter(3, 3, cmat, 9, 0);
			var filter2:BitmapFilter = new BlurFilter(3,3);

			//filter = new BlurFilter(5, 5);
			bmp.addChild(paintBmp);

			//bmp.addEventListener(TUIOEvent.TUIO_DOWN, this.drawDot);
			//bmp.addEventListener(TUIOEvent.TUIO_MOVE, this.drawLine);
			//bmp.addEventListener(TUIOEvent.TUIO_UP, this.drawDot);
			bmp.cacheAsBitmap = true;

			var filter:BitmapFilter = getBevelFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			//myFilters.push(filter2);
			bmp.filters = myFilters;

			this.addChild(bmp);
			menu.scaleX = 0.7;
			menu.scaleY = 0.7;
			menu.x = 55;
			menu.y = 768/2;


			setupMenu();
			this.addChild(menu);

			//this.addChild(redButton);
			//this.addChild(greenButton);
			//this.addChild(blueButton);
			//this.addChild(clearButton);
			
			var exitButton:Loader = new Loader();
			exitButton.load(new URLRequest("closeButton.png"));
			exitButton.x = 20;
			exitButton.y = 768 - 148;
			exitButton.alpha = 1.0;
			exitButton.addEventListener(TUIOEvent.TUIO_DOWN, this.exit);
			
			this.addChild(exitButton);

			if (col==undefined) {
				setBlue(new Event("dummy"));
			}

		}
		function exit(e:Event) {
			var subobj = new mTouchSurface();
			subobj.name = "SurfaceHolder";
			parent.addChild(subobj);
			parent.removeChild(parent.getChildByName("PaintSurface"));
		}
		private function getBevelFilter():BitmapFilter {
			return new BevelFilter(4.0,45,0xffffff,1.0,0x000000,0.5,20,20,1.0,BitmapFilterQuality.LOW);
		}
		function setupMenu() {
			menu.redButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setRed);
			menu.greenButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setGreen);
			menu.blueButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setBlue);
			menu.whiteButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setWhite);
			menu.blackButton.addEventListener(TUIOEvent.TUIO_DOWN, this.setBlack);
			menu.clearButton.addEventListener(TUIOEvent.TUIO_DOWN, this.clearLayer);
		}
		function setColor(r:Number, g:Number, b:Number) {
			col = new ColorTransform(r, g, b);
		}
		function setRed(e:Event) {
			trace("Set Red" );
			setColor(1.0, 0.0, 0.0);
		}
		function setGreen(e:Event) {
			setColor(0.0, 1.0, 0.0);
		}
		function setBlue(e:Event) {
			setColor(0.0, 0.0, 1.0);
		}
		function setWhite(e:Event) {
			setColor(1.0, 1.0, 1.0);
		}
		function setBlack(e:Event) {
			setColor(0.0, 0.0, 0.0);
		}
		function clearLayer(e:Event) {
			paintBmpData.dispose();
			Init();
		}


		function update(e:Event) {

			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			for(var i:int = 0; i<blobs.length; i++)
			{

				var Line:MovieClip = new MovieClip();
				Line.graphics.lineStyle(20,0xffffff,1.0);

				var historyLen:int = blobs[i].history.length;
				if(historyLen >= 2)
				{
					Line.graphics.moveTo(blobs[i].history[historyLen-2].x,blobs[i].history[historyLen-2].y);					
					Line.graphics.lineTo(blobs[i].history[historyLen-1].x,blobs[i].history[historyLen-1].y);

				//var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));
				//var m:Matrix = new Matrix();
				//m.translate(localPt.x, localPt.y);

				paintBmpData.draw(Line, null, col, 'normal');
				}
				//updateTUIOObject(tuioobj);

			}
		}




	}
}