//===========================================================
//=========================================================//
//						-=ANTHEM=-
//	file: frameLimiter.as
//
//	copyright: Matthew Bush 2007
//
//	notes: limits framerate
//
//=========================================================//
//===========================================================



//===========================================================
// frame limiter
//===========================================================

package General{
	
	
	import flash.utils.getTimer;
	
	
	public class FRateLimiter{
		
		
		//======================
		// limit frame function
		//======================
		static public function limitFrame(maxFPS:uint){
			
			var fTime:uint = 1000 / maxFPS;
			
			while(Math.abs(newT - oldT) < fTime){
				newT = getTimer();
			}
			oldT = getTimer();
			
		}
		
		//======================
		// member vars
		//======================
		static var oldT:uint = getTimer();
		static var newT:uint = oldT;
	}

}