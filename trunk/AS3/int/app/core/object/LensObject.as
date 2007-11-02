package app.core.object {		
	import flash.display.Sprite;		
	import flash.display.Shape;		
	import flash.events.Event;
	import flash.geom.Point;		
	import app.core.action.RotateScale;
	import app.core.element.*;
	import fl.controls.Button;
	import flash.events.*;
	import com.tweener.*;
	
	public class LensObject extends RotateScale
	{	
		private var clickgrabber:Shape = new Shape();				
		private var velX:Number = 0;
		private var velY:Number = 0;				
		private var velAng:Number = 0;		
		private var friction:Number = 0;
		private var angFriction:Number = 0;			
		
		private var fireButton:Button;
		
		function LensObject(setID, setShapi, setColor, setAlpha, setBlend, setWidth, setHeight, setX, setY)
		{   		
			clickgrabber.blendMode=setBlend;
			bringToFront = true;			
			noScale = false;
			noRotate = false;			
			clickgrabber.graphics.beginFill(setColor, setAlpha);
			
			fireButton = new Button();
			fireButton.setSize(35, setHeight+10);
			fireButton.addEventListener(MouseEvent.CLICK, fireFunc, false, 0, true);
			fireButton.label = "";
			
			var WrapperObject:Wrapper = new Wrapper(fireButton);
			WrapperObject.x = 133;
			WrapperObject.y = -105;			
			
			if(setShapi == "square")
			{
				clickgrabber.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,10);
			}
			else{clickgrabber.graphics.drawCircle(0,0,setWidth);}			
			clickgrabber.graphics.endFill();						
			
			this.addChild( clickgrabber );			
			clickgrabber.x = setX;
			clickgrabber.y = setY;
			//this.addEventListener(Event.ENTER_FRAME, slide);	
			this.addChild( WrapperObject );			
		}
		
		
		function fireFunc(e:Event)
		{
			trace("FIRE");			
		}
		
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;						
			velAng = dang;
		}
		
		private function slide(e:Event)
		{
			if(this.state == "none")
			{		
				if(Math.abs(velX) < 0.001)
					velX = 0;
				else {
					x += velX;
					velX *= friction;										
				}
				if(Math.abs(velY) < 0.001)
					velY = 0;					
				else {
					y += velY;
					velY *= friction;						
				}
				if(Math.abs(velAng) < 0.001)
					velAng = 0;					
				else {
					velAng *= angFriction;				
					this.rotation += velAng;					
				}
			}

		}
		
	}
}