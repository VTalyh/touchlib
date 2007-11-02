package app.core.object {
	
	import com.touchlib.*;
	import app.core.action.RotatableScalable;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.media.SoundTransform;
	import flash.media.Video;
/*	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
*/


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

		// Default values
		private var border_size:Number = 8.0;
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;
		private var velAng:Number = 0.0;
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;
		
		public function VideoObject(url:String) {
			this.x = 1600 * Math.random() - 800;
			this.y = 1600 * Math.random() - 800;

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
			play_btn.graphics.beginFill(0x000000, 0.9);
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

			border.graphics.beginFill(0xffffff, 0.75);
			border.graphics.drawRoundRect(0, 0, video1.width+(border_size * 2), video1.height+(border_size * 2),10);
			border.graphics.endFill();

			addChild(border);
			addChild(video1);
			addChild(clickgrabber);
			addChild(play_btn);
			addChild(pause_btn);
			
			toggle_play = 0;
			pause_btn.visible = false;
			
			//this.addEventListener(Event.ENTER_FRAME, slide);
			pause_btn.addEventListener(TUIOEvent.TUIO_DOWN, buttontouch, false, 0, true);
			play_btn.addEventListener(TUIOEvent.TUIO_DOWN, buttontouch, false, 0, true);
																	  
			// Pause video on add
			stream1.seek(1);
			stream1.pause();			
		}
		
		public function buttontouch(e:TUIOEvent) {			
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
/*		
		private function getShadowFilter():BitmapFilter {
			var color:Number = 0x000000;
			var angle:Number = 45;
			var alpha:Number = 0.8;
			var blurX:Number = 8;
			var blurY:Number = 8;
			var distance:Number = 15;
			var strength:Number = 0.65;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout);
		}
*/
		public override function released(dx:Number, dy:Number, dang:Number) {
			velX = dx;
			velY = dy;

			velAng = dang;
		}
		
		private function slide(e:Event) {
			if (this.state == "none") {
				if (Math.abs(velX) < 0.001) {
					velX = 0;
				} else {
					x += velX;
					velX *= friction;
				}
				if (Math.abs(velY) < 0.001) {
					velY = 0;
				} else {
					y += velY;
					velY *= friction;
				}
				if (Math.abs(velAng) < 0.001) {
					velAng = 0;
				} else {
					velAng *= angFriction;
					this.rotation += velAng;
				}
			}
		}
	}
}