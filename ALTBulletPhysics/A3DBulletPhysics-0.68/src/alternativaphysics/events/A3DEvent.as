package alternativaphysics.events {
	import alternativaphysics.collision.dispatch.A3DCollisionObject;
	import alternativaphysics.collision.dispatch.A3DManifoldPoint;

	import flash.events.Event;
	
	/** 
	* Класс событий Bullet
	* @public 
	* @author redefy 
	*/
	public class A3DEvent extends Event {
		/** 
		* Отправляется когда твердое тело сталкивается с другим
		* @public (const)
		*/
		public static const COLLISION_ADDED : String = "collisionAdded";
		/** 
		* Отправляется когда твердое тело сталкивается с лучом
		* @public (const)
		*/
		 public static const RAY_CAST : String = "rayCast";
		/**
		 * stored which object is collide with target object
		 */
		/** 
		* Сохраняет ссылку на обьект с которым столкнулся объект, подписанный на данные события.
		* @public (const)
		*/
		public var collisionObject : A3DCollisionObject;
		/** 
		* Содержит точку столкновения тел, нормаль, импульс и т.д.
		* @public (const)
		*/
		public var manifoldPoint : A3DManifoldPoint;

		public function A3DEvent(type : String) {
			super(type);
		}
	}
}