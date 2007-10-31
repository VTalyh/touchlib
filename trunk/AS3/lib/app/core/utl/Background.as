/*////////////////////////////////////////////////////
//////////////////////////////////////////////////////
////
////			Full Browser background image
////
////			by Josh Chernoff ( GFX Complex )
////			Copy right ~ josh chernoff ~ 2007
////  				   All rights reseverd
////
////
////			May be redistobuted under The 
////      GNU General Public License (GPL) Agreement
////
//////////////////////////////////////////////////////
*/////////////////////////////////////////////////////

/*
Class constructor requires two arguments 
(stage:Stage for refure to the stage) and 
(url:String for loading the background)
public class BrowserBackground(url:String);
*/


package com.gfxcomplex.display{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Bitmap;
	import flash.utils.Timer;

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;


	public class BrowserBackground extends Sprite{
		public static const BACKGROUND_LOADED:String  = "backgroundLoaded";
		public static const BACKGROUND_LOADING:String  = "backgroundLoading";

		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		private var _imageHolder:Sprite;
		private var _bitmap:Bitmap;
		private var _loader:Loader;
		private var _urlReqest:URLRequest;
		private var timer:Timer;
		
		public function get bytesTotal():Number{
			return _bytesTotal;
		}
		public function get bytesLoaded():Number{
			return _bytesLoaded;
		}		

		function BrowserBackground(url:String) {
			//image loader
			_loader = new Loader();
			_urlReqest = new URLRequest(url);

			//events stuff
			configureListeners(_loader.contentLoaderInfo);
			_loader.load(_urlReqest);
			
			
		}
		//events managment
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			dispatcher.addEventListener(Event.INIT, initHandler, false, 0, true);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.OPEN, openHandler, false, 0, true);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		}
		//Complete the loading
		private function completeHandler(event:Event):void {
			var sW:Number = stage.stageWidth;
			var sH:Number = stage.stageHeight;
			timer = new Timer(28, 44);
			//trace(_loader.contentLoaderInfo);
			
			var loader:Loader = Loader(event.target.loader);
			_bitmap = Bitmap(loader.content);
			_imageHolder = new Sprite();

			_bitmap.y -= _bitmap.height;
			_bitmap.smoothing = true;
			
			addChild(_imageHolder);
			_imageHolder.addChild(_bitmap);


			//Check scale and resize
			_imageHolder.width = sW;
			_imageHolder.scaleY = _imageHolder.scaleX;
			
			if (_imageHolder.height < sH) {
				_imageHolder.height = sH;
				_imageHolder.scaleX = _imageHolder.scaleY;
			}
			_imageHolder.y = sH ;
			_imageHolder.alpha = 0;
			timer.addEventListener(TimerEvent.TIMER, timerListener, false, 0, true);
			timer.start();
			
			//stage settings
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
			dispatchEvent(new Event(BrowserBackground.BACKGROUND_LOADED));
		}		
		
		private function progressHandler(event:ProgressEvent):void {
			//preloader ready
			//trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			dispatchEvent(new Event(BrowserBackground.BACKGROUND_LOADING));					
		}
		

		//On stageResized Event
		private function stageResized(event:Event):void {
			var sH:Number = stage.stageHeight;
			_imageHolder.width = stage.stageWidth;
			_imageHolder.scaleY = _imageHolder.scaleX;
			if (_imageHolder.height < sH) {
				_imageHolder.height = sH;
				_imageHolder.scaleX = _imageHolder.scaleY;
			}
			_imageHolder.y = sH;
		}
		
		//debugging and error handling/////////////////////////////////////////////
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			//trace("httpStatusHandler: " + event);
		}

		private function initHandler(event:Event):void {
			//trace("initHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function openHandler(event:Event):void {
			//trace("openHandler: " + event);
		}
		private function timerListener(e:TimerEvent){
			_imageHolder.alpha += .025;
			if(_imageHolder.alpha == 1.10){
				timer.removeEventListener(TimerEvent.TIMER, timerListener);
			}
			e.updateAfterEvent();
		}
	}//class
}//package