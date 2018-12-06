package alternativa.engine3d.controllers {
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.collisions.EllipsoidCollider;
	import alternativa.engine3d.utils.Utils;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.*;
	
	
	use namespace alternativa3d;
	
	public class OrbitController {

		private var delta:Vector3D = new Vector3D();
		private var deltar:Vector3D = new Vector3D();
		public var object:Camera3D;
		public var eventSource:InteractiveObject;
		public var speed:Number;
		
		public var fovMin:Number=20;
		public var fovMax:Number=50;
		public var fov:Number=20;
		public var deltaFov:Number=1;
		public var cachedFov:Number=20;
		
		public var neytralX:Number=100;
		public var neytralY:Number=60;
		
		private var collider:EllipsoidCollider;
		private var CollisionMesh:Mesh;
		
		private var move:Boolean=false;
		
		private var RAD2DEG:Number = 180/Math.PI;
		private var DEG2RAD:Number = Math.PI/180;

		public var position:Vector3D;
		private var rotation:Vector3D;
		public var target:Vector3D = new Vector3D(0,0,0);
		
		private var med:Number;
		
		private var mousePoint:Point = new Point();
		private var mouseLook:Boolean;
		
		/**
		 * Speed multiplier for acceleration mode.
		 */
		public var speedMultiplier:Number=5;
		
		/**
		 * Mouse sensitivity.
		 */
		public var mouseSensitivity:Number=20;
		
		/**
		 * The maximal slope in the vertical plane in radians.
		 */
		public var maxPitch:Number = Math.PI/-4;
		
		/**
		 * The minimal slope in the vertical plane in radians.
		 */
		public var minPitch:Number = Math.PI/-2;
		
		public var moveTarget:Boolean=false;
		public var mTarMax:Number=0;
		public var mTarMin:Number=0;
		
		private var navi:MovieClip;
		private var press:Boolean;

		private var onNavi:Boolean=false;
		private var zoomNaviDelta:Number=0;


		public function OrbitController(eventSource:InteractiveObject, object:Camera3D, stage:Stage, speed:Number=10) 
		{
			this.eventSource = eventSource;
			this.object = object;
			this.speed = speed;
			
			position = new Vector3D(object.x,object.y,object.z);
			rotation = getRotVector();//new Vector3D(object.rotationX,object.rotationY,object.rotationZ);
			
			eventSource.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			eventSource.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//stage.addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
			//eventSource.addEventListener(MouseEvent.MOUSE_MOVE, isMove);
			eventSource.addEventListener(MouseEvent.MOUSE_WHEEL, isZoom);
			
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			//stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function getRotVector():Vector3D
		{
			var v:Vector3D = new Vector3D();
			
			trace(position.z.toString()+"-"+target.z.toString()+"/"+fov.toString()+" = "+((position.z - target.z)/fov).toString()+" acos("+Math.acos((position.z - target.z)/fov).toString()+")")
			v.x = 0;//Math.acos((position.z - target.z)/fov);
			var med:Number = Math.sin(v.x) * fov;
			trace(String(Math.atan2((position.y - target.y),(position.x - target.x))));
			v.z = Math.atan2((position.y - target.y),(position.x - target.x));

			return v;
		}

		private function onMouseDown(e:MouseEvent):void {
			press=true;
		}
	
		private function onMouseUp(e:*=null):void {
			press=false;
		}
		
		private function isZoom(e:MouseEvent):void
		{
			/*if(e.delta>0)
			{
				zoomNaviDelta+=e.delta;
			}
			else
			{
				
			}	*/
			//trace(e.delta);
			zoomNaviDelta-=e.delta*deltaFov;
			//deltar.y=deltar.y+e.delta;
		}		
		
		private var MouseX:Number;
		private var MouseY:Number;		
		
		private var time:int=0;
		private var gipoF:Number=0;
		private var gipo:Number=0;
		private var gipoD:Number=0;
		
		public function update():void
		{
			var frameTime:Number = time;
			time = getTimer();
			frameTime = 0.02*(time - frameTime);
			if (frameTime > 1) frameTime = 1;	
			
			if (press)
            {
                deltar.x = deltar.x - (eventSource.mouseY - MouseY) * 0.0625;
                deltar.z = deltar.z - (eventSource.mouseX - MouseX) * 0.0625;
            }
			deltar.y=deltar.y+zoomNaviDelta * 0.03;
            MouseX = eventSource.mouseX;
            MouseY = eventSource.mouseY;
			deltar.x=deltar.x*0.9;
			deltar.z=deltar.z*0.9;
			deltar.y=deltar.y*0.9;
			zoomNaviDelta*=0.9;

			rotation.x += deltar.x*DEG2RAD//;*frameTime*mouseSensitivity;
			rotation.z += deltar.z*DEG2RAD//;*frameTime*mouseSensitivity;
			if (rotation.x>maxPitch)
			{
				rotation.x=maxPitch;
			}
			else if (rotation.x<minPitch)
			{
				rotation.x=minPitch;
			}
			//trace(rotation.x);
			fov+=deltar.y;
			if(fov>fovMax)
			{
				fov=fovMax;
				zoomNaviDelta=0;
			}
			if(fov<fovMin)
			{
				fov=fovMin;
				zoomNaviDelta=0;
			}	
			if(moveTarget)
			{
				gipoF = fovMax - fovMin;
				gipoD = 100-(fov-fovMin)*100/gipoF;
				gipo = mTarMax-mTarMin;
				target.z = mTarMin+gipo*gipoD/100;
			}
			
			
			position.z = target.z + Math.cos(rotation.x) * fov;
			med = Math.sin(rotation.x) * fov;
			position.x = target.x + Math.cos(rotation.z) * med;
			position.y = target.y + Math.sin(rotation.z) * med;
			
			object.posVector = position;
			object.lookAt(target.x,target.y,target.z);
		}
		
		public function setPosZ(z:Number):void
		{
			position.z = z;
		}
	}
	
}
