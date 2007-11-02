package app.core.object {
	import com.touchlib.*;	
	import app.core.action.RotatableScalable;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.geom.*;		
	import flash.text.*;
	
	//[Embed(source="C:\\Windows\\Fonts\\DIN.otf", fontFamily="DIN")] 
	
	public class KeyboardObject extends RotatableScalable
	{
		
		private var keyboard: Loader;
		private var inShift:Boolean = false;
		
		public function KeyboardObject()
		{	
			keyboard = new Loader();

			keyboard.load(new URLRequest("www/keyboard.swf"));
			
			keyboard.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange, false, 0, true );	
			
			this.addChild(keyboard);
		}
		function arrange(e:Event) {
		
			var chars: String = 'qwertyuiopasdfghjklzxcvbnm';
			var mc:MovieClip = new MovieClip();
			mc=keyboard.content;
			for (var i:int = 0; i< chars.length; i++) {
				mc['button'+chars.charAt(i).toString().toUpperCase()].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey, false, 0, true);
				mc['button'+chars.charAt(i).toString().toUpperCase()].char = chars.charAt(i).toString();
			}

			mc['buttonDot'].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey, false, 0, true);
			mc['buttonDot'].char = ".".toString();

			mc['buttonComma'].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey, false, 0, true);
			mc['buttonComma'].char = ",".toString();
			
			mc['buttonSpace'].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey, false, 0, true);
			mc['buttonSpace'].char = " ";
			
			mc['buttonBackSpace'].addEventListener(TUIOEvent.TUIO_DOWN, this.BackSpaceDown, false, 0, true);
			mc['buttonEnter'].addEventListener(TUIOEvent.TUIO_DOWN, this.EnterDown, false, 0, true);
			
			mc['buttonShift'].addEventListener(TUIOEvent.TUIO_DOWN, this.ShiftDown, false, 0, true);
			mc['buttonShift'].addEventListener(TUIOEvent.TUIO_UP, this.ShiftUp, false, 0, true);
			//mc['holder'].addEventListener(TUIOEvent.TUIO_DOWN, this.Holder, false, 0, true);
		}
		function Holder(e:Event) {
			e.stopPropagation();
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
			
			var t: TextField = parent.getChildByName('labels').getChildByName('t');
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "Agency FB";
			format.color= 0x000000;
			format.size= 72;

			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			
			e.stopPropagation();
			
		}
		function EnterDown(e:Event) {
		
			parent.getChildByName('labels').name = 'labels1';
			var labels: TextObject = new TextObject();
			labels.name = 'labels';
			labels.rotation = rotation;
			labels.x = x;
			labels.y = y;
			parent.addChild(labels);
			
			var t: TextField = parent.getChildByName('labels').getChildByName('t');
			
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "Agency FB";
			format.color= 0x000000;
			format.size= 72;

			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			
			e.stopPropagation();
		
		}
		function DownKey(e:Event) {
			//this.alpha -= 0.1;
		
			var t: TextField = parent.getChildByName('labels').getChildByName('t');
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);	
			var ch: String;
			
			if (t.text == "type here...") t.text = '';
			if (e.relatedObject.parent.char != undefined) {
			 	ch = e.relatedObject.parent.char;
			trace(ch);}
			else 
				ch = e.relatedObject.parent.parent.char;
				
			if (inShift) {
				t.text += ch.toUpperCase();
			} else {
				t.text += ch;
			}
				
			var format:TextFormat= new TextFormat();
			format.font = "Agency FB";
			format.color= 0x000000;
			format.size = 72;
			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			
			e.stopPropagation();
			
		}
	}
}