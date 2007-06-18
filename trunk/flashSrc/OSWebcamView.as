package {
    import flash.display.MovieClip;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.*;
    import flash.media.Camera;
    import flash.media.Video;
	
	public class OSWebcamView extends MovieClip {
	    private var video:Video;
        
        public function OSWebcamView() {
			trace("Webcam");
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            var camera:Camera = Camera.getCamera();
            
            if (camera != null) {
                camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
                video = new Video(camera.width, camera.height);
                video.attachCamera(camera);
                addChild(video);
            } else {
                trace("You need a camera.");
            }
        }
        
        private function activityHandler(event:ActivityEvent):void {
            trace("activityHandler: " + event);
        }
    }
}		
	