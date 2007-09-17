package {

import flash.display.Sprite;
import flash.system.Capabilities;

import com.touchlib.*;
import app.*;

[SWF(width='1680', height='1050', backgroundColor='0x000000', frameRate='33')]

public class Main extends Sprite
{
	public function Main()
	{		
	TUIO.init( this, 'localhost', 3000, Capabilities.screenResolutionX, Capabilities.screenResolutionY, '', true );
	
	//var subobj = new PaintSurface();
	var subobj:PhotoCanvas = new PhotoCanvas();
	this.addChild(subobj);
	
	var subsubobj:Flickr = new Flickr(subobj);

	//this.subobj.subsubobj.clearPics();
	}
	}
}