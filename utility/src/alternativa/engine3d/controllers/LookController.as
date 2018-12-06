package alternativa.engine3d.controllers {
	import alternativa.engine3d.alternativa3d;
	import flash.display.Stage;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Camera3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.collisions.EllipsoidCollider;
	import alternativa.engine3d.utils.Utils;
	import flash.utils.getTimer;
	import flash.geom.Matrix3D;
	
	use namespace alternativa3d;
	
	public class LookController {

		private var delta:Vector3D = new Vector3D();
		private var deltar:Vector3D = new Vector3D();
		public var object:Object3D;
		public var stage:Stage;
		public var speed:Number;
		
		public var fovMin:Number=Math.PI/4;
		public var fovMax:Number=Math.PI/2;
		public var fov:Number=Math.PI/2;
		public var cachedFov:Number=Math.PI/2;
		
		public var neytralX:Number=100;
		public var neytralY:Number=60;
		
		private var collider:EllipsoidCollider;
		private var CollisionMesh:Mesh;
		
		private var move:Boolean=false;
		
		private static const RAD2DEG:Number = 180/Math.PI;
		private static const DEG2RAD:Number = Math.PI/180;

		private var position:Vector3D;
		private var rotation:Vector3D;

		public function LookController(stage:Stage, object:Object3D, speed:Number=1) 
		{
			this.stage = stage;
			this.object = object;
			this.speed = speed;
			
			position = new Vector3D(object.x,object.y,object.z);
			rotation = new Vector3D(object.rotationX,object.rotationY,object.rotationZ);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, isDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, isUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, isMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, isZoom);
		}
		
		public function setCollider(x:Number,y:Number,z:Number):void
		{
			collider = new EllipsoidCollider(x, y, z);
		}
		
		public function setColliderMesh(obj:Mesh):void
		{
			CollisionMesh = obj;
		}		
		
		private function isDown(e:MouseEvent):void
		{
			move=true;
			delta.y = Math.cos(object.rotationZ) * speed;
			delta.x = -Math.sin(object.rotationZ) * speed;
		}
		
		private function isUp(e:MouseEvent):void
		{
			move=false;
			delta.y = 0;
			delta.x = 0;			
		}
		
		private function isZoom(e:MouseEvent):void
		{
			if(e.delta>0)
			{
				fov-=0.05;
			}
			else
			{
				fov+=0.05;
			}
			
			if(fov>fovMax)
			{
				fov=fovMax;
			}
			if(fov<fovMin)
			{
				fov=fovMin;
			}			
			
		}		
		
		private var MouseX:Number;
		private var MouseY:Number;		
		private function isMove(e:MouseEvent):void
		{
			MouseX = e.stageX;
			MouseY = e.stageY;
		}		
		
		private var StageX:Number;
		private var StageY:Number;	
		private var deltaR:Number=3;//Math.PI/60;	
		private var destination:Vector3D;
		private var time:int;
		private var tmp:Matrix3D;
		
		public function update():void
		{
			var frameTime:Number = time;
			time = getTimer();
			frameTime = 0.02*(time - frameTime);
			if (frameTime > 1) frameTime = 1;
			
			
			StageX = stage.stageWidth/2;
			StageY = stage.stageHeight/2;
			if(MouseX>StageX+neytralX)
			{
				deltar.z = ((MouseX-(StageX+neytralX))/(StageX-neytralX))*-deltaR;//0.05;
			}
			else if(MouseX<StageX-neytralX)
			{
				deltar.z = ((StageX-neytralX-MouseX)/(StageX-neytralX))*deltaR;//-0.05;
			}
			else
			{
				deltar.z = 0;
			}
			if(MouseY>StageY+neytralY)
			{
				deltar.x = ((MouseY-(StageY+neytralY))/(StageY-neytralY))*-deltaR;//0.05;
			}
			else if(MouseY<StageY-neytralY)
			{
				deltar.x = ((StageY-neytralY-MouseY)/(StageY-neytralY))*deltaR;//-0.05;
			}
			else
			{
				deltar.x = 0;
			}			
			
			
			
			rotation.x += deltar.x*DEG2RAD*frameTime;//;
			rotation.z += deltar.z*DEG2RAD*frameTime;//;
			if (rotation.x>Math.PI/-4)
			{
				rotation.x=Math.PI/-4;
			}
			else if (rotation.x<(Math.PI/2+Math.PI/4)*-1)
			{
				rotation.x=(Math.PI/2+Math.PI/4)*-1;
			}
			//trace(rotation.x);
			
			if (CollisionMesh==null || collider==null)
			{
				position.x+=delta.x*frameTime;
				position.y+=delta.y*frameTime;
			}
			else
			{
				destination = collider.calculateDestination(position, delta, CollisionMesh);
				position.x = destination.x;
				position.y = destination.y;				
			}
			
			//update object
			tmp = new Matrix3D();
			tmp.appendRotation(Utils.toDegrees(rotation.x),Vector3D.X_AXIS);
			tmp.appendRotation(Utils.toDegrees(rotation.y),Vector3D.Y_AXIS);
			tmp.appendRotation(Utils.toDegrees(rotation.z),Vector3D.Z_AXIS);
			tmp.appendTranslation(position.x, position.y, position.z);
			object.matrix = tmp;
			if (object is Camera3D)
			{
				if (cachedFov !== fov)
				{
					var cam:Camera3D = object as Camera3D;
					cam.fov = fov;
					cam.calculateProjection(cam.view.width, cam.view.height);					
				}
			}
			cachedFov = fov;
			
			
			/*object.x = position.x;
			object.y = position.y;
			object.z = position.z;
			object.rotationX = rotation.x;
			object.rotationY = rotation.y;
			object.rotationZ = rotation.z;			
			if (object is Camera3D)
			{
				if (cachedFov !== fov)
				{
					//var cam:Camera3D = object as Camera3D;
					//cam.fov = fov;
					//cam.calculateProjection(cam.view.width, cam.view.height);					
				}
			}
			cachedFov = fov;*/
		}
		
		public function setPosZ(z:Number):void
		{
			position.z = z;
		}

	}
	
}
