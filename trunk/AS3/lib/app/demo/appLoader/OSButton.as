package app.demo.appLoader
{
	import com.touchlib.*;
	import app.demo.appLoader.*;
	import app.core.element.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import fl.controls.Button;
	import flash.text.*;
	import flash.net.*;
	
	public dynamic class OSButton extends MovieClip
	{
		public var appName;
		public var appDesc;
		public var appAuthor;
		
		private var appLoader:AppLoader;
		private var bOpen:Boolean = false;
		
		public function OSButton()
		{
			appName = "not set";

			
			var wrap:Wrapper;
			wrap = new Wrapper(btClose);
			wrap.name = "btClose";
			btClose.addEventListener(MouseEvent.CLICK, closeClicked, false, 0, true);						
			addChild(wrap);
			
			wrap = new Wrapper(btInfo);
			wrap.name = "btInfo";
			btInfo.addEventListener(MouseEvent.CLICK, infoClicked, false, 0, true);			
			addChild(wrap);
			
			wrap = new Wrapper(btConfig);
			wrap.name = "btConfig";
			btConfig.addEventListener(MouseEvent.CLICK, configClicked, false, 0, true);
			addChild(wrap);
			
			wrap = new Wrapper(btExpander);
			wrap.name = "btExpander";
			btExpander.addEventListener(MouseEvent.CLICK, expanderClicked, false, 0, true);
			addChild(wrap);	
			
			btClose.visible = false;
			btInfo.visible = false;
			btConfig.visible = false;	
			mcExpanderBack.visible = false;			

		}
		
		function closeClicked(e:MouseEvent)
		{
			appQuit();
			toggleOpen();
		}
		
		function infoClicked(e:MouseEvent)
		{
			toggleOpen();
		}
		function configClicked(e:MouseEvent)
		{
			toggleOpen();
		}
		
		function toggleOpen()
		{
			if(bOpen)
			{
				btClose.visible = false;
				btInfo.visible = false;
				btConfig.visible = false;
				mcExpanderBack.visible = false;
				gotoAndStop("closed");
				bOpen = false;
			} else {
				gotoAndStop("open");				
				bOpen = true;
				
				btClose.visible = true;
				btInfo.visible = true;
				btConfig.visible = true;
				mcExpanderBack.visible = true;
				
			}			
		}
		
		function expanderClicked(e:MouseEvent)
		{

			toggleOpen();
		}
		
		function setAppInfo(ldr:MovieClip, name:String, desc:String, auth:String)
		{
			appLoader = ldr;
			
			appName = name;
			appDesc = desc;
			appAuthor = auth;
		}
		
		function appQuit()
		{
			// RESTORE OS
			
			appLoader.closeApp(this.parent);
			
		}
	}
}
	