package cc3dexample.entity 
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Sphere;
	import alternsector.physics.adaptors.alternativa3d.ccd.CC3D;
	import flash.geom.Vector3D;
	import portal.Sector;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class TestBall
	{
		private var _object:Sphere;
		private var _radius:Number;
		private var _radiusY:Number;
		private var _radiusZ:Number;
		public var cc3D:CC3D;
		public static var COUNT:int = 0;
		
		public function TestBall(sector:Sector, radius:Number, radiusY:Number=0, radiusZ:Number=0) 
		{
			this._radiusZ = radiusZ!= 0 ? radiusZ : radius;
			this._radiusY = radiusY!= 0 ? radiusY : radius;
			this._radius = radius;
			
			
			this._object = new Sphere(radius);
			_object.name = "Ball" + COUNT++;
			
			if (radiusY != 0 || radiusZ != 0) {
				var normScale:Vector3D = new Vector3D(_radius, _radiusY, _radiusZ);
				normScale.normalize();
				_object.scaleX  = 1;
				_object.scaleY  = _radiusY / radius;
				_object.scaleZ  = _radiusZ / radius;
			}
			_object.sorting = 0;
			
			testCC3D(sector);
			_object.setMaterialToAllFaces( new FillMaterial(0xFF0000, 1, 1,0) )
		}
		
		public function testCC3D(sector:Sector):void 
		{
			cc3D =  CC3D.create(_object, this, _GROUPS.BALL, 0, 0, 0, _radius, _radiusY, _radiusZ, sector);
		//	cc3D.collider.threshold = 0.0000001
			_WORLD.addCC3D(cc3D);
		}
		
		public function get object():Sphere { return _object; }
		
	}

}