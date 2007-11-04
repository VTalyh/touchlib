package app.core.object {		
	import app.core.action.RotateScale;
	import app.core.element.*;
	
	import com.tweener.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.events.*;
	import flash.geom.ColorTransform;	
	import fl.controls.Button;	
	import flash.display.BlendMode;
	
	
	public class LensObject extends RotateScale
	{				
		private var clickgrabber:Shape = new Shape();
		
		private var _darken:Shape = new Shape();
		private var _lighten:Shape = new Shape();
		private var _multiply:Shape = new Shape();
		private var _screen:Shape = new Shape();
		private var _overlay:Shape = new Shape();
		private var _hardlight:Shape = new Shape();
		private var _add:Shape = new Shape();
		private var _subtract:Shape = new Shape();
		private var _difference:Shape = new Shape();
		private var _invert:Shape = new Shape();
		private var _alpha:Shape = new Shape();
		private var _erase:Shape = new Shape();
		private var _layer:Shape = new Shape();
		private var _normal:Shape = new Shape();
			
		private var velX:Number = 0;
		private var velY:Number = 0;				
		private var velAng:Number = 0;		
		private var friction:Number = 0;
		private var angFriction:Number = 0;	
		
		private var TSliderScale:HorizontalSlider = new HorizontalSlider(20,280);		
		
		private var fireButton:Button;
		
		function LensObject(setID, setShapi, setColor, setAlpha, setBlend, setWidth, setHeight, setX, setY)
		{   		
			//clickgrabber.blendMode=setBlend;
			
			//clickgrabber.filters =[new ConvolutionFilter(3,3,[0,1,0,1-31,0,1,0])];
		
			bringToFront = true;			
			noScale = false;
			noRotate = false;				
			
			fireButton = new Button();
			fireButton.setSize(35, setHeight+10);
			fireButton.addEventListener(MouseEvent.CLICK, fireFunc, false, 0, true);
			fireButton.label = "";
			
			var WrapperObject:Wrapper = new Wrapper(fireButton);
			WrapperObject.x = 133;
			WrapperObject.y = -105;		
			this.addChild( WrapperObject );	
			
			TSliderScale.x = 155;
			TSliderScale.y = 110;
			TSliderScale.rotation +=90;
			TSliderScale.setValue(0.5);
			//this.addChild(TSliderScale);	
			clickgrabber.blendMode = setBlend;
			clickgrabber.graphics.beginFill(setColor, 0);
			clickgrabber.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			clickgrabber.graphics.endFill();	
			
			this.addChild( clickgrabber );		
		
			clickgrabber.x = setX;
			clickgrabber.y = setY;	
			//this.addEventListener(Event.ENTER_FRAME, slide);		
			//this.addEventListener(Event.ENTER_FRAME, frameUpdate);	
			
			_invert.graphics.beginFill(setColor, 0.95);
			_invert.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_invert.graphics.endFill();				
			_invert.blendMode= BlendMode.INVERT ;			
			//this.addChild( _invert );			
			_invert.x = setX;
			_invert.y = setY;
			
			_darken.graphics.beginFill(setColor, 0.35);
			_darken.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_darken.graphics.endFill();				
			_darken.blendMode= BlendMode.DARKEN;			
			//this.addChild( _darken );			
			_darken.x = setX;
			_darken.y = setY;	
			
			_lighten.graphics.beginFill(setColor, 0.35);
			_lighten.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_lighten.graphics.endFill();				
			_lighten.blendMode= BlendMode.LIGHTEN;			
			//this.addChild( _lighten );			
			_lighten.x = setX;
			_lighten.y = setY;	
			
			_multiply.graphics.beginFill(setColor, 0.35);
			_multiply.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_multiply.graphics.endFill();				
			_multiply.blendMode= BlendMode.MULTIPLY;			
			//this.addChild( _multiply );			
			_multiply.x = setX;
			_multiply.y = setY;	
			
			_screen.graphics.beginFill(setColor, 0.35);
			_screen.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_screen.graphics.endFill();				
			_screen.blendMode= BlendMode.SCREEN;			
			//this.addChild( _screen );			
			_screen.x = setX;
			_screen.y = setY;		
			
			_overlay.graphics.beginFill(setColor, 0.35);
			_overlay.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_overlay.graphics.endFill();				
			_overlay.blendMode= BlendMode.OVERLAY;			
			//this.addChild( _overlay );			
			_overlay.x = setX;
			_overlay.y = setY;	
			
			_hardlight.graphics.beginFill(setColor, 0.35);
			_hardlight.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_hardlight.graphics.endFill();				
			_hardlight.blendMode= BlendMode.HARDLIGHT;			
			//this.addChild( _hardlight );			
			_hardlight.x = setX;
			_hardlight.y = setY;		
			
			_add.graphics.beginFill(setColor, 0.15);
			_add.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_add.graphics.endFill();				
			_add.blendMode= BlendMode.ADD;			
			this.addChild( _add );			
			_add.x = setX;
			_add.y = setY;	
			
			_subtract.graphics.beginFill(setColor, 0.35);
			_subtract.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_subtract.graphics.endFill();				
			_subtract.blendMode= BlendMode.SUBTRACT;			
			//this.addChild( _subtract );			
			_subtract.x = setX;
			_subtract.y = setY;	
			
			_difference.graphics.beginFill(setColor, 0.95);
			_difference.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_difference.graphics.endFill();				
			_difference.blendMode= BlendMode.DIFFERENCE;			
			this.addChild( _difference );			
			_difference.x = setX;
			_difference.y = setY;					
			
			_alpha.graphics.beginFill(setColor, 1.0);
			_alpha.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_alpha.graphics.endFill();				
			_alpha.blendMode= BlendMode.ALPHA ;			
			//this.addChild( _alpha );			
			_alpha.x = setX;
			_alpha.y = setY;	
					
			_erase.graphics.beginFill(setColor, 1);
			_erase.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_erase.graphics.endFill();				
			_erase.blendMode= BlendMode.ERASE ;			
			//this.addChild( _erase );			
			_erase.x = setX;
			_erase.y = setY;	
			
			_layer.graphics.beginFill(setColor, 1.0);
			_layer.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_layer.graphics.endFill();				
			_layer.blendMode= BlendMode.LAYER ;			
			//this.addChild( _layer );			
			_layer.x = setX;
			_layer.y = setY;
		
			_normal.graphics.beginFill(setColor, 1.0);
			_normal.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,0);
			_normal.graphics.endFill();				
			_normal.blendMode= BlendMode.NORMAL ;			
			//this.addChild( _normal );			
			_normal.x = setX;
			_normal.y = setY;
		}
				
				/*
			var color:ColorTransform = clickgrabber.transform.colorTransform;
			color.redMultiplier = 0;
			color.blueMultiplier = 0;
			color.greenMultiplier = 0;
			clickgrabber.transform.colorTransform=color;	
			*/
		
		function fireFunc(e:Event)
		{
			if(this.y>=800)
			Tweener.addTween(this, {x:500,y:420,scaleX: 0.8, scaleY: 0.8, rotation:0, time:0.5, transition:"easeinoutquad"});		
			else
			Tweener.addTween(this, {x:450,y:840,scaleX: 0.65, scaleY: 0.65, rotation:-90, time:0.5, transition:"easeinoutquad"});			
		}
		
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;						
			velAng = dang;
		}
		private function frameUpdate(e:Event)
		{	
		this.alpha += TSliderScale.sliderValue;
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