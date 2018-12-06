// FIVe3D JigLibFlash Demo FP10 - JigLibFlash support for FIVe3D - Using FIVe3D FP10 v1.0.1 and AlmostLogical FIVe3D Additional Files FP10
//  Note: You will need AlmostLogical FIVe3D Additional Files FP10 to run this.
//        This package is located here: http://blog.almostlogical.com/resources/AlmostLogical_FIVe3D_Additional_Files_Package_FP10.zip
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.badimon.five3D.typography.Typography3D;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.five3d.FIVe3DPhysics;
	import jiglib.plugin.five3d.FIVe3DMesh;
	
	import net.badimon.five3D.typography.HelveticaBold;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.DynamicText3D;
	
	import almostlogical.five3d.primitives.Cube;
	
	/**
	 * @author Devin Reimer - blog.almostlogical.com
	 */
	[SWF(width="650", height="420", backgroundColor="#E0FFFA", frameRate="31")]
	public class FallingBoxes extends Sprite
	{
		private var scene:Scene3D;
		private var world:Sprite3D;
		private var basePhysicsScene:Sprite3D;
		private var background:Sprite3D;
		private var physics:FIVe3DPhysics;
		private var isStarted:Boolean = false; //used to determine after first click
		
		public function FallingBoxes()
		{
			setupScene();
			createGround();
			
			addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		private function setupScene():void
		{
			scene = new Scene3D();
			scene.x = + (stage.stageWidth / 2);
			addChild(scene);
			
			world = new Sprite3D();
			scene.addChild(world);
			
			background = new Sprite3D();
			world.addChild(background);
			
			basePhysicsScene = new Sprite3D();
			world.addChild(basePhysicsScene);
			
			physics = new FIVe3DPhysics(basePhysicsScene, 1.5);
			
			basePhysicsScene.addEventListener(MouseEvent.CLICK, cubeClicked, false, 0, true);
			basePhysicsScene.buttonMode = true; //when ever you mouse over an object within the scene it would show the clickable hand cursor
		}
			
		private function createGround():void
		{
			var mesh:Sprite3D;
			var ground:RigidBody = physics.createGround(500,500, -300,0x0066FF,0x000000);
			ground.x = -250;
			ground.z = 250;
			
			//the following two lines overrides the ground being place in basePhysicsScene and instead place in background Sprite so it always is in the background
			basePhysicsScene.removeChild(FIVe3DMesh(ground.skin).mesh);
			background.addChild(FIVe3DMesh(ground.skin).mesh);
			
			mesh = FIVe3DMesh(ground.skin).mesh;
			
			mesh.addEventListener(MouseEvent.CLICK,groundClicked, false, 0, true);
			mesh.mouseChildren = false;
			mesh.buttonMode = true;
			mesh.addChild(createInstructionMessage());
		}
		
		private function createInstructionMessage():Sprite3D
		{
			var container:Sprite3D = new Sprite3D();
			var messageLine1:DynamicText3D = new DynamicText3D(new HelveticaBold()); //text not as complete as FP9 version as I have yet to write new version of MultilineDynamicText3D
			messageLine1.size = 35;
			messageLine1.color = 0xFFFFFF;
			messageLine1.text = "Rapidly Click The Ground!";
			messageLine1.x = 35;
			container.addChild(messageLine1);
			container.y = 200;
			return container;
		}
		
		private function groundClicked(evt:Event = null):void
		{
			if (!isStarted) //if not the first click
			{
				//remove all children from ground - aka (text)
				for (var i:int = 0; i < Sprite3D(evt.target).numChildren; i++)
				{
					Sprite3D(evt.target).removeChildAt(0);
				}
				isStarted = true;
			}
			spawnNewCube();
		}

		private function spawnNewCube():void
		{
			var width:Number = (Math.random() * 80) + 20;
			var depth:Number = (Math.random() * 50) + 20;
			var height:Number = (Math.random() * 80) + 20;
			var color:uint = 0xFFFFFF * Math.random();
			var mesh:Sprite3D;
			
			var nextCube:RigidBody = physics.createCube(width,depth,height,[color,color,color,color,color,color]);
			nextCube.x = (Math.random() * 150) - 75;
			nextCube.y = 75;
			nextCube.z = (Math.random() * 150) - 75;
			nextCube.rotationX = Math.random() * 360;
			nextCube.rotationY = Math.random() * 360;
			nextCube.rotationZ = Math.random() * 360;
			
			nextCube.updateObject3D(); //this prevents one frame of the object being at a location it is actually not
			mesh = FIVe3DMesh(nextCube.skin).mesh;
			
			mesh.mouseChildren = false; //prevents individual faces from being clicked
		}
		
		private function cubeClicked(evt:MouseEvent):void
		{
			removePhysicsObjBySprite3D(evt.target as Sprite3D);
		}
		
		private function removePhysicsObjBySprite3D(obj:Sprite3D):void
		{
			physics.removeBody(getRigidBodyFromMeshAndReactivate(obj));
			basePhysicsScene.removeChild(obj);
		}
		
		private function getRigidBodyFromMeshAndReactivate(obj:Sprite3D):RigidBody
		{
			var tempRigidBody:RigidBody;
			var requiredRigidBody:RigidBody;
			
			for (var bodyStr:String in physics.engine.bodys)
			{
				tempRigidBody = physics.engine.bodys[bodyStr];	
				if (obj == physics.getMesh(tempRigidBody))
				{
					requiredRigidBody = tempRigidBody;
				}
				else if (!tempRigidBody.isActive)
				{
					tempRigidBody.setActive(); //this will cause any object that could be resting on top of the removed object to fall
				}
			}
			
			return requiredRigidBody;
		}
		
		private function mainLoop(evt:Event):void
		{
			physics.step();
			if (isStarted)
			{
				world.rotationY += .5;
			}
		}
		
	}
	
}