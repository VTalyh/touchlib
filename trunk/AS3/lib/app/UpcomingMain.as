package {
	import flash.display.*;
	import com.yahoo.webapis.upcoming.*;
	import com.yahoo.webapis.upcoming.events.*;
		
	
	dynamic public class UpcomingMain extends MovieClip
	{
		private var myUS:UpcomingService;

		public var uevents:Array = new Array();
		public var metros:Array = new Array();
        public var venues:Array = new Array();      		

		public function UpcomingMain(): void {
			this.tfText.text = "hi";			
			myUS = new UpcomingService("9f2a7af87cb634c66f90682868354b4eb30775b9");
			myUS.addEventListener(UpcomingResultEvent.GET_TOKEN, tokenLoaded);
			
			trace("Hi");
			trace(myUS);

			
		}

		public function tokenLoaded(evtObject:Object) : void {
			myUS.addEventListener(UpcomingResultEvent.EVENT_SEARCH, eventSearch);
			myUS.addEventListener(UpcomingResultEvent.METRO_GET_MY_LIST, metroList);
			myUS.addEventListener(UpcomingResultEvent.VENUE_GET_LIST, venueList);
			myUS.getMyMetroList();
			
			myUS.user.addEventListener(UpcomingResultEvent.USER_UPDATED, userUpdated);
			myUS.user.updateById();
			
			trace("Token loaded");
			this.tfText.appendText("Token loaded");
			
			myUS.findEvents();			
		}
		
//		public function userUpdated (evtObject:Object) : void {
//			user_photo.source = myUS.user.photourl;
//			user_name.text = myUS.user.name;
//		}
		public function venueList (evtObject:Object) : void {
			venues = evtObject.data;
			trace(venues);
		}
		public function eventSearch (evtObject:Object) : void {
			uevents = evtObject.data;
			trace(uevents);
		} 
		public function metroList (evtObject:Object) : void {
			metros = evtObject.data;
			trace(metros);			
		}		
		

		
	}
}