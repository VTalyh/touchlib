package app.demo.artgen
{
	import flash.display.*;
	import com.touchlib.*;
	import app.demo.artgen.*;
	import app.core.element.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.text.*;
	
	public class SettingsDialog extends MovieClip 
	{
		var swarmTypes:Array;
		var shapes:Array;
		var modDests:Array;
		
		private var swarmType:ScrollList;
		private var swarmNumber:HorizontalSlider;
		private var shapeType:ScrollList;		
		private var scaleSlider:HorizontalSlider;				
		private var alphaSlider:HorizontalSlider;						
		private var lifeSlider:HorizontalSlider;
		private var speedSlider:HorizontalSlider;		
		private var turnSlider:HorizontalSlider;
		private var delaySlider:HorizontalSlider;
		private var scaleDecaySlider:HorizontalSlider;
		
		private var settings:XML;
		private var main:ArtGenMain;
		
		public function SettingsDialog(s:XML, m:ArtGenMain) 
		{
			settings = s;
			main = m;
			

			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.font = "Neo Tech Std";
			tf.size = "16";					
			
			
			swarmTypes = new Array();			
			swarmTypes.push("LazyFollower");			
			swarmTypes.push("HoppingBugs");	
			swarmTypes.push("Boid");
			swarmTypes.push("Boid2");			
			
			shapes = new Array();
			shapes.push("Shape1.swf");
			
			modDests = new Array();
			modDests.push("sine");
			modDests.push("square");
			modDests.push("random");
			
			var curY:int = 20;
			var lab:TextField;
			swarmType = new ScrollList(swarmTypes);
			swarmType.y = curY;
			swarmType.x = 100;
			swarmType.setSelected(settings.swarmType);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SWARM TYPE";
			lab.y = curY+10;
			addChild(lab);
			curY += 75;
			addChild(swarmType);
			
			swarmNumber = new HorizontalSlider(200, 40);
			swarmNumber.y = curY;
			swarmNumber.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SWARM MEMBERS";
			lab.y = curY+10;
			addChild(lab);			
			curY += 60;
			swarmNumber.setValue((settings.numMembers - 1) / 9.0);			
			addChild(swarmNumber);
			
			shapeType = new ScrollList(shapes);
			shapeType.y = curY;
			shapeType.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SHAPE";
			lab.y = curY+10;
			addChild(lab);						
			shapeType.setSelected(settings.shape);						
			curY += 75;
			addChild(shapeType);
			
			scaleSlider = new HorizontalSlider(200, 40);
			scaleSlider.y = curY;
			scaleSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SCALE";
			lab.y = curY+10;
			addChild(lab);									
			scaleSlider.setValue(settings.scale);			
			curY += 60;
			addChild(scaleSlider);			
			
			alphaSlider = new HorizontalSlider(200, 40);
			alphaSlider.y = curY;
			alphaSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "ALPHA";
			lab.y = curY+10;
			addChild(lab);									
			alphaSlider.setValue(settings.alpha);
			curY += 60;
			addChild(alphaSlider);						
			
			lifeSlider = new HorizontalSlider(200, 40);
			lifeSlider.y = curY;
			lifeSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LIFE";
			lab.y = curY+10;
			addChild(lab);									
			lifeSlider.setValue(settings.trail.lifeTime/10000.0);
			curY += 60;
			addChild(lifeSlider);						
			
			delaySlider = new HorizontalSlider(200, 40);
			delaySlider.y = curY;
			delaySlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "CREATE DELAY";
			lab.y = curY+10;
			addChild(lab);									
			delaySlider.setValue(settings.trail.createDelay/7.0);
			curY += 60;
			addChild(delaySlider);			
			
			scaleDecaySlider = new HorizontalSlider(200, 40);
			scaleDecaySlider.y = curY;
			scaleDecaySlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SCALE DECAY";
			lab.y = curY+10;
			addChild(lab);									
			scaleDecaySlider.setValue((settings.trail.scaleDecay + 0.1) / 0.2);
			curY += 60;
			addChild(scaleDecaySlider);						
			
			
			var donebtn:SimpleButton = new DoneButton();			
			
			// FIXME: need a cancel button.

			var wrap:TouchlibWrapper = new TouchlibWrapper(donebtn);
			wrap.x = 600;
			wrap.y = 450;			
			donebtn.addEventListener(MouseEvent.CLICK, doneClicked);
			addChild(wrap);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			
		}
		
		public function addedToStageHandler(e:Event)
		{
			graphics.beginFill(0x000000, 0.8);
			graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		public function doneClicked(e:Event)
		{
			this.visible = false;
			main.applySettings();
		}
		
		
		public function getXML():XML
		{
			settings.scale = scaleSlider.getValue();
			settings.alpha = alphaSlider.getValue();			
			settings.shape = shapeType.getSelected();			
			settings.swarmType = swarmType.getSelected();						
			settings.numMembers = int((swarmNumber.getValue()*9.0) + 1.0);
			settings.trail.lifeTime = lifeSlider.getValue()*10000;			
			settings.trail.createDelay = int(delaySlider.getValue()*7.0);
			settings.trail.scaleDecay = ((scaleDecaySlider.getValue()*0.2) - 0.1) ;			
			
			return settings;
		}
	}
}