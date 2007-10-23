package app.tank
{
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;
	import com.touchlib.*;
	import app.tank.*;
	
	dynamic public class TankProjectile extends MovieClip
	{
		private var facingVec:Point;			
		private var lifeCount:int;
		private var game:TankGame;
		public var owner:PlayerTank;

		public function TankProjectile(ang:Number, vel:Number, o:PlayerTank, g:TankGame)
		{
			game = g;
			owner = o;
			lifeCount = 20;
			var upVec:Point = new Point(0,-1);
			
			var m:Matrix = new Matrix();
			m.rotate((ang * Math.PI) / 180.0);
			m.scale(vel, vel);
			facingVec = m.transformPoint(upVec);			
			
			this.rotation = ang;
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate);					
		}

		public function frameUpdate(e:Event)
		{
			lifeCount -= 1;
			
			if(lifeCount <= 0)
			{
				removeSelf();
			} else {
				this.x += facingVec.x;
				this.y += facingVec.y;
				
				// Check for collisions?
				game.projectileHandleCollisions(this);
			}
		}
		
		public function removeSelf()
		{
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME, this.frameUpdate);
			delete this;			
		}
	}
}