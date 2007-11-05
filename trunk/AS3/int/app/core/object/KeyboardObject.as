package app.core.object {
	import app.core.action.RotatableScalable;
	
	import com.touchlib.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;	
	
	//[Embed(source="C:\\Windows\\Fonts\\Arial.ttf", fontFamily="Arial")] 
	
	public class KeyboardObject extends RotatableScalable
	{
		
		private var keyboard: Loader;
		private var inShift:Boolean = false;
		
		public function KeyboardObject()
		{	
			noSelection = true;
			
			keyboard = new Loader();

			keyboard.load(new URLRequest("www/keyboard.swf"));
			
			keyboard.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange );	
			
			this.addChild(keyboard);
		}
		function arrange(e:Event) {		
			var chars: String = 'qwertyuiopasdfghjklzxcvbnm';
		//	var mc:MovieClip = keyboard.content;
			var mc:MovieClip = new MovieClip();
			for (var i:int = 0; i< chars.length; i++) {
				mc['button'+chars.charAt(i).toString().toUpperCase()].addEventListener(TUIOEvent.TUIO_DOWN, this.DownKey);
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
			
			mc['buttonShift'].addEventListener(TUIOEvent.TUIO_DOWN, this.ShiftDown);
			mc['buttonShift'].addEventListener(TUIOEvent.TUIO_UP, this.ShiftUp);
			//mc['holder'].addEventListener(TUIOEvent.DownEvent, this.Holder);
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
			/*
			var t: TextField = parent.getChildByName('labels').getChildByName('t');
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "Arial";
			format.color= 0x000000;
			format.size= 72;

			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			*/
			e.stopPropagation();
		}
		function EnterDown(e:Event) {
			/*
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
			format.font= "Arial";
			format.color= 0x000000;
			format.size= 72;

			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			*/
			e.stopPropagation();
		}
		function DownKey(e:Event) {
			//this.alpha -= 0.1;
		/*	var t: TextField = parent.getChildByName('labels').getChildByName('t');
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);	
			var ch: String;
			
			if (t.text == " ~ ") t.text = '';
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
			format.font = "Arial";
			format.color= 0x000000;
			format.size = 72;
			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			*/
			e.stopPropagation();
		}
	}
}