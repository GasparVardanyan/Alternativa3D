package 
{
    import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
    import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
    
	import away3d.debug.AwayStats;
    import away3d.containers.*;
    import away3d.primitives.*;
	import away3d.lights.PointLight3D;
	import away3d.core.base.Mesh;
	import away3d.core.render.Renderer;
	import away3d.materials.ShadingColorMaterial;
	
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3d.*;
    
    [SWF(backgroundColor="#222266", frameRate="60", width="800", height="600")]
    public class Away3DTerrainTest extends Sprite
    {
		[Embed(source="res/hightmap1.jpg")]
        public var TERRIAN_MAP:Class;
		
        public var view:View3D;
		private var mylight:PointLight3D;
		private var materia:ShadingColorMaterial;
		
		private var terrain:JTerrain;
		private var ballBody:Vector.<RigidBody>;
		private var boxBody:Vector.<RigidBody>;
		private var capsuleBody:Vector.<RigidBody>;
		private var physics:Away3DPhysics;
		
		private var keyRight   :Boolean = false;
		private var keyLeft    :Boolean = false;
		private var keyForward :Boolean = false;
		private var keyReverse :Boolean = false;
		private var keyUp:Boolean = false;
        
        public function Away3DTerrainTest()
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
			
			//view.renderer = Renderer.CORRECT_Z_ORDER;
			
			mylight = new PointLight3D();
			view.scene.addLight(mylight);
			mylight.ambient = 0.4;
			mylight.y = 900;
			
			materia = new ShadingColorMaterial(0x77ee77);
			
			physics = new Away3DPhysics(view, 8);
			
			//create terrain
			var terrainBMD:Bitmap = new TERRIAN_MAP;
			terrain = physics.createTerrain(terrainBMD.bitmapData, { material:materia, width:800, height:800, segmentsW:10, segmentsH:10, maxHeight:350 } );
			terrain.friction = 0.2;
			
			ballBody = new Vector.<RigidBody>();
			var color:uint;
			for (var i:int = 0; i < 5; i++)
			{
				color = (i == 0)?0xff8888:0xeeee00;
				materia = new ShadingColorMaterial(color);
				ballBody[i] = physics.createSphere({ material:this.materia, radius:22 });
				ballBody[i].moveTo(new Vector3D( 0, 200 + (60 * i + 60), 200));
			}
			ballBody[0].mass = 10;
			
			boxBody=new Vector.<RigidBody>();
			for (i = 0; i < 3; i++)
			{
				boxBody[i] = physics.createCube({ material:this.materia, width:50, height:30, depth:40 });
				boxBody[i].moveTo(new Vector3D(-200, 200 + (50 * i + 50), 0));
			}
			
			var capsuleSkin:Cylinder;
			capsuleBody = new Vector.<RigidBody>();
			for (i = 0; i < 3; i++)
			{
				capsuleSkin = new Cylinder( { material:this.materia, radius:20, height:50 } );
				view.scene.addChild(capsuleSkin);
				
				capsuleBody[i] = new JCapsule(new Away3dMesh(capsuleSkin), 20, 30);
				capsuleBody[i].moveTo(new Vector3D(200, 200 + (80 * i + 80), 0));
				capsuleBody[i].setOrientation(JMatrix3D.getRotationMatrixAxis(90, Vector3D.X_AXIS));
				physics.addBody(capsuleBody[i]);
			}
			
			view.camera.y = 700;
			view.camera.z = -400;
			view.camera.lookAt(Mesh(terrain.terrainMesh).position);
			view.camera.zoom = 5;
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
				ballBody[0].addWorldForce(new Vector3D(-100,0,0),ballBody[0].currentState.position);
			}
			if(keyRight)
			{
				ballBody[0].addWorldForce(new Vector3D(100,0,0),ballBody[0].currentState.position);
			}
			if(keyForward)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,100),ballBody[0].currentState.position);
			}
			if(keyReverse)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,-100),ballBody[0].currentState.position);
			}
			if(keyUp)
			{
				ballBody[0].addWorldForce(new Vector3D(0, 100, 0), ballBody[0].currentState.position);
			}
			
            view.render();
			physics.engine.integrate(0.2);
        }

    }

}
