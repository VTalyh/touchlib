	/**
	 * Papervision3dTutorial.as
	 * 25 March 2007
	 * @author Dennis Ippel - http://www.rozengain.com
	 */	//

package app.core.object.n3D
{
	import app.core.action.RotatableScalable;
	
	import com.touchlib.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.filters.*;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.Collada;
	import org.papervision3d.objects.Cube;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.scenes.Scene3D;
	

	[SWF(backgroundColor="#000000", frameRate="60")]
	

	public class PapervisionCube extends RotatableScalable
	{
		private var myMaterials:Object;
		private var material:ColorMaterial;
		
		//private var materiallist:MaterialsList = new MaterialsList();
		private var container:Sprite;
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var rootNode:DisplayObject3D;
		private var xwing:DisplayObject3D = new Collada( "local/3D/xwing.dae");
		//private var xwing:DisplayObject3D = new Collada( "3dXwing/assets/xwing.dae");
		
		public var _3dRot_x:Number = new Number(0);
		public var _3dRot_y:Number = new Number(0);
		public var _3dRot_z:Number = new Number(0);
		
		
		private var cube:Cube;
		private var dragBG:Sprite= new Sprite();
		
		/**
		 * Constructor
		 * @return 
		 */		 
		public function PapervisionCube()
		{
			/*
			var material1:WireframeMaterial = new WireframeMaterial(0xFF0000);
			var material2:WireframeMaterial = new WireframeMaterial(0x00FF00);
			var material3:WireframeMaterial = new WireframeMaterial(0x0000FF);
			
			// create the material list for the cube
			
			materiallist.addMaterial(material1,"top");
			materiallist.addMaterial(material1,"bottom");
			materiallist.addMaterial(material2,"front");
			materiallist.addMaterial(material2,"back");
			materiallist.addMaterial(material3,"left");
			materiallist.addMaterial(material3,"right");
			*/
		
			noSelection = true;	
			// initialize the objects
			init3D();
			
			// add a listener for the 3D loop
			addEventListener(Event.ENTER_FRAME, loop3D);
		}
		
		/**
		 * Creates the container, scene, camera and root node
		 */		
		private function init3D():void {
			// create the container, add it to the stage, position it
			container = new Sprite();
			//container.y= -150;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(300, 300, 0, -150, -150);
			var colors:Array = [0xFFFFFF, 0x000000];
			var alphas:Array = [0, 25];
			var ratios:Array = [0x0F, 255];
			//dragBG.graphics.lineStyle(1.0,0xFFFFFF,1);
			//dragBG.graphics.beginFill(0xFFFFFF,0.10);
			dragBG.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			dragBG.graphics.drawCircle(0,0,150);
			dragBG.graphics.endFill();
			var dropshadow:DropShadowFilter=new DropShadowFilter(0, 45, 0x000000, 0.75, 15, 15);
			dragBG.filters=new Array(dropshadow);
			addChild(dragBG);
			dragBG.alpha = 0.65; 
			//container.scaleX= 0.5;
			//container.scaleY = 0.5;
			addChild( container );
			// create a new scene and use the container
			scene = new Scene3D( container );
			
			// create a new camera and position it
			camera = new Camera3D();
			camera.zoom = 1.1;
			camera.focus = 150;
			//camera.x = 3000;
			camera.z = 3000;
			camera.y = 3000;
			xwing.y = -150;
			xwing.scaleX = 0.5;
			xwing.scaleY = 0.5;
			xwing.scaleZ = 0.5;

			rootNode = scene.addChild( new DisplayObject3D("rootNode") );
			rootNode.y = -100;
			//rootNode.addChild(bgPlane);
			rootNode.addChild(xwing);
			
			
		}
		
		/**
		 * The 3D animation loop
		 * @param event
		 */		
		private function loop3D( event:Event ):void {
			xwing.rotationX = _3dRot_x;
			xwing.rotationY = _3dRot_y;
			xwing.rotationZ = _3dRot_z;
		
			//trace(xwing);
			scene.renderCamera( camera );
		}
	}
}
	