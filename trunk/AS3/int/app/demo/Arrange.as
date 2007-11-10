/*
This class will take objects within a PhotoCanvas element and sort them according to pre-defined settings.

Example: http://youtube.com/watch?v=zu7fNQYmzUs & http://oskope.com/

*/

package app.demo{
import com.touchlib.*;
import app.core.canvas.LiquidCanvas;
import app.core.loader.*;
import app.core.element.*;
import app.core.object.*;
import flash.display.*;
import flash.system.Capabilities;
import flash.events.*;

//http://code.google.com/p/tweener/
import com.tweener.transitions.Tweener;
import flash.display.DisplayObject;
import flash.geom.Rectangle;

public class Arrange extends Sprite
{	
	private var photos:LiquidCanvas;
	private var LocalLoader_0:Local;
	
	private var spr0:Shape;
	private var spr1:Shape;
	private var spr2:Shape;
	private var spr3:Shape;
		
	public function Arrange()
	{
	
		photos = new LiquidCanvas();
		this.addChildAt(photos, 0);	
		LocalLoader_0 = new Local(photos);	
	
		var spr0:Shape = new Shape();
		spr0.graphics.beginFill(0xE3E2E2,1.0);
		spr0.graphics.drawRect(-0,-0,100,100);
		spr0.graphics.endFill();	
		spr0.x = (-photos.width/2)+0; spr0.y = -photos.height/2;
		spr0.addEventListener(TUIOEvent.TUIO_DOWN, stackPhotos, false, 0, true);
		spr0.addEventListener(MouseEvent.MOUSE_DOWN, stackPhotos, false, 0, true);
		photos.addChildAt(spr0,1);
			
		var spr1:Shape = new Shape();
		spr1.graphics.beginFill(0xD7D6D6,1.0);
		spr1.graphics.drawRect(-0,-0,100,100);
		spr1.graphics.endFill();	
		spr1.x = (-photos.width/2)+100; spr1.y = -photos.height/2;
		spr1.addEventListener(TUIOEvent.TUIO_DOWN, messPhotos, false, 0, true);	
		//spr1.addEventListener(MouseEvent.MOUSE_DOWN, messPhotos);	
		photos.addChild(spr1);

			
		var spr2:Shape = new Shape();
		spr2.graphics.beginFill(0xC0C0C0,1.0);
		spr2.graphics.drawRect(-0,-0,100,100);
		spr2.graphics.endFill();	
		spr2.x = (-photos.width/2)+200; spr2.y = -photos.height/2;
		spr2.addEventListener(TUIOEvent.TUIO_DOWN, gridPhotos);	
		//spr2.addEventListener(MouseEvent.MOUSE_DOWN, gridPhotos);		
		photos.addChild(spr2);
	
	
			
		//var WrapperObject_2:Wrapper = new Wrapper(spr2);					
		//photos.addChild( WrapperObject_2 );	
		
		/*var spr3:Shape = new Shape();
		spr3.graphics.beginFill(0x898585,1.0);
		spr3.graphics.drawRect(-0,-0,300,300);
		spr3.graphics.endFill();		
		spr3.x = photos.width/2-300; spr3.y = -photos.height/2;
		spr3.addEventListener(TUIOEvent.TUIO_DOWN, function(){flickr_obj.toggleObjects();}, false, 0, true);		
		//spr3.addEventListener(TUIOEvent.UpEvent, stackPhotos, false, 0, true);
		photos.addChild(spr3);	
		*/
		photos.scaleX=1, photos.scaleY=1;	
		//photos.x=250, photos.y=250;
	}
	
	//private var photoW:int = photos.width;
	private var minX:int = -0, maxX:int = 1024;
	private var minY:int = -0, maxY:int = 786;
	
	
	private function toggleCanvas(_photos:Sprite)
	{
		removeChild(_photos);
	}	
	
	private function stackPhotos(e:Event):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
			minX = -0, maxX = 1024;
			minY = -0, maxY = 786;
			//var targetX:int = minX+240;
			//var targetY:int = minY+500;	
			var targetX:int = 0;
			var targetY:int = 0;
			var targetRotation:int = 0;	
			
			/*
			if(photos.rotation <= 90 && photos.rotation > 0){targetRotation = -90}
			if(photos.rotation <= 180 && photos.rotation > 90){targetRotation = -180}
			if(photos.rotation <= -90 && photos.rotation < 0){targetRotation = 90}
			if(photos.rotation <= -180 && photos.rotation < -90){targetRotation = 180}
			trace('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '+photos.rotation+' = '+targetRotation);
			*/
			
			//var targetScale:Number = photos.scaleX * photos.scaleY + 5.0;	
			var targetScale:Number = 1.0;	
			//trace(targetScale);		
    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.8, transition:"easeinoutquad"});	
		}
	}
	
	private function gridPhotos(e:Event):void
	{
	
		//Tweener.addTween(spr2, {scaleX: targetScale, scaleY: 5.0, rotation:180, time:1.0, transition:"easeinoutquad"});
		
		const gap:int = 15; // horizental and vertical gap
		
		var rowWidth:int = gap; // current row width
		var rowBaseline:int = gap; // baseline of current row
		var rowHeight:int = gap; // height of the tallest child in current row
		
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{	
			minX = -450, maxX = 1024;
			minY = -250, maxY = 200;
			
			var child:DisplayObject = photos.getChildAt(i);
			if(child is Shape) continue; // void its 'clickgrabber'
			
			var bounds:Rectangle = child.getBounds(photos);
			var selfBounds:Rectangle = child.getBounds(child);
			var xOff:Number = selfBounds.x * child.scaleX;
			var yOff:Number = selfBounds.y * child.scaleY;
			//trace(bounds);
			
			if(bounds.height > rowHeight) rowHeight = bounds.height;
			
			var targetX:int = rowWidth-xOff+minX;
			var targetY:int = rowBaseline-yOff+minY;
			var targetRotation:int = 0;			
			//var targetRotation:int = photos.rotation;
	
			
			var targetScale:Number = 0.5;	
		
			
			rowWidth += bounds.width + gap;
			if(rowWidth > maxX) // need to start a new row
			{
				rowWidth = gap;
				rowBaseline += rowHeight + gap;
				rowHeight = gap;
				
				targetX = rowWidth-xOff;
				targetY = rowBaseline-yOff;
				
			}
		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.8, transition:"easeinoutquad"});
		//syncPhotos(child);
		}
	}
	private function messPhotos(e:Event):void
	{
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
			var child:DisplayObject = photos.getChildAt(i);
			if(child is Shape) continue; // void its 'clickgrabber'
			minX = -300, maxX = 300;
			minY = -300, maxY = 300;
			var targetX:int = minX + Math.random() * (maxX-minX);
			var targetY:int = minY + Math.random() * (maxY-minY);
			var targetRotation:int = Math.random()*180;
			var targetScale:Number = (Math.random()*0.4) + 0.5;			
			Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.8, transition:"easeinoutquad"});
			}
		}
	}	
}