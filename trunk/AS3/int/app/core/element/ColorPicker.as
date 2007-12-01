package app.core.element
{
	import app.core.element.*;
	
	import com.touchlib.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.*;
	import app.core.action.Multitouchable;	
	
	import caurina.transitions.Tweener;
	
	public class ColorPicker extends Multitouchable
	{
		private var imgLoader:Loader = null;	     
		private var separateByPixels:BitmapData; 	
		private var label:TextField;
		public var color:int;
		public var r:int;
		public var g:int;
		public var b:int;
		private var colorThumb:Shape;
		private var selectedSpr:Sprite;
		private var sampleSprite:Sprite;
		
		function ColorPicker() {
			imgLoader = new Loader();		
			//imgLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler);	
			imgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true);	
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;		
			var request:URLRequest = new URLRequest( "www/img/color.png" );			
			imgLoader.unload();
			imgLoader.load( request, context);			
		}	
		function onCompleteHandler(event:Event = null){			
			_fmt = new TextFormat("_sans", 10, 0xFFFFFF,false,false,false,false,null,"right");
			label = new TextField(); 
			label.defaultTextFormat=_fmt; 
			label.blendMode='invert';					
			label.x = imgLoader.width-110;
			label.y = -45;		
			
			//var image:Bitmap = Bitmap(imgLoader.content);
			separateByPixels = new BitmapData(imgLoader.width, imgLoader.height, false); 
			separateByPixels.draw(imgLoader);
			
			sampleSprite = new Sprite();
			sampleSprite.graphics.beginBitmapFill(separateByPixels);
			sampleSprite.graphics.drawRect(0, 0, imgLoader.width, imgLoader.height)
			sampleSprite.graphics.endFill();   
			sampleSprite.visible=false;
			//sampleSprite.y=-25;
			
			selectedSpr = new Sprite();
			selectedSpr.graphics.lineStyle(1.2, 0xffffff);
			selectedSpr.graphics.moveTo(-7, 0);
			selectedSpr.graphics.lineTo(7, 0);			
			selectedSpr.graphics.moveTo(0, -7);
			selectedSpr.graphics.lineTo(0, 7);	
			selectedSpr.blendMode='invert';			
			selectedSpr.visible=false;
				
			colorThumb = new Shape();
			colorThumb.graphics.lineStyle(1.2, 0xffffff);
			colorThumb.graphics.beginFill(0xFFFFFF);
			colorThumb.graphics.drawRect(0, -55, imgLoader.width, 50);
			colorThumb.graphics.endFill();
			
			var colorThumbBorder = new Shape();
			colorThumbBorder.graphics.lineStyle(1, 0xffffff);
			colorThumbBorder.graphics.drawRect(0, -55, imgLoader.width, 50);	
			
		
			addChild(colorThumb);		
			addChild(colorThumbBorder);			
			addChild(sampleSprite);		
			addChild(label);		
			addChild(selectedSpr);	
	
		}	
		function setThumbColor(i) {
			var thumbColorTransform:ColorTransform = new ColorTransform();
			thumbColorTransform.color = i;
			colorThumb.transform.colorTransform = thumbColorTransform;
		}
		public override function handleDownEvent(id:int, mx:Number, my:Number, targetObj)
		{	
			if(targetObj is ColorPicker || targetObj is Shape)
			{ 	
				selectedSpr.x = selectedSpr.y = 0;
				if(sampleSprite.alpha!=1){		
				sampleSprite.visible=true;		
				selectedSpr.visible=true;
				Tweener.addTween(sampleSprite, {alpha:1, y:0, time:0.35, transition:"easeinoutquad"});				
				}
				else{				
				Tweener.addTween(sampleSprite, {alpha:0, y:0, time:0.35, transition:"easeinoutquad"});
				sampleSprite.visible=false;		
				selectedSpr.visible=false;
				}			
			}
			else{
			color  = separateByPixels.getPixel(mx- this.x, my-this.y);
			setThumbColor(color);		
			//trace(color.toString(16).toUpperCase());
			r = color >> 16;
			g = (color & 0xff00) >> 8;
			b = color & 0xff;
			label.text = r + "," + g + "," + b;					
			selectedSpr.x = mx- this.x;
			selectedSpr.y = my- this.y;
			}
		}		

		public override function handleMoveEvent(id:int, mx:Number, my:Number, targetObj)
		{
			color  = separateByPixels.getPixel(mx- this.x, my-this.y);
			setThumbColor(color);	
			r = color >> 16;
			g = (color & 0xff00) >> 8;
			b = color & 0xff;
			label.text = r + "," + g + "," + b;					
			selectedSpr.x = mx- this.x;
			selectedSpr.y = my- this.y;
		}		


	}
}
