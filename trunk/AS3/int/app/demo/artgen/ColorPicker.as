package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import app.core.element.*;
	import flash.geom.*;	
	import flash.utils.*;
	import flash.net.*;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	public class ColorPicker extends Sprite
	{
		private var colorWheel_0:ColorWheel;
		
		function ColorPicker()
		
		{
			colorWheel_0 = new ColorWheel();
			addChild(colorWheel_0);	
			
			trace(colorWheel_0.getPixel(img._xmouse, img._ymouse));
		}
	}
}

/*
import flash.display.BitmapData;
import flash.geom.ColorTransform;
var separateByPixels:BitmapData = new BitmapData(img._width, img._height, false);
separateByPixels.draw(img);
function setThumbColor(i) {
	var thumbColorTransform:ColorTransform = new ColorTransform();
	thumbColorTransform.rgb = i;
	your_thumb.transform.colorTransform = thumbColorTransform;
}
function onMouseDown(){
	setThumbColor(separateByPixels.getPixel(img._xmouse, img._ymouse));
}*/