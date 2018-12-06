package  
{
	import away3d.containers.View3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import jiglib.cof.JConfig;
	import jiglib.debug.Stats;
	import jiglib.events.JCollisionEvent;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.plugin.away3d4.*;
	
	/**
	 * ...
	 * @author Muzer
	 */
	[SWF(width="800", height="600", frameRate="60")]
	public class CollisionEventTest extends Sprite
	{
		private var view:View3D;
		private var mylight:PointLight;
		private var materia:ColorMaterial;
		
		private var ground:RigidBody;
		private var ball:RigidBody;
		private var boxBody:Vector.<RigidBody>;
		
		private var physics:Away3D4Physics;
		
		private var keyRight   :Boolean = false;
		private var keyLeft    :Boolean = false;
		private var keyForward :Boolean = false;
		private var keyReverse :Boolean = false;
		private var keyUp:Boolean = false;
		
		public function CollisionEventTest() 
		{
			super();
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			init3D();
			
			this.addChild(new Stats(view, physics));
		}
		
		private function init3D():void
		{
			view = new View3D();
			addChild(view);
			
			mylight = new PointLight();
			view.scene.addChild(mylight);
			mylight.color = 0xffffff;
			mylight.diffuse = 1;
			mylight.y = 500;
			mylight.z = -700;
			
			view.camera.y = mylight.y;
			view.camera.z = mylight.z;
			view.camera.rotationX = 20;
			
			physics = new Away3D4Physics(view, 8);
			
			materia = new ColorMaterial(0x77ee77);
			materia.lights = [mylight];
			
			ground = physics.createGround(materia);
			
			ball = physics.createSphere(materia, 22);
			ball.addEventListener(JCollisionEvent.COLLISION_START, collisionStart);
			ball.addEventListener(JCollisionEvent.COLLISION_END, collisionEnd);
			
			ball.moveTo(new Vector3D( -100, 50, -200));
			physics.getMesh(ball).material=new ColorMaterial(0xff8888);
			physics.getMesh(ball).material.lights=[mylight];
			
			
			materia = new ColorMaterial(0xeeee00);
			materia.lights = [mylight];
			
			boxBody = new Vector.<RigidBody>();
			for (var i:int = 0; i < 4; i++)
			{
				boxBody[i] = physics.createCube(materia, 50, 50, 50 );
				boxBody[i].moveTo(new Vector3D( -150 + 100 * i, 50, 0));
			}
		}
		
		private function collisionStart(event:JCollisionEvent):void {
			if (event.body != ground) {
				physics.getMesh(event.body).material = new ColorMaterial(0x0000ff);
				physics.getMesh(event.body).material.lights = [mylight];
			}
		}
		private function collisionEnd(event:JCollisionEvent):void {
			if (event.body != ground) {
				physics.getMesh(event.body).material = new ColorMaterial(0xeeee00);
				physics.getMesh(event.body).material.lights = [mylight];
			}
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
					keyUp=false;
			}
		}
		
		private function onEnterFrame(event:Event):void
        {
			if(keyLeft)
			{
				ball.addWorldForce(new Vector3D(-10,0,0),ball.currentState.position);
			}
			if(keyRight)
			{
				ball.addWorldForce(new Vector3D(10,0,0),ball.currentState.position);
			}
			if(keyForward)
			{
				ball.addWorldForce(new Vector3D(0,0,10),ball.currentState.position);
			}
			if(keyReverse)
			{
				ball.addWorldForce(new Vector3D(0,0,-10),ball.currentState.position);
			}
			if(keyUp)
			{
				ball.addWorldForce(new Vector3D(0, 10, 0), ball.currentState.position);
			}
			
			physics.step(0.1);
			
            view.render();
        }
	}

}