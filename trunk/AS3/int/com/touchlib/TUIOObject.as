package com.touchlib {

	import flash.display.Sprite;
	import flash.display.DisplayObject;	
	//import flash.display.InteractiveObject;	
	//import flash.display.MovieClip;	
	import flash.geom.Point;
	//import flash.utils.Timer;
	//import flash.events.MouseEvent;
	//import flash.events.Event;

	public class TUIOObject 
	{
		public var x:Number;
		public var y:Number;
		
		public var oldX:Number;
		public var oldY:Number;
		
		public var dX:Number;
		public var dY:Number;				
		
		public var area:Number = 0;
		public var height:Number = 0;
		public var width:Number = 0;
		
		public var TUIOClass:String;		// cur or Obj.. 
		public var sID:int;
		public var ID:int;
		public var angle:Number;		
		public var pressure:Number;
		
		private var isNew:Boolean;
		public var isAlive:Boolean;		
		public var obj:Object;
		public var spr:Sprite;
		public var trlx:Sprite;
		
		public var color:int;
		
		var aListeners:Array;

		public function TUIOObject (cls:String, id:int, px:Number, py:Number, dx:Number, dy:Number, sid:int = -1, ang:Number = 0, ht:Number=0.0, wd:Number=0.0, o:Object = null)
		{
			aListeners = new Array();
			TUIOClass = cls;
			ID = id;
			x = px;
			y = py;
			oldX = px;
			oldY = py;
			dX = dx;
			dY = dy;
			sID = sid;
			angle = ang;
			isAlive = true;
			height = ht;
			width = wd;
			area = ht * wd;
							
			spr = new TUIOCursor(ID.toString(),0xFFFFFF, area);			
			
			spr.x = x;
			spr.y = y;  		
			
			try {
 	 			obj = o;
			} catch (e)
			{
				obj = null;
			}
			
			//trace("Start " + ID + ", " + sID + " (" + int(px) + "," + int(py) + ")");
			

			
			isNew = true;
		}
		
		public function notifyCreated()
		{
			if(obj)
			{
				try
				{
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
					//trace("Down : " + localPoint.x + "," + localPoint.y);
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OVER, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));													
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_DOWN, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));									
				} catch (e)
				{
						trace("Failed : " + e);
//					trace(obj.name);
					obj = null;
				}
			}			
		}
		
		public function setObjOver(o:DisplayObject)
		{
			try {
				
				if(obj == null)
				{
					obj = o;				
					if(obj) 
					{
						var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
						obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OVER, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));					
					}
				} else if(obj != o) 
				{
					
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));								
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OUT, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));
					if(o)
					{
						localPoint = obj.parent.globalToLocal(new Point(x, y));
						o.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OVER, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));
					}
					obj = o;								
				}
			} catch (e)
			{
//				trace("ERROR " + e);
			}
		}
		
		public function addListener(reciever:Object)
		{
			for(var i:int = 0; i<aListeners.length; i++)
			{
				if(aListeners[i] == reciever)			
					return;
			}
			
			aListeners.push(reciever);
		}
		public function removeListener(reciever:Object)
		{
			for(var i:int = 0; i<aListeners.length; i++)
			{
				if(aListeners[i] == reciever)
					aListeners.splice(i, 1);
			}
		}		
		
		public function kill()
		{
			//trace("Die " + ID);			
			var localPoint:Point;
			
			if(obj && obj.parent)
			{				
				localPoint = obj.parent.globalToLocal(new Point(x, y));				
				obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OUT, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));				
				obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_UP, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));									
			}			
			obj = null;
			
			for(var i:int=0; i<aListeners.length; i++)
			{
				localPoint = aListeners[i].parent.globalToLocal(new Point(x, y));				
				aListeners[i].dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_UP, true, false, x, y, localPoint.x, localPoint.y, 0, 0, aListeners[i], false,false,false, true, 0, TUIOClass, ID, sID, angle));								
			}
			
			aListeners = new Array();
		}
		
		public function notifyMoved()
		{
			var localPoint:Point;	
			trace("Notify moved");
			for(var i:int=0; i<aListeners.length; i++)
			{			
				localPoint = aListeners[i].parent.globalToLocal(new Point(x, y));			
				trace("Notify moved"+ localPoint);			
				aListeners[i].dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, 0, 0, aListeners[i], false,false,false, true, 0, TUIOClass, ID, sID, angle));								
			}			
		}
	}
}