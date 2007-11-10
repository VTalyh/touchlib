package app.core.object {
	//import com.touchlib.*;	
	import app.core.action.RotatableScalable;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	
	public class TextObject extends RotatableScalable
	{
		[Embed(source="Arial.ttf", fontFamily="myFont")] 
		public var myFont:Class;
		
		public var t: TextField;
		public var mc: MovieClip;
		public var inString:String;	
		
		public function TextObject(inVar:String)
		{					
			//var linkedFont:myFont = new myFont();
			//var txt01:TextField = new TextField();
			//txt01.defaultTextFormat = (new TextFormat(linkedFont.fontName));			
			//var embeddedFontClass = getDefinitionByName("myFont");
			//Font.registerFont(embeddedFontClass);
			
			
			inString = inVar;
			
			mc = new MovieClip();
			mc.graphics.beginFill(0xffffff,0.0);
			mc.graphics.drawRect(-200,-200,400,400);
			//noScale = true;
			//noRotate = true;
			noSelection = true;
			noMove = true;	
					
			trace('Text Object Created');
			
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0xFFFFFF;
			format.size= 72;
			

			t = new TextField();
			t.autoSize = TextFieldAutoSize.CENTER;
			//t.wordWrap = true;
			t.background = true;	
			t.backgroundColor = 0x000000;	
			t.border = true;	
			t.borderColor = 0x333333;			
			t.embedFonts = true;
			t.selectable  = true;		 
			if(inString != ' '){	t.text = ' '+inString+' ';}
			else{	t.text = "~";}
			
		
			t.name = "t";
			t.x = 0;
			t.y = -36;
			t.setTextFormat(format);
			
			//mc.addChild(t);
			this.addChild(t);
		}
	}
}