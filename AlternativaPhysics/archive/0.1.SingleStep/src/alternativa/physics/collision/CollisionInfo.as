package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Vector3;
	
	/**
	 * 
	 */
	public class CollisionInfo {
		
		private static var pool:Vector.<CollisionInfo> = new Vector.<CollisionInfo>();
		
		public static function create():CollisionInfo {
			if (pool.length > 0) {
				return pool.pop();
			}
			return new CollisionInfo();
		}
		
		public static function destroy(collInfo:CollisionInfo):void {
			collInfo.body1 = collInfo.body2 = null;
			pool.push(collInfo);
		}

		private const N:int = 8;
		
		public var body1:Body;
		public var body2:Body;
		// Коэффициент отскока
		public var restitution:Number;
		// Коэффициент трения
		public var friction:Number;

		public var normal:Vector3 = new Vector3();
		public var points:Vector.<CollisionPoint> = new Vector.<CollisionPoint>(N, true);
		public var pcount:int;
		
		public function CollisionInfo() {
			for (var i:int = 0; i < N; i++) points[i] = new CollisionPoint();
		}
		
	}
}