package a3d_helper.physics.vehicles.controllers
{
	import alternativa.physicsengine.events.PhysicsEvent;
	import alternativa.physicsengine.physics.PhysicsScene;
	import a3d_helper.physics.vehicles.Tank;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class TankPhysicsController
	{
		public var tank:Tank;
		public var scene:PhysicsScene;
		public var stage:Stage;
		public var rayForce:Number;
		public var frozen:Boolean;
		
		public var forvardMoveKeys:Vector.<uint> = new Vector.<uint>();
		public var backMoveKeys:Vector.<uint> = new Vector.<uint>();
		public var rightMoveKeys:Vector.<uint> = new Vector.<uint>();
		public var leftMoveKeys:Vector.<uint> = new Vector.<uint>();
		
		private var main:TankPhysicsController;
		private var kUp:Boolean, kDown:Boolean, kRight:Boolean, kLeft:Boolean;
		
		public function TankPhysicsController(tank:Tank, scene:PhysicsScene, stage:Stage, rayForce:Number)
		{
			this.tank = tank;
			this.scene = scene;
			this.stage = stage;
			this.rayForce = rayForce;
			this.main = this;
			
			forvardMoveKeys.push(Keyboard.UP);
			backMoveKeys.push(Keyboard.DOWN);
			rightMoveKeys.push(Keyboard.RIGHT);
			leftMoveKeys.push(Keyboard.LEFT);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			scene.addEventListener(PhysicsEvent.OnBeforeUpdate, function(e:PhysicsEvent):void
			{
				if (!frozen) tank.moveWithKeyboard(kUp, kDown, kRight, kLeft, main.rayForce);
			});
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.UP) kUp = true;
			if (e.keyCode == Keyboard.DOWN) kDown = true;
			if (e.keyCode == Keyboard.RIGHT) kRight = true;
			if (e.keyCode == Keyboard.LEFT) kLeft = true;
			
			//for each (var key:uint in forvardMoveKeys)
				//if (e.keyCode == key) kUp = true;
			//for each (key in backMoveKeys)
				//if (e.keyCode == key) kDown = true;
			//for each (key in rightMoveKeys)
				//if (e.keyCode == key) kRight = true;
			//for each (key in leftMoveKeys)
				//if (e.keyCode == key) kLeft = true;
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.UP) kUp = false;
			if (e.keyCode == Keyboard.DOWN) kDown = false;
			if (e.keyCode == Keyboard.RIGHT) kRight = false;
			if (e.keyCode == Keyboard.LEFT) kLeft = false;
			
			//for each (var key:uint in forvardMoveKeys)
				//if (e.keyCode == key) kUp = false;
			//for each (key in backMoveKeys)
				//if (e.keyCode == key) kDown = false;
			//for each (key in rightMoveKeys)
				//if (e.keyCode == key) kRight = false;
			//for each (key in leftMoveKeys)
				//if (e.keyCode == key) kLeft = false;
		}
	}
}
