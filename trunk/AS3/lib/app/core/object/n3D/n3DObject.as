package app.core.object.n3D
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.text.*;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import com.touchlib.*;
	import flash.geom.*;			
	import flash.filters.BlurFilter;
	import app.core.object.n3D.PapervisionCube;
	import app.core.element.*;
	
    import flash.filters.*;


	public class n3DObject extends MovieClip
	{
		
		private var TKnobX:TouchlibKnob=  new TouchlibKnob(80);
		private var TKnobY:TouchlibKnob=  new TouchlibKnob(80);
		private var TKnobZ:TouchlibKnob=  new TouchlibKnob(80);
		private var TSliderX:TouchlibSlider = new TouchlibSlider(20,400);
		private var TSliderY:TouchlibSlider = new TouchlibSlider(20,400);
		private var TSliderZ:TouchlibSlider = new TouchlibSlider(20,400);
		//private var TKnobZ:TouchlibKnob = new TouchlibKnob(30);
		private var boxRed:Sprite = new Sprite();
		private var boxHolder:Sprite = new Sprite();
		private var _3dCube = new PapervisionCube();
		
		private var resetBT:Sprite = new Sprite();
		
		public function n3DObject():void{
			
			resetBT.graphics.beginFill(0x8C8C8C,1.0);
			resetBT.graphics.drawRoundRect(0,0,50,20,8);
			resetBT.graphics.endFill();
			resetBT.x = 955;
			resetBT.y = 60;
			resetBT.addEventListener(TUIOEvent.TUIO_DOWN, resetPos);
			resetBT.addEventListener(MouseEvent.MOUSE_DOWN, resetPos);
			
			this.addChild(resetBT);
			
			/*boxRed.graphics.beginFill(0xFF0000, 1);
			boxRed.graphics.drawRect(-150,-75,300,150);
				
			boxHolder.addChild(boxRed);*/
			boxHolder.x = 1024*0.5;
			boxHolder.y = 768*0.5;
			this.addChild(boxHolder);
			boxHolder.addChild(_3dCube);
			//var TKnob = new TouchlibKnob(100);
			TKnobX.x = 550;
			TKnobX.y = 30;
			this.addChild(TKnobX);
			
			TKnobY.x = 700;
			TKnobY.y = 30;
			this.addChild(TKnobY);
			
			TKnobZ.x = 850;
			TKnobZ.y = 30;
			this.addChild(TKnobZ);
			
			
			TSliderX.x = 450
			TSliderX.y = 40;
			TSliderX.rotation +=90;
			TSliderX.setValue(0.5);
			this.addChild(TSliderX);
			
			TSliderY.x = 450;
			TSliderY.y = 90;
			TSliderY.rotation +=90;
			TSliderY.setValue(0.5);
			this.addChild(TSliderY);
			
			TSliderZ.x = 450;
			TSliderZ.y = 140;
			TSliderZ.rotation +=90;
			TSliderZ.setValue(0.5);
			this.addChild(TSliderZ);
			
			
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate);		
			
			}
			
			function resetPos(event:Event):void{
				TSliderX.setValue(0.5);
				TSliderY.setValue(0.5);
				TSliderZ.setValue(0.5);
				TKnobX.setValue(0);
				TKnobY.setValue(0);
				TKnobZ.setValue(0);
				_3dCube._3dRot_x = 0;
				_3dCube._3dRot_y = 0;
				_3dCube._3dRot_z = 0;
				}
			
			function frameUpdate(e:Event)
		{
			
			
			if(TKnobX.knobValue != 0){
				_3dCube._3dRot_x = TKnobX.knobValue*360;
				TSliderX.setValue(0.5);
			}
			if(TKnobY.knobValue != 0){
				_3dCube._3dRot_y = TKnobY.knobValue*360;
				TSliderY.setValue(0.5);
			}
			if(TKnobZ.knobValue != 0){
				_3dCube._3dRot_z = TKnobZ.knobValue*360;
				TSliderZ.setValue(0.5);
			}
			
			
			
			_3dCube._3dRot_x += (TSliderX.sliderValue*2)-1;
			_3dCube._3dRot_y += (TSliderY.sliderValue*2)-1;
			_3dCube._3dRot_z += (TSliderZ.sliderValue*2)-1;
			
			
			
			//trace(TSliderH.sliderValue);
			//boxHolder.rotation = TKnob.knobValue*360;
			//trace(TSlider.sliderValue);
			//boxHolder.x = TSliderH.sliderValue*800;
		}
		
		
		
		}
}