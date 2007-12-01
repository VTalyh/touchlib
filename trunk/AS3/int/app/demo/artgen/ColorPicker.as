
package app.demo.artgen
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
	
	public class ColorPicker extends Multitouchable
	{
		private var imgLoader:Loader = null;	     
		private var separateByPixels:BitmapData; 	
		private var label:TextField;
		public var color:int;
		public var r:int;
		public var g:int;
		public var b:int;
		private var selectedSpr:Sprite;
		function ColorPicker() {
			imgLoader = new Loader();		
			//imgLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler);	
			imgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true);	
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;		
			var request:URLRequest = new URLRequest( "www/img/color.png" );			
			imgLoader.unload();
			imgLoader.load( request, context);			
			label = new TextField();
		}	
		function onCompleteHandler(event:Event = null){
			//var image:Bitmap = Bitmap(imgLoader.content);
			separateByPixels = new BitmapData(imgLoader.width, imgLoader.height, false); 
			separateByPixels.draw(imgLoader);
			var sampleSprite:Sprite = new Sprite();
			sampleSprite.graphics.beginBitmapFill(separateByPixels);
			sampleSprite.graphics.drawRect(0, 0, imgLoader.width, imgLoader.height)
			sampleSprite.graphics.endFill();        
			
			selectedSpr = new Sprite();
			selectedSpr.graphics.lineStyle(1.0, 0xffffff);
			selectedSpr.graphics.moveTo(-5, 0);
			selectedSpr.graphics.lineTo(5, 0);			
			selectedSpr.graphics.moveTo(0, -5);
			selectedSpr.graphics.lineTo(0, 5);	
			selectedSpr.blendMode='invert';
			
			
			addChild(sampleSprite);		
			addChild(label);
			addChild(selectedSpr);			
		}	
		
		public override function handleDownEvent(id:int, mx:Number, my:Number)
		{
			trace(mx + "," + my);
			// FIXME: why is this?
			color  = separateByPixels.getPixel(mx- this.x, my-this.y);
			trace(color.toString(16).toUpperCase());
			r = color >> 16;
			g = (color & 0xff00) >> 8;
			b = color & 0xff;
			label.text = r + "," + g + "," + b;
			
			selectedSpr.x = mx- this.x;
			selectedSpr.y = my- this.y;
		}		
		

	}
}
