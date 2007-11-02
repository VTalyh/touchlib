/*
This class will take objects within a PhotoCanvas element and sort them according to pre-defined settings.

Example: http://youtube.com/watch?v=zu7fNQYmzUs & http://oskope.com/

*/

package app{
import com.touchlib.*;
import app.*;
import flash.display.*;
import flash.system.Capabilities;
import flash.events.*;

//http://code.google.com/p/tweener/
import com.tweener.transitions.Tweener;
import flash.display.DisplayObject;
import flash.geom.Rectangle;

public class Arrange extends Sprite
{	
	private var photos:PhotoCanvas;
	private var flickr_obj:Flickr;
	
	private var spr0:Shape;
	private var spr1:Shape;
	private var spr2:Shape;
	private var spr3:Shape;
		
	public function Arrange()
	{
	
		photos = new PhotoCanvas();
		this.addChildAt(photos, 0);	

		//var sub_object_01:PhotoLocal = new PhotoLocal(photos);
		//var flickr_obj:Flickr = new Flickr(photos, 100, -photos.width/2, -photos.height/2);		
		//var nLoad_obj_0 = new nLoad(photos,1,"mine","", 0, 0, 1,"http://nui.mine.nu/declaration.jpg");
		var nLoad_obj_0 = new nLoad(photos, 100, "mine", "", 0, 0, 1,"");
		
		var spr0:Shape = new Shape();
		spr0.graphics.beginFill(0xE3E2E2,1.0);
		spr0.graphics.drawRect(-0,-0,300,300);
		spr0.graphics.endFill();	
		spr0.x = (-photos.width/2)+0; spr0.y = -photos.height/2;
		spr0.addEventListener(TUIOEvent.DownEvent, stackPhotos, false, 0, true);
		photos.addChild(spr0);
		
		var spr1:Shape = new Shape();
		spr1.graphics.beginFill(0xD7D6D6,1.0);
		spr1.graphics.drawRect(-0,-0,300,300);
		spr1.graphics.endFill();	
		spr1.x = (-photos.width/2)+300; spr1.y = -photos.height/2;
		spr1.addEventListener(TUIOEvent.DownEvent, messPhotos, false, 0, true);	
		photos.addChild(spr1);
		
		var spr2:Shape = new Shape();
		spr2.graphics.beginFill(0xC0C0C0,1.0);
		spr2.graphics.drawRect(-0,-0,300,300);
		spr2.graphics.endFill();	
		spr2.x = (-photos.width/2)+600; spr2.y = -photos.height/2;
		spr2.addEventListener(TUIOEvent.DownEvent, gridPhotos, false, 0, true);	
		photos.addChild(spr2);
		
		var spr3:Shape = new Shape();
		spr3.graphics.beginFill(0x898585,1.0);
		spr3.graphics.drawRect(-0,-0,300,300);
		spr3.graphics.endFill();		
		spr3.x = photos.width/2-300; spr3.y = -photos.height/2;
		spr3.addEventListener(TUIOEvent.DownEvent, function(){nLoad_obj_0.toggleObjects();}, false, 0, true);		
		//spr3.addEventListener(TUIOEvent.UpEvent, stackPhotos, false, 0, true);
		photos.addChild(spr3);	
		
		photos.scaleX=0.3, photos.scaleY=0.3;	
		photos.x=700, photos.y=700;
	}
	
	//private var photoW:int = photos.width;
	private var minX:int = -2000, maxX:int = 2000;
	private var minY:int = -2000, maxY:int = 2000;
	
	private function toggleCanvas(_photos:Sprite)
	{
		removeChild(_photos);
	}
	private function stackPhotos(e:TUIOEvent):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
			minX = -2000, maxX = 2000;
			minY = -2000, maxY = 2000;
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
			var targetScale:Number = photos.scaleX * photos.scaleY + 5.0;	
			trace(targetScale);		
    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.8, transition:"easeinoutquad"});	
		}
	}
	
	private function gridPhotos(e:TUIOEvent):void
	{
	
		//Tweener.addTween(spr2, {scaleX: targetScale, scaleY: 5.0, rotation:180, time:1.0, transition:"easeinoutquad"});
		
		const gap:int = 10; // horizental and vertical gap
		
		var rowWidth:int = gap; // current row width
		var rowBaseline:int = gap; // baseline of current row
		var rowHeight:int = gap; // height of the tallest child in current row
		
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{	
			minX = -2000, maxX = 3900;
			minY = -2000, maxY = 900;
			
			var child:DisplayObject = photos.getChildAt(i);
			if(child is Shape) continue; // void its 'clickgrabber'
			
			var bounds:Rectangle = child.getBounds(photos);
			var selfBounds:Rectangle = child.getBounds(child);
			var xOff:Number = selfBounds.x * child.scaleX;
			var yOff:Number = selfBounds.y * child.scaleY;
			//trace(bounds);
			
			if(bounds.height > rowHeight) rowHeight = bounds.height;
			
			var targetX:int = rowWidth-xOff+minX+200;
			var targetY:int = rowBaseline-yOff+minY+450;
			var targetRotation:int = 0;			
			//var targetRotation:int = photos.rotation;
	
			
			var targetScale:Number = 0.85;	
		
			
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
	private function messPhotos(e:TUIOEvent):void
	{
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
			var child:DisplayObject = photos.getChildAt(i);
			if(child is Shape) continue; // void its 'clickgrabber'
			minX = -1500, maxX = 1500;
			minY = -1600, maxY = 1300;
			var targetX:int = minX + Math.random() * (maxX-minX) + 100;
			var targetY:int = minY + Math.random() * (maxY-minY);
			var targetRotation:int = Math.random()*180 - 90;
			var targetScale:Number = (Math.random()*0.4) + 0.5;			
			Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX-150, y:targetY+220, time:0.8, transition:"easeinoutquad"});
			}
		}
		

	}	
}