package app.core.element
{
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import com.touchlib.*;	
	import flash.geom.*;			
    import flash.filters.*;
	import flash.text.*;


	public class HorizontalSlider extends MovieClip
	{
		private var gfxSliderGrip:Sprite;
		private var gfxActiveGrip:Sprite;
		private var gfxActiveGlow:Sprite;
		public var sliderValue:Number = 0.0;
		private var isActive:Boolean = false;
		private var gfxWidth:Number = 0;
		private var gfxHeight:Number = 0;
		private var scrollableHeight:Number;
		private var borderPixels:Number = 4;
		private var roundnessPixels:Number = 0;
		
		private var activeX:Number;
		private var activeY:Number;		
		private var indicatorText:TextField;
		
		private var mouseActive:Boolean;
		

		public function HorizontalSlider(wd:Number, ht:Number)
		{

					
			var slider_Shadow : DropShadowFilter = new DropShadowFilter(4,30,0,.5,10,10);
			//var slider_Shadow : DropShadowFilter = new DropShadowFilter(4,30,0,.5,10,10);
			
			mouseActive = false;
			gfxWidth = wd;
			gfxHeight = ht;
			gfxSliderGrip = new Sprite();
			gfxSliderGrip.graphics.beginFill(0x8C8C8C, 1);
			gfxSliderGrip.graphics.drawRoundRect(-(wd/2) + borderPixels-15, -20, wd-borderPixels*2, 40, roundnessPixels, roundnessPixels);
			gfxSliderGrip.filters = [slider_Shadow];
			addChild(gfxSliderGrip);
			
			
			gfxActiveGrip = new Sprite();
			gfxActiveGrip.graphics.beginFill(0xFFFFFF, 1);
			gfxActiveGrip.graphics.drawRoundRect(-(wd/2) + borderPixels-15, -20, wd-borderPixels*2, 40, roundnessPixels, roundnessPixels);
			gfxActiveGrip.visible = false;
			addChild(gfxActiveGrip);
			
			var blurfx:BlurFilter = new BlurFilter(10, 10, 1);
			
			gfxActiveGlow = new Sprite();
			gfxActiveGlow.graphics.beginFill(0xFFFFFF, 0.3);
			gfxActiveGlow.graphics.drawCircle(0,0,20);
			gfxActiveGlow.visible = false;
			gfxActiveGlow.filters = [blurfx];
			//addChild(gfxActiveGlow);			
			
			scrollableHeight = gfxHeight - 40 - borderPixels*2;
			
			this.graphics.beginFill(0x373737, 1);
			this.graphics.drawRoundRect(0, 0, wd, ht, roundnessPixels, roundnessPixels);
			
			
			this.addEventListener(TUIOEvent.TUIO_MOVE, this.tuioMoveHandler);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.tuioDownEvent);						
			this.addEventListener(TUIOEvent.TUIO_UP, this.tuioUpEvent);									
			this.addEventListener(TUIOEvent.TUIO_OVER, this.tuioRollOverHandler);									
			this.addEventListener(TUIOEvent.TUIO_OUT, this.tuioRollOutHandler);

			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOutHandler);
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate);			
			
			updateGraphics();
		}
		
		function updateGraphics()
		{

			gfxSliderGrip.x = 25;
			gfxSliderGrip.y = gfxHeight - 20 - borderPixels - (scrollableHeight*sliderValue);
			
			gfxActiveGrip.x = 25;
			gfxActiveGrip.y = gfxHeight - 20 - borderPixels - (scrollableHeight*sliderValue);
			
			//indicatorText.text = sliderValue;
			//trace(indicatorText.text);
		
		}
		
		function sliderStartDrag()
		{
			isActive = true;
			gfxActiveGlow.visible = true;	
			gfxActiveGrip.visible = true;
			
		}
		
		
		function sliderStopDrag()
		{
			if(isActive)
			{
				isActive = false;
				gfxActiveGlow.visible = false;
				gfxActiveGrip.visible = false;
			}
			mouseActive = false;					
		}		
		
		public function setValue(f:Number)
		{
			if(f < 0)
				f = 0.0;
			if(f > 1.0)
				f = 1.0;
			sliderValue = f;
			
			updateGraphics();
			
		}
		
		public function getValue():Number	
		{
			return sliderValue;
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
				gfxActiveGlow.x = activeX;
				gfxActiveGlow.y = activeY;
			}
		}

		
		public function tuioDownEvent(e:TUIOEvent)
		{		

			TUIO.listenForObject(e.ID, this);
			sliderStartDrag();			
			e.stopPropagation();
		}

		public function tuioUpEvent(e:TUIOEvent)
		{		
			sliderStopDrag();		
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
				setValue(1.0 - ((localPt.y-20-borderPixels) / scrollableHeight));
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

			mouseActive = true;
			sliderStartDrag();
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{		

			sliderStopDrag();

		}		

		public function mouseMoveHandler(e:MouseEvent)
		{
			if(isActive)
			{
				activeX = this.mouseX;
				activeY = this.mouseY;
				setValue(1.0 - ((this.mouseY-20-borderPixels) / scrollableHeight));
			}
		}
		
		public function mouseRollOverHandler(e:MouseEvent)
		{	
		 sliderStopDrag();	
		}
		
		public function mouseRollOutHandler(e:MouseEvent)
		{
//			sliderStopDrag();			
		
		}					
	}
}