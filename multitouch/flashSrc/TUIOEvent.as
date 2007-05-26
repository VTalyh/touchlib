package whitenoise {
	import flash.events.*;
	import flash.xml.*;
	import flash.net.*
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.describeType;

	
	public class TUIOEvent extends Event
	{
		public var TUIOClass:String;
		public var sID:int;
		public var ID:int;
		public var angle:Number;
		public var stageX:Number;
		public var stageY:Number;
		public var localX:Number;
		public var localY:Number;
		public var buttonDown:Boolean;
		public var relatedObject:DisplayObject;
		
		public static var MoveEvent:String = "TUIO_MOVE";
		public static var DownEvent:String = "TUIO_DOWN";		
		public static var UpEvent:String = "TUIO_UP";				
		public static var RollOverEvent:String = "TUIO_ROLLOVER";						
		public static var RollOutEvent:String = "TUIO_ROLLOUT";								
		
		public function TUIOEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, stageX:Number = 0, stageY:Number = 0, localX:Number = 0, localY:Number = 0, relatedObject:DisplayObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, TUIOClass:String = "2Dcur", ID:int = -1, sID:int = -1, angle:Number = 0.0)
		{
			this.TUIOClass = TUIOClass;
			this.sID = sID;
			this.ID = ID;
			this.angle = angle;
			this.stageX = stageX;
			this.stageY = stageY;
			this.localX = localX;
			this.localY = localY;
			this.buttonDown = buttonDown;
			this.relatedObject = relatedObject;

			super(type, bubbles, cancelable);
			
//			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			
		}

	}
}