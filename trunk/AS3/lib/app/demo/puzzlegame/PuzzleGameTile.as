/* 
Class/Package name: PuzzleGameTile
Description: Part of the PuzzleGame
Created by Laurence Muller (aka Falcon4ever)
E-mail: info@falcon4ever.com
Site: www.multigesture.net
License: GPL
*/

package app.demo.puzzlegame {
	
	import flash.display.*;
	import flash.events.*;
	
	import com.touchlib.TUIO;
	import app.demo.puzzlegame.*;		
	import app.core.action.RotatableScalable;
	
	public class PuzzleGameTile extends RotatableScalable {		
	
		// Items
		private var clickgrabber:Shape = new Shape();
		private var item:Sprite = new Sprite();	
				
		public function PuzzleGameTile() {											
			
			noScale = true;
			noRotate = true;		

			// Clickgrabber
			clickgrabber.scaleX = 1;
			clickgrabber.scaleY = 1;
			
			clickgrabber.graphics.beginFill(0xffffff, 0.1);
			clickgrabber.graphics.drawRect(0, 0, 1, 1);
			clickgrabber.graphics.endFill();						

			addChild(clickgrabber);			
		}		
	}
}
