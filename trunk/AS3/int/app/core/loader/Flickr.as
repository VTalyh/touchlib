package app.core.loader{	
	import app.core.object.ImageObject;
	import flash.display.DisplayObject;		
	import flash.display.MovieClip;	
	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.geom.Point;	

	//import flash.util.trace;		

	public class Flickr extends MovieClip
	{
		// Class properties
		private var index:int = 0;		
		private var rest:URLLoader = null;
		private var flickr:XML = null;
		private var thestage:Sprite;
		private var allPics:Array;
		
		// Constructor
		public function Flickr(d:Sprite) 
		{
			thestage = d;
			allPics = new Array();
			// Setup the UI and get initial data
			fetch("recent");
		}
		
		// Retrieve a set of data from Flickr
		// Creates a RESTful request and loads data
		public function fetch(type:String):void 
		{			
			clearPics();
			// Request and name/value query string variables
			var request:URLRequest = 
					new URLRequest( "http://api.flickr.com/services/rest/" );
			var variables:URLVariables = new URLVariables();
			
			// Query string variables can be added dynamically
			// (e.g. AS2 Object)
			variables.api_key = "566c6aa058a2b4aa13f1b6ddc9bfd582";
			
			if(type == "recent")
			{
				variables.method = "flickr.photos.getRecent";
			} else if(type == "mine") {
				variables.method = "flickr.photosets.getPhotos";
				variables.photoset_id = "72157600024718701";
			}
			

			// Set the variables
			request.data = variables;
			
			// Create an object for HTTP XML data load
			// Add an event listener to get notified once data is loaded
			// Start the request using the specified URL and variables
			rest = new URLLoader();
			rest.addEventListener( "complete", parse , false, 0, true);
			rest.load( request );
		}
		
		// Called when the XML data has been returned from Flickr
		private function parse( event:Event ):void 
		{			
			// Take XML data and turn it into an E4X object for manipulation
			// Load first photo into display object
			flickr = new XML( rest.data );
			showPics();
		}
		
		// Cycles through available photo data
		// Used optional arguments feature of AS3
		// Not sure if it is the right approach
		private function showPics():void 
		{	
			// Variables to segement out URL pieces
			// The request object to load the photo into the display object
			var id:String = null;
			var secret:String = null;
			var server:String = null;			
			var url:String = null;
			var request:URLRequest = null;			
			
			//trace(flickr);

			// Increment the counter
			// TODO: Account for being at the end of the array
//			index = int(Math.random()*flickr..photo.length());

			var len:int = flickr..photo.length();
		
			if(len > 25)
				len = 25;

			for(var i:int=0; i<len; i++)
			{

				// Get the various URL parameters from the XML data
				// Using E4X
				// Have to use the toString() method for String assignment
				server = flickr..photo[i].@server.toString();
				id = flickr..photo[i].@id.toString();
				secret = flickr..photo[i].@secret.toString();
				
				// Assemble the URL and request
				url = 	"http://static.flickr.com/" + server + "/" + id + "_" + 
						secret + ".jpg";
		
	
				var photo:ImageObject = new ImageObject( url );
				thestage.addChild(photo);
				allPics.push(photo);
			}
		}
		
		function clearPics():void
		{
			for(var i:int = 0; i<allPics.length; i++)
			{
				thestage.removeChild(allPics[i]);
			}
			
			allPics = new Array();
		}

	}
}