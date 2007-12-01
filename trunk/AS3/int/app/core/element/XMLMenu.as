// EACH MENU NEEDS AN UNIQUE ID?
// Setting actions to individual menu items @ parent level
// Remove Rotate/Scale extension
//
// Preloader
// Width/Height settings in XML 
// Mouse hover/over/out efffects in XML
// FONT Settings in XML
// Finish Radial Menu (add timer to autoclose ~2.5 seconds) Embeded Fonts working in Flex Builder
// Menu background images

package app.core.element {
//public class XMLMenu extends RotatableScalable {	
public class XMLMenu extends Sprite {	
[Embed(source="Arial.ttf", fontFamily="myFont")]  var myFont:Class;
				
		private var __menuList:XMLList;	 		
		private var __loader:URLLoader;			
		private var __spacing:Number;
		private var __sizeX:Number;
		private var __sizeY:Number;
		private var __menuX:Number;
		private var __menuY:Number;		
		private var __layout:String;	
		private var __labels:Boolean;
		private var __effects:Boolean;			
		private var imageButtonUP:Loader;
	 
				
public function XMLMenu(layout:String, xml_url:String, spacing:Number, sizeX:Number, sizeY:Number, menuX:Number, menuY:Number, labels:Boolean, effects:Boolean):void {	
			loadXML(xml_url);
			__layout=layout;				
			__sizeX = sizeX;
			__sizeY = sizeY;
			__menuX = menuX;
			__menuY = menuY;
			__labels = labels;
			__effects = effects;	
			__spacing = spacing;
			//this.noMove=true;
			//this.noScale=true;
			//this.noRotate=true;
		}
		
		private function loadXML(xml_url):void {			
			__loader = new URLLoader();
			__loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			__loader.load(new URLRequest(xml_url));
		}

		private function onXMLLoaded(event:Event):void {

			try {
				var menuXML:XML = new XML(__loader.data);
				__menuList = menuXML.button; 
				drawMenu();	
				
			} catch(error:Error) {			
				var errorMessage:TextField = new TextField();
				errorMessage.autoSize = TextFieldAutoSize.LEFT;
				errorMessage.textColor = 0xFF0000;
				errorMessage.text = error.message;	
				//errorMessage.x = 100, errorMessage.y = 100;
				addChild(errorMessage);
				return;
			}			
		}

		private function drawMenu():void {		
			var spacer:Number = 0;
			var menuHolder:Sprite = new Sprite();		
		
			addChild(menuHolder);	
			
			menuHolder.x = __menuX;
			menuHolder.y = __menuY;		
			
			var format0:TextFormat = new TextFormat();
			format0.font= "Arial";
			format0.color = 0xFFFFFF;
			format0.size = 10;			
			
			var format1:TextFormat = new TextFormat();
			format1.font= "Arial";
			format1.color = 0xFFFFFF;
			format1.size = 12;		
			//format1.bold = true;			
			var count:int = 0;			
				
			
			for each (p in __menuList) {			
				var button:Sprite = new Sprite();	
				button.name = "button"+count;				
				button.mouseChildren = false;				
				button.buttonMode = true;				
				var label:TextField = new TextField();				
				if(!__labels){label.visible=false}			
				label.autoSize = TextFieldAutoSize.LEFT;
				label.selectable = false;
				label.defaultTextFormat = format0;
				label.embedFonts = false;
				label.text = __menuList[count].text();
			
				if(__layout != "radial"){				
						
				/*imageButtonUP = new Loader();
				imageButtonUP.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler);
				imageButtonUP.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);		
				var context:LoaderContext = new LoaderContext();
				context.checkPolicyFile = true;	
				imageButtonUP.load(new URLRequest(__menuList[count]..@up), context);	
				imageButtonUP.name = "up";		
				*/
				imageButtonUP = new Loader();		
				imageButtonUP.load(new URLRequest(__menuList[count]..@up));		
				imageButtonUP.name = "up";	
				
				var imageButtonDOWN:Loader = new Loader();		
				imageButtonDOWN.load(new URLRequest(__menuList[count]..@down));		
				imageButtonDOWN.alpha = 0;
				imageButtonDOWN.name = "down";	
				
				var imageButtonOVER:Loader = new Loader();		
				imageButtonOVER.load(new URLRequest(__menuList[count]..@over));		
				imageButtonOVER.alpha = 0;
				imageButtonOVER.name = "over";	
					
				button.addChild(imageButtonUP);			
				button.addChild(imageButtonOVER);						
				button.addChild(imageButtonDOWN);
				
				var down:Sprite = new Sprite();
				down.graphics.beginFill(0xFF0000, 0);
				down.graphics.drawRect(0, 0, __sizeX, __sizeY);
				down.alpha = 0;
				//down.name = "down";				
			
				button.addChild(down);				
				button.addChild(label);		
				
				label.x = (button.width/2) - (label.width/2);
				label.y = (button.height/2) - (label.height/2)-0.5;				
							
				}			
				
				if(__layout == "horizontal"){
				button.x = spacer;
				spacer += button.width + __spacing;
				}else if(__layout == "vertical"){
				button.y = spacer;
				spacer += button.height + __spacing;
				}				
				else if(__layout == "radial"){				
				
				//this.noMove=false;
				//this.noScale=false;
				//this.noRotate=false;		
				
				var radialHolderBG = new Shape();		
				var radialHolderUP = new Sprite();		
				var radialHolderDOWN = new Sprite();
				var radialHolderOVER = new Sprite();
				var radialHolderCLOSE = new Sprite();					   		
	   			
				radialHolderBG.graphics.beginFill(0x000000, 0.0);	
	   			radialHolderBG.graphics.drawCircle(0, 0, 125);		
	   			radialHolderBG.graphics.endFill();	
	   			//button.addChild(radialHolderBG);	
	   				
				var color = ColorUtil.random(0,50,0);					
				var temp1 = 360/6;							
				
				var wedge_0 = new Wedge(__sizeX, 0, 0, 0, temp1*Consts.DEG_TO_RAD);							
	   			wedge_0.draw(radialHolderUP, 0.0, 0xCCCCCC, 0x000000, 0.40); 	   	
	   			radialHolderUP.rotation += 60*(count+1); 	
	   			button.addChild(radialHolderUP);	
	   			radialHolderUP.name="up";
	   			
	   			var wedge_1 = new Wedge(__sizeX, 0, 0, 0, temp1*Consts.DEG_TO_RAD);							
	   			wedge_1.draw(radialHolderOVER, 2, 0xFFFFFF, 0x000000, 0.5); 	   	
	   			radialHolderOVER.rotation += 60*(count+1); 	
	   			button.addChild(radialHolderOVER);	
	   			radialHolderOVER.name="over";
	   			radialHolderOVER.alpha=0;
	   		
	   			var wedge_2 = new Wedge(__sizeX, 0, 0, 0, temp1*Consts.DEG_TO_RAD);							
	   			wedge_2.draw(radialHolderDOWN, 0.5, 0x000000, 0xFF0000, 0.5); 	   	
	   			radialHolderDOWN.rotation += 60*(count+1); 	
	   			button.addChild(radialHolderDOWN);		  
	   			radialHolderDOWN.name="down";
	   			radialHolderDOWN.alpha=0; 			   			
	   			
	   			//radialHolderCLOSE.graphics.beginFill(0xFFFFFF, 0.5);	
	   			//radialHolderCLOSE.graphics.drawCircle(0, 0, 30);		
	   			//radialHolderCLOSE.graphics.endFill();
	   			//button.addChild(radialHolderCLOSE);			
	   			
	   			var label:TextField = new TextField();				
				label.autoSize = TextFieldAutoSize.LEFT;	
				label.defaultTextFormat = format1;
				label.selectable = false;
				//label.embedFonts = true;			
				label.text = __menuList[count].text();
				radialHolderDOWN.addChild(label);				
				label.x = 15+(radialHolderUP.width/2) - (label.width/2);
				label.y = -10+(radialHolderUP.height/2)- (label.height/2);	
				//label.rotation = 34;			
				
	   			}				
	   			
				button.addEventListener(MouseEvent.MOUSE_OVER, displayActiveState);
				button.addEventListener(MouseEvent.MOUSE_OUT, displayInactiveState);
				button.addEventListener(MouseEvent.CLICK, displayMessage);					
				
				button.addEventListener(TUIOEvent.TUIO_OVER, displayActiveState);
				button.addEventListener(TUIOEvent.TUIO_OUT, displayInactiveState);
				button.addEventListener(TUIOEvent.TUIO_DOWN, displayMessage);			
				menuHolder.addChild(button);
				count++;
			}	
				if(__layout == "radial"){	
				var MASKe = new Shape();				
				//radialHolderUP.mask=MASK;	 
	   			MASKe.graphics.lineStyle(1, 0x000000, 1);
	   			MASKe.graphics.beginFill(0xFFFFFF, 1);	
	   			//MASK.blendMode='invert';	
	   			MASKe.graphics.drawCircle(0, 0, 45);	
	   			//MASK.addEventListener(MouseEvent.CLICK, killRadial);	
	   			MASKe.graphics.endFill();
	   			this.addChild(MASKe);	
	   			MASKe.name="maskit";
	   			trace(this);
	   			}
	
		}	
		private function onCompleteHandler(e:Event = null)
		{
		var image:Bitmap = Bitmap(imageButtonUP.content);
        image.smoothing=true;
       	//image.x = -photoLoader.width/2;
		//image.y = -photoLoader.height/2;	
        this.addChildAt(image,0);  
		}
		private function onProgressHandler(mProgress:ProgressEvent)
		{
		var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
		trace(percent*100+"%");
		}
		private function killRadial(e:Event)
		{
		trace('kill this radial menu!');
		}
		private function displayActiveState(e:Event):void {
			Tweener.addTween(e.currentTarget.getChildByName("over"), {alpha:0.75, time:0.2, transition:"easeinoutquad"});
			e.stopPropagation();
		}
		private function displayInactiveState(e:Event):void {	
			Tweener.addTween(e.currentTarget.getChildByName("over"), {alpha:0.0, time:0.65, transition:"easeinoutquad"});
			Tweener.addTween(e.currentTarget.getChildByName("down"), {alpha:0.0, delay:0.40,time:0.25, transition:"easeinoutquad"});		
			e.stopPropagation();
		}
		private function displayMessage(e:Event):void {		
			//e.currentTarget.getChildByName("down").alpha=1;
			Tweener.addTween(e.currentTarget.getChildByName("down"), {alpha:1.0, time:0.35, transition:"easeinoutquad"});				
			//e.currentTarget.removeChild(button);			
			e.stopPropagation();
		}
		
	
	}		
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.*;

	import flash.net.URLLoader
	import flash.net.URLRequest
	import flash.xml.XML
	import flash.events.Event;
	import flash.error.Error;
	import com.touchlib.TUIOEvent;
	import app.core.element.Wrapper; 
	import app.core.utl.Wedge;	 import flash.events.*;
	import app.core.utl.Consts;
	import caurina.transitions.Tweener;	import app.core.utl.ColorUtil;
	import flash.text.*;	
	import app.core.action.RotatableScalable;	
	import flash.system.LoaderContext;
//	import flash.text.TextField;
//	import flash.text.TextFieldAutoSize;
//	import flash.text.TextFormat;
}