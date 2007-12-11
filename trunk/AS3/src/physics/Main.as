/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package{

import Engine.Dynamics.*
import Engine.Collision.*
import Engine.Collision.Shapes.*
import Engine.Dynamics.Joints.*
import Engine.Dynamics.Contacts.*
import Engine.Common.Math.*
import flash.events.Event;
import flash.display.*;
import flash.text.*;
import General.*
import TestBed.*;

import com.touchlib.*;
import app.core.utl.FPS;

import flash.display.MovieClip;


	public class Main extends MovieClip{
		public function Main(){
			
			TUIO.init( this, 'localhost', 3000, '', true );
			
			var fpsM = new FPS();
			fpsM.x = 68;
			fpsM.y = 25;
			addChild(fpsM);
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
			//m_fpsCounter.x = 7;
			//m_fpsCounter.y = 5;
			//addChildAt(m_fpsCounter, 0);
			
			m_sprite = this as Sprite;
			// input
			m_input = new Input(m_sprite);
			
			// textfield pointer
			m_aboutText = m_aboutTextN;			

			
		}
		
		public function update(e:Event){
			
			// clear for rendering
			graphics.clear()
			
			// toggle between tests
			if (Input.isKeyPressed(39)){ // Right Arrow
				m_currId++;
				m_currTest = null;
			}
			else if (Input.isKeyPressed(37)){ // Left Arrow
				m_currId--;
				m_currTest = null
			}
			// Reset
			else if (Input.isKeyPressed(82)){ // R
				m_currTest = null
			}
			
			// if null, set new test
			if (!m_currTest){
				switch(m_currId){
					// Bridge
					case 0:
						m_currTest = new TestBridge();
						break;
					// Example
					case 1:
						m_currTest = new TestExample();
						break;
					// Ragdoll
					case 2:
						m_currTest = new TestRagdoll();
						break;
					// Compound
					case 3:
						m_currTest = new TestCompound();
						break;
					// Stack
					case 4:
						m_currTest = new TestStack();
						break;
					// Crank
					case 5:
						m_currTest = new TestCrank();
						break;
					// Pulley
					case 6:
						m_currTest = new TestPulley();
						break;
					// Gears
					case 7:
						m_currTest = new TestGears();
						break;
					// Wrap around
					default:
						if (m_currId < 0){
							m_currId = 7;
							m_currTest = new TestGears();
						}
						else{
							m_currId = 0;
							m_currTest = new TestBridge();
						}
						break;
				}
			}
			
			// update current test
			m_currTest.Update();

			
			// Update input (last)
			Input.update();
			
			// update counter and limit framerate
			//m_fpsCounter.update();
			FRateLimiter.limitFrame(30);
			
		}
		
		
		//======================
		// Member data
		//======================
		//static public var m_fpsCounter:FpsCounter = new FpsCounter();
		public var m_currId:int = 0;
		public var m_currTest:Test;
		static public var m_sprite:Sprite;
		static public var m_aboutText:TextField;
		// input
		public var m_input:Input;
	}
}