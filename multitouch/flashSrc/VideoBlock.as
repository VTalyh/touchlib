package whitenoise {
	import whitenoise.TUIO;
	import flash.display.*;
	import flash.net.*;
    import flash.events.*;
    import flash.media.Video;
	import flash.media.Camera;	
	
    public class VideoBlock extends MovieClip {
        private var videoURL:String = "C:\\art\\AR_BALLS_1.flv";
        private var connection:NetConnection;
        private var stream:NetStream;

        public function VideoBlock() {
            connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);

        }

        private function netStatusHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Unable to locate video: " + videoURL);
                    break;
            }
        }

        private function connectStream():void {
            var stream:NetStream = new NetStream(connection);
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            var video:Video = new Video();
            video.attachNetStream(stream);

            stream.play(videoURL);
            addChild(video);
			trace("Connect ");
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
        
        private function asyncErrorHandler(event:AsyncErrorEvent):void {
     
        }
    }
}