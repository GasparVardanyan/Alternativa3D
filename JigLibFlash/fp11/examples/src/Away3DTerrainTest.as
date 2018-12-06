package 
{
    import away3d.containers.*;
    import away3d.lights.PointLight;
    import away3d.materials.ColorMaterial;
    import away3d.primitives.*;
    import away3d.entities.Mesh;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    
    import jiglib.cof.JConfig;
    import jiglib.debug.Stats;
    import jiglib.geometry.*;
    import jiglib.math.*;
    import jiglib.physics.RigidBody;
    import jiglib.plugin.away3d4.*;
    
    [SWF(backgroundColor="#222266", frameRate="60", width="800", height="600")]
    public class Away3DTerrainTest extends Sprite
    {
		[Embed(source="../res/hightmap3.jpg")]
        public var TERRIAN_MAP:Class;
		
        public var view:View3D;
		private var mylight:PointLight;
		private var materia1:ColorMaterial;
		
		private var terrain:JTerrain;
		private var ballBody:Vector.<RigidBody>;
		private var boxBody:Vector.<RigidBody>;
		private var physics:Away3D4Physics;
		
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
			
			this.addChild(new Stats(view, physics));
        }
		
		private function init3D():void
		{
			view = new View3D();
            addChild(view);
			
			mylight = new PointLight();
			view.scene.addChild(mylight);
			mylight.color = 0xffffff;
			mylight.y = 800;
			mylight.z = -800;
			
			view.camera.y = mylight.y;
			view.camera.z = mylight.z;
			view.camera.rotationX = 40;
			
			JConfig.solverType="FAST";
			physics = new Away3D4Physics(view, 8);
			physics.engine.setCollisionSystem(true, -500, -500, -500, 20, 20, 20, 100, 100, 100);
			
			materia1 = new ColorMaterial(0x77ee77);
			materia1.lights = [mylight];
			
			//create terrain
			var terrainBMD:Bitmap = new TERRIAN_MAP();
			terrain = physics.createTerrain(materia1, terrainBMD.bitmapData, 1000, 300, 1000, 50, 50, 300, 0, false);
			
			materia1 = new ColorMaterial(0xeeee00);
			materia1.lights = [mylight];
			
			ballBody = new Vector.<RigidBody>();
			for (var i:int = 0; i < 20; i++)
			{
				ballBody[i] = physics.createSphere(materia1, 20);
				ballBody[i].moveTo(new Vector3D( -300+600*Math.random(),500+500*Math.random(), -300+600*Math.random()));
			}
			ballBody[0].mass = 10;
			physics.getMesh(ballBody[0]).material=new ColorMaterial(0xff8888);
			physics.getMesh(ballBody[0]).material.lights=[mylight];
			
			boxBody=new Vector.<RigidBody>();
			for (i = 0; i < 20; i++)
			{
				boxBody[i] = physics.createCube(materia1, 50, 30, 40);
				boxBody[i].moveTo(new Vector3D( -300+600*Math.random(),500+500*Math.random(), -300+600*Math.random()));
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
			physics.step(0.2);
        }

    }

}
