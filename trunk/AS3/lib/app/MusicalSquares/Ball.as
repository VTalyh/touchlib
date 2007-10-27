package app.MusicalSquares {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	
	public class Ball extends Sprite {
		
		public var radius:Number;
		private var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number = 1;
		
		public function Ball(radius:Number=40, color:uint=0xff0000) {
			this.radius = radius;
			this.color = color;
			init();
		}
		public function init():void {
			graphics.beginFill(color);
			graphics.lineStyle(2, 0xFFFFFF, 1, false, LineScaleMode.NONE);
			//graphics.drawCircle(radius/2, radius/2, radius);
			graphics.drawRect(-radius/2, -radius/2, radius, radius);			
			graphics.endFill();
			
			//this.x = this.width/2;
			//this.y = this.height/2;
		}
	}
}