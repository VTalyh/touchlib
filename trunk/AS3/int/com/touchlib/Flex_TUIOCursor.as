package com.touchlib
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class TUIOCursor extends Sprite
	{
		private var DEBUG_TEXT:TextField;	
		
		public function TUIOCursor(debugText:String)
		{
			super();
			if(TUIO.debugMode){
			// Draw us the lil' circle
			graphics.beginFill(0xFFFFFF , 0.5);					
			graphics.drawCircle(0,0,5);
			graphics.drawCircle(0,0,10);
			graphics.endFill();
			graphics.lineStyle(1, 0x000000, 1);	
			graphics.drawCircle(0,0,10);		
			graphics.drawCircle(0,0,11);		
			graphics.lineStyle(1, 0x000000, 1);			
			graphics.drawCircle(0,0,12);	
		}
		else
		{		
			graphics.beginFill(0xFFFFFF , 0.25);					
			graphics.drawCircle(0,0,12);
			}	
			if(TUIO.debugMode){
			// Add textfield for debugging, shows the cursor id
			if (debugText != '' || debugText != null)
			{
				var format:TextFormat = new TextFormat();
				DEBUG_TEXT = new TextField();
	        	format.font = 'Verdana';
	     		format.color = 0xFFFFFF;
	       	 	format.size = 10;
				DEBUG_TEXT.defaultTextFormat = format;
				DEBUG_TEXT.autoSize = TextFieldAutoSize.LEFT;
				DEBUG_TEXT.background = true;	
				DEBUG_TEXT.backgroundColor = 0x000000;	
				DEBUG_TEXT.border = true;	
				DEBUG_TEXT.text = '';
				DEBUG_TEXT.appendText(' '+debugText+'  ');
				
				DEBUG_TEXT.x = 15;
				DEBUG_TEXT.y = -8;  
				
				addChild(DEBUG_TEXT);
			}}
		}
		
	}
}