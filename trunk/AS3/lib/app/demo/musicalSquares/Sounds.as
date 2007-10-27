package app.demo.musicalSquares
{
	import com.touchlib.*;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	//import com.touchlib.*;


	public class Sounds {
		
		private static var C1key = new Sound(new URLRequest("www/mp3/C1.mp3"));
		private static var D1key = new Sound(new URLRequest("www/mp3/D1.mp3"));
		private static var E1key = new Sound(new URLRequest("www/mp3/E1.mp3"));
		private static var F1key = new Sound(new URLRequest("www/mp3/G1.mp3"));
		private static var G1key = new Sound(new URLRequest("www/mp3/A1.mp3"));
		private static var A1key = new Sound(new URLRequest("www/mp3/Perc1.mp3"));
		private static var B1key = new Sound(new URLRequest("www/mp3/Perc2.mp3"));
		private static var C2key = new Sound(new URLRequest("www/mp3/Perc3.mp3"));		
		
		private static var sndTransform:SoundTransform = new SoundTransform();	

		/////////////////////////////////////////////
		//Play sound when ball hits
		/////////////////////////////////////////////
		public static function sound(ball0:Throwing):void {			
			
			var newVolume:Number = .1;
			
			switch (ball0.name) {								
				
				case "ball0" :
                    sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    C1key.play(0, 0, sndTransform);
					break;
				case "ball1" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    D1key.play(0, 0, sndTransform);
					break;
				case "ball2" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    E1key.play(0, 0, sndTransform);
					break;
				case "ball3" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    F1key.play(0, 0, sndTransform);
					break;		
				case "ball4" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    G1key.play(0, 0, sndTransform);
					break;
				case "ball5" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    A1key.play(0, 0, sndTransform);
					break;
				case "ball6" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    B1key.play(0, 0, sndTransform);
					break;
				case "ball7" :
		            sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
                    C2key.play(0, 0, sndTransform);
					break;	
			}					
		}		
		
		/////////////////////////////////////////////
		//Play sound when ball hits
		/////////////////////////////////////////////
		public static function sound2(ball1:Throwing):void {
	
			var newVolume:Number = .1;
		
			switch (ball1.name) {
	
				case "ball0" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					C1key.play(0, 0, sndTransform);
					break;
				case "ball1" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					D1key.play(0, 0, sndTransform);
					break;
				case "ball2" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					E1key.play(0, 0, sndTransform);
					break;
				case "ball3" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					F1key.play(0, 0, sndTransform);
					break;
				case "ball4" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					G1key.play(0, 0, sndTransform);
					break;
				case "ball5" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					A1key.play(0, 0, sndTransform);
					break;
				case "ball6" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					B1key.play(0, 0, sndTransform);
					break;
				case "ball7" :
					sndTransform.volume = newVolume;
					//sndTransform.pan = newPan;
					C2key.play(0, 0, sndTransform);
					break;
			}
		}		
	}
}