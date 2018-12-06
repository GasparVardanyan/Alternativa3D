package  
{
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.debug.AwayStats;
	import away3d.containers.View3D;
	import away3d.lights.PointLight3D;
	import away3d.primitives.Cylinder;
	import away3d.core.render.Renderer;
	import away3d.materials.ShadingColorMaterial;
	
	
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.cof.JConfig;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.away3d.*;
	/**
	 * ...
	 * @author Muzer
	 */
	[SWF(width="800", height="600", backgroundColor="#222266", frameRate="60")]
	public class Away3DFlash3DPhysics extends Sprite
	
	{
		private var view:View3D;
		private var mylight:PointLight3D;
		private var materia:ShadingColorMaterial;
		
		private var ground:RigidBody;
		private var ballBody:Vector.<RigidBody>;
		private var boxBody:Vector.<RigidBody>;
		private var capsuleBody:Vector.<RigidBody>;
		
		private var physics:Away3DPhysics;
		
		private var keyRight   :Boolean = false;
		private var keyLeft    :Boolean = false;
		private var keyForward :Boolean = false;
		private var keyReverse :Boolean = false;
		private var keyUp:Boolean = false;
		
		public function Away3DFlash3DPhysics() 
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			init3D();
			
			var stats:AwayStats = new AwayStats(view);
			addChild(stats);
		}
		
		private function init3D():void
		{
			view = new View3D();
            view.x = stage.stageWidth / 2;
            view.y = stage.stageHeight / 2;
            addChild(view);
			
			mylight = new PointLight3D();
			view.scene.addLight(mylight);
			mylight.ambient = 0.4;
			mylight.y = 500;
			mylight.z = -700;
			
			view.camera.y = mylight.y;
			view.camera.z = mylight.z;
			view.camera.lookAt(new Vector3D());
			
			physics = new Away3DPhysics(view, 8);
			
			materia = new ShadingColorMaterial(0x77ee77);
			ground = physics.createCube( { material:this.materia, width:500, height:10, depth:500, segmentsW:2, segmentsH:1, segmentsD:2} );
			ground.movable = false;
			ground.friction = 0.2;
			ground.restitution = 0.8;
			
			ballBody = new Vector.<RigidBody>();
			var color:uint;
			for (var i:int = 0; i < 6; i++)
			{
				color = (i == 0)?0xff8888:0xeeee00;
				materia = new ShadingColorMaterial(color);
				ballBody[i] = physics.createSphere({ material:this.materia, radius:22 });
				ballBody[i].mass = 3;
				ballBody[i].moveTo(new Vector3D( -100, 30 + (50 * i + 50), -100));
			}
			
			boxBody = new Vector.<RigidBody>();
			materia = new ShadingColorMaterial(0xeeee00);
			for (i = 0; i < 6; i++)
			{
				boxBody[i] = physics.createCube({ material:this.materia, width:50, height:30, depth:40 });
				boxBody[i].moveTo(new Vector3D(0, 50 + (40 * i + 40), 0));
			}
			
			var capsuleSkin:Cylinder;
			capsuleBody = new Vector.<RigidBody>();
			for (i = 0; i < 6; i++)
			{
				capsuleSkin = new Cylinder( { material:this.materia, radius:20, height:50 } );
				view.scene.addChild(capsuleSkin);
				
				capsuleBody[i] = new JCapsule(new Away3dMesh(capsuleSkin), 20, 30);
				capsuleBody[i].moveTo(new Vector3D(100, 10 + (80 * i + 80), -100));
				physics.addBody(capsuleBody[i]);
			}
		}
		
		private function clearBodies():void {
			for each(var body:RigidBody in boxBody) {
				view.scene.removeChild(physics.getMesh(body));
				physics.engine.removeBody(body);
			}
			boxBody.splice(0, boxBody.length);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					keyForward = true;
					keyReverse = false;
					break;

				case Keyboard.DOWN:
					keyReverse = true;
					keyForward = false;
					break;

				case Keyboard.LEFT:
					keyLeft = true;
					keyRight = false;
					break;

				case Keyboard.RIGHT:
					keyRight = true;
					keyLeft = false;
					break;
				case Keyboard.SPACE:
					keyUp = true;
					break;
				break;
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					keyForward = false;
					break;

				case Keyboard.DOWN:
					keyReverse = false;
					break;

				case Keyboard.LEFT:
					keyLeft = false;
					break;

				case Keyboard.RIGHT:
					keyRight = false;
					break;
				case Keyboard.SPACE:
					//keyUp=false;
			}
		}
		
		private function resetBody():void
		{
			for (var i:int = 0; i < ballBody.length;i++ )
			{
				if (ballBody[i].currentState.position.y < -200)
				{
					ballBody[i].moveTo(new Vector3D( 0, 1000 + (60 * i + 60), 0));
				}
			}
			
			for (i = 0; i < boxBody.length;i++ )
			{
				if (boxBody[i].currentState.position.y < -200)
				{
					boxBody[i].moveTo(new Vector3D(0, 1000 + (60 * i + 60), 0));
				}
			}
			
			for (i = 0; i < capsuleBody.length;i++ )
			{
				if (capsuleBody[i].currentState.position.y < -200)
				{
					capsuleBody[i].moveTo(new Vector3D(0, 1000 + (60 * i + 60), 0));
				}
			}
		}
		
		private function onEnterFrame(event:Event):void
        {
			if(keyLeft)
			{
				ballBody[0].addWorldForce(new Vector3D(-50,0,0),ballBody[0].currentState.position);
			}
			if(keyRight)
			{
				ballBody[0].addWorldForce(new Vector3D(50,0,0),ballBody[0].currentState.position);
			}
			if(keyForward)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,50),ballBody[0].currentState.position);
			}
			if(keyReverse)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,-50),ballBody[0].currentState.position);
			}
			if(keyUp)
			{
				ballBody[0].addWorldForce(new Vector3D(0, 50, 0), ballBody[0].currentState.position);
			}
			physics.engine.integrate(0.1);
			
			resetBody();
            view.render();
        }
	}

}