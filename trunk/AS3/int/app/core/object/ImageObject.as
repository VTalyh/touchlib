package app.core.object{
	import app.core.action.RotatableScalable;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.*;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	
	import caurina.transitions.Tweener;
	
	import app.core.object.TextObject;	
	
	public class ImageObject extends RotatableScalable 
	{
		private var clickgrabber:Shape = new Shape();		
		private var photoLoader:Loader = null;		
		
		private var thisTween:Boolean;
		private var thisSlide:Boolean;	
			
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;		
		
		private var velAng:Number = 0.0;
		
		private var friction:Number = 0.45;
		private var angFriction:Number = 0.45;
		
		private var TextObject_0:TextObject;	
		
		public function ImageObject (url:String, mouseSelect:Boolean, thisTweenX:Boolean, thisSlideX:Boolean)
		{
			mouseSelection=mouseSelect;
			thisTween=thisTweenX;
			thisSlide=thisSlideX;
			//trace(stage);
			this.x = 1600 * Math.random() - 800;
			this.y = 1600 * Math.random() - 800;			
			photoLoader = new Loader();
			photoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange, false, 0, true);					
			//photoLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			
			clickgrabber.graphics.beginFill(0xffffff, 0.1);
			clickgrabber.graphics.drawRect(0, 0, 1,1);
			clickgrabber.graphics.endFill();			
			trace(url);
			var request:URLRequest = new URLRequest( url );			
			
			// Unload any current child
			// Load new photo as specified by request object
			// NOTE: Repeated calls to load photo will add children to display 
			//		 object. All the photos will continue to be displayed 
			//		 overlapping one another. Allows for reuse of display 
			//		 object.
			photoLoader.unload();
			photoLoader.load( request );						
						
			this.addChild( photoLoader );	
			this.addChild( clickgrabber );
			
			TextObject_0 = new TextObject(url);	
			TextObject_0.noMove=true;
			TextObject_0.visible=false;
			this.addChild(TextObject_0);		
			
			
				
//            var filter:BitmapFilter = getShadowFilter();
//            var myFilters:Array = new Array();
//            myFilters.push(filter);
//            filters = myFilters;			
			
			if(thisSlide){	
			this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);
			}
		
		}

		private function arrange( event:Event = null ):void 
		{	this.x = 0;
			this.y = 0;	
			this.scaleX = 0;
			this.scaleY = 0;	
			this.alpha = 1;
			this.rotation = 0;
			
			photoLoader.x = -photoLoader.width/2;
			photoLoader.y = -photoLoader.height/2;			
			photoLoader.scaleX = 1.0;
			photoLoader.scaleY = 1.0;			
			
			clickgrabber.scaleX = photoLoader.width;
			clickgrabber.scaleY = photoLoader.height;			
			clickgrabber.x = -photoLoader.width/2;
			clickgrabber.y = -photoLoader.height/2;			
			
			TextObject_0.visible=true;
			TextObject_0.scaleX = 0.17;
			TextObject_0.scaleY = 0.17;	
			TextObject_0.y=photoLoader.height/2+10;	
			
		if(thisTween){		
		
				
			var targetX:int = this.x;	
			var targetY:int = this.y;		
			var targetRotation:int = Math.random()*180 - 90;	 
			var targetScale:Number = (Math.random()*0.4) + 0.4;	
			//Tweener.addTween(this, {alpha:1, time:0.6, transition:"easeinoutquad"});	
			Tweener.addTween(this, {alpha:1, x:targetX, y:targetY,scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, time:0.7, transition:"easeinoutquad"});	
		}else {
		this.alpha = 1.0;
		this.scaleX = 1;
		this.scaleY = 1;	
		this.rotation = 0;
		//this.scaleX = (Math.random()*0.4) + 0.3;
		//this.scaleY = this.scaleX;
		//this.rotation = Math.random()*180 - 90;
			}
		}				
		



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
            return new DropShadowFilter(distance,
                                        angle,
                                        color,
                                        alpha,
                                        blurX,
                                        blurY,
                                        strength,
                                        quality,
                                        inner,
                                        knockout);
        }		
		
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;			
			
			velAng = dang;
		}
		
		private function slide(e:Event):void
		{
			if(this.state == "none")
			{		
				if(Math.abs(velX) < 0.001)
					velX = 0;
				else {
					x += velX;
					velX *= friction;										
				}
				if(Math.abs(velY) < 0.001)
					velY = 0;					
				else {
					y += velY;
					velY *= friction;						
				}
				if(Math.abs(velAng) < 0.001)
					velAng = 0;					
				else {
					velAng *= angFriction;				
					this.rotation += velAng;					
				}
			}
		}
		
		
	}
}