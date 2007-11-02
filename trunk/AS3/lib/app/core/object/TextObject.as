package app.core.object {
	import com.touchlib.*;	
	import app.core.action.RotatableScalable;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.geom.*;		
	import flash.text.*;
	import flash.utils.getDefinitionByName;
	
	public class TextObject extends RotatableScalable
	{
		
		private var t: TextField;
		private var mc: MovieClip;
		
		public function TextObject()
		{	
			mc = new MovieClip();
			mc.graphics.beginFill(0xffffff,0.0);
			mc.graphics.drawRect(-200,-200,400,400);
			//noScale = true;
			//noRotate = true;

			
			/**/
			//var linkedFont:myFont = new myFont();
			//var txt01:TextField = new TextField();
			//txt01.defaultTextFormat = (new TextFormat(linkedFont.fontName));
			
			var embeddedFontClass = getDefinitionByName("myFont");
			Font.registerFont(embeddedFontClass);
			
			
			var format:TextFormat= new TextFormat();
			format.font= "Agency FB";
			format.color= 0x000000;
			format.size= 72;

			t = new TextField();
			t.autoSize = TextFieldAutoSize.CENTER;
			//t.wordWrap = true;
			t.background = true;
			t.border = false;				
			t.embedFonts = true;
			t.text = "type here...";
			t.name = "t";
			t.x = 0;
			t.y = -36;
			t.setTextFormat(format);
			//t.setTextFormat(fmt);
			
			
			//mc.addChild(t);
			this.addChild(t);
		}
	}
}