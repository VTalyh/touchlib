//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.documentClass
{
	import flash.display.Sprite;
	
	import com.touchlib.*;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import app.apploader.*;

	// fixme: read apps, categories from XML
	
	dynamic public class AppLoader extends MovieClip 
	{
		var appLoader:Loader;
		var xmlLoader:URLLoader;
		var appButtons:Array;
		
		var screenshotLoader:Loader;
		
		var selectedButton:AppLoaderButton;
		
		var loadbtn:TouchlibWrapper;

		public function AppLoader()
		{
			selectedButton = null;
			appButtons = new Array();
			
			TUIO.init( this, 'localhost', 3000, '', false );
			
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, this.xmlLoaded); 			
			xmlLoader.load(new URLRequest("www/data/applist.xml"));
			
			var b:SimpleButton = new AppLoadButton();

			loadbtn = new TouchlibWrapper(b);
			loadbtn.x = 571;
			loadbtn.y = 515;			
			loadbtn.visible = false;		
			
			screenshotLoader = new Loader();
			screenshotLoader.visible = false;
			screenshotLoader.x = 218;
			screenshotLoader.y = 85;
			addChild(screenshotLoader);
			
			addChild(loadbtn);
			
			loadbtn.addEventListener(MouseEvent.CLICK, loadClicked);
			

			appLoader = new Loader();
			addChild(appLoader);
			/*
			this.addEventListener(TUIOEvent.MoveEvent, this.tuioMoveHandler);			
			this.addEventListener(TUIOEvent.DownEvent, this.tuioDownEvent);						
			this.addEventListener(TUIOEvent.UpEvent, this.tuioUpEvent);									
			this.addEventListener(TUIOEvent.RollOverEvent, this.tuioRollOverHandler);									
			this.addEventListener(TUIOEvent.RollOutEvent, this.tuioRollOutHandler);			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOutHandler);
*/
		}
		
		public function loadClicked(e:MouseEvent)
		{
			screenshotLoader.unload();
			screenshotLoader.visible = false;
			trace("Load " + selectedButton.appName);
			this.gotoAndPlay("RunApp");
		}
		
		public function runApp()
		{
			loadbtn.visible = false;						
			appLoader.load(new URLRequest(selectedButton.appName + ".swf"));			
			this.setChildIndex(appLoader, this.numChildren-1);
			removeChild(appLoader);
			parent.addChild(appLoader);
			parent.removeChild(this);
		}
		
		public function showDesc()
		{
			screenshotLoader.unload();			
			screenshotLoader.load(new URLRequest("www/images/apps/" + selectedButton.appName + "_screenshot.jpg"));
			screenshotLoader.visible = true;
			this.tfAppInfo.text = selectedButton.appDescription;
		}
		
		public function buttonDropped(b:AppLoaderButton)
		{
			if(selectedButton == null && b.hitTestObject(this.mcAppTarget))
			{
				b.lockInPlace();
				b.parent.removeChild(b);				
				b.x = 0;
				b.y = 0;
				gotoAndPlay("AppInfo");				
				this.mcAppTarget.addChild(b);
				loadbtn.visible = true;
				selectedButton = b;

			}
		}
		
		public function buttonUnlock(b:AppLoaderButton)
		{
			b.unlock();
			b.x = b.parent.x - this.mcAppArea.x;
			b.y = b.parent.y - this.mcAppArea.y;
			
			b.parent.removeChild(b);							
			
			this.mcAppArea.addChild(b);			
			loadbtn.visible = false;							
			this.gotoAndPlay("Cancel");
			selectedButton = null;
			
		}
		
		public function xmlLoaded(e:Event)
		{	
			var myFont:Font = new DustismoFont();			
		
			try
			{
				var xml:XML = new XML(e.target.data);
				
				var by:int = 0;
				
				var tf:TextFormat = new TextFormat();
				tf.font = myFont.fontName;
				tf.color = 0xffffff;
				tf.bold = true;
				tf.size = "22";					
				tf.align = TextFormatAlign.RIGHT;;
				
				for each (var cat:XML in xml.categories.category)
				{

					var bx:int = 0;
					var catlabel:TextField = new TextField();
					
					catlabel.defaultTextFormat = tf;
					catlabel.text = cat.@name;
					catlabel.y = by + (96 / 2) - 11;
					catlabel.x = 0;
					catlabel.width = 128;
					catlabel.embedFonts = true;

					
					this.mcCatArea.addChild(catlabel);
					
					for each (var app:XML in cat.apps.app)
					{
						trace("app " + app);
						var button:AppLoaderButton = new AppLoaderButton(this, app.name, app.body);
						button.setPos(bx, by);

						bx += 96 + 12
						appButtons.push( button );
						this.mcAppArea.addChild( button );
					}
					
					by += 96 + 12;
				}

			} catch (e:TypeError)
			{
				//Could not convert the data, probavlu because
				//because is not formated correctly
				
				trace("Could not parse the XML")
				trace(e.message)
			}
		}
		
	}
}