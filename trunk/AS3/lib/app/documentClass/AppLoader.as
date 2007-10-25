//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.documentClass
{
	import flash.display.Sprite;
	
	import com.touchlib.TUIO;
	import flash.display.*;
	import flash.net.*;

	public class AppLoader extends Sprite 
	{
		var loader1:Loader;
		public function AppLoader() 
		{
			TUIO.init( this, 'localhost', 3000, 'www/xml/test2.xml', true );
			trace("Apploader");
			loader1 = new Loader();
			
			loader1.load(new URLRequest("Paint.swf"));
			loader1.scaleX = 0.5;
			loader1.scaleY = 0.5;	
			loader1.x = 150;
			loader1.y = 150;
			
			addChild(loader1);
			
		}
	}
}