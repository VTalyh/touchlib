// TODO: two finger color blending
// ----- Still some minor bugs on the toggling of the colorBar
// ----- make this class return a color value also.. similar to a slider

// instead of showing a thumbnail for each finger - just blend all the colors under all the fingers and show that
// we don't need to see thumbs for each one..  

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
		private var colorThumbBlend:Shape;
		
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
			_fmt = new TextFormat("_sans", 10, 0xFFFFFF,false,false,false,null,null,"right");
			label = new TextField(); 
			label.defaultTextFormat=_fmt; 
			label.blendMode='invert';		
			label.selectable=false;						
			label.x = imgLoader.width-110;
			label.y = -40;		
			
			//var image:Bitmap = Bitmap(imgLoader.content);
			separateByPixels = new BitmapData(imgLoader.width, imgLoader.height, false); 
			separateByPixels.draw(imgLoader);
			
			sampleSprite = new Sprite();
			sampleSprite.graphics.beginBitmapFill(separateByPixels);
			sampleSprite.graphics.drawRect(0, 0, imgLoader.width, imgLoader.height)
			sampleSprite.graphics.endFill();   
			sampleSprite.visible=false;
			sampleSprite.scaleY = 0;
			//sampleSprite.y=-25;
			
			selectedSpr = new Sprite();
			selectedSpr.graphics.lineStyle(1.35, 0xffffff);
			selectedSpr.graphics.moveTo(-7, 0);
			selectedSpr.graphics.lineTo(7, 0);			
			selectedSpr.graphics.moveTo(0, -7);
			selectedSpr.graphics.lineTo(0, 7);	
			selectedSpr.blendMode='invert';			
			selectedSpr.visible=false;
				
			colorThumb = new Shape();
			colorThumb.graphics.beginFill(0xFFFFFF);
			colorThumb.graphics.drawRoundRect(0, -55, imgLoader.width, 50,6);
			colorThumb.graphics.endFill();
			
			/*			
			colorThumbBlend = new Shape();
			colorThumbBlend.graphics.beginFill(0xFFFFFF);
			colorThumbBlend.graphics.drawRoundRect(0, -55, 50, 50,6);
			colorThumbBlend.graphics.endFill();
			*/
			
			var colorThumbBorder = new Shape();
			colorThumbBorder.graphics.lineStyle(1, 0xffffff);
			colorThumbBorder.graphics.drawRoundRect(0, -55, imgLoader.width, 50,6);	
			
		
			addChild(colorThumb);
			//addChild(colorThumbBlend);			
			addChild(colorThumbBorder);			
			addChild(sampleSprite);		
			addChild(label);		
			addChild(selectedSpr);	
	
		}	
		function setThumbColor(c) {
			var thumbColorTransform:ColorTransform = new ColorTransform();
			thumbColorTransform.color = c;
			colorThumb.transform.colorTransform = thumbColorTransform;
		}	
		/*
		function setThumbBlend(c) {
			var thumbColorBlend:ColorTransform = new ColorTransform();
			thumbColorBlend.color = c;
			colorThumbBlend.transform.colorTransform = thumbColorBlend;
		}
		*/
		public override function handleDownEvent(id:int, mx:Number, my:Number, targetObj)
		{	
			//trace('---------------------------------------------------------------------------------------'+blobs.length);
			if(targetObj is ColorPicker || targetObj is Shape)
			{ 	
				//selectedSpr.x = selectedSpr.y = 0;
				if(sampleSprite.alpha!=1){		
				sampleSprite.visible=true;		
				selectedSpr.visible=true;
				Tweener.addTween(sampleSprite, {alpha:1, scaleY:1, time:0.35, transition:"easeinoutquad"});				
				}
				else{				
				Tweener.addTween(sampleSprite, {alpha:0,scaleY:0, time:0.35, transition:"easeinoutquad"});
				sampleSprite.visible=false;		
				selectedSpr.visible=false;
				}			
			}
			else{	
			// hrmm if id > 0 then loop thru the current blobs and extract their X/Y... create a new color/crosshair at that point... 
			// determine average of colors and draw it to the blending thumbnail (should each new point get a new thumbnail?)
			
			for(var i:int = 0; i<blobs.length; i++)
			{
			//trace(blobs[i].y+'-----------'+this.x);	
			}
			color1  = separateByPixels.getPixel(mx- this.x, my-this.y);		
			color2 = color1;			
			//color2  = separateByPixels.getPixel(250, 250);
			setThumbColor(color1);		
			//setThumbBlend((color2 + color1)/2);
			color = color1;
			//trace(color.toString(16).toUpperCase());
			r = color1 >> 16;
			g = (color1 & 0xff00) >> 8;
			b = color1 & 0xff;
			label.text = r + ", " + g + ", " + b;					
			selectedSpr.x = mx- this.x;
			selectedSpr.y = my- this.y;	
			}
		
		}		

		public override function handleMoveEvent(id:int, mx:Number, my:Number, targetObj)
		{
			color1  = separateByPixels.getPixel(mx- this.x, my-this.y);
			color2 = color1;
			//color2  = separateByPixels.getPixel(250, 250);
			setThumbColor(color1);		
			//setThumbBlend((color2 + color1)/2);
			color = color1;
			r = color1 >> 16;
			g = (color1 & 0xff00) >> 8;
			b = color1 & 0xff;
			label.text = r + ", " + g + ", " + b;					
			selectedSpr.x = mx- this.x;
			selectedSpr.y = my- this.y;
		}		

	}
}
