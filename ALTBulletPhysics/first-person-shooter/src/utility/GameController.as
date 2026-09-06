package utility {
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.AnimSprite;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativaphysics.collision.shapes.A3DSphereShape;
	import alternativaphysics.dynamics.A3DRigidBody;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author redefy
	 */
	public class GameController extends EventDispatcher { 
		private var mouseDown:Boolean = false;
		private var _keyDown:Boolean = false;
		
		private var shoot:SFX = new SFX("../src/resources/sounds/weapons/ak47-1.mp3");
		private var inempty:SFX = new SFX("../src/resources/sounds/weapons/ak47_clipin.mp3");
		private var empty:SFX = new SFX("../src/resources/sounds/weapons/ak47_clipout.mp3");
		private var steps:SFX = new SFX("../src/resources/sounds/player/dirt3.mp3");
		
		private var timer1:Timer = new Timer(100);
		private var timer2:Timer = new Timer(400);
	
		public function addListeners():void {
			GV.container.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseHandler);
			GV.container.addEventListener(MouseEvent3D.MOUSE_UP, mouseHandler);
			GV.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			GV.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			
			timer1.addEventListener(TimerEvent.TIMER, soundsCheck1);
			timer1.start();
			
			timer2.addEventListener(TimerEvent.TIMER, soundsCheck2);
			timer2.start();
		}
	
		private function mouseHandler(e:Event):void {
			switch (e.type) {
				case "mouseDown":
					mouseDown = true;
				break;
				
				case "mouseUp":
					mouseDown = false;
					GV.flash.stop();
				break;
				
				default:
					
				break;
			}
		}
		
		public function set keyDown(value:Boolean):void {
			_keyDown = value;
		}
		
		public function soundsCheck1(e:TimerEvent):void {
			if (mouseDown) {
				if (Number(GV.ui.patrons) <= 0) {
					if(Number(GV.ui.chargers) <= 0) {
						GV.ui.patrons = "0";
						empty.start(500, 1);
					} else {
						GV.ui.patrons = "30";
						GV.ui.chargers = String(Number(GV.ui.chargers) - 1);
						inempty.start(0, 1);
					}
				} else {
					GV.flash.start();
					shoot.start(0,1);
					GV.ui.patrons = String(Number(GV.ui.patrons) - 1);
				}
			}
		}
		
		public function soundsCheck2(e:TimerEvent):void {	
			if(_keyDown) {
				steps.start();
			}
		}
		
		private function rayBullet():void {
			var rays:RayIntersectionData = GV.container.intersectRay(GV.hand.localToGlobal(new Vector3D(GV.flash.x + 10, GV.flash.y + 40, GV.flash.z - 9)), new Vector3D(1,0,0));
			
			var geo:GeoSphere = new GeoSphere(10, 2, false, new FillMaterial(0xFFFF00FF));
			geo.x = rays.point.x;
			geo.y = rays.point.y;
			geo.z = rays.point.z;
			trace(rays.point);
			//var ff:Vector3D = GV.hand.localToGlobal(new Vector3D(GV.flash.x+10, GV.flash.y+40, GV.flash.z-9));
	
			GV.container.addChild(geo);
			
			//var shape:A3DSphereShape = new A3DSphereShape(2);
			//var rigid:A3DRigidBody = new A3DRigidBody(shape, geo, 0.2);
			//rigid.position = ff;
			//rigid.ccdMotionThreshold = 0.0001;
			////rigid.ccdSweptSphereRadius = 0.01;
			//GV.physicsWorld.addRigidBody(rigid);
	
			//geo.geometry.upload(GV.stage3D.context3D);
			//var ray:Vector3D = GV.hand.localToGlobal(new Vector3D(GV.s.x+2, GV.s.y+60, GV.s.z)).subtract(new Vector3D(GV.camera.x, GV.camera.y, GV.camera.z));
			//ray.normalize();
			//ray.scaleBy(10);
			//rigid.applyCentralImpulse(ray);
		}
		
		public function update():void {
			//if (mouseDown)rayBullet();
		}
	}
}