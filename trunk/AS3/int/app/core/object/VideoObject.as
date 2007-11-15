package app.core.object {
	
	//import com.touchlib.*;
	import app.core.action.RotatableScalable;
	import app.core.element.*;

	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.media.SoundTransform;
	import flash.media.Video;


	public class VideoObject extends RotatableScalable {
		// Items
		private var clickgrabber:Shape = new Shape();
		private var border:Shape = new Shape();
		private var video1:Video;
		private var stream1:NetStream;
		private var connection:NetConnection;
		private var Client:Object;
		private var play_btn:Sprite = new Sprite();
		private var pause_btn:Sprite = new Sprite();
		private var toggle_play:Number;
		
		private var slider:HorizontalSlider;
		
		// Default values
		private var border_size:Number = 10.0;
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;
		private var velAng:Number = 0.0;
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;
		
		public function VideoObject(url:String) {
			this.x = 1000 * Math.random() - 500;
			this.y = 1000 * Math.random() - 500;
			this.x = 0;
			this.y = 0;
			connection = new NetConnection();
			connection.connect(null);

			Client = new Object();
			Client.onMetaData = onMetaData;

			stream1 = new NetStream(connection);
			stream1.soundTransform = new SoundTransform(1); // Range: 0 = sound off, 1 = sound on
			stream1.play( url );
			
			stream1.client = Client;

			video1 = new Video();
			video1.attachNetStream(stream1);
			//trace(stream1);
			stream1.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);

			video1.x = -video1.width/2;
			video1.y = -video1.height/2;
			video1.scaleX = 1.0;
			video1.scaleY = 1.0;

			border.x = video1.x-border_size;
			border.y = video1.y-border_size;
			
			
			//play_btn.graphics.lineStyle(0, 0x202020);
			play_btn.graphics.beginFill(0x00CC00, 0.0);
			play_btn.graphics.drawRect(video1.x+2, video1.y+2, 100, 100);
			play_btn.graphics.endFill();												
			//play_btn.graphics.lineStyle(0, 0x202020);
			play_btn.graphics.beginFill(0x000000, 1);
			play_btn.graphics.moveTo(video1.x+8, video1.y+7);
			play_btn.graphics.lineTo(video1.x+8, video1.y+7);
			play_btn.graphics.lineTo(video1.x+28, video1.y+17);			
			play_btn.graphics.lineTo(video1.x+8, video1.y+27);			
			play_btn.graphics.lineTo(video1.x+8, video1.y+7);	
			play_btn.graphics.endFill();
			play_btn.blendMode="invert";
			
			//pause_btn.graphics.lineStyle(0, 0x000000);
			pause_btn.graphics.beginFill(0xFFFFFF,0.0);
			pause_btn.graphics.drawRect(video1.x+2, video1.y+2, 100, 100);
			pause_btn.graphics.endFill();			
			//pause_btn.graphics.lineStyle(0, 0x202020);
			pause_btn.graphics.beginFill(0x000000, 0.25);
			pause_btn.graphics.drawRect(video1.x+9, video1.y+7, 6, 20);
			pause_btn.graphics.drawRect(video1.x+19, video1.y+7, 6, 20);
			pause_btn.graphics.endFill();
			pause_btn.blendMode="invert";
			
			
			
			clickgrabber.scaleX = video1.width;
			clickgrabber.scaleY = video1.height;
			clickgrabber.x = -video1.width/2;
			clickgrabber.y = -video1.height/2;

			//var wrapper:Wrapper = new Wrapper(colorBtn); 
			//var knob:TouchlibKnob=  new TouchlibKnob(20);
			var slider:HorizontalSlider = new HorizontalSlider(video1.width,20);
			//this.knob.x = 460;
			//this.knob.y=10;
			slider.x=-video1.width/2;
			slider.y=video1.height/2+5;
			//slider.rotation-=90;

			//this.addChild(knob);		
			//this.addChild(wrapper);
					
			/*
			// Disabled since most movies are small anyway (320x240)
			this.scaleX = (Math.random()*0.4) + 0.3;
			this.scaleY = this.scaleX;
			this.rotation = Math.random()*180 - 90;
			*/

			clickgrabber.graphics.beginFill(0xffffff, 0.1);
//			clickgrabber.graphics.beginFill(0xff00ff, 0.5);
			clickgrabber.graphics.drawRect(0, 0, 1, 1);
			clickgrabber.graphics.endFill();

			border.graphics.beginFill(0xffffff, 0.20);	
			border.graphics.lineStyle(1,0xffffff, 0.35);
			border.graphics.drawRect(0, 0, video1.width+(border_size * 2), video1.height+(border_size * 2)+25);
			border.graphics.endFill();

			addChild(border); 
			addChild(video1);
			addChild(clickgrabber);
			//addChild(play_btn);
			//addChild(pause_btn);	
			addChild(slider);			
			

			var wrapper0:Wrapper = new Wrapper(play_btn); 		
			var wrapper1:Wrapper = new Wrapper(pause_btn); 
			wrapper0.addEventListener(MouseEvent.CLICK, buttontouch);
			wrapper1.addEventListener(MouseEvent.CLICK, buttontouch);
			addChild(wrapper0);
			addChild(wrapper1);		
																	  
			toggle_play = 0;
			pause_btn.visible = false;
			stream1.seek(1);
			stream1.pause();			
		}
		
		public function buttontouch(e:Event) {			
			if(toggle_play == 0)
			{
				stream1.togglePause();
				pause_btn.visible = true;
				play_btn.visible = false;
				toggle_play = 1;
			}
			else
			{				
				stream1.pause();
				pause_btn.visible = false;
				play_btn.visible = true;
				toggle_play = 0;
			}
		}
		
		private function onMetaData(data:Object) {
			// _duration = data.duration;
		}
		
		private function onNetStatus(e:NetStatusEvent) {
			switch (e.info.code) {
				case 'NetStream.Buffer.Flush' :	// Video done
						stream1.seek(1);
						stream1.pause();
						pause_btn.visible = false;
						play_btn.visible = true;
						toggle_play = 0;
					break;
			}
		}

		public override function released(dx:Number, dy:Number, dang:Number) {
			velX = dx;
			velY = dy;
			velAng = dang;
		}		
	}
}