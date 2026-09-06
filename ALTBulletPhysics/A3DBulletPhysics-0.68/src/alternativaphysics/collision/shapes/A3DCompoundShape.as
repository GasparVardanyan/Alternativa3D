package alternativaphysics.collision.shapes {
	import alternativaphysics.math.A3DMath;
	import alternativaphysics.math.A3DTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;


	/**
	* Класс представляет из себя составной шейп из примитивных шейпов. 
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DCompoundShape extends A3DCollisionShape {
		private var _children : Vector.<A3DCollisionShape>;
		private var _transforms:Vector.<A3DTransform>;

		/** 
		* Конструктор
		* @public 
		*/
		public function A3DCompoundShape() {
			pointer = bullet.createCompoundShapeMethod();
			super(pointer, 7);
			_children = new Vector.<A3DCollisionShape>();
			_transforms = new Vector.<A3DTransform>();
		}
		/** 
		* Добавляет шейп в составной шейп.
		* @public 
		* @param child шейп который мы хотим добавить к шейпу A3DCompoundShape
		* @param localPos вектор с координатами относительно центра A3DCompoundShape, на которых мы хотим разместить добавляемый шейп
		* @param localRot вектор с углами поворота относительно A3DCompoundShape, на которые мы хотим повернуть добавляемый шейп
		* @return void 
		*/
		public function addChildShape(child : A3DCollisionShape, localPos : Vector3D = null, localRot : Vector3D = null) : void {
			
			if ( localPos == null )
			localPos = new Vector3D();
			
			if ( localRot == null )
			localRot = new Vector3D();
			
			var tr:A3DTransform = new A3DTransform();
			tr.position = localPos;
			tr.rotation = A3DMath.degrees2radiansV3D(localRot);
			_transforms.push(tr);
			
			var rot:Matrix3D = A3DMath.euler2matrix(A3DMath.degrees2radiansV3D(localRot));
			var rotArr : Vector.<Number> = rot.rawData;
			bullet.addCompoundChildMethod(pointer, child.pointer, localPos.x / _scaling, localPos.y / _scaling, localPos.z / _scaling, rotArr[0], rotArr[4], rotArr[8], rotArr[1], rotArr[5], rotArr[9], rotArr[2], rotArr[6], rotArr[10]);

			_children.push(child);
		}

		/** 
		* Удаляет шейп-ребенка из составного шейпа .
		* @public 
		* @param childShapeindex индекс шейпа
		* @return void 
		*/
		public function removeChildShapeByIndex(childShapeindex : int) : void {
			bullet.removeCompoundChildMethod(pointer, childShapeindex);

			_children.splice(childShapeindex, 1);
			_transforms.splice(childShapeindex, 1);
		}
		
		/**
   	     *remove all children shape from compound shape
   	     */
   	    public function removeAllChildren() : void {
   	       while (_children.length > 0){
				removeChildShapeByIndex(0);
   	       }
   	       _children.length = 0;
   	       _transforms.length = 0;
   	     }

		/** 
		* Возвращает список детей составного шейпа.
		* @public 
		* @return Vector.<A3DCollisionShape> 
		*/
		public function get children() : Vector.<A3DCollisionShape> {
			return _children;
		}
		

		/** 
		* Возвращает параметры трансформации шейпа-ребенка по его индексу
		* @public 
		* @param index индекс шейпа
		* @return A3DTransform 
		*/
		public function getChildTransform(index:int):A3DTransform {
			return _transforms[index];
		}
		

		/** 
		* Масштабирует все тела, которые содержит этот шейп. 
		* @public (setter) 
		* @param scale Вектор с параметрами масштабирования по всем трем осям
		* @return void 
		*/
		override public function set localScaling(scale:Vector3D):void {
			m_localScaling.setTo(scale.x, scale.y, scale.z);
			bullet.setShapeScalingMethod(pointer, scale.x, scale.y, scale.z);
			var i:int = 0;
			for each(var shape:A3DCollisionShape in _children) {
				shape.localScaling = scale;
				_transforms[i].position = A3DMath.vectorMultiply(_transforms[i].position, scale);
				i++;
			}
		}
	}
}