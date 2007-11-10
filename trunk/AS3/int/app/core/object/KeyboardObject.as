package app.core.object {
	import app.core.action.RotatableScalable;
	
	import com.touchlib.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;	
	
	public class KeyboardObject extends RotatableScalable
	{	
		[Embed(source="Arial.ttf", fontFamily="myFont")] var myFont:Class;
		
		public var keyboard: Loader;
		public var inShift:Boolean = false;

		
		public function KeyboardObject()
		{				
			noSelection = true;			
			
			keyboard = new Loader();

			keyboard.load(new URLRequest("www/keyboard.swf"));
			
			keyboard.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange );	
			
			this.addChild(keyboard);
		
		
		}
		function arrange(e:Event) {	
			trace('Keyboard Object Created');
			var chars: String = 'qwertyuiopasdfghjklzxcvbnm';
			var mc:MovieClip = keyboard.content;
			
			for (var i:int = 0; i< chars.length; i++) {
				mc['button'+chars.charAt(i).toString().toUpperCase()].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey);
				mc['button'+chars.charAt(i).toString().toUpperCase()].addEventListener(MouseEvent.CLICK, this.MouseDownKey);
				mc['button'+chars.charAt(i).toString().toUpperCase()].char = chars.charAt(i).toString();
			}

			mc['buttonDot'].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey);
			mc['buttonDot'].char = ".".toString();

			mc['buttonComma'].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey);
			mc['buttonComma'].char = ",".toString();
			
			mc['buttonSpace'].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey);
			mc['buttonSpace'].char = " ";
			
			mc['buttonBackSpace'].addEventListener(TUIOEvent.TUIO_DOWN, this.BackSpaceDown);
			mc['buttonEnter'].addEventListener(TUIOEvent.TUIO_DOWN, this.EnterDown);
			mc['buttonBackSpace'].addEventListener(MouseEvent.CLICK, this.MouseBackSpaceDown);
			mc['buttonEnter'].addEventListener(MouseEvent.CLICK, this.MouseEnterDown);
			
			mc['buttonShift'].addEventListener(TUIOEvent.TUIO_DOWN, this.ShiftDown);
			mc['buttonShift'].addEventListener(TUIOEvent.TUIO_UP, this.ShiftUp);
		}

		function ShiftDown(e:Event) {
			inShift = !inShift;
			e.stopPropagation();
		}
		function ShiftUp(e:Event) {
			inShift = false;			
			e.stopPropagation();
		}
		function BackSpaceDown(e:Event) {
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "Arial";
			format.color= 0x000000;
			format.size= 72;
			t.setTextFormat(format);			
			stage.setChildIndex(t.parent, parent.numChildren-1);
			e.stopPropagation();
		}
		function EnterDown(e:Event) {			
			parent.getChildByName('TextObject_0').name = 'TextObject_1';
			var TextObject_0: TextObject = new TextObject();
			TextObject_0.name = 'TextObject_0';
			TextObject_0.rotation = rotation;
			TextObject_0.x = 0;
			TextObject_0.y = -125;
			parent.addChild(TextObject_0);	
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');			
			var tmp:String = t.text;
			t.text = '~';
			t.text += tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0x000000;
			format.size= 72;
			t.setTextFormat(format);			
			parent.setChildIndex(t.parent, parent.numChildren-1);		
			e.stopPropagation();
		}
		function DownKey(e:Event) {					
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var ch: String;			
			if (t.text == "~") t.text = '';			
			if (e.relatedObject.parent.char != undefined) 
			 	ch = e.relatedObject.parent.char
			else 
				ch = e.relatedObject.parent.parent.char;
				
			if (inShift) {
				t.text += ch.toUpperCase();
			} else {
				t.text += ch;
			}		
			
			var format:TextFormat= new TextFormat();
			format.font = "myFont";
			format.color= 0x000000;
			format.size = 72;
			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
		 
			e.stopPropagation();
			
		}
		function MouseDownKey(e:Event) {					
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var ch: String;			
			if (t.text == "~") t.text = '';	
			if (e.target.parent.char != undefined) 
			 	ch = e.target.parent.char;
			else 
				ch = e.target.parent.parent.char;
				
			if (inShift) {
				t.text += ch.toUpperCase();
			} else {
				t.text += ch;
			}		
			
			var format:TextFormat= new TextFormat();
			format.font = "myFont";
			format.color= 0x000000;
			format.size = 72;
			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
		 
			e.stopPropagation();
			
		}	
		function MouseBackSpaceDown(e:Event) {
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "Arial";
			format.color= 0x000000;
			format.size= 72;
			t.setTextFormat(format);			
			//stage.setChildIndex(t.parent, parent.numChildren);
			e.stopPropagation();
		}
		function MouseEnterDown(e:Event) {			
			parent.getChildByName('TextObject_0').name = 'TextObject_1';
			var TextObject_0: TextObject = new TextObject();
			TextObject_0.name = 'TextObject_0';
			TextObject_0.rotation = rotation;
			TextObject_0.x = 0;
			TextObject_0.y = 0;
			parent.addChild(TextObject_0);	
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');			
			var tmp:String = t.text;
			t.text = '~';
			t.text += tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0x000000;
			format.size= 72;
			t.setTextFormat(format);			
			parent.setChildIndex(t.parent, parent.numChildren-1);		
			e.stopPropagation();
		}
	}
}