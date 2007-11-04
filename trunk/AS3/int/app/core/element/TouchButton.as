package app.core.element {	
	import com.nui.tuio.TUIOEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.tweener.transitions.Tweener;
	
	public dynamic class nButton extends MovieClip {
		public function nButton() {
			alpha = 1;			
			this.addEventListener(TUIOEvent.DownEvent, this.downEvent);						
			this.addEventListener(TUIOEvent.UpEvent, this.upEvent);									
			this.addEventListener(TUIOEvent.RollOverEvent, this.rollOverHandler);									
			this.addEventListener(TUIOEvent.RollOutEvent, this.rollOutHandler);	
			buttonMode = true;
			useHandCursor = true;
		}
		public function downEvent(e:TUIOEvent)
		{
			trace("Button Down");
			Tweener.addTween(this, {rotation:360, time:0.3, transition:"linear"});		
			//Tweener.addTween(this, {_blur_blurX:50, _blur_quality:2, time:1, transition:"linear"});
		}
		public function upEvent(e:TUIOEvent)
		{
			trace("Button Up");		

		}
		public function rollOverHandler(e:TUIOEvent)
		{
			trace("Button Over");		
			Tweener.addTween(this, {alpha:0.2, time:0.5, transition:"easeinoutquad"});
		}
		public function rollOutHandler(e:TUIOEvent)
		{
			trace("Button Out");
			Tweener.addTween(this, {alpha:1, time:1, transition:"easeinoutquad"});
		}		
	}
}
